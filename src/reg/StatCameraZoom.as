package src.reg 
{
	import lbg.utils.NumberUtils;
	/**
	 * ...
	 * @author 
	 */
	public class StatCameraZoom implements IStat
	{
		protected var _minZoom:Stat = new Stat();
		protected var _maxZoom:Stat = new Stat();
		protected var _maxSpeed:Stat = new Stat();
		
		public function StatCameraZoom() 
		{
			
		}
		
		/**
		 * @param	minZoom Camera zoom at zero speed
		 * @param	maxZoom Camera zoom at maxSpeed
		 * @param	maxSpeed Speed at which camera is zoomed out to maxZoom
		 */
		public function addLevel(level:uint, minZoom:Number, maxZoom:Number, maxSpeed:Number, powerUntilNextPoint:Number = 1):void {
			_minZoom.addLevel(level, minZoom, powerUntilNextPoint);
			_maxZoom.addLevel(level, maxZoom, powerUntilNextPoint);
			_maxSpeed.addLevel(level, maxSpeed, powerUntilNextPoint);
		}
		
		public function valueAt(level:Number = 0):Number {
			return _maxZoom.valueAt(level);
		}
		
		
		public function zoomAtSpeed(level:Number, speed:Number):Number 
		{
			var minZoom:Number = _minZoom.valueAt(level);
			var maxZoom:Number = _maxZoom.valueAt(level);
			var maxSpeed:Number = _maxSpeed.valueAt(level);
			
			var zoom:Number;
			
			if (speed <= 0) {
				//Min zoom
				zoom = minZoom;
			}else if (speed <= maxSpeed) {
				zoom = NumberUtils.interpolate2(minZoom, maxZoom, 0, maxSpeed, speed);
			}else {
				//Beyond max speed, zoom is maxed
				zoom = maxZoom;
			}
			
			if (zoom == 3) {
				var a = 1;
			}
			
			return zoom;
		}
		
		
	}

}