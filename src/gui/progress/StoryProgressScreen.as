package src.gui.progress 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import src.Main;
	import src.UiScaler;
	import src.gui.TutorialBox;
	import src.shop.ShopTutorials;
	import src.shop.TipWidget;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class StoryProgressScreen extends MovieClip 
	{
		protected static var _instance:StoryProgressScreen;
		
		public var mainScreen:AbstractMainScreen;
		public var btnScreen:BtnScreen;
		public var btnScreenBg:MovieClip;
		public var tipWidget:TipWidget;
		public var tutorial:TutorialBox;
		
		public var baby:MovieClip;
		public var computers:MovieClip;
		
		public function StoryProgressScreen() 
		{
			super();
			
			btnScreen.init();
			tutorial.destroy();

			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			UiScaler.addAbsoluteManually(this, 100, -110);
			UiScaler.addAbsolute(computers, false, -150, -10);
			UiScaler.addAbsolute(baby, false, -290, -40);
			//UiScaler.addAbsolute(tutorial, false, 200);
			UiScaler.addAbsolute(btnScreen, false, -60);
			UiScaler.addAbsolute(btnScreenBg, false, -180);
			UiScaler.addAbsolute(mainScreen, false, 100);
		}
		
		
		static public function get instance():StoryProgressScreen 
		{
			if (_instance == null) {
				_instance = new StoryProgressScreen();
			}
			return _instance;
		}
		
		static public function get instancePayload():StoryProgressScreen 
		{
			if (_instance == null) {
				_instance = new PayloadProgressScreen();
			}
			return _instance;
		}
		
		static public function get instanceClassic():StoryProgressScreen 
		{
			if (_instance == null) {
				_instance = new ClassicProgressScreen();
			}
			return _instance;
		}
		
		public function destroy():void {
			_instance = null;
			
			if (mainScreen) mainScreen.destroy();
			mainScreen = null;
			
			if (btnScreen) btnScreen.destroy();
			btnScreen = null;
			
			if (tipWidget) tipWidget.destroy();
			tipWidget = null;
			
			if (tutorial) tutorial.destroy();
			tutorial = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
		static public function destroy():void {
			if (_instance) _instance.destroy();
		}
		
	}

}