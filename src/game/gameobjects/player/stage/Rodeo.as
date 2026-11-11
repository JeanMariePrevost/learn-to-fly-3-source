package src.game.gameobjects.player.stage 
{
	import flash.geom.Point;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import nape.constraint.DistanceJoint;
	import nape.constraint.PivotJoint;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import src.Main;
	import src.compound.Mod;
	import src.effects.smoketrail.SmokeTrail;
	import src.game.GameCamera;
	import src.game.GameEngine;
	import src.game.GameMediator;
	import src.game.gameobjects.GameObject;
	import src.game.gameobjects.player.Player;
	import src.game.gameobjects.ShapesData;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	import src.system.Global;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Rodeo extends AbstractStage 
	{
		protected var _payload:GameObject;
		protected var _payloadBody:Body;
		protected var _chains:Vector.<GameObject> = new Vector.<GameObject>();
		protected var _engine:GameEngine;
		protected var _trail:SmokeTrail;
		
		protected var _rotateP1:Point = new Point();
		protected var _rotateP2:Point = new Point();
		
		protected var _firstJoint:DistanceJoint;
		
		protected var _playerMassMod:Mod;
		
		public function Rodeo(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			var direction:Number = 0;//<0 left, >0 right
			
			if (ProfileState.instance.optionMouseControl >= 1) {
				//Mouse-controlled
				if (GameMediator.mouseControlValue >= 0) {
					direction = NumberUtils.interpolate2(0, 1, 0, 1, GameMediator.mouseControlValue, 0.3);
				}else {
					direction = NumberUtils.interpolate2(0, -1, 0, -1, GameMediator.mouseControlValue, 0.3);
				}
				trace("direction", direction, "GameMediator.mouseControlValue", GameMediator.mouseControlValue);
			}else {
				//Regular controls
				if (Input.metaLeft.isDown) {
					direction = -1;
				}else if (Input.metaRight.isDown) {
					direction = 1;
				}
			}
			
			if (fuel > 0) {
				if (Input.metaDown.isDown) {
					stopSound();
					_trail = null;
					if (direction != 0) {
						doRotation(direction, delta, 0.7, 0.1);
					}
					
					
				}else {
					playSound();
					
					if (direction != 0) {
						doRotation(direction, delta);
					}
					
					createTrails();
					
					var p:Point = GameCamera.getPositionOnCamera(_payload.getMovieClip().bottom);
					_trail.addSegment(p.x, p.y, _payload.getMovieClip().rotation + 90);
					
					substractFuel(delta);
					var pow:Number = power * Global.powerPerMassUnit * _payloadBody.mass * delta * StatHooks.stagePowerMult.value;
					_payload.applyRelativeAngleForce(pow, 0, Vec2.get(0, 8));
					rotatePlayer();
				}
			}else {
				stopSound();
				if (direction != 0) {
					doRotation(direction, delta, 0.7, 0.1);
				}
				_trail = null;
				
				_isFinished = true;
				if (_firstJoint) {
					_firstJoint.active = false;
					_firstJoint = null;
				}
				
			}
			
			_payloadBody.angularVel *= 0.975;
			
			
		}
		
		override protected function substractFuel(delta:Number):void 
		{
			super.substractFuel(delta);
			
			if (fuel <= 0 && _playerMassMod) {
				GameMediator.playerWeightChange.remove(playerChangedMass);
				GameMediator.updatePlayerDrag.remove(onPlayerDrag);
				_playerMassMod.destroy();
				_playerMassMod = null;
			}
		}
		
		protected function doRotation(mult:Number, delta:Number, rotationMult:Number = 1, translationMult:Number = 1):void {
			_rotateP1.x = _player.getPositionX();
			_rotateP1.y = _player.getPositionY();
			_rotateP2.x = _payload.getPositionX();
			_rotateP2.y = _payload.getPositionY();
			
			var distFromPlayer:Number = Point.distance(_rotateP1, _rotateP2);
			
			var rotationAmount:Number = rotationMult * NumberUtils.interpolate2(0.6, 0.55, 0, 500, distFromPlayer, 1);
			var translationAmount:Number = translationMult * NumberUtils.interpolate2(0.15, 1, 0, 500, distFromPlayer, 1.4) * Math.abs(mult);
			
			var angleFromPlayer:Number = Trig.angleToObject(_player.getMovieClip(), _payload.getMovieClip());
			
			_payload.applyRotation(_item.statTorque * rotationAmount * mult * delta);
			
			var translationBasePower:Number = 4 * translationAmount;
			
			var pow:Number = translationBasePower * Math.abs(mult) * Global.powerPerMassUnit * _payloadBody.mass * delta * StatHooks.stagePowerMult.value;
			if (mult >= 0) {
				_payload.applyRelativeAngleForce(pow, 91);
			}else {
				_payload.applyRelativeAngleForce(pow, - 91);
			}
			
			//trace(distFromPlayer.toFixed(1));
		}
		
		override public function startStage():void 
		{
			_engine = GameEngine.instance;
			setupChain();
			
			super.startStage();
		}
		
		protected function rotatePlayer():void {
			if (ProfileState.instance.optionMouseControl <= 0) {
				var rDiff:Number = _payload.rotation - _player.rotation;
				//trace("Rotation diff:", rDiff);
				_player.applyRotation(rDiff * 0.25);
			} else {
				var rDiff:Number = 0 - _player.rotation;
				//trace("Rotation diff:", rDiff);
				_player.applyRotation(rDiff * 1.1);
			}
				
		}
		
		protected function setupChain():void {
			var payloadScale:Number = 0.6;// NumberUtils.interpolate2(0.2, 3, 5, 450, unscaledPayloadMass, 1.25);//This part downscales the payload a bit if the player is lighter
			
			_payload = new GameObject(ShapesData.getShapeListOf("payload", payloadScale), new _item.statVisualClass());
			_payloadBody = _payload.getBody();
			_payload.getMovieClip().scaleX = _payload.getMovieClip().scaleY = payloadScale;
			_payload.setPositionFromPoint(_player.getPositionX(), _player.getPositionY(), 0.5, 1);
			_engine.addToPhysicsEngine(_payload);
			_payloadBody.cbTypes.add(Global.CB_TYPE_PARTICLE);
			_payloadBody.setShapeFilters(new InteractionFilter(Global.COLLISION_GROUP_PARTICLE, Global.COLLISION_MASK_PARTICLE));
			
			var chainLength:uint = 7;// Math.round(NumberUtils.interpolate2(MAX_CHAIN_LENGTH, MIN_CHAIN_LENGTH, 1, 250, payloadMass, 0.3));
			var chainScale:Number = 1;// NumberUtils.interpolate2(0.4, 3, 1, 250, payloadMass, 1.5);
			var chainLinkPosition:Number = 18 * chainScale;//How far from center the joint is on both sides
			
			for (var i:int = 0; i < chainLength; i++) {
				var c:GameObject = new GameObject(ShapesData.getShapeListOf("payloadChain", chainScale), new src.game.PayloadChain2());
				c.getBody().mass =  0.1;
				c.getMovieClip().scaleX = chainScale;
				c.getMovieClip().scaleY = chainScale * 1.5;
				c.setPositionFromPoint(_player.getPositionX() + NumberUtils.randomBoth(5), _player.getPositionY() + NumberUtils.randomBoth(5), 0.5, 1);
				_engine.addToPhysicsEngine(c);
				c.getBody().setShapeFilters(new InteractionFilter(Global.COLLISION_GROUP_CHAIN, Global.COLLISION_MASK_CHAIN));
				_chains.push(c);
			}
			
			var dj:DistanceJoint
			var j:PivotJoint;
			
			for (var i:int = 1; i < chainLength; i++) {
				//j = new PivotJoint(_chains[i - 1].getBody(), _chains[i].getBody(), new Vec2(0, -chainLinkPosition), new Vec2(0, chainLinkPosition));
				//j.space = _engine.physicsEngine.space;
				//j.active = true;
				//j.stiff = true;
				//j.ignore = true;
				
				dj = new DistanceJoint(_chains[i - 1].getBody(), _chains[i].getBody(), new Vec2(0, -chainLinkPosition), new Vec2(0, chainLinkPosition), 0, chainLinkPosition * 0.2);
				dj.space = _engine.physicsEngine.space;
				dj.active = true;
				dj.stiff = true;
				dj.ignore = true;
			}
			
			//j = new PivotJoint(_payloadBody, _chains[0].getBody(), new Vec2(0, 90 * payloadScale), new Vec2(0, chainLinkPosition));
			//j.space = _engine.physicsEngine.space;
			//j.active = true;
			//
			//j = new PivotJoint(_chains[_chains.length - 1].getBody(), _player.getBody(), new Vec2(0, -chainLinkPosition), new Vec2(0, 0));
			//j.space = _engine.physicsEngine.space;
			//j.active = true;
			
			dj = new DistanceJoint(_payloadBody, _chains[0].getBody(), new Vec2(0, 70 * payloadScale), new Vec2(0, chainLinkPosition), 0, chainLinkPosition * 0.2);
			dj.space = _engine.physicsEngine.space;
			dj.active = true;
			dj.stiff = true;
			dj.ignore = true;
			
			dj = new DistanceJoint(_chains[_chains.length - 1].getBody(), _player.getBody(), new Vec2(0, -chainLinkPosition), new Vec2(0, 0), 0, chainLinkPosition * 0.2);
			dj.space = _engine.physicsEngine.space;
			dj.active = true;
			dj.stiff = true;
			dj.ignore = true;
			_firstJoint = dj;//Reference to destroy when stage is over
			
			//Maximum distance constraint
			//dj = new DistanceJoint(_player.getBody(), _payloadBody, new Vec2(), new Vec2(), 1, 1000);
			//dj.space = _engine.physicsEngine.space;
			//dj.active = true;
			
			_engine.addChildToMovingLayer(_payload.getMovieClip(), 1);
			
			for each (var chain:GameObject in _chains) {
				_engine.addChildToMovingLayer(chain.getMovieClip(), 1);
			}
			
			
			_playerMassMod = new Mod(0, 1);
			StatHooks.invisWeightMult.addMod(_playerMassMod);
			playerChangedMass(_player.getBody().mass);
			GameMediator.playerWeightChange.add(playerChangedMass);
			GameMediator.updatePlayerDrag.add(onPlayerDrag);
		}
		
		
		protected function onPlayerDrag(drag:Number):void {
			drag = 1 - ((1 - drag) * StatHooks.dragMult.value);
			_payloadBody.velocity = _payloadBody.velocity.mul(drag);
		}
		
		protected function playerChangedMass(mass:Number):void {
			GameMediator.playerWeightChange.remove(playerChangedMass);
			
			var massModRatio:Number = NumberUtils.interpolate2(1, _item.statSpecial, 50, 450, mass, 1.2, true);
			_playerMassMod.mul = massModRatio;
			//trace("Player mass:", mass.toFixed(0), _item.statSpecial, massModRatio, _playerMassMod.mul);
			
			var payloadMass:Number = 3 + (_player.getBody().mass * (_item.getPowerAtWeightMult(_player.getBody().mass)) * 0.18);
			_payloadBody.mass = payloadMass;
			GameMediator.playerWeightChange.add(playerChangedMass);
			//trace("playerChangedMass:", mass, "->", payloadMass); 
		}
		
		protected function createTrails():void 
		{
			if (_trail == null) {
				_trail = SmokeTrail.newSmokeTrail();
				_trail.color = 0xEEEEEE;
				_trail.alpha = 1;
				_trail.fadeInLength = 6;
				_trail.fadeInAlpha = 0.1;
				_trail.fadeInPower = 0.7;
				_trail.fadeOutLegnth = 20;
				_trail.pushForce = 55;
				_trail.pushForceDrag = 0.95;
				_trail.spreadForce = 3.5;
				_trail.fadePerTick = 0.025;
				_trail.maxSegments = 50;
				_trail.lineWidth = 40;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trail.visual, _payload.getMovieClip(), -1);
			}
		}
		
		override public function destroy():void 
		{
			GameMediator.playerWeightChange.remove(playerChangedMass);
			GameMediator.updatePlayerDrag.remove(onPlayerDrag);
			
			if (_payload) _payload.destroy();
			_payload = null;
			_payloadBody = null;
			
			if (_chains) {
				for each(var o:GameObject in _chains) o.destroy();
				_chains.length = 0;
			}
			_chains = null;
			_engine = null;
			
			if (_trail)_trail.destroy();
			_trail = null;
			
			_rotateP1 = null;
			_rotateP2 = null;
			
			_firstJoint = null;
			
			if (_playerMassMod) _playerMassMod.destroy();
			_playerMassMod = null;
			
			
			super.destroy();
		}
		
		
		
	}

}