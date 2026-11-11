package lbg.camera.cameratype 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	/**
	 * ...
	 * @author 
	 */
	public class RectCameraSmooth extends AbstractCameraType
	{
		//zone x/y is the amount of difference from center this zone covers, based on stage size, added on top of previous zones
		//zone rate is the amount of correction over its area a zone corrects, 0 being none and 1 being instant centering
		//Anything outside of these zones gets corrected 100%
		protected var _firstZone:RectCameraSmoothZone;
		
		public function RectCameraSmooth(stage:Stage) 
		{
			super(stage);
			
			addZone(720 * 0.25, 540 * 0.25, 0.01);
			addZone(720 * 0.25, 540 * 0.25, 0.02);
			addZone(720 * 0.25, 540 * 0.25, 0.04);
			addZone(720 * 0.25, 540 * 0.25, 0.08);
			
			//addZone(0, 0, 1);
		}
		
		public function addZone(x:Number = 0, y:Number = 0, rate:Number = 0.01, previousZone:RectCameraSmoothZone = null):void {
			var newZone:RectCameraSmoothZone = new RectCameraSmoothZone(x, y, rate);
			if (previousZone) previousZone.setFollowingZone(newZone);
			if (_firstZone == null) {
				_firstZone = newZone;
			}
		}
		
		override public function tick(targetX:Number, targetY:Number, delta:Number = 1):void 
		{
			var xDiff:Number = Math.abs(_center.x - targetX);
			var yDiff:Number = Math.abs(_center.y - targetY);
			
			//trace("Distance from center of camera:", xDiff, yDiff);
			
			if ((xDiff <= MOVEMENT_THRESHOLD) && yDiff <= MOVEMENT_THRESHOLD) {
				//Center camera if within minimum movement threshold, to avoid veeeery slow movement over 0.5 pixels
				centerCameraAt(targetX, targetY);
				return;
			}
			
			//var moveX:Number = _firstZone.getMoveX(xDiff);
			//var moveY:Number = _firstZone.getMoveY(yDiff);
			
			var moveX:Number = xDiff;
			var moveY:Number = yDiff;
			
			//moveX = (xDiff == 0) ? 0:Math.min(Math.max(moveX, _minMovement), xDiff) * delta;
			//moveY = (yDiff == 0) ? 0:Math.min(Math.max(moveY, _minMovement), yDiff) * delta;
			
			//Because we mult by delta, prevent movement from becoming MORE than centering cam
			//moveY = Math.min(yDiff, moveY);
			//moveX = Math.min(xDiff, moveX);
				
			if (targetX >= _center.x) moveX *= -1;
			if (targetY >= _center.y) moveY *= -1;
			
			moveObjectsBy(moveX, moveY);
			
		}
		
	}

}