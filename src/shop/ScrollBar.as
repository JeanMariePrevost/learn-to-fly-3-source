package src.shop 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class ScrollBar extends MovieClip 
	{
		public var signalScroll:Signal = new Signal(Number);
		public var slider:MovieClip;
		public var arrowUp:ScrollBarArrow;
		public var arrowDown:ScrollBarArrow;
		
		protected const MIN_Y:Number = 0;//0.55;
		protected const MAX_Y:Number = 310;//Slider movement limit
		
		protected var _beingDragged:Boolean = false;
		protected var _dragAnchor:Number;
		
		
		public function ScrollBar() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, added);
			
			gotoAndStop(1);
			slider.gotoAndStop(1);
		}
		
		protected function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			slider.addEventListener(MouseEvent.MOUSE_DOWN, onSliderMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			slider.addEventListener(MouseEvent.ROLL_OVER, onSliderOver);
			slider.addEventListener(MouseEvent.ROLL_OUT, onSliderOut);
			
			
			updateScrollArrows();
		}
		
		private function onSliderOut(e:MouseEvent):void 
		{
			if(!_beingDragged) slider.gotoAndStop(1);
		}
		
		private function onSliderOver(e:MouseEvent):void 
		{
			slider.gotoAndStop(2);
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			if(!_beingDragged) gotoAndStop(1);
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			gotoAndStop(2);
		}
	
		public function updateSliderPos(norm:Number):void {
			_beingDragged = false;
			slider.y = NumberUtils.interpolate(MIN_Y, MAX_Y, norm, 1, true);
			
			updateScrollArrows();
		}
		
		public function moveSliderPos(byNorm:Number):void {
			slider.y = NumberUtils.interpolate(MIN_Y, MAX_Y, currentScrollValue+byNorm, 1, true);
			
			updateScrollArrows();
			signalScroll.dispatch(currentScrollValue);
		}
		
		protected function updateScrollArrows():void {
			var norm:Number = NumberUtils.interpolate2(0, 1, MIN_Y, MAX_Y, slider.y);
			
			arrowUp.updateFromSliderPosition(norm);
			arrowDown.updateFromSliderPosition(1 - norm);
		}
		
		
		protected function onMouseMove(e:MouseEvent):void 
		{
			if (_beingDragged) {
				var p:Point = globalToLocal(new Point(0, e.stageY - _dragAnchor));
				p.y = NumberUtils.constrain(p.y, MIN_Y, MAX_Y);
				slider.y = p.y;
				
				signalScroll.dispatch(currentScrollValue);
				updateScrollArrows();
			}
		}
		
		public function get currentScrollValue():Number {
			var value:Number = NumberUtils.interpolate2(0, 1, MIN_Y, MAX_Y, slider.y, 1, true);
			return value;
		}
		
		protected function onSliderMouseDown(e:MouseEvent):void 
		{
			_dragAnchor = e.localY;
			_beingDragged = true;
		}
		
		protected function onMouseUp(e:MouseEvent):void 
		{
			_beingDragged = false;
			
			if (!hitTestPoint(e.stageX, e.stageY, true)) {
				onMouseOut(e);
			}
		}
		
		protected function onMouseDown(e:MouseEvent):void 
		{
			if (e.target != this) return;//Clicking on the slider, not the bar. Return.
			
			slider.y = NumberUtils.constrain(e.localY - slider.height / 2, MIN_Y, MAX_Y);
			_dragAnchor = slider.height / 2;
			_beingDragged = true;
			onMouseMove(e);
		}
		
		public function destroy():void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			slider.removeEventListener(MouseEvent.MOUSE_DOWN, onSliderMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			
			slider.removeEventListener(MouseEvent.ROLL_OVER, onSliderOver);
			slider.removeEventListener(MouseEvent.ROLL_OUT, onSliderOut);
			
			signalScroll.removeAll();
			signalScroll = null;
			slider = null;
			arrowUp.destroy();
			arrowUp = null;
			arrowDown.destroy();
			arrowUp = null;
			
			if (stage) parent.removeChild(this);
			while (numChildren >= 1) removeChildAt(0);
		}
		
	}

}