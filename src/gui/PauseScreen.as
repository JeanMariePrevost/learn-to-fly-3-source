package src.gui 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import lbg.utils.DisplayObjectUtil;
	import src.UiScaler;
	import src.audio.Audio;
	import src.game.GameMediator;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class PauseScreen extends MovieClip 
	{
		protected var _gotFocusBack:Boolean = false;
		protected var _pauseStartTimer:Number = 0;
		
		public function PauseScreen() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			_gotFocusBack = false;
			GameMediator.gamePaused.dispatch();
			_pauseStartTimer = getTimer();
			
			mouseEnabled = mouseChildren = true;
			
			addEventListener(MouseEvent.CLICK, onMouseEvent, true, 3000);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent, true, 3000);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp, true, 3000);
			
			stage.addEventListener(MouseEvent.CLICK, onMouseEvent, true, 3000);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent, true, 3000);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent, true, 3000);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, true, 3000);
			
			Audio.pauseAllAudio();
			
			UiScaler.addAbsoluteManually(this, 360, -360);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			resumeGame();
		}
		
		private function resumeGame():void 
		{
			_gotFocusBack = true;
			
			var pauseDuration:Number = getTimer() - _pauseStartTimer;
			Main.instance.resumeGame();
			GameMediator.gameResumed.dispatch();
			GameMediator.gameResumedWithDuration.dispatch(pauseDuration);
			Audio.resumeAllAudio();
			
			destroy();
		}
		
		private function onMouseEvent(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
		}
		
		public function destroy():void {
			removeEventListener(MouseEvent.CLICK, onMouseEvent, true);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent, true);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
			
			if (stage) {
				stage.removeEventListener(MouseEvent.CLICK, onMouseEvent, true);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent, true);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent, true);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
			}
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}