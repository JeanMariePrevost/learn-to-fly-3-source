package src.shop 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import src.UiScaler;
	import src.gui.TutorialBox;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ShopTutorials extends MovieClip 
	{
		public var tut:TutorialBox;
		
		public function ShopTutorials() 
		{
			super();
			
			tut = new TutorialBox();
			addChild(tut);
			
			//Log.log("Upgrade tutorial check:", (ProfileState.instance.currentGameState.launcher.id != "emptyLauncher"), ProfileState.instance.currentGameState.cash.value, ProfileState.instance.tutorialBuyUpgrade, ProfileState.instance.stats.totalDays);
			
			if (ProfileState.instance.tutorialBuyLauncher == false) {
				ProfileState.instance.tutorialBuyLauncher = true;
				tut.gotoAndStop("launcher");
			}else if (ProfileState.instance.currentGameState.launcher.id != "emptyLauncher" && ProfileState.instance.currentGameState.cash.value >= 10 && ProfileState.instance.tutorialBuyUpgrade == false && ProfileState.instance.stats.totalDays >= 1) {
				ProfileState.instance.tutorialBuyUpgrade = true;
				tut.gotoAndStop("upgrades");
			}else if (ProfileState.instance.tutorialBuyUpgrade && ProfileState.instance.currentGameState.cash.value >= 5 && ProfileState.instance.tutorialStages == false && ProfileState.instance.stats.totalDays >= 2) {
				ProfileState.instance.tutorialStages = true;
				tut.gotoAndStop("stages");
			}else if (ProfileState.instance.tutorialStages && ProfileState.instance.currentGameState.cash.value >= 10 && ProfileState.instance.tutorialBoosts == false && ProfileState.instance.stats.totalDays >= 3) {
				ProfileState.instance.tutorialBoosts = true;
				tut.gotoAndStop("boosts");
			}else if (ProfileState.instance.tutorialBoosts && ProfileState.instance.currentGameState.cash.value >= 10 && ProfileState.instance.tutorialBodies == false && ProfileState.instance.stats.totalDays >= 4) {
				ProfileState.instance.tutorialBodies = true;
				tut.gotoAndStop("bodies");
			}else if (ProfileState.instance.stats.totalDays >= 7 && ProfileState.instance.tutorialBonusShop == false) {
				ProfileState.instance.tutorialBonusShop = true;
				tut.gotoAndStop("bonus");
			}else if (ProfileState.instance.tutorialBoosts && ProfileState.instance.tutorialBonusShop && ProfileState.instance.stats.totalDays>=12 && ProfileState.instance.tutorialHUD == false) {
				ProfileState.instance.tutorialHUD = true;
				tut.gotoAndStop("hud");
			}else if (ProfileState.instance.tutorialHUD && ProfileState.instance.stats.totalDays>=15 && ProfileState.instance.tutorialMusic == false) {
				ProfileState.instance.tutorialMusic = true;
				tut.gotoAndStop("music");
			}else if (ProfileState.instance.tutorialMusic && ProfileState.instance.stats.totalDays>=20 && ProfileState.instance.tutorialCustomization == false) {
				ProfileState.instance.tutorialCustomization = true;
				tut.gotoAndStop("custom");
			}else if (ProfileState.instance.currentGameState.gameMode == "Classic Mode" && ProfileState.instance.tutorialClassicHud == false) {
				ProfileState.instance.tutorialClassicHud = true;
				tut.gotoAndStop("classicHud");
			}else if (ProfileState.instance.currentGameState.gameMode == "Sandbox" && ProfileState.instance.tutorialSandbox == false) {
				ProfileState.instance.tutorialSandbox = true;
				tut.gotoAndStop("sandbox");
			}else {
				removeChild(tut);
			}
		}
			
		public function destroy():void {
			if (tut) tut.destroy();
			tut = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}