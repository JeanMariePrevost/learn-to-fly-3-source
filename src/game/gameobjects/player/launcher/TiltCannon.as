package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import sound.CannonLight;
	import sound.FuseBurning;
	import src.audio.Audio;
	import src.audio.ISound;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameCamera;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.game.GameToolTip;
	import src.game.particles.Particles;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class TiltCannon extends AbstractLauncher 
	{
		public var cannon:MovieClip;
		
		
		protected var _wrapper:DeltaMovieClipWrapper;
		protected var _cannonWrapper:DeltaMovieClipWrapper;
		
		
		protected var _minRotation:Number = -120;
		protected var _maxRotation:Number = 120;
		
		protected var _torqueTime:Number = 0;
		protected var _torqueDuration:Number = 20;
		protected var _torque:Number = 0.35;
		protected var _friction:Number = 0.94;
		protected var _accel:Number = 0.3;
		protected var _vr:Number = 0;
		protected var _noise:Number = 1;
		protected var _lockRotation:Boolean = false;
		
		protected var _wickLoop:ISound;
		
		public function TiltCannon(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			
			cannon.gotoAndStop(1);
			gotoAndStop(1);
			
			_wrapper = new DeltaMovieClipWrapper(this, 1);
			_wrapper.stop();
			
			_cannonWrapper = new DeltaMovieClipWrapper(cannon, "idleStart");
			_cannonWrapper.stop();
			
			_player.getMovieClip().visible = false;
			
			GameToolTip.show("tiltCannon");
			_wickLoop = Audio.playFadingSoundLoop(FuseBurning, this, 1000);
		}
		
		
		override public function tick(delta:Number):void 
		{
			if (!_lockRotation) {
				var currentTorque:Number = 0;
				
				if (Input.metaLeft.isDown) {
					_torqueTime = Math.min(_torqueTime+1, _torqueDuration);
					currentTorque = Easing.easeLinear(_torqueTime, 0, -_torque, _torqueDuration);
				}else if (Input.metaRight.isDown) {
					_torqueTime = Math.min(_torqueTime+1, _torqueDuration);
					currentTorque = Easing.easeLinear(_torqueTime, 0, _torque, _torqueDuration);
				}else {
					currentTorque = 0;
					_torqueTime = 0;
				}
				
				
				_vr += currentTorque;
				
				if (cannon.rotation == 0) {
					_vr += NumberUtils.randomBoth(_noise);
				}
				
				_vr += NumberUtils.constrain(cannon.rotation / 90, -1, 1) * _accel;
				_vr *= _friction;
				cannon.rotation += _vr;
				
				if (cannon.rotation >= _maxRotation) {
					cannon.rotation = _maxRotation;
					_vr = 0;
				}else if (cannon.rotation <= _minRotation) {
					cannon.rotation = _minRotation;
					_vr = 0;
				}
			}
			
			
			if (_wrapper.currentState == "on") {
				_wrapper.tick(delta);
				movePlayer();
			}else if (_wrapper.currentState == "active") {
				if (_cannonWrapper.currentState == "idle") {
					_cannonWrapper.setToOn();
					movePlayer();
				}else if (_cannonWrapper.currentState == "on") {
					_cannonWrapper.tick(delta);
					movePlayer();
				}else if (_cannonWrapper.currentState == "active") {
					//trace("BOOM!");
					playSoundEffect();
					GameToolTip.hide();
					_lockRotation = true;
					_cannonWrapper.setToSpecial();
					finalizeTakeoff();
					applyPower();
				}else if (_cannonWrapper.currentLabel == "specialStart") {
					_cannonWrapper.tick(delta);
				}else if (_cannonWrapper.currentLabel == "specialEnd") {
					//trace("Finished!");
					finalizeLauncher();
				}
			}
		}
		
		override protected function playSoundEffect():void 
		{
			if (_wickLoop) _wickLoop.fadeOut(150);
			Audio.playSound(CannonLight);
		}
		
		
		protected function movePlayer():void {
			//trace("Moving player");
			var pos:Point = DisplayObjectUtil.localToLocal2(cannon.tTop, cannon, GameCamera.instance.getMovingLayer(0));
			_player.setPositionFromAnchor(pos.x, pos.y);
			_player.rotation = Trig.toRadians(cannon.rotation);
		}
		
		protected function applyPower():void {
			var power:Number = launcherBasePower;
			var powerAtWeight:Number = powerAtCurrentWeight;
			
			movePlayer();
			_player.getMovieClip().visible = true;
			
			for (var i = 0; i <= 8; i++) {
				Particles.builder.smokeWhite(_player.getPositionX(), _player.getPositionY(), 0.8, 1.2, 2 + Math.random() * 6, cannon.rotation - 90 + NumberUtils.randomBoth(90));
			}
			for (i = 0; i <= 6; i++) {
				Particles.builder.smokeWhite(_player.getPositionX(), _player.getPositionY(), 0.8, 1.2, 10 + Math.random() * 8, cannon.rotation - 90 + NumberUtils.randomBoth(15));
			}
			
			//trace("Applying launcher power:", power, "x", powerAtWeight);
			
			applyLauncherThrust(power * powerAtWeight);
		}

		
	}

}