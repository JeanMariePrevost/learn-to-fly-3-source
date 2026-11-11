package src 
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import lbg.anticheatengine.SafeNumber;
	import lbg.debug.Log;
	import src.steamapi.LtF3FRESteamWorks;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameLauncher extends MovieClip 
	{
		public var txtVersionBase:TextField;
		public var logTextField:TextField;
		public var main:Main;
		protected var _timer:Timer;
		
		public function GameLauncher() 
		{
			super();
			
			Log.linkExternalTextField(logTextField);
			
			Log.log("GameLauncher()");
			
			txtVersionBase.text = "Loading game...";
			
			_timer = new Timer(250, 1);
			_timer.addEventListener(TimerEvent.TIMER, onLaunchTimer);
			_timer.start();
		}
		
		private function onLaunchTimer(e:TimerEvent):void 
		{
			txtVersionBase.text = "Launching game...";
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER, onLaunchTimer);
			_timer = null;
			
			Main.gameLaunchedSignal.addOnce(postLaunchHook);
			
			preLaunchHook();
			launchGame();
			
		}
		
		protected function preLaunchHook():void {
			Log.log("GameLauncher.preLaunchHook()");
		}
		
		protected function postLaunchHook():void {
			Log.log("GameLauncher.postLaunchHook()");
			
			if (ProfileState.instance.fullscreenAtLaunch) {
				main.toggleFullScreen(true);
			}
		}
		
		protected function launchGame():void {
			main = new Main(false);
			addChild(main);
			
			txtVersionBase.text = "Game launched.";
		}
		
	}

}