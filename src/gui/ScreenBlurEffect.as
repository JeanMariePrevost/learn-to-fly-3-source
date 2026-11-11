package src.gui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.Main;
	import src.UiScaler;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ScreenBlurEffect extends Sprite 
	{
		/** Multiplies the resolution of the bitmap */
		public var resolutionMult:Number = 0.5;
		/** default 45 */
		public var duration:Number = 20;
		/** default 1.1, max zoom*/
		public var zoomMult:Number = 1.08;
		/** default 0.4 */
		public var tintMult:Number = 0.85;
		public var enableBlur:Boolean = false;//Setting this to false gives a similar effect but w/o any costly blur
		
		protected var _bmd:BitmapData;
		protected var _bm:Bitmap;
		
		protected var _time:Number;
		protected var _deblurDuration:Number;
		
		//"idle", "in" or "out"
		protected var _state:String = "idle";
		
		public function ScreenBlurEffect() 
		{
			addEventListener(Event.ADDED_TO_STAGE, added);
			
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			mouseEnabled = mouseChildren = true;
			
			_bmd = new BitmapData(Main.visibleStageWidth * resolutionMult, Main.visibleStageWidth * resolutionMult);
			var mat:Matrix = new Matrix();
			mat.scale(resolutionMult, resolutionMult);
			_bmd.draw(Main.parentLayer, mat, null, null, new Rectangle(0, 0, UiScaler.maxWidthAtCurrentRatio, UiScaler.stageHeightAtCurrentRatio));
			
			scaleX = scaleY = 1 / resolutionMult;
			
			_bm = new Bitmap(_bmd);
			addChild(_bm);
			
			_time = 0;
			
			_state = "in";
			GuiSettings.guiTickSignal.remove(deblurTick);
			GuiSettings.guiTickSignal.add(tick);
	}
		
		protected function tick(delta:Number):void 
		{
			//Blur
			_time += delta;
			_time = NumberUtils.constrain(_time, 0, duration);
			var norm:Number = _time / duration;
			
			applyEffect(norm);
			
			if (_time >= duration) {
				_state = "idle";
				GuiSettings.guiTickSignal.remove(tick);
			}
		}
		
		protected function deblurTick(delta:Number):void 
		{
			//Deblur
			_time -= delta;
			_time = NumberUtils.constrain(_time, 0, _deblurDuration);
			var norm:Number = _time / _deblurDuration;
			
			applyEffect(norm);
			
			//QC high
			if (_bm) _bm.alpha = Easing.easeOutQuad(_time, 0, 1, _deblurDuration);
			//trace(_bm.alpha);
			
			if (_time <= 0) {
				_state = "idle";
				GuiSettings.guiTickSignal.remove(deblurTick);
				destroy();
			}
			
		}
		
		protected function applyEffect(norm:Number):void {
			if (stage == null || _bm == null) {
				destroy();
				return;
			}
			
			//trace("applyEffect", norm);
			
			var zoom:Number = 1;
			if (_state = "in") {
				zoom = Easing.easeOutQuart(norm, 1, zoomMult - 1, 1);
			}else {
				zoom = Easing.easeOutQuart(norm, 1, zoomMult - 1, 1);
			}
			_bm.scaleX = zoom;
			_bm.scaleY = zoom;
			_bm.x = (1 - zoom) * _bm.width * 0.5;
			_bm.y = (1 - zoom) * _bm.height * 0.5;
			
			DisplayObjectUtil.setObjectTint(this, 0xFFFFFF, Easing.easeBothInOutQuad(norm, 0, 1, 1) * tintMult);
		}
		
		public function deblurAndDestroy(duration:Number = 20):void {
			if (!isNaN(_deblurDuration)) return;//Already being deblurred
			
			_state = "out";
			
			_time = duration;
			_deblurDuration = duration;
			
			GuiSettings.guiTickSignal.add(deblurTick);
			GuiSettings.guiTickSignal.remove(tick);
		}
		
		public function destroy():void {
			GuiSettings.guiTickSignal.remove(tick);
			GuiSettings.guiTickSignal.remove(deblurTick);
			
			if(_bmd) _bmd.dispose();
			_bmd = null;
			_bm = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}