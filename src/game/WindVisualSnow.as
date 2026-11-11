package src.game 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author 
	 */
	public class WindVisualSnow extends MovieClip 
	{
		protected static const WIND_SPEED_MULT:Number = 4;
		protected var _tickSignal:Signal;
		protected var _speed:Number;
		protected var _bufferedWind:Number = 0;
		protected var _bufferSpeed:Number = 0.15;
		
		public function WindVisualSnow(tickSignal:Signal, container:DisplayObjectContainer) 
		{
			super();
			
			var r:Number = Math.random();
			if (r <= 0.3) {
				//Normal, in focus snow
				gotoAndStop(1);
				scaleX = scaleY = NumberUtils.randomRange(0.6, 1.2);
				_speed = scaleX * 1.2;
			}else if (r <= 0.5) {
				//Near, out of focus snow
				gotoAndStop(2);
				scaleX = scaleY = NumberUtils.randomRange(0.6, 1);
				_speed = scaleX * 2.5;
			}else {
				//Far, smaller snow
				gotoAndStop(3);
				scaleX = scaleY = NumberUtils.randomRange(0.6, 1);
				_speed = scaleX * 0.9;
			}
			
			_tickSignal = tickSignal;
			_tickSignal.add(tick);
			container.addChild(this);
		}
		
		protected function tick(delta:Number, wind:Number):void {
			var bufSpeed:Number = (Math.abs(_bufferedWind) >= Math.abs(wind)) ? _bufferSpeed * 0.1: _bufferSpeed;
			_bufferedWind -= (_bufferedWind - wind) * bufSpeed;
			
			y += _speed * delta + 1;
			x += _bufferedWind * _speed * delta *  WIND_SPEED_MULT;
			
			if (Math.abs(_bufferedWind) <= 0.1) {
				alpha -= 0.015;
				if (alpha <= 0) {
					destroy();
				}
			}
		}
		
		public function destroy():void {
			_tickSignal.remove(tick);
			
			while (numChildren >= 1) removeChildAt(0);
			
			if (stage) parent.removeChild(this);
		}
		
	}

}