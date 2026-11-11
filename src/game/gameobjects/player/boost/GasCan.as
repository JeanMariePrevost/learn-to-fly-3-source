package src.game.gameobjects.player.boost 
{
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.game.GameCamera;
	import src.game.gameobjects.FallingObject;
	import src.game.gameobjects.IFallingObject;
	import src.game.gameobjects.player.Player;
	import src.game.particles.Particles;
	import src.game.particles.Particles;
	import src.game.PhysicsEngine;
	import src.Main;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GasCan extends SimpleBoost 
	{
		protected var _started:Boolean = false;
		protected var _finished:Boolean = false;
		
		protected var _detachedObject1:IFallingObject;
		protected var _detachedObject2:IFallingObject;
		
		protected var _smokeTime:Number = 0;
		protected var _smokeDuration:Number = 2;
		
		public function GasCan(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		protected function startBoost():void {
			if (_player == null) return;
			if (!_player.enableTicking) return;
				
			Input.metaBoost.signalCommandDown.remove(startBoost);
			_started = true;
			if(leftWrapper) leftWrapper.gotoLabel("activeStart");
			if(rightWrapper) rightWrapper.gotoLabel("activeStart");
		}
		
		override public function tick(delta:Number):void 
		{
			if (_finished) return;
			
			var fuelBeforeTick:Number = fuel.value;
			
			if (_started) {
				if (fuel.value > 0) {
					playSound(60);
					applyThrust(delta);
					_hudSignal.dispatch(fuel.value / maxFuel);
					
					if (_smokeTime >= _smokeDuration) {
						Particles.builder.smokeBalloon(0, 20, 0.25, 0.40, 6 + Math.random() * 3, DisplayObjectUtil.globalRotationOf(leftVisual) + 90 + NumberUtils.randomBoth(4), leftVisual.tBottom).vScale = 0.06;
						Particles.builder.smokeBalloon(0, 20, 0.25, 0.40, 6 + Math.random() * 3, DisplayObjectUtil.globalRotationOf(rightVisual) - 90 + NumberUtils.randomBoth(4), rightVisual.tBottom).vScale = 0.06;
						_smokeTime = 0;
					}else {
						_smokeTime += 1;
					}
				}else {
					//Out of fuel
					stopSound();
					_finished = true;
					playDeathAnim();
				}
			}else if (Input.metaBoost.isDown || singleBoostInputIsDown) {
				startBoost();
			}
			
			if (fuelBeforeTick > 0 && fuel.value <= 0) {
				_player.updateBodyMass();
			}
		}
		
		protected function playDeathAnim():void {
			leftWrapper.gotoLabel("deathStart");
			rightWrapper.gotoLabel("deathStart");
			leftWrapper.destroy();
			rightWrapper.destroy();
			DisplayObjectUtil.changeContainer(leftVisual, GameCamera.instance.getMovingLayer(1));
			DisplayObjectUtil.changeContainer(rightVisual, GameCamera.instance.getMovingLayer(1));
			_detachedObject1 = FallingObject.getNewFallingObject(leftVisual);
			_detachedObject2 = FallingObject.getNewFallingObject(rightVisual);
			_detachedObject1.mimicBodyMomentum(_player.getBody(), 0.6);
			_detachedObject2.mimicBodyMomentum(_player.getBody(), 0.6);
			_detachedObject1.setPhysicsEngine(PhysicsEngine.instance);
			_detachedObject2.setPhysicsEngine(PhysicsEngine.instance);
			
			//Small rotation jitter
			_detachedObject1.applyRotation(NumberUtils.randomBoth(1));
			_detachedObject2.applyRotation(NumberUtils.randomBoth(1));
		}
		
		override public function get preventDayEnd():Boolean 
		{
			return (_started && !_finished);
		}
		
	}

}