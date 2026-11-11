package src.gui 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import src.UiScaler;
	import src.gui.decorators.MouseBounce2;
	import src.gui.decorators.TweenPos;
	
	/**
	 * ...
	 * @author 
	 */
	public class TutorialBox extends MovieClip 
	{
		public var arrows:MovieClip;
		public var btnYes:SimpleButton;
		
		protected var _bounce:MouseBounce2;
		
		protected var _lastFrame:int = 0;
		
		public function TutorialBox() 
		{
			super();
			
			stop();
			
			_bounce = new MouseBounce2(btnYes);
			
			_bounce.signalClickTarget.addOnce(onOk);
			
			TweenPos.tweenToCurrentPosition(this, new Point(0, 720), 65, 0, TweenPos.EASE_OUT_QUINT);
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			addEventListener(Event.EXIT_FRAME, onExitFrame);
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			UiScaler.addAbsoluteManually(this, 50, -50);
			UiScaler.addAbsoluteManually(arrows, 360, -360);
		}
		
		private function onExitFrame(e:Event):void 
		{
			if (_lastFrame != currentFrame) {
				//trace("Exit frame!");
				if (_bounce) _bounce.destroy();
				_bounce = null;
			}
		}
		
		private function onFrame(e:Event):void 
		{
			if (_lastFrame != currentFrame) {
				//trace("Enter frame!");
				if (_bounce == null) {
					_bounce = new MouseBounce2(btnYes);
					_bounce.signalClickTarget.addOnce(onOk);
				}
				_lastFrame = currentFrame;
				arrows.gotoAndStop(currentFrame);
			}
		}
		
		protected function onOk(target:DisplayObject):void {
			TweenPos.tweenFromCurrentPosition(this, new Point(0, 720), 35, 0, TweenPos.EASE_OUT).finishedSignal.addOnce(destroy);
		}
		
		public function destroy():void {
			removeEventListener(Event.ENTER_FRAME, onFrame);
			removeEventListener(Event.EXIT_FRAME, onExitFrame);
			
			btnYes = null;
			
			if (_bounce) {
				_bounce.destroy();
			}
			_bounce = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, false);
			if (parent) parent.removeChild(this);
		}
	}

}