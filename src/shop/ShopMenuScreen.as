package src.shop 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import src.ScreenManager;
	import src.audio.Sfx;
	import src.gui.Transition;
	import src.Main;
	import src.system.Global;
	import src.system.Input;
	import src.system.ProfileState;
	import src.system.SaveLoadModule;
	
	/**
	 * ...
	 * @author 
	 */
	public class ShopMenuScreen extends MovieClip 
	{
		public var btnReady:SimpleButton;
		public var btnBonusShop:SimpleButton;
		public var btnMedals:SimpleButton;
		public var btnOptions:SimpleButton;
		public var btnMainMenu:SimpleButton;
		public var btnCustomize:SimpleButton;
		public var btnMusic:SimpleButton;
		public var btnHud:SimpleButton;
		public var tvSweep:TvSweepEffect;
		public var scanlines:MovieClip;
		
		public function ShopMenuScreen() 
		{
			scanlines.cacheAsBitmap = true;
			
			btnReady.addEventListener(MouseEvent.CLICK, onReadyClick);
			btnBonusShop.addEventListener(MouseEvent.CLICK, onBonusClick);
			btnMedals.addEventListener(MouseEvent.CLICK, onMedalsClick);
			btnOptions.addEventListener(MouseEvent.CLICK, onOptionsClick);
			btnMainMenu.addEventListener(MouseEvent.CLICK, onMainMenuClick);
			btnCustomize.addEventListener(MouseEvent.CLICK, onCustomizeClick);
			btnMusic.addEventListener(MouseEvent.CLICK, onMusicClick);
			btnHud.addEventListener(MouseEvent.CLICK, onHudClick);
			
			tvSweep.mouseEnabled = tvSweep.mouseChildren = false;
			scanlines.mouseEnabled = scanlines.mouseChildren = false;
			
			if (ProfileState.instance.tutorialBonusShop == false) {
				btnBonusShop.visible = false;
			}
			
			if (ProfileState.instance.tutorialCustomization == false) {
				btnCustomize.visible = false;
			}
			
			if (ProfileState.instance.tutorialHUD == false) {
				btnHud.visible = false;
			}
			
			if (ProfileState.instance.tutorialMusic == false) {
				btnMusic.visible = false;
			}
			
			Input.readyAbort.signalCommandDown.add(onReadyClick2);
		}
		
		private function onBonusClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			Transition.transitionTo(ScreenManager.unloadShop, ScreenManager.loadBonusShop);
		}
		
		private function onReadyClick2():void {
			if (Input.instance.basicCommands.alt.isDown == false) onReadyClick(null);//Not if alt to prevent alt-enter from triggering it
		}
		
		private function onReadyClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			if (ProfileState.instance.currentGameState.gameMode == "Sandbox") {
				Transition.transitionTo(ScreenManager.unloadShop, ScreenManager.loadGameSandboxMode);
			}else if (ProfileState.instance.currentGameState.gameMode == "Payload Mode") {
				Transition.transitionTo(ScreenManager.unloadShop, ScreenManager.loadPayloadScreen);
			}else if (ProfileState.instance.currentGameState.gameMode == "Classic Mode") {
				Transition.transitionTo(ScreenManager.unloadShop, ScreenManager.loadClassicScreen);
			}else {
				//Story by default
				Transition.transitionTo(ScreenManager.unloadShop, ScreenManager.loadStoryProgressScreen);
			}
		}
		
		private function onMedalsClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			Transition.transitionTo(ScreenManager.unloadShop, ScreenManager.loadMedalBox);
		}
		
		private function onOptionsClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			Main.showOptionsMenu();
		}
		
		private function onMainMenuClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			Main.saveGame();
			//SaveLoadModule.saveProfileToFile(ProfileState.instance);
			Transition.transitionTo(ScreenManager.unloadShop, ScreenManager.loadMainMenu);
		}
		
		private function onCustomizeClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			Transition.transitionTo(ScreenManager.unloadShop, ScreenManager.loadCustomization);
		}
		
		private function onMusicClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			Transition.transitionTo(ScreenManager.unloadShop, ScreenManager.loadMusicScreen);
		}
		
		private function onHudClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			Transition.transitionTo(ScreenManager.unloadShop, ScreenManager.loadHudCustomization);
		}
		
		public function show():void {
			visible = true;
		}
		
		public function hide():void {
			visible = false;
		}
		
		public function destroy():void {
			Input.readyAbort.signalCommandDown.remove(onReadyClick2);
			
			btnReady.removeEventListener(MouseEvent.CLICK, onReadyClick);
			btnBonusShop.removeEventListener(MouseEvent.CLICK, onBonusClick);
			btnMedals.removeEventListener(MouseEvent.CLICK, onMedalsClick);
			btnOptions.removeEventListener(MouseEvent.CLICK, onOptionsClick);
			btnMainMenu.removeEventListener(MouseEvent.CLICK, onMainMenuClick);
			btnCustomize.removeEventListener(MouseEvent.CLICK, onCustomizeClick);
			btnMusic.removeEventListener(MouseEvent.CLICK, onMusicClick);
			btnHud.removeEventListener(MouseEvent.CLICK, onHudClick);
			
			tvSweep = null;
			scanlines = null;
			btnReady = null;
			btnMainMenu = null;
			btnCustomize = null;
			btnMusic = null;
			btnHud = null;
			btnBonusShop = null;
			btnMedals = null;
			btnOptions = null;
			while (numChildren >= 1) removeChildAt(0);
			if (stage) parent.removeChild(this);
		}
		
	}

}