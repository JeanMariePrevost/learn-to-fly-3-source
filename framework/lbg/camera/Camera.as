package lbg.camera 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import lbg.camera.cameratype.*;
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	/**
	 * ...
	 * @author 
	 */
	public class Camera
	{
		public static const RECTANGULAR_CAMERA:String = "rectangular_camera";
		public static const RECTANGULAR_SMOOTH_CAMERA:String = "rectangular_smooth_camera";
		public static const CIRCULAR_CAMERA:String = "circular_camera";
		protected var _cameraObject:ICameraType = new NullCamera();
		protected var _stage:Stage;
		
		public function Camera(stage:Stage) 
		{
			_stage = stage;
			setCameraType(RECTANGULAR_CAMERA);
		}
		
		public function addObject(obj:DisplayObject, horizontalParallax:Number = 1, verticalParallax:Number = 1):void
		{
			_cameraObject.addObject(obj, horizontalParallax, verticalParallax);
		}
		
		public function tick(targetX:Number, targetY:Number, delta:Number = 1):void 
		{
			_cameraObject.tick(targetX, targetY, delta);
		}
		
		public function centerCameraAt(targetX:Number, targetY:Number):void {
			_cameraObject.centerCameraAt(targetX, targetY);
		}
		
		
		public function setCenter(X:Number, Y:Number):void 
		{
			_cameraObject.setCenter(X, Y);
		}
		
		public function setElasticity(horizontal:Number, vertical:Number):void 
		{
			_cameraObject.setElasticity(horizontal, vertical);
		}
		
		public function setNeutralZone(horizontal:Number, vertical:Number):void 
		{
			_cameraObject.setNeutralZone(horizontal, vertical);
		}
		
		/**
		 * @param	easingStrengh <1 is stiffer, 1 is linear and >1 is smoother
		 * @param	minEasing Minimum movement mult applied no matter the easing
		 * @param	maxEasing Maximum movement mult applied no matter the easing
		 * @param	minMovement Minimum absolute movement applied
		 */
		public function setEasing(easingStrengh:Number = 1, minEasing:Number = 0.1, maxEasing:Number = 0.5, minMovement:Number = 0.09):void {
			_cameraObject.setEasing(easingStrengh, minEasing, maxEasing, minMovement);
		}
		
		public function setCameraType(cameraType:String = Camera.RECTANGULAR_CAMERA):void
		{
			switch(cameraType) {
				case CIRCULAR_CAMERA:
					_cameraObject = _cameraObject.copyConfigTo(new CircleCamera(_stage));
					break;
				case RECTANGULAR_CAMERA:
					_cameraObject = _cameraObject.copyConfigTo(new RectCamera(_stage));
					break;
				case RECTANGULAR_SMOOTH_CAMERA:
					_cameraObject = _cameraObject.copyConfigTo(new RectCameraSmooth(_stage));
					break;
				default:
					throw new Error("Camera - Invalid camera type");
					break;
			}
		}
		
		public function destroy():void {
			_cameraObject = null;
			_stage = null;
		}
		
		
		
	}

}