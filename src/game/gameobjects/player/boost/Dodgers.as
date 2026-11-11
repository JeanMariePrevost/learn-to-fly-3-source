package src.game.gameobjects.player.boost 
{
	import flash.utils.getTimer;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.compound.Mod;
	import src.game.DeltaMovieClipWrapper;
	import src.game.gameobjects.player.Player;
	import src.game.particles.Particles;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Dodgers extends SimpleBoost 
	{
		protected const DOUBLE_TAP_TIME:uint = 300;
		protected const INITIAL_BURST_MULT:Number = 5;//Effect will be multiplied for a few frames
		protected const INITIAL_BURST_DURATION:Number = 20;//Duration of the fade-out for the burst
		protected var _initialBurstCount:Number = INITIAL_BURST_DURATION;
		
		protected var _leftTiming:Number = 0;
		protected var _thrustingLeft:Boolean = false;
		protected var _wasThrustingLeft:Boolean = false;
		
		protected var _rightTiming:Number = 0;
		protected var _thrustingRight:Boolean = false;
		protected var _wasThrustingRight:Boolean = false;
		
		protected var _rudderMod:Mod = new Mod(0, 1);//Used to remove rudder control
		protected var _smokeCounter:Number = 0;
		
		protected var _classicModeNerf:Number = 2;//Multiplies fuel usage if in classic mode
		
		
		public function Dodgers(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			Input.metaLeft.signalCommandDown.add(leftDown);
			Input.metaLeft.signalCommandUp.add(leftUp);
			Input.metaRight.signalCommandDown.add(rightDown);
			Input.metaRight.signalCommandUp.add(rightUp);
			
			StatHooks.rudderMult.addMod(_rudderMod);
			
			if (ProfileState.instance.currentGameState.gameMode != "Classic Mode") {
				_classicModeNerf = 1;//Disable nerf because not playing in classic mode
			}
		}
		
		override public function tick(delta:Number):void 
		{
			var fuelBeforeTick:Number = fuel.value;
			
			if (fuel.value > 0) {
				if (_thrustingLeft) {
					thrustLeft(delta);
					rightWrapper.setToOn();
				}else {
					rightWrapper.setToOff();
				}
				
				if (_thrustingRight) {
					thrustRight(delta);
					leftWrapper.setToOn();
				}else {
					leftWrapper.setToOff();
				}
			}else {
				_thrustingLeft = false;
				_thrustingRight = false;
				leftWrapper.setToOff();
				rightWrapper.setToOff();
			}
			
			if (_thrustingLeft || _thrustingRight) {
				//Disable rudder while dodging
				_rudderMod.mul = 0;
				playSound();
				if (!_wasThrustingLeft && !_wasThrustingRight) {
					//Just starting a new thrust, reset burst count
					_initialBurstCount = 0;
				}
				
			}else {
				stopSound();
				_rudderMod.mul = 1;
			}
			
			_wasThrustingLeft = _thrustingLeft;
			_wasThrustingRight = _thrustingRight;
			
			_hudSignal.dispatch(fuel.value / maxFuel);
			
			if (fuelBeforeTick > 0 && fuel.value <= 0) {
				_player.updateBodyMass();
			}
		}
		
		
		protected function leftDown():void {
			if (fuel.value <= 0 || !_player.enableTicking) return;
			
			var time:Number = getTimer();
			
			if (time - _leftTiming < DOUBLE_TAP_TIME) {
				_thrustingLeft = true;
			}else {
				_leftTiming = getTimer();
			}
			
		}
		
		protected function leftUp():void {
			_thrustingLeft = false;
		}
		
		protected function thrustLeft(delta:Number):void {
				if (_smokeCounter <= 0) {
					_smokeCounter = 2;
					Particles.builder.smokeWhiteQuick(rightVisual.smokeTarget1.x, rightVisual.smokeTarget1.y, 0.5, 0.7, 8 + Math.random() * 4, DisplayObjectUtil.globalRotationOf(rightVisual.smokeTarget1) - rightVisual.smokeTarget1.rotation*2 + 180 + NumberUtils.randomBoth(4), rightVisual);
					if(rightVisual.smokeTarget2) Particles.builder.smokeWhiteQuick(rightVisual.smokeTarget2.x, rightVisual.smokeTarget2.y, 0.5, 0.7, 8 + Math.random() * 4, DisplayObjectUtil.globalRotationOf(rightVisual.smokeTarget2) - rightVisual.smokeTarget2.rotation*2 + 180 + NumberUtils.randomBoth(4), rightVisual);
				}else {
					_smokeCounter -= 1;
				}
				var burstMult:Number = getBurstMult(delta);
				fuel.value -= delta * burstMult * _classicModeNerf;
				var thrust:Number = power * getPowerAngleMult() * StatHooks.boostPowerMult.value * delta * burstMult * _item.getPowerAtWeightMult(_player.getBody().mass)
				//trace("Dodgers left thrust:", thrust);
				_player.applyThrust(thrust, -90);
		}
		
		
		protected function rightDown():void {
			if (fuel.value <= 0 || !_player.enableTicking) return;
			
			var time:Number = getTimer();
			
			if (time - _rightTiming < DOUBLE_TAP_TIME) {
				_thrustingRight = true;
			}else {
				_rightTiming = getTimer();
			}
			
		}
		
		protected function rightUp():void {
			_thrustingRight = false;
		}
		
		protected function thrustRight(delta:Number):void {
				if (_smokeCounter <= 0) {
					_smokeCounter = 2;
					Particles.builder.smokeWhiteQuick(leftVisual.smokeTarget1.x, leftVisual.smokeTarget1.y, 0.5, 0.7, 8 + Math.random() * 4, DisplayObjectUtil.globalRotationOf(leftVisual.smokeTarget1) + 180 + NumberUtils.randomBoth(4), leftVisual);
					if(leftVisual.smokeTarget2) Particles.builder.smokeWhiteQuick(leftVisual.smokeTarget2.x, leftVisual.smokeTarget2.y, 0.5, 0.7, 8 + Math.random() * 4, DisplayObjectUtil.globalRotationOf(leftVisual.smokeTarget2) + 180 + NumberUtils.randomBoth(4), leftVisual);
				}else {
					_smokeCounter -= 1;
				}
				var burstMult:Number = getBurstMult(delta);
				fuel.value -= delta * burstMult * _classicModeNerf;
				var thrust:Number = power * getPowerAngleMult() * StatHooks.boostPowerMult.value * delta * burstMult * _item.getPowerAtWeightMult(_player.getBody().mass)
				//trace("Dodgers right thrust:", thrust);
				_player.applyThrust(thrust, 90);
		}
		
		protected function getBurstMult(delta:Number):Number {
			var mult:Number = Easing.easeBothInOutCubic(_initialBurstCount, INITIAL_BURST_MULT, 1 - INITIAL_BURST_MULT, INITIAL_BURST_DURATION);
			_initialBurstCount = Math.min(INITIAL_BURST_DURATION, _initialBurstCount + delta);
			//trace("Dodger burst mult =", mult);
			return mult;
		}
		
		protected function getPowerAngleMult():Number {
			var r:Number = Math.abs(_player.getMovieClip().rotation);
			var diff:Number = Math.abs(r - 90);
			
			var mult:Number = NumberUtils.interpolate2(0.2, 1, 0, 90, diff, 0.8);
			
			//trace("Angle =", r, "Mult =", mult);
			
			return mult;
		}
		
		
		override public function get preventDayEnd():Boolean 
		{
			return (_thrustingLeft || _thrustingRight);
		}
		
		
	}

}