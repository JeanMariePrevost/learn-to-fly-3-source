package  lbg.camera.cameratype
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author 
	 */
	internal class MovableObject 
	{
		protected var _displayObject:DisplayObject;
		protected var _xParallax:Number;
		protected var _yParallax:Number;
		
		public function MovableObject(obj:DisplayObject, xParallax:Number, yParallax:Number) 
		{
			_displayObject = obj;
			_xParallax = xParallax;
			_yParallax = yParallax;
		}
		
		public function moveObject(moveX:Number, moveY:Number):void {
			_displayObject.x += moveX * _xParallax;
			_displayObject.y += moveY * _yParallax;
		}
		
	}

}