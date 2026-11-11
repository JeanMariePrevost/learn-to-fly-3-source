package src.shop 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.Sfx;
	import src.EasterPenguin;
	import src.game.StatHooks;
	import src.gui.decorators.TweenPos;
	import src.gui.Transition;
	import src.MedalCheck;
	import src.shop.QuickCopyIcon;
	import src.shop.QuickSellIcon;
	import src.Main;
	import src.reg.*;
	import src.shop.bonusshop.BonusShopEngine;
	import src.shop.medals.MedalBox;
	import src.system.GameState;
	import src.system.GameStateItem;
	import src.system.Global;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ShopEngine extends MovieClip 
	{
		//Shop-wide signals/////
		public static var signalSlotClick:Signal = new Signal(Slot);//When a slot on screen is clicked
		public static var signalItemClick:Signal = new Signal(GameStateItem);//When an item in list is clicked
		public static var singalCashChanged:Signal = new Signal(Number);
		////////////////////////
		
		protected static var _instance:ShopEngine;
		
		public var bg:MovieClip;
		
		public var buyBar:BuyBar;//Item list sidebar
		public var upgradeBar:UpgradeBar;//Item info/upgrade sidebar
		
		public var mainScreen:ShopMainScreen;
		public var hintScreen:ShopHintScreen;
		public var menuScreen:ShopMenuScreen;
		
		protected var _quickSellIcon:QuickSellIcon;
		protected var _quickCopyIcon:QuickCopyIcon;
		
		protected var _tutorial:ShopTutorials;
		protected var _easterBaby:EasterPenguin;
		
		protected var _mouseOffsetAfterTweens:Point = new Point();
		protected var _mainScreenTweenSignal:Signal;//Used to remove listener at destroy()
		
		protected var _hintScreenOffsetX:Number = 600;
		protected var _hintScreenOffsetY:Number = 455;
		
		public function ShopEngine(displayObject:DisplayObjectContainer) 
		{
			if (_instance != null) {
				throw new Error("Multiple instances of ShopEngine");
				return;
			}
			
			_instance = this;
			
			displayObject.addChild(this);
			
			StatHooks.initHooks();
			
			//MyPlayFab.instance.login();
			
			_tutorial = new ShopTutorials();//Called first to verify if the shop has to change, like new features unlocked
			
			mainScreen = new ShopMainScreen();
			addChild(mainScreen);
			
			if (ProfileState.instance.currentGameState.gameMode == "Sandbox") {
				hintScreen = new ShopHintScreenSandbox();
			}else {
				hintScreen = new ShopHintScreen();
			}
			addChild(hintScreen);
			hintScreen.x = _hintScreenOffsetX;
			hintScreen.y = _hintScreenOffsetY;
			
			menuScreen = new ShopMenuScreen();
			addChild(menuScreen);
			
			buyBar = new BuyBar();
			addChild(buyBar);
			buyBar.hide();
			
			buyBar.signalBuyItem.add(buyItem);
			
			upgradeBar = new UpgradeBar();
			addChild(upgradeBar);
			upgradeBar.hide();
			
			upgradeBar.signalCloseBar.add(gotoMenuScreen);
			upgradeBar.signalSellItem.add(startItemSale);
			upgradeBar.signalMouseOut.add(loadFromState);
			upgradeBar.signalPreviewLevel.add(mainScreen.previewSlots);
			upgradeBar.signalPlusClick.add(upgradeItem);
			upgradeBar.signalMinusClick.add(downgradeItem);
			
			Input.esc.signalCommandDown.add(gotoMenuScreen);
			
			_quickCopyIcon = new QuickCopyIcon();
			addChild(_quickCopyIcon);
			
			_quickSellIcon = new QuickSellIcon();
			addChild(_quickSellIcon);
			
			signalSlotClick.add(mainScreen.onSlotClick);
			
			
			_mainScreenTweenSignal = TweenPos.tweenToCurrentPosition(mainScreen, new Point( -70, 35), 25, 0, TweenPos.EASE_OUT_CUBIC).finishedSignal;
			_mainScreenTweenSignal.addOnce(tweenFinished);
			
			TweenPos.tweenToCurrentPosition(hintScreen, new Point(30, 15), 25, 0, TweenPos.EASE_OUT_CUBIC);
			TweenPos.tweenToCurrentPosition(menuScreen, new Point(20, -10), 25, 0, TweenPos.EASE_OUT_CUBIC);
			
			addChild(_tutorial);
			
			BonusShopEngine.playerCameFromMainMenu = false;
			MedalBox.playerCameFromMainMenu = false;
			
			//Easter eggs
			var easterEggMult:Number = NumberUtils.interpolate2(3, 0.8, 0, 110, ProfileState.instance.stats.totalDays, 0.8, true);//The more you play, the more you see
			var easterEggOdds:Number = NumberUtils.interpolate2(0, 1, 5 * easterEggMult, 15 * easterEggMult, ProfileState.instance.daysWithoutEasterEgg);
			Log.log("Baby easter egg ->", ProfileState.instance.stats.totalDays, "days played");
			Log.log("Baby easter egg -> mult:", easterEggMult, "odds:", easterEggOdds);
			if (Math.random() <= easterEggOdds) {
				_easterBaby = new EasterPenguin();
				Main.babiesLayer.addChild(_easterBaby);
				ProfileState.instance.daysWithoutEasterEgg = 0;
			}else {
				ProfileState.instance.daysWithoutEasterEgg += 1;
			}
			
			ProfileState.instance.stats.bestCash = Math.max(ProfileState.instance.stats.bestCash, ProfileState.instance.currentGameState.cash.value);
			
			MedalCheck.checkCash(ProfileState.instance.currentGameState.cash.value);
			MedalCheck.checkCashTotal(ProfileState.instance.stats.totalCash);
			MedalCheck.checkDays(ProfileState.instance.stats.totalDays);
			MedalCheck.checkCheater(ProfileState.instance.playerCheated.value);
			MedalCheck.checkObstaclesHit(ProfileState.instance.stats.totalObstaclesHit);
			MedalCheck.checkAltitudeTotal(ProfileState.instance.stats.totalAltitude);
			MedalCheck.checkAllBonus();
			MedalCheck.checkComeBack(ProfileState.instance.realLifeDaysPlayed);
			MedalCheck.checkFlightTimeTotal(ProfileState.instance.stats.totalFlightTime);
			
			if (ProfileState.instance.medals.completionist >= 1) ProfileState.instance.addUnlockKey("dodoBody");
			
			
			ProfileState.instance.stats.fixBrokenStats();
			
			switch(ProfileState.instance.currentGameState.gameMode) {
				case "Story Mode":
					if(ProfileState.instance.currentGameState.gameCompleted.value == true) MedalCheck.checkGameModeStory();
					break;
				case "Payload Mode":
					if(ProfileState.instance.currentGameState.gameCompleted.value == true) MedalCheck.checkGameModePayload();
					break;
				case "Classic  Mode":
					if (ProfileState.instance.currentGameState.gameCompleted.value == true) {
						MedalCheck.checkChallengeClassic();
						MedalCheck.checkGameModeClassic();
					}
					break;
				case "Sandbox":
					MedalCheck.checkGameModeSandbox();
					break;
			}
			
			MedalCheck.checkCompletionist();
			
			
			//////////////////////////////////////////////////////////////////////
			//Steam Stats stuff
			//////////////////////////////////////////////////////////////////////
			


			
			//////////////////////////////////////////////////////////////////////
			//End of Steam Stats stuff
			//////////////////////////////////////////////////////////////////////
			
			
			addUiScaling();
			
		}
		
		private function addUiScaling():void 
		{
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(mainScreen), 150, -115);
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(hintScreen), _hintScreenOffsetX - 70, 80 -_hintScreenOffsetX);
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(menuScreen), 500, -475);
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(upgradeBar), 720, -720);
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(buyBar), 720, -730);
			
			//addChild(upgradeBar);
			//addChild(_tutorial);
			
			//UiScaler.addAbsoluteManually(mainScreen, 170, -160);
			//UiScaler.addAbsolute(hintScreen, false, -200);
			//UiScaler.addAbsoluteManually(menuScreen, 500, -500);
		}
		
		protected function tweenFinished():void {
			Main.unsafeTickSignal.add(tick);
			_mouseOffsetAfterTweens.x = stage.mouseX;
			_mouseOffsetAfterTweens.y = stage.mouseY;
		}
		
		protected function tick(delta:Number):void {
			if (stage == null) {
				//For some reason the signal fires even after the listener is removed, but only once
				Log.log("ShopEngine tick() warning - Ticking without stage property");
				return;
			}
			
			
			if (ProfileState.instance.optionEnableShopAnim) {
				//Shop screen movement effect
				var mX:Number = stage.mouseX - _mouseOffsetAfterTweens.x;
				var mY:Number = stage.mouseY - _mouseOffsetAfterTweens.y;
				
				var targetX:Number =  10 * (mX / 720);
				var targetY:Number =  7 * (mY / 720);
				
				mainScreen.x -= (mainScreen.x - (targetX * 0.8)) * 0.05;
				mainScreen.y -= (mainScreen.y - (targetY * 0.8)) * 0.05;
				
				hintScreen.x -= (hintScreen.x - (targetX * 1.9 + _hintScreenOffsetX)) * 0.05;
				hintScreen.y -= (hintScreen.y - (targetY * 3.1 + _hintScreenOffsetY)) * 0.05;
				
				menuScreen.x -= (menuScreen.x - (targetX * 1.5)) * 0.05;
				menuScreen.y -= (menuScreen.y - (targetY * 1.9)) * 0.05;
				
				buyBar.x -= (buyBar.x - (targetX * 0.2)) * 0.05;
				buyBar.y -= (buyBar.y - (targetY * 2.6)) * 0.05;
				
				upgradeBar.x -= (upgradeBar.x - (targetX * 1.2)) * 0.05;
				upgradeBar.y -= (upgradeBar.y - (targetY * 1.2)) * 0.05;
			}
			
			
		}
		
		public function loadFromState():void {
			mainScreen.loadFromState();
		}
		
		public function buyItem(entry:RegistryEntry, beingDuplicated:Boolean = false):void {
			
			var cost:Number = entry.statCost.valueAt(0) - mainScreen.selectedSlot.getItem().totalCostAtCurrentLevel;
			
			if (ProfileState.instance.currentGameState.cash.value >= cost) {
				ProfileState.instance.stats.totalFrequentBuyer += 1;
				ProfileState.instance.currentGameState.cash.value -= cost;
				singalCashChanged.dispatch(ProfileState.instance.currentGameState.cash.value);
				mainScreen.selectedSlot.getItem().changeItemTo(entry);
				buyBar.hide();
				upgradeBar.show(mainScreen.selectedSlot.getItem());
				loadFromState();
				doCashPopup(cost, mainScreen.selectedSlot.x + mainScreen.selectedSlot.width / 4, mainScreen.selectedSlot.y + mainScreen.selectedSlot.height / 3);
				MedalCheck.checkFrequentBuyer(ProfileState.instance.stats.totalFrequentBuyer);
				
				//If shift held down, try upgrading to max
				if (Input.instance.basicCommands.shift.isDown && beingDuplicated == false) {
					upgradeItem(mainScreen.selectedSlot);
				}
			}
			
		}
		
		//Return false if no changes were done
		public static function duplicateItem(fromSlot:Slot, toSlot:Slot):Boolean {
			if (fromSlot.getItem().type == toSlot.getItem().type) {
				var cashBefore:Number = ProfileState.instance.currentGameState.cash.value;
				
				_instance.mainScreen.selectedSlot = toSlot;
				_instance.buyItem(fromSlot.getItem().entry, true);
				
				if (toSlot.isEmpty) return false;
				
				for ( var i:int = 0; i < fromSlot.getItem().level; i++) {
					upgradeItem2(toSlot);
				}
				
				var cashAfter:Number = ProfileState.instance.currentGameState.cash.value;
				
				if (cashBefore != cashAfter) {
					doCashPopup(cashBefore - cashAfter, (toSlot.x + toSlot.width / 4), (toSlot.y + toSlot.height / 3));
					gotoUpgradeBar(toSlot.getItem());
					return true;
				}else {
					return false;
				}
				
			}
			return false;
		}
		
		public function startItemSale():void {
			//Sfx.playCoin();
			//sellItemInSlot(mainScreen.selectedSlot);
			
			loadFromState();
			buyBar.show(mainScreen.selectedSlot.getItem());
			upgradeBar.hide();
			
			ProfileState.instance.stats.bestCash = Math.max(ProfileState.instance.stats.bestCash, ProfileState.instance.currentGameState.cash.value);
			MedalCheck.checkCash(ProfileState.instance.currentGameState.cash.value);
		}
		
		public static function startItemSaleInSlot(slot:Slot):void {
			instance.mainScreen.selectedSlot = slot;
			instance.startItemSale();
		}
		
		public static function directlySellItemInSlot(slot:Slot):void {
			var newId:String;
			
			switch(slot.getItem().type) {
				case "body":
					newId = "emptyBody";
					break;
				
				case "launcher":
					newId = "emptyLauncher";
					break;
					
				case "stage":
					newId = "emptyStage";
					break;
					
				case "boost":
					newId = "emptyBoost";
					break;
					
				default:
					throw new Error("Selected slot type not found, cannot sell item");
					return;
			}
			
			var cashValue:Number = slot.getItem().totalCostAtCurrentLevel;
			ProfileState.instance.currentGameState.cash.value += cashValue;
			doCashPopup(cashValue, (slot.x + slot.width / 4), (slot.y + slot.height / 3));
			
			var entry:RegistryEntry = Registry.getEntry(newId);
			slot.getItem().changeItemTo(entry);
			_instance.loadFromState();
		}
		
		public static function upgradeItem(slot:Slot = null):void {
			if (slot == null) {
				slot = _instance.mainScreen.selectedSlot;
			}
			
			var cashBefore:Number = ProfileState.instance.currentGameState.cash.value;
			
			if (Input.instance.isKeyDown(16)) {
				//Buy till max
				for (var i:int = 0; i <= 120; i++) {
					upgradeItem2(slot);
				}
			}else {
				upgradeItem2(slot);
			}
			
			var cashAfter:Number = ProfileState.instance.currentGameState.cash.value;
			
			if (cashBefore != cashAfter) {
				doCashPopup(cashBefore - cashAfter, (slot.x + slot.width / 4), (slot.y + slot.height / 3));
			}
			
			_instance.upgradeBar.updateStats();
			_instance.loadFromState();
		}
		
		protected static function upgradeItem2(slot:Slot):void {
			var cost:Number = -slot.getItem().getCostAt(1);
			//trace("Upgrade cost:", cost);
			
			if (ProfileState.instance.currentGameState.cash.value >= Math.abs(cost)) {
				if (!slot.getItem().isMaxed) {
					ProfileState.instance.currentGameState.cash.value += cost;
					
					slot.upgradeItem(1);
					ProfileState.instance.stats.totalItemUpgrades += 1;
				}
			}
			
			MedalCheck.checkItemUpgrades();
		}
		
		public static function downgradeItem(slot:Slot = null):void {
			var cashBefore:Number = ProfileState.instance.currentGameState.cash.value;
			if (slot == null) {
				var slot:Slot = _instance.mainScreen.selectedSlot;
			}
			
			if (Input.instance.isKeyDown(16)) {
				//Downgrade to 0
				for (var i:int = 0; i <= 120; i++) {
					downgradeItem2(slot);
				}
			}else {
				downgradeItem2(slot);
			}
			
			var cashAfter:Number = ProfileState.instance.currentGameState.cash.value;
			
			if (cashBefore != cashAfter) {
				doCashPopup(cashBefore - cashAfter, (slot.x + slot.width / 4), (slot.y + slot.height / 3));
			}
			
			_instance.upgradeBar.updateStats();
			_instance.loadFromState();
			MedalCheck.checkCash(ProfileState.instance.currentGameState.cash.value);
		}
		
		protected static function downgradeItem2(slot:Slot):void {
			if (slot.getItem().level >= 1) {
				var cashValue:Number = slot.getItem().getCostAt(0);
				ProfileState.instance.currentGameState.cash.value += cashValue;
				//_instance.mainScreen.selectedSlot.upgradeItem( -1);
				slot.upgradeItem( -1);
			}
		}
		
		public static function doCashPopup(cash:Number, X:Number, Y:Number):void {
			if (cash == 0) return;
			
			var popup:CashPopup = new CashPopup(cash, X, Y);
			_instance.addChild(popup);
		}
		
		public static function gotoBuyBar(item:GameStateItem):void {
			_instance.upgradeBar.hide();
			//_instance.menuScreen.hide();
			_instance.buyBar.show(item);
		}
		
		public static function gotoUpgradeBar(item:GameStateItem):void {
			//_instance.menuScreen.hide();
			_instance.buyBar.hide();
			_instance.upgradeBar.show(item);
		}
		
		public static function gotoMenuScreen():void {
			_instance.upgradeBar.hide();
			_instance.buyBar.hide();
			_instance.menuScreen.show();
		}
		
		/** Unlike goto functions, this one goes to menu if in buy, or remains in upgrade bar */
		public static function quickUpgradeBarCheck(item:GameStateItem):void {
			if (_instance.upgradeBar.shown) {
				if (_instance.upgradeBar.item == item) {
					//Nothing do to, currently upgrading the selected item
				}else {
					_instance.mainScreen.selectedSlot = _instance.mainScreen.getSlotByItem(item);
					gotoUpgradeBar(item);
				}
			}else {
				gotoMenuScreen();
			}
		}
		
		public function destroy():void {
			if(_mainScreenTweenSignal) _mainScreenTweenSignal.removeAll();
			_mainScreenTweenSignal = null;
			Main.unsafeTickSignal.remove(tick);
			
			ShopMediator.clearAllSignals();
			
			//These 3 signals are static, remove their listeners but don't set to null
			signalSlotClick.removeAll();
			signalItemClick.removeAll();
			singalCashChanged.removeAll();
			
			Input.esc.signalCommandDown.removeAll();
			
			_instance = null;
			
			bg = null;
			
			if (_easterBaby) _easterBaby.destroy();
			_easterBaby = null;
			
			if (_tutorial) _tutorial.destroy();
			_tutorial = null;
			
			if(_quickCopyIcon) _quickCopyIcon.destroy();
			_quickCopyIcon = null;
			
			if(_quickSellIcon) _quickSellIcon.destroy();
			_quickSellIcon = null;
			
			if(buyBar) buyBar.destroy();
			buyBar = null;
			buyBar = null;
			if(upgradeBar) upgradeBar.destroy();
			upgradeBar = null;
			if(mainScreen) mainScreen.destroy();
			mainScreen = null;
			if(menuScreen) menuScreen.destroy();
			menuScreen = null;
			if(hintScreen) hintScreen.destroy();
			hintScreen = null;
			
			_mouseOffsetAfterTweens	= null;
			
			if (stage) parent.removeChild(this);
			while (numChildren >= 1) removeChildAt(0);
		}
		
		static public function get instance():ShopEngine 
		{
			if (_instance == null) {
				_instance = new ShopEngine(Main.mainLayer);
			}
			return _instance;
		}
		
		public static function destroy():void {
			if (_instance) _instance.destroy();
		}
		
		static public function get instanceIsNull():Boolean 
		{
			return _instance == null;
		}
		
	}

}