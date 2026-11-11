package src.steamapi 
{
	import com.amanitadesign.steam.FRESteamWorks;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import lbg.debug.Log;
	import org.osflash.signals.Signal;
	import src.Main;
	/**
	 * ...
	 * @author 
	 */
	public class LtF3FRESteamWorks 
	{
		
		public static var fres:FRESteamWorks;
		static public function get fresReady():Boolean 
		{
			return fres && fres.isReady;
		}
		
		public static var steamInitTimer:Timer = new Timer(500, 0);
		public static var steamInitTries:int = 0;//Keeps track of how long we've been waiting on steam
		
		public static var signalFresIsReady:Signal = new Signal();
		
		private static var _target:IEventDispatcher;
		
		
		public static function init(target:IEventDispatcher):void {
			
			try {
				_target = target;
				fres = new FRESteamWorks(target);
				if(fres) fres.init();
			}catch (e:Error) {
				Log.log("LtF3FRESteamWorks.init() ERROR, most likely not playing from inside steam or playing the swf");
				Log.log(e.errorID);
				Log.log(e.name);
				Log.log(e.message);
				
				giveUpOnSteam();
				
				return;
			}
			
			Log.log("LtF3FRESteamWorks.init() completed successfully");
			
			fres.getAppID();
			
			if (fres && fres.isReady) {
				Log.log("LtF3FRESteamWorks init - fres is up and ready");
				addOverlayWorkaround();
				signalFresIsReady.dispatch();
			}else {
				if(fres) Log.log("LtF3FRESteamWorks init - fres is not ready");
				if(fres == null) Log.log("LtF3FRESteamWorks init - fres is null");
				steamInitTimer.addEventListener(TimerEvent.TIMER, onSteamInitTimer);
				steamInitTimer.start();
			}
		}
		
		static private function onSteamInitTimer(e:TimerEvent):void 
		{
			if (fres && fres.isReady) {
				Log.log("onSteamInitTimer - fres is up and ready");
				steamInitTimer.removeEventListener(TimerEvent.TIMER, onSteamInitTimer);
				steamInitTimer.reset();
				signalFresIsReady.dispatch();
				addOverlayWorkaround();
			}else {
				if (fres) {
					Log.log("Steam Init Timer - Steam not found... fres ready:", fres.isReady);
				}else {
					Log.log("Steam Init Timer - Steam not found... fres is null");
				}
				
				steamInitTries += 1;
				
				if (steamInitTries >= 7) {
					giveUpOnSteam();
					return;
				}
				
				try {
					if (fres == null) fres = new FRESteamWorks(_target);
					fres.init();
				}catch (e:Error) {
					Log.log("LtF3FRESteamWorks.onSteamInitTimer() ERROR", e.name, e.message);
				}
			}
		}
		
		protected static function giveUpOnSteam():void {
			steamInitTimer.removeEventListener(TimerEvent.TIMER, onSteamInitTimer);
			steamInitTimer.reset();
			fres = null;
			signalFresIsReady.dispatch();
		}
		
		
		
		public static function addOverlayWorkaround():void {
			fres.addOverlayWorkaround(Main.instance.stage, true);
			fres.addOverlayWorkaround(Main.debugLayer, true);
		}
		
		
		
		
		
		
	}

}