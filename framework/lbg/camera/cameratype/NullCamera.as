package lbg.camera.cameratype 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author 
	 */
	public class NullCamera implements ICameraType
	{
		
		public function NullCamera() 
		{
			
		}
		
		public function addObject(obj:DisplayObject, xParallax:Number, yParallax:Number):void 
		{
			
		}
		
		public function setCenter(X:Number, Y:Number):void 
		{
			
		}
		
		public function setElasticity(horizontal:Number, vertical:Number):void 
		{
			
		}
		
		public function setNeutralZone(horizontal:Number, vertical:Number):void 
		{
			
		}
		
		public function tick(targetX:Number, targetY:Number, delta:Number = 1):void 
		{
			
		}
		
		public function copyConfigTo(camera:ICameraType):ICameraType 
		{
			return camera;
		}
		
		public function centerCameraAt(targetX:Number, targetY:Number):void 
		{
			
		}
		
		public function setEasing(power:Number, minEasing:Number = 0.1, maxEasing:Number = 0.5, minMovement:Number = 0.09):void 
		{
			
		}
		
	}

}