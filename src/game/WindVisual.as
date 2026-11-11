package src.game 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import lbg.components.NumberBuffer;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	import src.Main;
	import src.UiScaler;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class WindVisual extends Sprite 
	{
		protected const SNOW_STOP_START_ALT:Number = 0.6;//Altitude where snow starts disappearing
		protected const SNOW_STOP_END_ALT:Number = 0.9;
		protected var _spawnDuration:Number = 7;
		protected var _spawnTime:Number = 0;
		protected var _snowMultFromAltitude:Number = 1;
		
		protected var _snowflakeSignal:Signal = new Signal(Number, Number);
		
		protected var _bufferedWind:NumberBuffer = new NumberBuffer(30, 0);
		
		public function WindVisual() 
		{
			super();
			
			Main.unsafeTickSignal.add(tick);
			GameMediator.updatePlayerAltitude.add(updateAltitude);
		}
		
		protected function updateAltitude(alt:Number):void {
			_snowMultFromAltitude = NumberUtils.interpolate2(1, 0, Global.spaceAltitude * SNOW_STOP_START_ALT, Global.spaceAltitude * SNOW_STOP_END_ALT, alt);
		}
		
		public function tick(delta:Number):void {
			if (ProfileState.instance.optionSmoke == "Off") return;
			
			var wind:Number = WindEngine.wind;
			_bufferedWind.add(wind);
			
			_spawnTime += Math.abs(_bufferedWind.value) * _snowMultFromAltitude;
			if (_spawnTime >= _spawnDuration) {
				createSnowFlake(_bufferedWind.value);
				_spawnTime = 0;
			}
			
			//trace("Wind:", wind, "Buffered:", _bufferedWind.value);
			_snowflakeSignal.dispatch(delta, _bufferedWind.value);
		}
		
		protected function createSnowFlake(wind:Number):void {
			var s:WindVisualSnow = new WindVisualSnow(_snowflakeSignal, this);
			
			if (wind >= 0) {
				//Spawn left
				s.x = -10;
				s.y = Math.random() * 640 - 100;
			}else {
				//Spawn right
				s.x = UiScaler.maxWidthAtCurrentRatio + 10;
				s.y = Math.random() * 640 - 100;
			}
		}
		
		public function destroy():void {
			GameMediator.updatePlayerAltitude.remove(updateAltitude);
			Main.unsafeTickSignal.remove(tick);
			
			if(_snowflakeSignal) _snowflakeSignal.removeAll;
			_snowflakeSignal = null;
			
			if (_bufferedWind) _bufferedWind.destroy();
			_bufferedWind = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}