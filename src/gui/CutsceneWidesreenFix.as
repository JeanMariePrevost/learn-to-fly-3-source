package src.gui 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import lbg.components.NumberBuffer;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.Main;
	import src.UiScaler;
	
	/**
	 * ...
	 * @author 
	 */
	public class CutsceneWidesreenFix extends MovieClip 
	{
		
		protected const X_MARGIN:int = 122;//How far from the top/bottom we begin checking
		protected const Y_MARGIN:int = 20;
		
		protected const X_SAMPLES:int = 8;//How many pixels are checked over X axis
		protected const Y_SAMPLES:int = 4;
		
		protected var bmp:BitmapData = new BitmapData(720, 540, false, 0x00000000);
		protected var buffer:NumberBuffer = new NumberBuffer(6, 0.25);
		
		protected var _destroyed:Boolean = false;
		
		public function CutsceneWidesreenFix() 
		{
			super();
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		
		private function removedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			destroy();
		}
		
		private function onFrame(e:Event):void 
		{
			if (this.stage == null) {
				destroy();
				return;
			}
			
			var brightness:Number = getAverageColorOfStage();
			
			buffer.add(brightness);
			
			var resultBrightness:Number = NumberUtils.interpolate( -80, 25, buffer.value, 0.7);
			var resultContrast:Number = NumberUtils.interpolate( -30, 40, buffer.value, 0.7);
			
			DisplayObjectUtil.setColorMatrix(this, 0, 0, resultBrightness, resultContrast);
		}
		
		protected function getAverageColorOfStage():Number {
				bmp.fillRect(bmp.rect, 0x000000);
				  bmp.draw(Main.parentLayer);
				  
				  //var rgb:Object = HexToRGB(bmp.getPixel(0, 0));
				  //var luma:int =  rgb.r * rgb.r * .241 +   rgb.g * rgb.g * .691 +   rgb.b * rgb.b  * .068
				  
				  var v:Vector.<Vector.<Number >  >  = bmp.histogram();
				  var r:Number = 0;
				  var g:Number = 0;
				  var b:Number = 0;
				  var a:Number = 0;
				  for (var i:int=0; i<256; i++) {
							r +=  i * v[0][i] / 255;
							g +=  i * v[1][i] / 255;
							b +=  i * v[2][i] / 255;
							a += i*v[3][i]/255;
				  }
				  var brightness:Number = (r+g+b)/(3*a);
				  trace("brightness: " + brightness);
				  return brightness;
		}
		
		private function HexToRGB(value:uint):Object {	
			var RGB:Object = new Object();
			RGB.r = (value >> 16) & 0xFF;
			RGB.g = (value >> 8) & 0xFF;
			RGB.b = value & 0xFF;
			return RGB;
		}		
		
		public function destroy():void {
			removeEventListener(Event.ENTER_FRAME, onFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			if (bmp)  bmp.dispose()
			bmp = null;
			
			if(buffer) buffer.destroy();
			buffer = null;
			
			
			if (!_destroyed) {
				DisplayObjectUtil.removeAllChildFrom(this, true);
			}
			
			_destroyed = true;
		}
	}

}