package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import sound.UfoSound;
	import src.UiScaler;
	import src.audio.Audio;
	import src.audio.ISound;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameCamera;
	import src.game.GameEngine;
	import src.game.GameEnginePayload;
	import src.game.GameMediator;
	import src.game.StatHooks;
	import src.game.gameobjects.FallingObject;
	import src.game.gameobjects.IFallingObject;
	import src.game.gameobjects.player.Player;
	import src.game.GameToolTip;
	import src.game.PhysicsEngine;
	import src.system.GameStateItem;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Ufo extends AbstractLauncher 
	{
		public var cow:MovieClip;
		public var beam:MovieClip;
		
		protected var _fallingCow:IFallingObject;
		
		
		protected const DEBRIS_START_FRAME:uint = 220;
		protected const MOVE_MIN_RANGE:Number = 400;
		protected const MOVE_MAX_RANGE:Number = 600;
		protected const MOVE_MIN_DURATION:Number = 200;
		protected const MOVE_MAX_DURATION:Number = 300;
		
		protected const MAX_SCORE:Number = 250;
		
		protected const BEAM_GOOD_WIDTH:Number = 105;
		protected const BEAM_END_WIDTH:Number = 240;
		
		protected var _playerControl:Number = 6;
		protected var _wrapper:DeltaMovieClipWrapper;
		protected var _debris:UfoDebrisLayer;
		protected var _message1:MovieClip;
		protected var _message2:MovieClip;
		
		protected var _tickFunction:Function;
		
		protected var _cowVr:Number = 0;
		protected var _cowVrIncrement:Number = (Math.random() - 0.5) * 0.1;
		protected var _cowVrDrag:Number = 0.97;
		protected var _cowBaseY:Number;
		
		protected var _playerVr:Number = 0;
		protected var _playerVrDrag:Number = 0.91;
		
		
		protected var _moveTime:Number = 0;
		protected var _moveDuration:Number = 200;
		protected var _moveStart:Number = 0;
		protected var _moveEnd:Number = 0;
		
		protected var _outroTime:Number = 0;
		protected var _outroDuration:Number = 120;
		protected var _outroStartY:Number;
		protected var _outroModY:Number = -3000;
		
		protected var _score:Number = 0;
		protected var _fuel:Number;
		protected var _time:Number = 0;//Adds up all the delta while active phase
		
		protected var _soundLoop:ISound;
		
		public function Ufo(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			
			_wrapper = new DeltaMovieClipWrapper(this);
			//_wrapper.setAction("offEnd", "deathStart");
			
			_fuel = _item.statFuel * NumberUtils.interpolate(1, StatHooks.launchPowerMult.value, 0.4);//Part of the usual power mult goes into fuel
			_playerControl = 10;// _item.statTorque;
			beam.scaleX = _item.statTopSpeed;
			//beam.cacheAsBitmap = true;
			
			_message1 = new _item.statVisualClass();
			_message1.stop();
			GameCamera.instance.addChildToFixedLayer(_message1, 4);
			UiScaler.addAbsolute(_message1, 360);
			
			_tickFunction = tickIntro;
			_wrapper.setToOn();
			
			_cowBaseY = cow.y;
			beam.gotoAndStop(1);
			
			_soundLoop = Audio.playFadingSoundLoop(UfoSound, this, 1500);
			
			GameToolTip.show("alienBait");
			
			_player.setPositionFromAnchor(0, gameEngine.ground.groundLevel, Player.ANCHOR_BOTTOM);
			
			moveBeamY(true);
		}
		
		/** Returns the item power adjusted with StatHooks launch mult*/
		override public function get launcherBasePower():Number {
			var p:Number = _item.statPower * NumberUtils.interpolate(1, StatHooks.launchPowerMult.value, 0.2);//Only a slight part of the bonus goes as power
			
			return p;
		}
		
		override public function tick(delta:Number):void 
		{
			_tickFunction(delta);
			
			if (beam) {
				beam.gotoAndStop(_wrapper.currentFrame);
			}
		}
		
		protected function tickIntro(delta:Number):void {
			if (_message1.stage && _message1.currentFrame >= _message1.totalFrames) {
				_message1.parent.removeChild(_message1);
			}else {
				_message1.nextFrame();
			}
			
			if (_debris == null && currentFrame >= DEBRIS_START_FRAME) {
				_debris = new UfoDebrisLayer();
				GameCamera.instance.addChildToFixedLayer(_debris.visual, 0);
				_debris.start();
			}
			
			if (_wrapper.currentState == "active") {
				GameToolTip.hide();
				_tickFunction = tickActive;
			}
			
			moveBeamY(true);
		}
		
		protected function tickActive(delta:Number):void {
			_fuel -= delta;
			_time+= delta;
			if (_fuel <= 0) {
				if (_message2 == null) {
					_message2 = new _item.statVisualClass2();
					_message2.stop();
					GameCamera.instance.addChildToFixedLayer(_message2, 4);
					UiScaler.addAbsolute(_message2, 360);
				}else {
					if (_message2.stage && _message2.currentFrame >= _message2.totalFrames) {
						_message2.parent.removeChild(_message2);
					}else {
						_message2.nextFrame();
					}
				}
				_wrapper.setToSpecial();
				if (_message2.currentFrame >= _message2.totalFrames && _wrapper.currentLabel == "specialEnd") {
					endPullPhase();
					return;
				}
			}
			
			tickBeamMovement(delta);
			
			applyLiftTick(delta);
			
			var drag:Number = 1 - ((1 - _item.statSpecial) * delta);
			_player.applyDrag(drag);
			
			y += ((_player.getPositionY() + _score) - y) * (0.02 + NumberUtils.interpolate2(0,0.35,0,300,Math.abs((_player.getPositionY() + _score) - y), 2));
			
			_cowVr += _cowVrIncrement;
			_cowVr *= _cowVrDrag;
			cow.rotation += _cowVr;
			cow.y = NumberUtils.interpolate2(_cowBaseY, _cowBaseY - 1600, _item.statFuel, 0, _fuel, 1);
			
			
			if (ProfileState.instance.optionMouseControl >= 1) {
				//Mouse-controlled
				//GameMediator.mouseControlValue;
				//trace("GameMediator.mouseControlValue", GameMediator.mouseControlValue);
				applyLauncherThrust(_playerControl * GameMediator.mouseControlValue, 90, false);
				_playerVr += 0.0008 * delta * GameMediator.mouseControlValue;
			}else {
				//Regular controls
				if (Input.metaLeft.isDown) {
					applyLauncherThrust(_playerControl, -90, false);
					_playerVr -= 0.0008 * delta;
				}
				
				if (Input.metaRight.isDown) {
					applyLauncherThrust(_playerControl, 90, false);
					_playerVr += 0.0008 * delta;
				}
			}
			
			_playerVr *= _playerVrDrag;
			if (_playerVr >= 0) {
				if (_player.rotation >= 0) {
					_playerVr *= NumberUtils.interpolate2(1, 0, 0, 0.55, Math.abs(_player.rotation), 3);
				}
			}else {
				if (_player.rotation <= 0) {
					_playerVr *= NumberUtils.interpolate2(1, 0, 0, 0.55, Math.abs(_player.rotation), 3);
				}
			}
			
			var newRotation:Number = _player.rotation + _playerVr * delta;
			_player.rotation = newRotation;
			
			countScore(delta);
			
			moveBeamY();
		}
		
		protected function moveBeamY(instant:Boolean = false):void {
			if (instant) {
				y = _player.getPositionY();
			}else {
				var yFromScore:Number = NumberUtils.interpolate2(MAX_SCORE * 1.6, -900, MAX_SCORE, -item.statTorque, _score, 1);
				y = yFromScore + NumberUtils.interpolate(y, _player.getPositionY(), Math.min(1, _time / 120));
				//trace(y, yFromScore, _player.getPositionY());
			}
		}
		
		protected function applyLiftTick(delta:Number):void {
			var power:Number = launcherBasePower;
			var powerAtWeight:Number = _item.getPowerAtWeightMult(_player.getBody().mass);
			
			var payloadMult:Number = 1;
			
			//Payload mode nerf
			if (ProfileState.instance.currentGameState.gameMode == "Payload Mode") {
				var payloadWeight:Number = GameEnginePayload.selectedPayload.statWeight.valueAt(0);
				payloadMult = NumberUtils.interpolate2(1, 0.05, 10, 250, payloadWeight, 0.7);
			}
			
			applyLauncherThrust(power * powerAtWeight * delta * payloadMult, 0, false);
		}
		
		protected function tickBeamMovement(delta:Number):void {
			if (_moveTime >= _moveDuration) {
				//New movement
				_moveStart = x;
				var direction:Number = (Math.random() <= 0.5) ? 1: -1;
				var movement:Number = direction * NumberUtils.randomRange(MOVE_MIN_RANGE, MOVE_MAX_RANGE);
				//trace("New movement:", movement);
				_moveEnd = x + movement;
				_moveTime = 0;
				_moveDuration = NumberUtils.randomRange(MOVE_MIN_DURATION, MOVE_MAX_DURATION);
			}else {
				//trace("Moving", _moveDuration - _moveTime)
				_moveTime += delta;
				var oldX:Number = x;
				x = Easing.easeBothInOutQuad(_moveTime, _moveStart, _moveStart - _moveEnd, _moveDuration);
				rotation = NumberUtils.interpolate2( 5, -5, -1, 1, (oldX - x) / 2, 0.9);
			}
			
		}
		
		protected function countScore(delta:Number):void {
			var mult:Number = 0.02 * delta;
			var amount:Number = y - _player.getPositionY();
			var offset = rotation * amount * mult;
			
			var goodWidth:Number = BEAM_GOOD_WIDTH * beam.scaleX;
			var endWidth:Number = BEAM_END_WIDTH * beam.scaleX;
			
			if (Math.abs((x + offset) - _player.getPositionX()) <= goodWidth) {
				_score += NumberUtils.interpolate2(2, 0.4, -item.statTorque, MAX_SCORE, _score, 0.5);
			}else {
				_score -= NumberUtils.interpolate2(0, 6, goodWidth, endWidth, Math.abs((x + offset) - _player.getPositionX()), 2);
			}
			
			_score = Math.min(MAX_SCORE, Math.max( -item.statTorque, _score));
			//trace("UFO Fuel:", _fuel.toFixed(), "Score:", _score.toFixed());
			
			if (_score <= -item.statTorque) {
				//Falling off
				endPullPhase();
			}
		}
		
		protected function endPullPhase():void {
			detachCow();
			
			
			if (_soundLoop) _soundLoop.fadeOut(500);
			
			finalizeTakeoff();
			
			_debris.stop();
			_wrapper.setToDeath();
			_outroStartY = beam.y;
			_tickFunction = tickDeath;
		}
		
		protected function detachCow():void {
			DisplayObjectUtil.changeContainer(cow, GameCamera.instance.getMovingLayer(0));
			_fallingCow = FallingObject.getNewFallingObject(cow);
			_fallingCow.useObjectPosition(cow);
			GameCamera.instance.addChildToMovingLayer(_fallingCow.getMovieClip());
			_fallingCow.setPhysicsEngine(PhysicsEngine.instance);
			_fallingCow.mimicBodyMomentum(_player.getBody(), 0.4);
		}
		
		protected function tickDeath(delta:Number):void {
			if (_outroTime < _outroDuration) {
				_outroTime += delta;
				y += ((_player.getPositionY() + _score) - y) * (0.01 + NumberUtils.interpolate2(0,0.25,0,300,Math.abs((_player.getPositionY() + _score) - y), 2));
				//beam.y = Easing.easeLinear(_outroTime, _outroStartY, _outroModY, _outroDuration);
				//trace(beam.y);
				//y -= 10;
				//x += 20;
			}else {
				finalizeLauncher();
				destroy();
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			cow = null;
			beam = null;
			_fallingCow = null;
			
			if (_wrapper) _wrapper.destroy();
			_wrapper = null;
			
			_debris = null;
			
			if (_message1) {
				if (_message1.parent) _message1.parent.removeChild(_message1);
			}
			_message1 = null;
			
			if (_message2) {
				if (_message2.parent) _message2.parent.removeChild(_message2);
			}
			_message2 = null;
			
			_tickFunction = null;
			
			if (_soundLoop) _soundLoop.destroy();
			_soundLoop = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}