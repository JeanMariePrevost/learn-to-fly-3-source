package src.gui 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lbg.utils.NumberUtils;
	
	/**
	 * ...
	 * @author 
	 */
	public class HoldToConfirmButton extends MovieClip 
	{
		/**Number of frames it will take to completely fill the bar */
		public var framesToFill:Number = 60;
		protected var _time:Number = 0;
		protected var _mouseIsDown:Boolean = false;
		protected var _mouseIsOver:Boolean = false;
		
		public function HoldToConfirmButton() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			_mouseIsOver = false;
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			_mouseIsOver = true;
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			_mouseIsDown = true;
		}
		
		private function onFrame(e:Event):void 
		{
			if (_mouseIsDown && _mouseIsOver) {
				_time++;
			}else if (_mouseIsDown) {
				_time--;
			}else {
				_time = 0;
			}
			
			_time = NumberUtils.constrain(_time, 0, framesToFill);
			var val:Number = NumberUtils.interpolate2(1, totalFrames, 0, framesToFill, _time, 1, true);
			gotoAndStop(Math.round(val));
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			_mouseIsDown = false;
		}
		
	}

}