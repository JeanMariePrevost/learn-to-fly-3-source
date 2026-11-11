package lbg.components 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	/**
	 * DEPRECATED - replaced by MovieClipButton Class
	 * ATM No loops are allowed ----------------------------------------------------------------------------------
	 * 
	 * SimpleButton uses various predetermined labels to simulate basic button behaviors
	 * idle
	 * in (should not loop)
	 * over
	 * out (should not loop)
	 * down
	 * off  //Disabled
	 * 
	 * no "Start" and "End" labels, requires manual "tick" function call
	 */
	public class MySimpleButton extends OldLabelMovieClip 
	{
		protected var _enable:Boolean = true;
		
		/** Determines if the button can be interacted with*/
		public function get enable():Boolean { return _enable };
		public function set enable(val:Boolean):void {
			_enable = val;
			if (_enable) {
				gotoAndStop("idle");
				addEventListener(MouseEvent.ROLL_OVER, doMouseOver);
				addEventListener(MouseEvent.ROLL_OUT, doMouseOut);
				addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
				if(stage) stage.addEventListener(MouseEvent.MOUSE_UP, doMouseUp);
				DisplayObjectUtil.setColorMatrix(this, 0, 0, 0, 0);
			}else {
				gotoAndStop("off");
				removeEventListener(MouseEvent.ROLL_OVER, doMouseOver);
				removeEventListener(MouseEvent.ROLL_OUT, doMouseOut);
				removeEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
				if (stage) stage.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
				DisplayObjectUtil.setColorMatrix(this, 0, -60, -60, -20);
			}
		};
		
		
		public function MySimpleButton() 
		{
			super();
			
			if (_labels.indexOf("idle") == -1 || _labels.indexOf("over") == -1 || _labels.indexOf("down") == -1) {
				Log.log("MySimpleButton ERROR - MovieClip doesn't have proper labels to be a SimpleButton");
				//throw new Error("MovieClip doesn't have proper labels to be a SimpleButton");
			}else {
				if (_labels.indexOf("in") != -1) addPlayLabel("in");
				if (_labels.indexOf("out") != -1) addPlayLabel("out");
				
				gotoAndStop("idle");
				
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
			
		}
		
		protected function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			enable = _enable;
		}
		
		protected function doMouseOver(e:MouseEvent):void {
			if (currentLabel == "idle" || currentLabel == "out") doIn();
		}
		
		protected function doMouseOut(e:MouseEvent):void {
			if (currentLabel == "over" || currentLabel == "in") doOut();
		}
		
		protected function doMouseDown(e:MouseEvent):void {
			gotoAndStop("down");
		}
		
		protected function doMouseUp(e:MouseEvent):void {
			//if (e.target == this) {
			if (this.hitTestPoint(e.stageX, e.stageY)) {
				gotoAndStop("over");
				//click?
			}else {
				gotoAndStop("idle");
				//or out?
			}
		}
		
		protected function doIn():void { 
			if (_labels.indexOf("in") == -1) {
				gotoAndStop("over");
			}else {
				gotoAndStop("in");
			}
		}
		
		protected function doOut():void {
			if (_labels.indexOf("out") == -1) {
				gotoAndStop("idle");
			}else {
				gotoAndStop("out");
			}
		}
		
		override public function destroy():void {
			removeEventListener(MouseEvent.ROLL_OVER, doMouseOver);
			removeEventListener(MouseEvent.ROLL_OUT, doMouseOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			super.destroy();
		}
		
	}

}