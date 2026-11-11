package lbg.effects 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * Creates a motion-blured version of a specified DisplayObject INSIDE of it
	 * This means that whatever was in the original DisplayObject will be invisible and only the blurred object will remain in its place
	 * @author 
	 */
	public class MotionBlurWrapper extends MotionBlurBitmap 
	{
		protected var cachedVisual:Sprite = new Sprite();
		
		public function MotionBlurWrapper(object:DisplayObjectContainer)
		{
			for (var i:int = 0; i < object.numChildren; i++) {
				var child:DisplayObject = object.getChildAt(i);
				//trace(i, "->", child);
				cachedVisual.addChild(child);
			}
			
			super(cachedVisual);
			object.addChild(this);
		}
		
		public function putBackCachedVisual(object:DisplayObjectContainer):void {
			if (stage) parent.removeChild(this);
			
			while (cachedVisual.numChildren >= 1) {
				var c:DisplayObject = cachedVisual.getChildAt(0);
				cachedVisual.removeChild(c);
				object.addChild(c);
			}
		}
		
		public function rebuildVisual(object:DisplayObjectContainer):void {
			while (cachedVisual.numChildren >= 1) {
				cachedVisual.removeChildAt(0);
			}
			
			for (var i:int = 0; i < object.numChildren; i++) {
				var child:DisplayObject = object.getChildAt(i);
				cachedVisual.addChild(child);
			}
			
			
			var maxSize:Number = blurMaxStrength * 2 + Math.sqrt(object.width * object.width + object.height * object.height);
			
			_bmd.dispose();
			_bmd = new BitmapData(maxSize, maxSize, true, 0);
			//_bmd.height = _bmd.width = maxSize;
			
			_object = object;
			
			//removeChild(_bm);
			//_bm = new Bitmap(_bmd);
			//addChild(_bm);
			
			_bm.bitmapData = _bmd;
			
			_offset = maxSize / 2;
			_bm.x = - _offset;
			_bm.y = - _offset;
		}
		
	}

}