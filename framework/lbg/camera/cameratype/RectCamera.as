package lbg.camera.cameratype 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import lbg.debug.Log;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.Main;
	/**
	 * ...
	 * @author 
	 */
	public class RectCamera extends AbstractCameraType
	{
		
		public function RectCamera(stage:Stage) 
		{
			super(stage);
		}
		
		override public function tick(targetX:Number, targetY:Number, delta:Number = 1):void 
		{
			var xDiff:Number = Math.abs(_center.x - targetX);
			var yDiff:Number = Math.abs(_center.y - targetY);
			
			
			//This is used because the camera's settings (e.g. neutral zone, easing...) are all built at a certain fixed scale.
			//Moved beyond this scale, the settings become irrelevant (e.g. 72px deadzone is 1/10th of 720px, but a mere 1/26th at 1920
			//This scales down the x/yDiff values and then scales them back up right at the end of the tick to be applied
			var highResolutionCameraFix:Number = 1;
			if (_stage && _stage.fullScreenSourceRect) {
				var highResolutionCameraFix:Number = NumberUtils.interpolate2(1, 0.6, 960, 1920, _stage.fullScreenSourceRect.width, 2);
				//Log.log("RectCamera fix:", highResolutionCameraFix);
			}
			
			xDiff *= highResolutionCameraFix;
			yDiff *= highResolutionCameraFix;
			
			if ((xDiff <= MOVEMENT_THRESHOLD) && yDiff <= MOVEMENT_THRESHOLD) {
				//Center camera if within minimum movement threshold, to avoid veeeery slow movement over 0.5 pixels
				centerCameraAt(targetX, targetY);
				return;
			}
			
			//Substract the neutral zone
			xDiff = Math.max(0, xDiff - _neutralZone.x);
			yDiff = Math.max(0, yDiff - _neutralZone.y);
			
			if (xDiff == 0 && yDiff == 0) {
				return;
			}
			
			var xMult:Number = _maxEasing;
			var yMult:Number = _maxEasing;
			var xWithinElasticity:Number = xDiff;
			var yWithinElasticity:Number = yDiff;
			var xOverElasticity:Number = 0;
			var yOverElasticity:Number = 0;
			
			if (xDiff < _elasticity.x) {
				xMult = interpolate(_minEasing, _maxEasing, 0, _elasticity.x, xDiff, _easePower);
			}else {
				xOverElasticity = xDiff - _elasticity.x;
				xWithinElasticity -= xOverElasticity;
			}
			if (Math.abs(yDiff) < _elasticity.y) {
				yMult = interpolate(_minEasing, _maxEasing, 0, _elasticity.y, yDiff, _easePower);
			}else {
				yOverElasticity = yDiff - _elasticity.y;
				yWithinElasticity -= yOverElasticity;
			}
			
			var moveX:Number = (xWithinElasticity * xMult) + xOverElasticity;
			var moveY:Number = (yWithinElasticity * yMult) + yOverElasticity;
			
			moveX = (xDiff == 0) ? 0:Math.min(Math.max(moveX, _minMovement), xDiff) * delta;
			moveY = (yDiff == 0) ? 0:Math.min(Math.max(moveY, _minMovement), yDiff) * delta;
			
			//Because we mult by delta, prevent movement from becoming MORE than centering cam
			moveY = Math.min(yDiff, moveY);
			moveX = Math.min(xDiff, moveX);
				
			if (targetX >= _center.x) moveX *= -1;
			if (targetY >= _center.y) moveY *= -1;
			
			//Re-multiplying the move into scale if the fix was applied
			moveX *= highResolutionCameraFix;
			moveY *= highResolutionCameraFix;
			
			moveObjectsBy(moveX, moveY);
			
		}
		
	}

}