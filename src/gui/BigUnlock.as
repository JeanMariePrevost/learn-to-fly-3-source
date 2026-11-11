package src.gui {
	import flash.display.MovieClip;
	import flash.events.Event;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.Audio;
	import src.Main;
	import src.MedalCheck;
	import src.system.Global;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class BigUnlock extends MovieClip 
	{
		protected static var _instance:BigUnlock;
		
		public var message:MovieClip;
		
		protected var _clickDone:Boolean = false;
		
		public function BigUnlock(text:String) 
		{
			super();
			
			if (_instance) _instance.destroy();
			
			_instance = this;
			
			message.txtMessage.text = text;
			
			gotoAndStop(1);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			stage.frameRate = 30; 
			
			Audio.playMusic(MusicUnlock, 0).loop = false;
			
			Main.guiTickSignal.add(tick);
			
			switch(ProfileState.instance.currentGameState.gameMode) {
				case "Story Mode":
					MedalCheck.checkGameModeStory();
					break;
				case "Payload Mode":
					MedalCheck.checkGameModePayload();
					break;
				case "Classic Mode":
					MedalCheck.checkGameModeClassic();
					break;
			}
			
			UiScaler.addAbsoluteManually(this, 360, -360);
		}
		
		protected function tick(delta:Number):void {
			if (currentFrame < totalFrames) {
				nextFrame();
			}else {
				gotoAndStop("loopStart");
			}
			
			if (_clickDone == false && Input.instance.isMouseDown() && currentFrame >= 60) {
				_clickDone = true;
				
				if (ProfileState.instance.modeUnlockedPayload == false) {
					ProfileState.instance.modeUnlockedPayload = true;
					Transition.transitionTo(destroy, ScreenManager.loadBigUnlockPayload);
				}else if (ProfileState.instance.modeUnlockedClassic == false) {
					ProfileState.instance.modeUnlockedClassic = true;
					Transition.transitionTo(destroy, ScreenManager.loadBigUnlockClassic);
				//}else if (ProfileState.instance.modeUnlockedSandbox == true) {
					//Transition.transitionTo(destroy, ScreenManager.loadSecret);
				}else {
					Transition.transitionTo(destroy, ScreenManager.loadMainMenu);
				}
				
				Main.saveGame();
			}
		}
		
		public static function getNewBigUnlock(text:String):BigUnlock {
			destroy();
			
			_instance = new BigUnlock(text);
			
			return _instance;
		}
		
		static public function get instance():BigUnlock 
		{
			return _instance;
		}
		
		public static function destroy():void {
			if (_instance) _instance.destroy();
		}
		
		public function destroy():void {
			_instance = null;
			
			if (stage) stage.frameRate = Global.defaultFramerate;
			
			message = null;
			Main.guiTickSignal.remove(tick);
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}