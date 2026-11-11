package lbg.camera.cameratype 
{
	/**
	 * WIP, not currently working as it should, set to always center cam
	 * @author 
	 */
	public class RectCameraSmoothZone 
	{
		/** The number of pixels cover left and right by this zone */
		public var x:Number = 0;
		/** The number of pixels cover up and down by this zone */
		public var y:Number = 0;
		/** The amount of offcenter movement corrected by this zone every tick */
		public var rate:Number = 0;
		
		protected var _nextZone:RectCameraSmoothZone;
		
		
		public function RectCameraSmoothZone(x:Number = 0, y:Number = 0, rate:Number = 0) 
		{
			this.x = x;
			this.y = y;
			this.rate = rate;
		}
		
		public function setFollowingZone(zone:RectCameraSmoothZone):void {
			_nextZone = zone;
		}
		
		public function getMoveX(xDistanceFromCenter:Number):Number {
			var distanceInZone:Number = Math.max(0, Math.min(xDistanceFromCenter, x));
			var distanceBeyondZone:Number = xDistanceFromCenter - x;
			var moveX:Number = distanceInZone * rate;
			
			if (_nextZone) {
				moveX = _nextZone.getMoveX(distanceBeyondZone);//Get correction for the next zone
			}else {
				moveX += distanceBeyondZone;//Correct 100% of distance outside any zone
			}
			
			return moveX;
		}
		
		public function getMoveY(yDistanceFromCenter:Number):Number {
			var distanceInZone:Number = Math.max(0, Math.min(yDistanceFromCenter, y));
			var distanceBeyondZone:Number = yDistanceFromCenter - y;
			var moveY:Number = distanceInZone * rate;
			
			if (_nextZone) {
				moveY = _nextZone.getMoveY(distanceBeyondZone);//Get correction for the next zone
			}else {
				moveY += distanceBeyondZone;//Correct 100% of distance outside any zone
			}
			
			return moveY;
		}
		
	}

}