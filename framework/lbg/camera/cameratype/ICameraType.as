package lbg.camera.cameratype 
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author 
	 */
	public interface ICameraType 
	{
		function addObject(obj:DisplayObject, xParallax:Number, yParallax:Number):void
		function setCenter(X:Number, Y:Number):void
		function setElasticity(horizontal:Number, vertical:Number):void
		function setNeutralZone(horizontal:Number, vertical:Number):void
		function setEasing(power:Number, minEasing:Number = 0.1, maxEasing:Number = 0.5, minMovement:Number = 0.09):void
		function tick(targetX:Number, targetY:Number, delta:Number = 1):void
		function centerCameraAt(targetX:Number, targetY:Number):void
		function copyConfigTo(camera:ICameraType):ICameraType
	}
	
}