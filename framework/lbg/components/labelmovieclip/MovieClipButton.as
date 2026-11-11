package lbg.components.labelmovieclip 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	
	/**
	 * MovieClipButton uses various predetermined labels to simulate basic button behaviors
	 * idle
	 * in (idle->over)
	 * over
	 * out (over->idle)
	 * down
	 * off  //When button is disabled
	 * 
	 * 
	 * Each label requires a Start/End label (e.g. idleStart, idleEnd)
	 */
	public class MovieClipButton extends LabelMovieClip 
	{
		public static const ACTION_PLAY:String = LabelMovieClip.ACTION_PLAY;
		public static const ACTION_STOP:String = LabelMovieClip.ACTION_STOP;
		
		protected var _enable:Boolean = true;
		
		/** Determines if the button can be interacted with*/
		public function get enable():Boolean { return _enable }
		public function set enable(val:Boolean):void {
			_enable = val;
			if (_enable) {
				_movieClip.gotoAndStop("idleStart")
				_movieClip.addEventListener(MouseEvent.ROLL_OVER, doMouseOver);
				_movieClip.addEventListener(MouseEvent.ROLL_OUT, doMouseOut);
				_movieClip.addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
				_movieClip.stage.addEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			}else {
				_movieClip.gotoAndStop("offStart");
				_movieClip.removeEventListener(MouseEvent.ROLL_OVER, doMouseOver);
				_movieClip.removeEventListener(MouseEvent.ROLL_OUT, doMouseOut);
				_movieClip.removeEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
				_movieClip.stage.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			}
		}
		
		public function MovieClipButton(movieClip:MovieClip, tickSignal:Signal = null, playFromEnterFrame:Boolean = false):void {
			super(movieClip, tickSignal);
			
			setAction("idleStart", ACTION_PLAY);
			setAction("idleEnd", "idleStart");
			
			setAction("inStart", ACTION_PLAY);
			setAction("inEnd", "overStart");
			
			setAction("overStart", ACTION_PLAY);
			setAction("overEnd", "overStart");
			
			setAction("outStart", ACTION_PLAY);
			setAction("outEnd", "idleStart");
			
			setAction("downStart", ACTION_PLAY);
			setAction("downEnd", "downStart");
			
			setAction("offStart", ACTION_PLAY);
			setAction("offEnd", "offStart");
			
			if (playFromEnterFrame) _movieClip.addEventListener(Event.ENTER_FRAME, onClipFrame);
			
			if (_movieClip.stage) {
				enable = true;
			}else {
				_movieClip.addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event):void 
		{
			_movieClip.removeEventListener(Event.ADDED_TO_STAGE, init);
			enable = true;
		}
		
		private function onClipFrame(e:Event):void 
		{
			tick(1);
		}
			
		protected function doMouseOver(e:MouseEvent):void {
			if (currentAction == "idle" || currentAction == "out") gotoAction("in");
		}
		
		protected function doMouseOut(e:MouseEvent):void {
			if (currentAction == "over" || currentAction == "in") gotoAction("out");
		}
		
		
		protected function doMouseDown(e:MouseEvent):void {
			gotoAction("down");
		}
		
		protected function doMouseUp(e:MouseEvent):void {
			//if (e.target == this) {
			if (_movieClip.hitTestPoint(e.stageX, e.stageY)) {
				gotoAction("over");
				//click?
			}else {
				gotoAction("idle");
				//or out?
			}
		}
		
		override public function destroy():void 
		{
			if (_movieClip) {
				_movieClip.addEventListener(Event.ENTER_FRAME, onClipFrame);
				_movieClip.removeEventListener(MouseEvent.ROLL_OVER, doMouseOver);
				_movieClip.removeEventListener(MouseEvent.ROLL_OUT, doMouseOut);
				_movieClip.removeEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
				_movieClip.stage.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			}
			
			super.destroy();
		}
		
		

		
	}

}