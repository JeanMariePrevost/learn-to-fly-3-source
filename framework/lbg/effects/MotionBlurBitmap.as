package lbg.effects 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import lbg.utils.NumberUtils;
	
	/**
	 * Creates a motion-blured version of a specified DisplayObject
	 * IT is however treated as a completely separate object, a blurred "copy" of the original.
	 * @author 
	 */
	public class MotionBlurBitmap extends Sprite 
	{
		
		public var blurMaxStrength:Number = 80;//Maximum blur value
		public var blurStartSpeed:Number = 2;
		public var blurEndSpeed:Number = 80;
		public var blurEasePower:Number = 1.2;
		
		protected var _bm:Bitmap;
		protected var _bmd:BitmapData;
		//protected var _bmdCache:BitmapData;
		protected var _object:DisplayObjectContainer;
		protected var _offset:Number;
		protected var _rotationMatrix:Matrix = new Matrix();
		protected var _blurFilter:BlurFilter = new BlurFilter(0, 0, 1);
		protected var _blurPoint:Point = new Point();
		
		protected var _oldPos:Point = new Point();
		protected var _newPos:Point = new Point();
		
		public function MotionBlurBitmap(object:DisplayObjectContainer) 
		{
			var maxSize:Number = blurMaxStrength * 2 + Math.sqrt(object.width * object.width + object.height * object.height);
			
			_bmd = new BitmapData(maxSize, maxSize, true, 0);
			_object = object;
			_bm = new Bitmap(_bmd);
			addChild(_bm);
			_offset = maxSize / 2;
			_bm.x = - _offset;
			_bm.y = - _offset;
		}
		
		public function forceBlur(magnitude:Number = 0, angleInRads:Number = 0):void {
			
			
			_rotationMatrix.identity();
			_rotationMatrix.rotate( -angleInRads);
			
			// move the matrix by the offset to account for the
			 //centered position of the original click_mc
			_rotationMatrix.translate(_offset, _offset);
			
			// clear blur_bmp by filling it with empty pixels
			_bmd.fillRect(_bmd.rect, 0);
			
			// draw the rotated, translated click_mc into blur_bmp
			_bmd.draw(_object, _rotationMatrix);
				
			if (magnitude != 0) {
				// apply the blur power to the blur filter
				_blurFilter.blurX = Math.min(blurMaxStrength, magnitude);
				
				// apply the blur filter to the blur_bmp
				_bmd.applyFilter(_bmd, _bmd.rect, _blurPoint, _blurFilter);
				
				
				// rotate blurredClick_mc to counteract the rotation of 
				// rotate_matrix used in draw
			}
			rotation = angleInRads * 180 / Math.PI;
		}
		
		public function blurFromDisplacement(distance:Number = 0, angleInRads:Number = 0, minimumMovement:Number = 3):void {
				forceBlur(getBlurAmount(distance), angleInRads);
		}
		
		public function blurFromPosition(X:Number = 0, Y:Number = 0, minimumMovement:Number = 3):void {
			_oldPos.x = _newPos.x;
			_oldPos.y = _newPos.y;
			
			_newPos.x = X;
			_newPos.y = Y;
			
			
			var distance:Number = Point.distance(_oldPos, _newPos);
			
			if (distance < minimumMovement) {
				_newPos.x = _oldPos.x;
				_newPos.y = _oldPos.y;
				
				forceBlur(0, 0);
			}else {
				var dx:Number = _oldPos.x - _newPos.x;
				var dy:Number = _oldPos.y - _newPos.y;
				var angleInRads:Number = Math.atan2(dy, dx);
				
				forceBlur(getBlurAmount(distance), angleInRads);
			}
		}
		
		protected function getBlurAmount(distance:Number):Number {
			var blur:Number = NumberUtils.interpolate2(0, blurMaxStrength, blurStartSpeed, blurEndSpeed, distance, blurEasePower);
			return blur;
		}
		
		
		
		
		
	}

}