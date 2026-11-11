package src 
{
	import flash.display.DisplayObjectContainer;
	import lbg.debug.Log;
	import src.audio.*;
	import src.game.*;
	import src.gui.*;
	import src.cards.CardBox;
	import src.customization.CustomScreen;
	import src.customization.HudCustomizationScreen;
	import src.customization.MusicScreen;
	import src.customization.ShipCustomScreen;
	import src.game.sandboxmode.SandBoxScreen;
	import src.game.spacestage.SpaceStage;
	import src.gui.decorators.PixelatedView;
	import src.gui.menus.CutsceneReplay;
	import src.gui.menus.EndGameScreen;
	import src.gui.progress.ClassicProgressScreen;
	import src.gui.progress.PayloadProgressScreen;
	import src.gui.progress.StoryProgressScreen;
	import src.shop.*;
	import src.system.*;
	import src.shop.bonusshop.BonusShopEngine;
	import src.shop.medals.MedalBox;
	import src.spaceinvader.SpaceInvader;
	/**
	 * Simply a collection of load/unload functions to clean up the Main class mess
	 * This will also allow me to track the currently loaded screens
	 * @author 
	 */
	public class ScreenManager 
	{
		public static var loadedScreens:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
		
		public static function unloadAllScreens(withRecursiveDestroy:Boolean = true):void {
			for each(var screen:DisplayObjectContainer in loadedScreens) {
				if ("destroy" in screen) screen["destroy"]();
			}
			
			loadedScreens.length = 0;
			
			unloadGame();
			
			Main.instance.recursiveDestroy();
		}
		
		public static function addScreen(screen:DisplayObjectContainer):void {
			loadedScreens.push(screen);
			Main.mainLayer.addChild(screen);
			
			var endString:String = (loadedScreens.length == 1) ? " screen currently loaded.":" screens currently loaded.";
			Log.log(loadedScreens.length.toFixed(0) + endString);
		}
		
		public static function loadSpaceInvader():void {
			Log.log("loadSpaceInvader()");
			Audio.fadeAllAudio();
			PixelatedView.enable();
			addScreen(SpaceInvader.instance);
		}
		
		public static function unloadSpaceInvader():void {
			Log.log("unloadSpaceInvader()");
			Audio.fadeAllAudio();
			SpaceInvader.destroy();
			if (ProfileState.instance.cheatPixel == false) PixelatedView.disable();
			Main.instance.stage.frameRate = Global.defaultFramerate;
			Main.instance.stage.quality = ProfileState.instance.optionQuality;
		}
		
		
		public static function loadVCR():void {
			Log.log("loadVCR()");
			Audio.fadeAllAudio();
			Music.playShopMusic();
			addScreen(CutsceneReplay.instance);
			Main.instance.sysButtonsToTop();
		}
		
		public static function loadShop():void {
			Log.log("loadShop()");
			
			unloadAllScreens();
			
			Audio.fadeAllAudio();
			Music.playShopMusic();
			Main.instance.enableFocusLostPausing = true;
			Main.instance.stage.frameRate = Global.defaultFramerate;
			ShopEngine.destroy();
			addScreen(ShopEngine.instance);
			Main.instance.sysButtonsToTop();
		}
		
		public static function unloadShop():void {
			Log.log("unloadShop()");
			ShopEngine.destroy();
			ShopTooltip.hideAll();
			
			Main.instance.recursiveDestroy();
		}
		
		public static function loadMainMenu():void {
			Log.log("loadMainMenu()");
			addScreen(MainMenuController.instance);
			Main.instance.enableFocusLostPausing = true;
			Main.instance.sysButtonsToTop();
		}
		
		public static function loadGame():void {
			Log.log("loadGame()");
			Main.instance.enableFocusLostPausing = true;
			Audio.fadeAllAudio();
			GameEngine.initInstance();
			Main.instance.stage.focus = Main.instance.stage;
			Input.instance.resetEveryCommand();
			Main.instance.stage.frameRate = Global.defaultFramerate;
			Main.instance.sysButtonsToTop();
		}
		
		public static function loadGameSandboxMode():void {
			Log.log("loadGameSandboxMode()");
			Main.instance.enableFocusLostPausing = true;
			Audio.fadeAllAudio();
			GameEngineSandbox.initInstance();
			Main.instance.stage.focus = Main.instance.stage;
			Input.instance.resetEveryCommand();
			Main.instance.sysButtonsToTop();
		}
		
		public static function loadGameClassicMode():void {
			Log.log("loadGameClassicMode()");
			Main.instance.enableFocusLostPausing = true;
			Audio.fadeAllAudio();
			GameEngineClassic.initInstance();
			Main.instance.stage.focus = Main.instance.stage;
			Input.instance.resetEveryCommand();
			Main.instance.sysButtonsToTop();
		}
		
		public static function loadGamePayloadMode():void {
			Log.log("loadGamePayloadMode()");
			Main.instance.enableFocusLostPausing = true;
			Audio.fadeAllAudio();
			GameEnginePayload.initInstance();
			Main.instance.stage.focus = Main.instance.stage;
			Input.instance.resetEveryCommand();
			Main.instance.sysButtonsToTop();
		}
		
		public static function unloadGame():void {
			Log.log("unloadGame()");
			
			GameEngine.destroy();
			GameEngineClassic.destroy();
			GameEnginePayload.destroy();
			GameEngineSandbox.destroy();
			Main.instance.stage.focus = Main.instance.stage;
			Input.instance.resetEveryCommand();
		}
		
		public static function loadBonusShop():void {
			Log.log("loadBonusShop()");
			Main.instance.enableFocusLostPausing = true;
			Audio.fadeAllAudio();
			Music.playBonusShopMusic();
			addScreen(BonusShopEngine.instance);
			Main.instance.sysButtonsToTop();
		}
		
		public static function loadMedalBox():void {
			Log.log("loadMedalBox()");
			addScreen(MedalBox.instance);
			Main.instance.sysButtonsToTop();
		}
		
		public static function loadCardBox():void {
			Log.log("loadCardBox()");
			addScreen(CardBox.instance);
			Main.instance.sysButtonsToTop();
		}
		
		public static function loadSpaceMiniGame(speed:Number, direction:Number):void {
			Log.log("loadSpaceMiniGame()");
			addScreen(SpaceStage.startSpaceStage(speed, direction));
		}
		
		public static function unloadSpaceMiniGame():void {
			Log.log("unloadSpaceMiniGame()");
			SpaceStage.destroy();
		}
		
		public static function loadEndGameScreen():void {
			Log.log("loadEndGameScreen()");
			unloadAllScreens();
			Music.fadeOutAll();
			addScreen(EndGameScreen.instance);
		}
		
		public static function unloadEndGameScreen():void {
			Log.log("unloadEndGameScreen()");
			EndGameScreen.destroy();
			ShopTooltip.hideAll();
		}
		
		public static function loadMusicScreen():void {
			Audio.fadeAllAudio();
			Log.log("loadMusicScreen()");
			addScreen(MusicScreen.instance);
			Main.instance.sysButtonsToTop();
		}
		
		public static function unloadMusicScreen():void {
			Log.log("unloadMusicScreen()");
			Audio.fadeAllAudio();
			MusicScreen.destroy();
			ShopTooltip.hideAll();
		}
		
		public static function loadCustomization():void {
			Log.log("loadCustomization()");
			addScreen(CustomScreen.instance);
			Main.instance.sysButtonsToTop();
		}
		
		public static function unloadCustomization():void {
			Log.log("unloadCustomization()");
			CustomScreen.destroy();
			ShopTooltip.hideAll();
		}
		
		public static function loadShipCustomization():void {
			Log.log("loadShipCustomization()");
			addScreen(ShipCustomScreen.instance);
			Main.instance.sysButtonsToTop();
		}
		
		public static function unloadShipCustomization():void {
			Log.log("unloadShipCustomization()");
			ShipCustomScreen.destroy();
			ShopTooltip.hideAll();
		}
		
		public static function loadHudCustomization():void {
			Log.log("loadHudCustomization()");
			addScreen(HudCustomizationScreen.instance);
			Main.instance.sysButtonsToTop();
		}
		
		public static function unloadHudCustomization():void {
			Log.log("unloadHudCustomization()");
			HudCustomizationScreen.destroy();
			ShopTooltip.hideAll();
		}
		
		public static function loadPayloadScreen():void {
			Log.log("loadPayloadScreen()");
			StoryProgressScreen.destroy();
			addScreen(StoryProgressScreen.instancePayload);
			Main.instance.sysButtonsToTop();
		}
		
		public static function loadStoryProgressScreen():void {
			Log.log("loadStoryProgressScreen()");
			StoryProgressScreen.destroy();
			addScreen(StoryProgressScreen.instance);
			Main.instance.sysButtonsToTop();
		}
		
		public static function loadClassicScreen():void {
			Log.log("loadClassicScreen()");
			StoryProgressScreen.destroy();
			addScreen(StoryProgressScreen.instanceClassic);
			Main.instance.sysButtonsToTop();
		}
		
		public static function loadSandBoxScreen():void {
			Log.log("loadSandBoxScreen()");
			addScreen(SandBoxScreen.instance);
			Main.instance.sysButtonsToTop();
		}
		
		protected static function loadBigUnlock(message:String):void {
			addScreen(BigUnlock.getNewBigUnlock(message));
		}
		
		public static function loadBigUnlockPayload():void {
			Log.log("loadBigUnlockPayload()");
			loadBigUnlock("Payload Mode\rUnlocked!");
		}
		
		public static function loadBigUnlockClassic():void {
			Log.log("loadBigUnlockClassic()");
			loadBigUnlock("Classic Mode\rUnlocked!");
		}
		
		public static function loadBigUnlockSandbox():void {
			Log.log("loadBigUnlockSandbox()");
			loadBigUnlock("Sandbox\rUnlocked!");
		}
		
		public static function loadSecret():void {
			Log.log("loadSecret()");
			addScreen(GameSecret.instance);
		}
		
		public static function loadProfileStatsScreen():void {
			Log.log("loadProfileStatsScreen()");
			addScreen(ProfileStatsScreen.instance);
			Audio.fadeAllAudio();
			Music.playBonusShopMusic();
		}
		
	}

}