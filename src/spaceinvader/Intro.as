package src.spaceinvader 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import lbg.utils.DisplayObjectUtil;
	import src.audio.Music;
	import src.audio.Sfx;
	
	/**
	 * ...
	 * @author 
	 */
	public class Intro extends MovieClip 
	{
		protected var _playedIntro:Boolean = false;
		protected var _stoppedIntroMusic:Boolean = false;
		protected var _playedTitle:Boolean = false;
		
		public function Intro() 
		{
			super();
			
			gotoAndStop(1);
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			
		}
		
		private function onFrame(e:Event):void 
		{
			switch(currentLabel) {
				case "intro":
					if (_playedIntro == false) {
						_playedIntro = true;
						Music.playInvaderIntro();
					}
					nextFrame();
					break;
				case "title":
					if (_stoppedIntroMusic == false) {
						_stoppedIntroMusic = true;
						Music.fadeOutAll();
					}
					nextFrame();
					break;
				case "titleFlash":
					if (_playedTitle == false) {
						_playedTitle = true;
						Sfx.playInvaderTitleFlash();
						Music.playInvaderTitle();
					}
					nextFrame();
					break;
				case "end":
					removeEventListener(Event.ENTER_FRAME, onFrame);
					break;
					
			}
		}
		
		public function destroy():void {
			removeEventListener(Event.ENTER_FRAME, onFrame);
			_playedIntro = true;
			_stoppedIntroMusic = true;
			_playedTitle = true;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}