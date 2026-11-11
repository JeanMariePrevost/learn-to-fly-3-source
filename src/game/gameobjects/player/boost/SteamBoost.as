package src.game.gameobjects.player.boost 
{
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.audio.Audio;
	import src.game.gameobjects.player.Player;
	import src.game.particles.Particles;
	import src.system.GameStateItem;
	import src.system.Global;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class SteamBoost extends SimpleBoost 
	{
		protected var _pressure:Number = 0;
		protected var _maxPressure:Number = 100;
		
		protected var _particleCounter:Number = 0;
		protected var _particleEvery:Number = 2;
		
		
		public function SteamBoost(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			leftWrapper.stop();
			rightWrapper.stop();
			
			_preventDayEnd = false;
		}
		
		override public function tick(delta:Number):void 
		{
			//super.tick(delta);
			
			
			if (leftWrapper.currentState == "active") {
				if (_pressure > 0) {
					//Boosting
					doBoost(delta);
				}else {
					//finished boosting
					leftWrapper.setToOff();
					rightWrapper.setToOff();
					stopSound();
				}
			}else if (leftWrapper.currentState == "on") {
				//Charging
				if ((Input.metaBoost.isDown || singleBoostInputIsDown)) {
					//Continue charging
					doCharge(delta);
				}else {
					//Release charge
					playSound(50);
					leftWrapper.setToActive();
					rightWrapper.setToActive();
					doBoost(delta);
				}
			}else if (leftWrapper.currentState == "off") {
				leftWrapper.tick(delta);
				rightWrapper.tick(delta);
			}else {
				//Idle
				if (fuel.value >0 && (Input.metaBoost.isDown || singleBoostInputIsDown)) {
					//Begin charging
					leftWrapper.setToOn();
					rightWrapper.setToOn();
					doCharge(delta);
				}
			}
		}
		
		protected function doBoost(delta:Number):void {
			_pressure = Math.max(0, _pressure - (delta * 2));
			
			leftWrapper.interpolateCurrentLabel(1 - (_pressure / _maxPressure));
			rightWrapper.interpolateCurrentLabel(1 - (_pressure / _maxPressure));
			
			var thrustFade:Number = NumberUtils.interpolate2(1, 0.5, _maxPressure, 0, _pressure);
			
			applyThrust(delta * thrustFade);
			
			if(Global.enableParticles){
				if (_particleCounter <= 0) {
					
					Particles.builder.smokeWhite(0, 0, 0.5, 0.8,7, DisplayObjectUtil.globalRotationOf(leftVisual["target"]), leftVisual["target"]);
					Particles.builder.smokeWhite(0, 0, 0.5, 0.8, 7, DisplayObjectUtil.globalRotationOf(rightVisual["target"]) + 90, rightVisual["target"]);
					_particleCounter = _particleEvery;
				}else {
					_particleCounter --;
				}
			}
		}
		
		protected function doCharge(delta:Number):void {
			if (fuel.value > 0 && _pressure < _maxPressure) {
				_pressure = Math.min(_maxPressure, _pressure + delta);
				fuel.value -= delta;
				
				leftWrapper.interpolateCurrentLabel(_pressure / _maxPressure);
				rightWrapper.interpolateCurrentLabel(_pressure / _maxPressure);
			}
			
			_hudSignal.dispatch(fuel.value / maxFuel);
		}
		
		
	}

}