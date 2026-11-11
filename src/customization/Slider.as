package src.customization 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class Slider extends MovieClip 
	{
		public var ball:MovieClip;
		public var bar:MovieClip;
		
		/** Dispatch whenever the slider position changes (normValue:Number) */
		protected var _signalChange:Signal = new Signal(Number);
		protected var _mouseDown:Boolean = false;
		protected var _norm:Number = 0;
		
		public function Slider() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			
			gotoAndStop(1);
			ball.gotoAndStop(1);
			bar.gotoAndStop(1);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			Main.unsafeTickSignal.add(tick);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onMouseDown(e:Event) {
			_mouseDown = true;
		}
		
		protected function onMouseUp(e:Event) {
			_mouseDown = false;
		}
		
		protected function tick(delta:Number):void {
			if (stage) {
				if (hitTestPoint(stage.mouseX, stage.mouseY)) {
					if (_mouseDown) {
						ball.gotoAndStop(3);
						bar.gotoAndStop(3);
						dragSlider();
					}else {
						ball.gotoAndStop(2);
						bar.gotoAndStop(2);
					}
				}else {
					if (_mouseDown) {
						ball.gotoAndStop(3);
						bar.gotoAndStop(3);
						dragSlider();
					}else {
						ball.gotoAndStop(1);
						bar.gotoAndStop(1);
					}
				}
			}
		}
		
		protected function dragSlider():void {
			var ballOffset:Number = ball.getBounds(this).width * 0.5;
			var sliderLength:Number = getBounds(this).width;
			var norm:Number = NumberUtils.interpolate2(0, 1, ballOffset, sliderLength - (ballOffset), mouseX);
			gotoAndStop(1 + Math.ceil((totalFrames - 0.001) * norm));
			_norm = norm;
			_signalChange.dispatch(norm);
		}
		
		public function get signalChange():Signal 
		{
			return _signalChange;
		}
		
		/** The normalized value of the slider position */
		public function get value():Number 
		{
			return _norm;
		}
		
		public function set value(value:Number):void 
		{
			_norm = value;
			_norm = NumberUtils.constrain(_norm);
			gotoAndStop(1 + Math.ceil((totalFrames - 0.001) * value));
		}
		
		public function destroy():void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			Main.unsafeTickSignal.remove(tick);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			ball = null;
			bar = null;
			
			_signalChange.removeAll();
			_signalChange = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}