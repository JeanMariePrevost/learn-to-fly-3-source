package src.game 
{
	import lbg.compositetick.ICompositeLeaf;
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	import nape.geom.Vec2;
	import src.Main;
	import src.reg.Stat;
	import src.system.Global;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author 
	 */
	public class WindEngine implements ICompositeLeaf
	{
		protected var _windForceMin:Stat = new Stat();
		protected var _windForceMax:Stat = new Stat();
		protected var _windDurationMin:Stat = new Stat();
		protected var _windDurationMax:Stat = new Stat();
		protected var _windPauseMin:Stat = new Stat();
		protected var _windPauseMax:Stat = new Stat();
		
		protected var _phaseCounter:Number = 0;
		protected var _windBlowing:Boolean = false;//True while wind is in effect, false while paused
		
		protected var _wind:Number = 0;
		protected var _direction:Number = 1;
		
		//Wind gust mechanics
		protected var _targetForce:Number = 0;
		protected var _fadeDuration:Number = 0;
		protected var _fadeIn:Number = 0;
		protected var _fadeOut:Number = 0;
		
		protected var _altitude:Number = 0;
		
		protected static var _instance:WindEngine;
		
		
		public function WindEngine() 
		{
			if (_instance != null) {
				Log.log("ERROR - WindEngine already instantiated");
				_instance.destroy();
			}
			_instance = this;
			
			///////////////////////////////////////////
			//Wind behavior at different altitude
			///////////////////////////////////////////
			var alt:Number = -100000000;
			
			_windForceMin.addLevel(alt, 1);
			_windForceMax.addLevel(alt, 3);
			_windDurationMin.addLevel(alt, 100);
			_windDurationMax.addLevel(alt, 250);
			_windPauseMin.addLevel(alt, 150);
			_windPauseMax.addLevel(alt, 400);
			
			var alt:Number = 0;
			
			_windForceMin.addLevel(alt, 1);
			_windForceMax.addLevel(alt, 3);
			_windDurationMin.addLevel(alt, 100);
			_windDurationMax.addLevel(alt, 250);
			_windPauseMin.addLevel(alt, 150);
			_windPauseMax.addLevel(alt, 400);
			
			alt = Global.spaceAltitude * 0.75;
			
			_windForceMin.addLevel(alt, 5, 2);
			_windForceMax.addLevel(alt, 12, 2);
			_windDurationMin.addLevel(alt, 100, 2);
			_windDurationMax.addLevel(alt, 500, 2);
			_windPauseMin.addLevel(alt, 150, 2);
			_windPauseMax.addLevel(alt, 600, 2);
			
			alt = Global.spaceAltitude * 0.95;
			
			_windForceMin.addLevel(alt, 0.5);
			_windForceMax.addLevel(alt, 3);
			_windDurationMin.addLevel(alt, 100);
			_windDurationMax.addLevel(alt, 500);
			_windPauseMin.addLevel(alt, 250);
			_windPauseMax.addLevel(alt, 800);
			
			alt = Global.spaceAltitude * 1;
			
			_windForceMin.addLevel(alt, 0);
			_windForceMax.addLevel(alt, 0);
			_windDurationMin.addLevel(alt, 0);
			_windDurationMax.addLevel(alt, 1);
			_windPauseMin.addLevel(alt, 20000);
			_windPauseMax.addLevel(alt, 20000);
			
			startPause(0);
			
			GameMediator.updatePlayerAltitude.add(updateAltitude);
		}
		
		private function updateAltitude(alt:Number):void 
		{
			_altitude = alt;
		}
		
		public function tick(delta:Number):void {
			if (_windBlowing) {
				if (_fadeIn < _fadeDuration) {
					//Wind fading in
					_wind = NumberUtils.interpolate2(0, _targetForce, 0, _fadeDuration, _fadeIn, 1, true);
					_fadeIn += delta;
				}else  if (_phaseCounter > 0) {
					//Wind blows full strength
					_phaseCounter -= delta;
					_wind = _targetForce;
				}else if (_fadeOut < _fadeDuration) {
					//Wind fading out
					_wind = NumberUtils.interpolate2(0, _targetForce, _fadeDuration, 0, _fadeOut, 1, true);
					_fadeOut += delta;
				}else {
					//Wind gust over, start pause
					startPause(_altitude);
				}
			}else {
				if (_phaseCounter > 0) {
					//Wind down, nothing happens
					_wind = 0;
					_phaseCounter -= delta;
				}else {
					//Pause over, launch new wind gust
					startWindGust(_altitude);
				}
			}
			
			//trace("Wind:", _wind);
		}
		
		protected function startPause(altitude:Number):void {
			_windBlowing = false;
			_wind = 0;
			
			var minCount:Number = _windPauseMin.valueAt(altitude);
			var maxCount:Number = _windPauseMax.valueAt(altitude);
			
			_phaseCounter = NumberUtils.interpolate(minCount, maxCount, Math.random(), 1, true);
		}
		
		protected function startWindGust(altitude:Number):void {
			_windBlowing = true;
			
			_direction = (Math.random() <= 0.5) ? 1: -1;
			
			var minCount:Number = _windDurationMin.valueAt(altitude);
			var maxCount:Number = _windDurationMax.valueAt(altitude);
			
			_phaseCounter = NumberUtils.interpolate(minCount, maxCount, Math.random(), 1, true);
			
			var minForce:Number = _windForceMin.valueAt(altitude);
			var maxForce:Number = _windForceMax.valueAt(altitude);
			
			_targetForce = NumberUtils.interpolate(minForce, maxForce, Math.random(), 1, true);
			
			_fadeDuration = NumberUtils.interpolate(15, 60, Math.random(), 1, true);
			_fadeIn = _fadeOut = 0;
		}
		
		protected function setWind(force:Number):void {
			_wind = force;
		}
		
		public static function get wind():Number 
		{
			//trace("Wind mult", StatHooks.windEffectMult.value);
			if (_instance) {
				return _instance._wind * _instance._direction * ProfileState.instance.bonusItems.bonusWind.statPower * StatHooks.windEffectMult.value;
			}else {
				return NaN;	
			}
		}
		
		public function destroy():void {
			_windForceMin = null;
			_windForceMax = null;
			_windDurationMin = null;
			_windDurationMax = null;
			_windPauseMin = null;
			_windPauseMax = null;
			
			_instance = null;
		}
	}

}