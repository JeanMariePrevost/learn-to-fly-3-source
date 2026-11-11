package src 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import src.shop.medals.MedalBox;
	
	/**
	 * ...
	 * @author 
	 */
	public class MemoryTester extends MovieClip 
	{
		protected static var _instance:MemoryTester;
		
		public var btnShop:SimpleButton;
		public var btnBonusShop:SimpleButton;
		public var btnMedals:SimpleButton;
		public var btnGame:SimpleButton;
		public var btnCustom:SimpleButton;
		public var btnUnload:SimpleButton;
		
		public function MemoryTester(singleton:Enforcer) 
		{
			super();
			
			btnShop.addEventListener(MouseEvent.CLICK, doShop);
			btnBonusShop.addEventListener(MouseEvent.CLICK, doBonusShop);
			btnMedals.addEventListener(MouseEvent.CLICK, doMedals);
			btnGame.addEventListener(MouseEvent.CLICK, doGame);
			btnCustom.addEventListener(MouseEvent.CLICK, doCustom);
			btnUnload.addEventListener(MouseEvent.CLICK, doUnloadAll);
			
		}
		
		private function doShop(e:MouseEvent):void 
		{
			ScreenManager.loadShop();
			ScreenManager.unloadShop();
		}
		
		private function doBonusShop(e:MouseEvent):void 
		{
			ScreenManager.loadShop();
			ScreenManager.unloadShop();
		}
		
		private function doMedals(e:MouseEvent):void 
		{
			ScreenManager.loadMedalBox();
			MedalBox.destroy();
		}
		
		private function doGame(e:MouseEvent):void 
		{
			ScreenManager.loadGame();
			ScreenManager.unloadGame();
		}
		
		private function doCustom(e:MouseEvent):void 
		{
		}
		
		private function doUnloadAll(e:MouseEvent):void 
		{
			ScreenManager.unloadAllScreens();
		}
		
		public static function show():void {
			Main.debugLayer.addChild(instance);
		}
		
		public static function hide():void {
			if (instance.stage) {
				instance.parent.removeChild(instance);
			}
		}
		
		public static function toggle():void {
			if (instance.stage) {
				hide();
			}else {
				show();
			}
		}
		
		public static function get instance():MemoryTester {
			if (_instance == null) {
				_instance = new MemoryTester(new Enforcer());
			}
			
			return _instance;
		}
		
		
	}

}

class Enforcer { }
