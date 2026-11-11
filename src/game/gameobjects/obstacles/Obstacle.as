package src.game.gameobjects.obstacles 
{
	import flash.utils.getTimer;
	import lbg.compositetick.ICompositeLeaf;
	import flash.display.MovieClip;
	import lbg.debug.Log;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import nape.dynamics.CollisionArbiter;
	import nape.dynamics.Contact;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.geom.Vec3;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.*;
	import nape.callbacks.*;
	import org.osflash.signals.Signal;
	import src.game.GameMediator;
	import src.game.gameobjects.GameObject;
	import src.game.gameobjects.player.Player;
	import src.game.gameobjects.ShapesData;
	import src.game.particles.Particles;
	import src.game.PhysicsEngine;
	import src.game.StatHooks;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Obstacle extends GameObject implements ICompositeLeaf
	{
		/** (deadObstacle:Obstacle) */
		public var signalDeath:Signal = new Signal(Obstacle);
		
		protected const MINIMUM_TIME_IMPACT_DUST:Number = 150;//MS before spawning another smoke puff
		protected const ROTATION_CORRECTION_AT_COLLISION:Number = 0.001;//How low rotation correction drops upon impact, allowing the player to better affect the object rotation
		protected var _rotationCorrectionIncreasePerTick:Number = 0.0005;//How quickly it rebuilds up
		protected var _targetRotation:Number = 0;//Rotation the object tries to aim for
		protected var _drag:Number = 0.95;
		
		private var __impulsePower:Number = 5;
		
		protected var _rotationCorrection:Number = 1;//Runtime, not a setting
		protected var _collisionDuration:Number = 0;
		protected var _collisionOnListener:InteractionListener;
		protected var _player:Player;
		private var __life:Number = 20;
		protected var _impactDustTimer:Number = 0;
		
		protected var _baseMass:Number = 1;//Stores mass set by setMass() to be used by refreshMass()
		
		public function Obstacle(visual:MovieClip = null, shapeCoords:Array = null) 
		{
			if (ProfileState.instance.cheatDodos) {
				var left:Number = 9999;
				var right:Number = -9999;
				for (var i:int = 0; i < shapeCoords.length; i++) {
					left = Math.min(left, shapeCoords[i][0]);
					right = Math.max(right, shapeCoords[i][0]);
				}
				
				var dodoScale:Number = (right - left) / 100;
				//trace("Dodo scaling:", (right - left), dodoScale);
				dodoScale = NumberUtils.constrain(dodoScale, 0.7, 15);
				
				
				shapeCoords = ShapesData.getCoordsListOf("dodoObstacle", dodoScale);
				
				if (visual) {
					while (visual.numChildren >= 1) visual.removeChildAt(0);
				}
				if (visual && visual.parent) visual.parent.removeChild(visual);
				
				visual = new CheatDodoVisual();
				visual.scaleX = visual.scaleY = dodoScale * 1.05;
				
				applyFlipChance(visual, shapeCoords);
				
				var shapeList:ShapeList;
				
				if (shapeCoords == null) {
					Log.log("Obstacle - shapeCoords is null.");
					shapeList =  getDefaultRectShapeList(visual, 0.9);
				}else {
					shapeList = ShapesData.createShapeListFrom2DArray(shapeCoords);
				}
			}else {
				//Regular init, dodo cheat not enabled
				if (visual == null) {
					Log.log("Obstacle - passed visual is null.");
					visual = new DebugObstacleVisual();
				}
				
				applyFlipChance(visual, shapeCoords);
				
				var shapeList:ShapeList;
				
				if (shapeCoords == null) {
					shapeList =  getDefaultRectShapeList(visual, 0.9);
				}else {
					shapeList = ShapesData.createShapeListFrom2DArray(shapeCoords);
				}
			}
			

			
			
			super(shapeList, visual, null);
			
			
			_body.gravMass = 0;
			_body.setShapeMaterials(new Material(1, 0.1, 0.5, 1, 0.0001));
		}
		
		/** Used to centralize mass changes for easier maintenance */
		protected function setMass(mass:Number):void {
			//trace("Obstacle mass mult:", StatHooks.obstacleMassMult.value);
			_baseMass = mass;
			refreshMass();
		}
		
		public function refreshMass():void {
			_body.mass = _baseMass * StatHooks.obstacleMassMult.value;
			if (_body.mass == 0) _body.mass = 0.0001;
		}
		
		public function setPlayer(player:Player):void {
			_player = player;
		}
		
		protected function getShapeCoords(shapeName:String, scaleShape:Number = 1):Array {
			if (ProfileState.instance.cheatHugeObstacles) scaleShape *= Global.HUGE_OBSTACLES_CHEAT_MULT;
			return ShapesData.getCoordsListOf(shapeName, scaleShape);
		}
		
		protected function applyFlipChance(visual:MovieClip, shapeCoords:Array):void {
			if (Math.random() <= 0.5) {
				visual.scaleX *= -1;
				ShapesData.flipHorizontal(shapeCoords);
			}
		}
		
		override public function setPhysicsEngine(engine:PhysicsEngine):void 
		{
			super.setPhysicsEngine(engine);
			
			_body.cbTypes.add(Global.CB_TYPE_OBSTACLE);
			_body.setShapeFilters(new InteractionFilter(Global.COLLISION_GROUP_OBSTACLE, Global.COLLISION_MASK_OBSTACLE));
			//_collisionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, Global.CB_TYPE_OBSTACLE, Global.CB_TYPE_PLAYER, onPlayerCollision);
			_collisionOnListener = new InteractionListener(CbEvent.ONGOING, InteractionType.COLLISION, Global.CB_TYPE_OBSTACLE, Global.CB_TYPE_PLAYER, onPlayerCollisionOngoing);
			//_body.space.listeners.add(_collisionListener);
			_body.space.listeners.add(_collisionOnListener);
		}
		
		override public function tick(delta:Number):void {
			super.tick(delta);
			
			if (_rotationCorrection < 1)_rotationCorrection += _rotationCorrectionIncreasePerTick;
			rectifyRotation(_rotationCorrection);
			
			applyObstacleForce(delta);
			
			applyDrag(_drag);
			
			_collisionDuration -= 0.1;
			if (_collisionDuration < 0) _collisionDuration = 0;
			
			//applying fixed rotation drag to obstacle to make them spin less on impact
			_body.angularVel *= 0.98;
		}
		
		protected function applyObstacleForce(delta:Number):void {
			var angle:Number = Trig.toDegrees(_body.rotation);
			if (_movieClip.scaleX < 0) {
				angle -= 180;
			}
			
			var power:Number = _impulsePower * Global.powerPerMassUnit * _body.mass;
			
			var vx:Number = Trig.vectorX(power, angle);
			var vy:Number = Trig.vectorY(power, angle);
			applyForce(vx, vy);
		}
		
		protected function rectifyRotation(correctionMult:Number):void {
			_body.angularVel *= 1 - (correctionMult * 0.2);
			_body.rotation = NumberUtils.interpolate(_body.rotation, Trig.toRadians(_targetRotation), correctionMult, 1, true);//Old
			//_body.rotation = Trig.toRadians(NumberUtils.interpolateRotation(Trig.toDegrees(_body.rotation), _targetRotation, correctionMult, 1.2, true));
		}
		
		protected function onPlayerCollisionOngoing(cb:InteractionCallback):void {
			if (_player == null) {
				Log.log("Obstacle onPlayerCollisionOngoing() ERROR - No player reference set");
				return;
			}
			
			if (cb.arbiters.length <= 0) {
				//Nape can report a collision without an arbiter.
				return;
			}else {
				var arbiter:CollisionArbiter = cb.arbiters.at(0).collisionArbiter;
			}
			
			
			if (_body == arbiter.body1 || _body == arbiter.body2) {
				var i:Vec3 = cb.arbiters.at(0).collisionArbiter.normalImpulse();
				var angle:Number = Trig.angleTo(i.x, i.y, 0, 0);
				var strength:Number = ((Math.abs(i.x) + Math.abs(i.y)) / 2);
				var normStrength:Number = strength / (cb.int1.castBody.mass + cb.int2.castBody.mass);
				
				var contact:Contact = arbiter.collisionArbiter.contacts.at(0);
				
				//Smoke/dust particle
				if (getTimer() - _impactDustTimer >= MINIMUM_TIME_IMPACT_DUST) {
					//Particles.builder.impactSmoke(_player.getPositionX(), _player.getPositionY());
					Particles.builder.impactSmoke(contact.position.x, contact.position.y,0.8,1.2,_player.speed, _player.speedAngle, null, normStrength);
					_impactDustTimer = getTimer();
					//trace("Smoke spawned at", getTimer();
				}
				
				//trace("Impact strength:", strength, "Norm:", normStrength);
				_collisionDuration += 1;
				
				GameMediator.obstacleHit.dispatch(this);
				damageObstacle(angle, normStrength, _collisionDuration);
			}
		}
		
		public function damageObstacle(angle:Number, impactStrength:Number, collisionDuration:Number):void {
			//Base damage is based on player mass
			var massDamageMult:Number = NumberUtils.interpolate2(1, 2.5, getBody().mass, getBody().mass * 3, _player.getBody().mass, 0.8, true);
			var baseDamage:Number = NumberUtils.interpolate2(5, 200, 1, 300, _player.getBody().mass, 0.8);
			
			//Speed mult range from 0 to 5 and is used because collision arbiters are really unreliable it would seem
			var playerSpeed:Number = _player.speed;
			var speedMult:Number;
			if (playerSpeed <= 20) {
				speedMult = Easing.easeOutQuad(playerSpeed, 0, 0.6, 20);
			}else {
				speedMult = NumberUtils.interpolate2(0.6, 5, 20, 200, playerSpeed, 0.8);
			}
			
			//Impact mult ranges from 0.25 to 2, based on impact strength, scales up very rapidly and then tapers off
			var impactMult:Number;
			if (impactStrength == 0) {
				//Nothing registered from arbiters.... use speed twice
				impactMult = speedMult;
			}else if (impactStrength <= 50) {
				impactMult = Easing.easeOutQuad(impactStrength, 0.25, 0.75, 50);
			}else {
				impactMult = NumberUtils.interpolate2(1, 2, 50, 1000, impactStrength, 0.5);
			}
			
			//Duration damage is very slow to kick in but incredibly strong after ~30 frames or so, prevents being stuck in an obstacle
			var durationDamage:Number = NumberUtils.interpolate2(0, 1000, 0, 60, collisionDuration, 4);
			
			var damage:Number = (baseDamage * impactMult) + (baseDamage * speedMult) + durationDamage;
			damage *= massDamageMult;
			//trace("Damage:", damage.toFixed(0));
			
			_life -= damage;
			//trace("Life left:", _life);
			if (_life <= 0) {
				new DeadObstacle(_movieClip, _player, (impactMult + (speedMult * 3)) * massDamageMult);
				_movieClip = null;
				destroy();
			}
		}
		
		//Instantly kills and obstacle and returns the life it had left */ 
		public function killObstacleFromShield(shieldStrengh:Number):Number {
			if (_life > 0) {
				var lifeInShieldStrength:Number = NumberUtils.interpolate2(1, 20, 10, 1500, _life, 1.2);
				if (shieldStrengh >= lifeInShieldStrength) {
					var dmg:Number = lifeInShieldStrength;
					trace("Shield killed obstacle for :", _life, "->", dmg.toFixed(0));
					_life = 0;
					return dmg;
				}else {
					var ratio:Number = shieldStrengh / lifeInShieldStrength;
					_life -= _life * ratio;
					return shieldStrengh;
				}
				
			}else {
				return 0;	
			}
		}
		
		
		
		override public function setPosition(X:Number = NaN, Y:Number = NaN):void 
		{
			super.setPosition(X, Y);
		}
		
		protected function get _impulsePower():Number 
		{
			return __impulsePower * StatHooks.obstacleSpeedMult.value;
		}
		
		protected function set _impulsePower(value:Number):void 
		{
			__impulsePower = value;
		}
		
		protected function get _life():Number 
		{
			return __life;
		}
		
		protected function set _life(value:Number):void 
		{
			__life = value;
		}
		
		override public function destroy():void 
		{
			_player = null;
			
			if (_body && _body.space && _collisionOnListener) _body.space.listeners.remove(_collisionOnListener);
			_collisionOnListener = null;
			
			if (signalDeath) {
				signalDeath.dispatch(this);
				signalDeath.removeAll();
			}
			signalDeath = null;
			
			super.destroy();
		}
		
	}

}