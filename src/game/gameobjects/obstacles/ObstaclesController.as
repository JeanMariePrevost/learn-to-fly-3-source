package src.game.gameobjects.obstacles 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import lbg.compositetick.*;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import lbg.utils.VectorUtils;
	import src.compound.Mod;
	import src.game.GameCamera;
	import src.game.GameLayer;
	import src.game.GameMediator;
	import src.game.gameobjects.player.Player;
	import src.game.PhysicsEngine;
	import src.game.StatHooks;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * TODO - implement obstacles pooling, creation and removal on ticking
	 * @author 
	 */
	public class ObstaclesController extends Sprite implements ICompositeLeaf   
	{
		//Obstacle weight scaling from player mass
		protected const OBSTACLE_FULL_WEIGHT_MULT:Number = 1;
		protected const OBSTACLE_MIN_WEIGHT_MULT:Number = 0.3;
		protected const PLAYER_MASS_FOR_FULL:Number = 3;
		protected const PLAYER_MASS_FOR_MIN:Number = 300;
		protected const OBSTACLE_WEIGHT_SCALING_POWER:Number = 0.3;//Affects the curve of the scaling
		protected const OVERALL_OBSTACLE_MASS_MULT:Number = 0.8;
		
		
		//Obstacle spawning and cleaning
		protected const MAX_DISTANCE_FROM_PLAYER:Number = 4000;//Distance to trigger obstacle destruction
		protected const SPAWN_DISTANCE:Number = 600;
		protected const SPAWN_ANGLE_JITTER:Number = 120;//Width of arc ahead of player where obstacles spawn
		protected const SPAWN_TIME_JITTER:Number = 0.5;//Maximum mult that can be ADDED to base spawn delay, 0=fixed values
		protected const OBSTACLE_AMOUNT_MULT:Number = 1.3;//Globally affect the amount of obstacles
		
		
		
		protected var _compositeNode:CompositeNode;
		protected var _physicsEngine:PhysicsEngine;
		protected var _obstacleVector:Vector.<Obstacle>;
		protected var _player:Player;
		
		protected var _nextTriggerDistance:Number = 1500;
		protected var _lastAltitude:Number = 0;
		protected var _lastSpawnPoint:Point = new Point();//Player position at time of obstacle spawn
		protected var _currentPos:Point = new Point();
		
		protected var _massModFromPlayerWeight:Mod = new Mod(0, 1);//Adjusts obstacles weight based on player total weight
		
		public function ObstaclesController(physicsEngine:PhysicsEngine, player:Player) 
		{
			_compositeNode = new CompositeNode();
			_obstacleVector = new Vector.<Obstacle>;
			_physicsEngine = physicsEngine;
			_player = player;
			
			
			GameMediator.updatePlayerPosition.add(playerMoved);
			GameMediator.updatePlayerAltitude.add(altitudeChanged);
			GameMediator.playerWeightChange.add(playerWeightChange);
			StatHooks.obstacleMassMult.addMod(_massModFromPlayerWeight);
			
			_player.updateBodyMass();
		}
		
		protected function playerWeightChange(mass:Number):void {
			var massMul:Number = OVERALL_OBSTACLE_MASS_MULT * NumberUtils.interpolate2(OBSTACLE_FULL_WEIGHT_MULT, OBSTACLE_MIN_WEIGHT_MULT, PLAYER_MASS_FOR_FULL, PLAYER_MASS_FOR_MIN, mass, OBSTACLE_WEIGHT_SCALING_POWER, true);
			_massModFromPlayerWeight.mul = massMul;
			refreshObstaclesMass();
		}
		
		protected function refreshObstaclesMass():void {
			for each(var o:Obstacle in _obstacleVector) {
				o.refreshMass();
			}
		}
		
		protected function playerMoved(X:Number, Y:Number):void {
			_currentPos.x = X;
			_currentPos.y = Y;
			var distance:Number = Point.distance(_lastSpawnPoint, _currentPos);
			//trace("Distance from last spawn:", distance);
			
			if (distance >= _nextTriggerDistance) {
				spawnObstacle();
				clearFarObstacles();
				//trace("Obstacle count:", _obstacleVector.length);
				_nextTriggerDistance = getNewSpawnDistance();
			}
		}
		
		protected function spawnObstacle():void {
			//trace("SPAWN!");
			var o:Obstacle = getNewObstacle();
			addObstacle(o);
			
			var spawnDistance:Number = SPAWN_DISTANCE / GameCamera.instance.getMovingLayer().scaleY;
			var angle:Number = Trig.angleToPoint(_lastSpawnPoint, _currentPos);
			
			//trace(spawnDistance, angle);
			
			var spawnAngle:Number = angle + NumberUtils.randomBoth(SPAWN_ANGLE_JITTER);
			
			var dx:Number = Trig.vectorX(spawnDistance, spawnAngle);
			var dy:Number = Trig.vectorY(spawnDistance, spawnAngle);
			o.setPosition(_player.getPositionX() + dx, _player.getPositionY() + dy);
			
			
			_lastSpawnPoint.x = _player.getPositionX();
			_lastSpawnPoint.y = _player.getPositionY();
		}
		
		protected function clearFarObstacles():void {
			var threshold:Number = MAX_DISTANCE_FROM_PLAYER / GameCamera.instance.getMovingLayer().scaleY;
			for each(var o:Obstacle in _obstacleVector) {
				if (NumberUtils.distanceBetween(_player.getPositionX(), _player.getPositionY(), o.getPositionX(), o.getPositionY()) >= threshold) {
					removeObstacle(o);
				}
			}
		}
		
		protected function altitudeChanged(alt:Number):void {
			_lastAltitude = alt;
		}
		
		/* Returns a new obstacle instance based on the current altitude */
		protected function getNewObstacle():Obstacle {
			var c:Class = ObstacleData.getObstacleType(_lastAltitude);
			var o:Obstacle = new (c as Class)();
			if(ProfileState.instance.cheatHugeObstacles) o.getMovieClip().scaleX = o.getMovieClip().scaleY = o.getMovieClip().scaleY * Global.HUGE_OBSTACLES_CHEAT_MULT;
			o.setPlayer(_player);
			
			return o;
			//return new Obstacle(null);
		}
		
		/* Returns time until next obstacle based on the current altitude */
		protected function getNewSpawnDistance():Number {
			var time:Number;
			if (_lastAltitude <= 30000) {
				//Early game
				time = NumberUtils.interpolate2(1500, 1500, 0, 30000, _lastAltitude, 1);
			}else if (_lastAltitude <= 70000) {
				//Mid game
				time = NumberUtils.interpolate2(1500, 2500, 30000, 70000, _lastAltitude, 1);
			}else if (_lastAltitude <= 180000) {
				//Mid game
				time = NumberUtils.interpolate2(2500, 6000, 70000, 180000, _lastAltitude, 1);
			}else {
				//Late game
				time = NumberUtils.interpolate2(6000, 10000, 180000, Global.spaceAltitude, _lastAltitude, 0.8);
			}
			
			time += time * Math.random() * SPAWN_TIME_JITTER;
			
			//trace("Obstacles mult:", StatHooks.obstaclesMult.value);
			//trace("Spawn time:", time);
			time /= StatHooks.obstaclesMult.value;
			time /= OBSTACLE_AMOUNT_MULT;
			//trace("Spawn time with mult:", time);
			
			
			return time;
		}
		
		protected function addObstacle(o:Obstacle):void {
			o.setPhysicsEngine(_physicsEngine);
			addChild(o.getMovieClip());
			_obstacleVector.push(o);
			//trace("addObstacle() ->", _obstacleVector.length);
			o.signalDeath.addOnce(obstacleJustDied);
		}
		
		protected function removeObstacle(o:Obstacle):void {
			VectorUtils.removeFromVector(_obstacleVector, o);
			o.signalDeath.remove(obstacleJustDied);
			o.destroy();
		}
		
		public function tick(delta:Number):void 
		{
			_compositeNode.tick(delta);
		}
		
		protected function obstacleJustDied(o:Obstacle):void {
			VectorUtils.removeFromVector(_obstacleVector, o);
		}
		
		public function destroy():void {
			GameMediator.updatePlayerPosition.remove(playerMoved);
			GameMediator.updatePlayerAltitude.remove(altitudeChanged);
			GameMediator.playerWeightChange.remove(playerWeightChange);
			
			if (_massModFromPlayerWeight) {
				StatHooks.obstacleMassMult.removeMod(_massModFromPlayerWeight);
				_massModFromPlayerWeight.destroy();
			}
			_massModFromPlayerWeight = null;
			
			if (_compositeNode) _compositeNode.destroy();
			_compositeNode = null;
			
			_physicsEngine = null;
			
			if (_obstacleVector) {
				for each(var o:Obstacle in _obstacleVector) {
					o.destroy();
				}
				_obstacleVector.length = 0;
			}
			_obstacleVector = null;
			_player = null;
			
			_lastSpawnPoint = null;
			_currentPos = null;
		}
		
	}

}