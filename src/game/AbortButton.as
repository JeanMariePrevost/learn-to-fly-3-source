package src.game 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import lbg.components.labelmovieclip.LabelMovieClip;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.UiScaler;
	import src.gui.decorators.TweenPos;
	import src.Main;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class AbortButton extends MovieClip 
	{
		public var hitZone:MovieClip;
		public var circleTimer:MovieClip;
		public var abortWarning:MovieClip;
		public var button:MovieClip;
		
		protected var _wrapper:DeltaMovieClipWrapper;
		
		protected const _yTweenAmount:Number = -100;
		
		protected var _timerDuration:Number = 60;//Time to abort
		protected var _timerTime:Number = 0;
		
		protected var _tweenIsOver:Boolean = false;
		
		public function AbortButton() 
		{
			super();
			
			hitArea = hitZone;
			hitZone.visible = false;
			
			circleTimer.visible = false;
			circleTimer.stop();
			abortWarning.visible = false;
			
			button.gotoAndStop(1);
			
			_wrapper = new DeltaMovieClipWrapper(this, "idle");
			
			_wrapper.setAction("idle", LabelMovieClip.ACTION_STOP);
			_wrapper.setAction("onStart", LabelMovieClip.ACTION_PLAY);
			_wrapper.setAction("onEnd", LabelMovieClip.ACTION_STOP);
			_wrapper.setAction("offStart", LabelMovieClip.ACTION_PLAY);
			_wrapper.setAction("offEnd", "idle");
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			TweenPos.tweenToCurrentPosition(this, new Point(0, _yTweenAmount), 50, 0, TweenPos.EASE_OUT_CUBIC).finishedSignal.addOnce(onTweenFinished);
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			Main.unsafeTickSignal.add(tick);
			
			Input.readyAbort.signalCommandDown.add(startAbortSequence);
			Input.readyAbort.signalCommandUp.add(stopAbortSequence);
			
			UiScaler.addAbsoluteManually(this, 720, -720);
			UiScaler.addAbsoluteManually(abortWarning, -300, 470);
			UiScaler.addAbsoluteManually(circleTimer, -260, 626);
			//abortWarning.visible = true;
			//circleTimer.visible = true;
		}
		
		protected function onTweenFinished():void {
			_tweenIsOver = true;
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			if(button.currentFrame == 1) button.gotoAndStop(2);
			if (_wrapper.currentState != "on") {
				_wrapper.gotoLabel("onStart");
			}
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			if (button.currentFrame == 2) {
				button.gotoAndStop(1);
				if (_wrapper.currentState != "off" && _wrapper.currentState != "idle") {
					_wrapper.gotoLabel("offStart");
				}
			}
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			startAbortSequence();
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			stopAbortSequence();
		}
		
		private function startAbortSequence():void 
		{
			if (_tweenIsOver == false) return;
			
			button.gotoAndStop(3);
			circleTimer.visible = true;
			abortWarning.visible = true;
			_timerTime = 0;
		}
		
		public function stopAbortSequence():void {
			if (button == null || _wrapper == null) {
				destroy();
				return;
			}
			
			button.gotoAndStop(1);
			if (_wrapper.currentState != "off" && _wrapper.currentState != "idle") {
				if (stage == null || hitZone.hitTestPoint(stage.mouseX, stage.mouseY) == false) {
					_wrapper.gotoLabel("offStart");
				}
			}
			circleTimer.visible = false;
			abortWarning.visible = false;
			_timerTime = 0;
		}
		
		public function tick(delta:Number):void {
			if (_tweenIsOver == false) return;
			
			if (circleTimer && circleTimer.visible) {
				_timerTime += delta;
				circleTimer.gotoAndStop(int(NumberUtils.interpolate2(1, circleTimer.totalFrames, 0, _timerDuration, _timerTime)));
				
				if (_timerTime >= _timerDuration) {
					GameEngine.instance.showResults();
				}
			}
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			
			Input.readyAbort.signalCommandDown.remove(startAbortSequence);
			Input.readyAbort.signalCommandUp.remove(stopAbortSequence);
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			if (stage) stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			
			hitZone = null;
			circleTimer = null;
			abortWarning = null;
			button = null;
			if (_wrapper) _wrapper.destroy();
			_wrapper = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
	}

}