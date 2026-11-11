package src.gui.decorators {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import lbg.debug.Log;
	import lbg.utils.Easing;
	import org.osflash.signals.Signal;
	import src.gui.GuiSettings;
	/**
	 * ...
	 * @author 
	 */
	public class MouseBounce 
	{
		protected var _target:DisplayObject;
		/** Default = 0.1 */
		public var scaleMod:Number = 0.1;
		public var durationIn:Number = 10;
		public var durationOut:Number = 15;
		
		protected var _mouseIsOver:Boolean = false;
		protected var _animTime:Number = durationOut;
		protected var _scaleOutStart:Number;
		
		/** When mouse gets over the target. (target:DisplayObject) */
		protected var _signalOverTarget:Signal = new Signal(DisplayObject);
		/** When mouse gets out of the target. (target:DisplayObject) */
		protected var _signalOutTarget:Signal = new Signal(DisplayObject);
		/** When target is clicked, safer than click event. (target:DisplayObject) */
		protected var _signalClickTarget:Signal = new Signal(DisplayObject);
		
		public function MouseBounce(target:DisplayObject) 
		{
			_target = target;
			
			_target.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			_target.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			
			GuiSettings.guiTickSignal.add(tick);
		}
		
		protected function tick(delta:Number):void 
		{
			if (_target == null) {
				//HACK - For some reason signals are received after being removed from list
				//This only happens ONCE after destroy and seems unlinked to the destroy process
				//This is probably because the signal list is not updated "mid-dispatch", hence the items cleared from list are still fired
				destroy();
				return;
			}
			
			if (_mouseIsOver && _animTime < durationIn) {
				_animTime += 1;
				_target.scaleX = _target.scaleY = Easing.easeOutBack(_animTime, 1, scaleMod, durationIn);
			}else if (!_mouseIsOver && _animTime < durationOut) {
				_animTime += 1;
				_target.scaleX = _target.scaleY = Easing.easeBothInOutQuad(_animTime, _scaleOutStart, -(_scaleOutStart - 1), durationOut);
			}
		}
		
		private function rollOver(e:MouseEvent):void 
		{
			_mouseIsOver = true;
			_animTime = 0;
			_signalOverTarget.dispatch(_target);
		}
		
		private function rollOut(e:MouseEvent):void 
		{
			_mouseIsOver = false;
			_animTime = 0;
			_scaleOutStart = _target.scaleX;
			_signalOutTarget.dispatch(_target);
		}
		
		public function destroy():void {
			GuiSettings.guiTickSignal.remove(tick);
			if (_target) {
				_target.removeEventListener(MouseEvent.ROLL_OVER, rollOver);
				_target.removeEventListener(MouseEvent.ROLL_OUT, rollOut);
				_target = null;
			}
			//trace("Destroyed", this);
		}
		
		public function get signalOverTarget():Signal 
		{
			return _signalOverTarget;
		}
		
		
	}

}