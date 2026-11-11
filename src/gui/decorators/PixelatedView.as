package src.gui.decorators 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import lbg.utils.NumberUtils;
	import src.Main;
	import src.UiScaler;
	
	/**
	 * ...
	 * @author 
	 */
	public class PixelatedView extends Sprite 
	{
		protected static var _instance:PixelatedView;
		
		public var bufferBmd:BitmapData;
		public var bmd:BitmapData;
		public var bm:Bitmap;
		
		protected const SCALE_FACTOR:Number = 3;
		protected const MAX_FRAME_SKIP:Number = 60;
		
		protected var _safetyTimer:Number = 0;
		protected var _safetyTimerLimit:Number = 0;
		protected var _frameSkipped:Number = 0;
		protected var _frameSkipStrikes:Number = 0;//After X strikes, kill the Pixelated view
		
		public function PixelatedView() 
		{
			super();
			
			bufferBmd = new BitmapData(960 / SCALE_FACTOR, 540 / SCALE_FACTOR);
			bmd = new BitmapData(UiScaler.SCREEN_WIDTH_AT_MAX_RATIO, UiScaler.UNSCALED_STAGE_HEIGHT);
			bm = new Bitmap(bmd);
			
			addChild(bm);
			Main.transitionLayer.addChild(this);
			
			Main.transitionLayer.mouseChildren = Main.transitionLayer.mouseEnabled = this.mouseChildren = this.mouseEnabled = false;
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			Main.parentLayer.stage.quality = "LOW";
			//Main.transitionLayer.stage.frameRate = 40;
			//Main.instance.scaleX = Main.instance.scaleY = 0.5;
			
		}
		
		public static function enable():void {
			if (_instance) _instance.destroy();
			
			_instance = new PixelatedView();
		}
		
		public static function disable():void {
			if (_instance) _instance.destroy();
		}
		
		private function onFrame(e:Event):void 
		{
			_safetyTimerLimit = 1000 / (Main.transitionLayer.stage.frameRate / Main.instance.lastDelta) * NumberUtils.interpolate2(1, 2, 0, MAX_FRAME_SKIP, _frameSkipped, 0.3);
			
			var sleepTime:Number = (getTimer() - _safetyTimer);
			if (sleepTime >= _safetyTimerLimit && _frameSkipped < MAX_FRAME_SKIP) {
				if (_frameSkipped >= MAX_FRAME_SKIP) {
					_frameSkipStrikes += 1;
					//trace("***PixelatedView strike:", _frameSkipStrikes);
					if (_frameSkipStrikes >= 5) {
						destroy();
						return;
					}
				}
				_safetyTimer = getTimer();
				_frameSkipped += 1;
				//trace("PixelatedView frame skipped:", _frameSkipped,  sleepTime);
				return;
			}else {
				if (_frameSkipped <= 1) _frameSkipStrikes -= 1;
				_frameSkipped = 0;
				//trace("PixelatedView running:", _frameSkipped,  sleepTime);
				bm.x = 720;
				_safetyTimer = getTimer();
				drawFrame(Main.parentLayer);
				bm.x = 0;
			}
		}
		
		
		public function drawFrame(obj:DisplayObject):void {
			var mat:Matrix = new Matrix();
			bmd.fillRect(bmd.rect, 0);
			
			mat.scale(1 / SCALE_FACTOR, 1 / SCALE_FACTOR);
			bufferBmd.draw(obj, mat, null, null, new Rectangle(0, 0, UiScaler.maxWidthAtCurrentRatio, 540), null);
			mat.scale(SCALE_FACTOR * SCALE_FACTOR, SCALE_FACTOR * SCALE_FACTOR);
			
			bmd.draw(bufferBmd, mat, null, null, null, null);
			
		}
		
		public function destroy():void {
			removeEventListener(Event.ENTER_FRAME, onFrame);
			if (bufferBmd) bufferBmd.dispose();
			bufferBmd = null;

			if (bmd) bmd.dispose();
			bmd = null;
			
			bm = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);

		}
		
	}

}