package src.shop 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	import src.UiScaler;
	import src.audio.Sfx;
	import src.compound.CompoundNumber;
	import src.game.StatHooks;
	import src.shop.QuickCopyIcon;
	import src.shop.QuickSellIcon;
	import src.Main;
	import src.reg.*;
	import src.system.GameState;
	import src.system.GameStateItem;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ShopMainScreen extends MovieClip 
	{
		public var above:MovieClip;
		public var below:MovieClip;
		
		public var txtCash:TextField;
		public var txtDay:TextField;
		public var txtBP:TextField;
		public var txtWeight:TextField;
		public var bg:MovieClip;
		public var scanlines:MovieClip;
		public var tvSweep:TvSweepEffect;
		
		public var bodyPlaceholder:MovieClip;
		public var launcherPlaceholder:MovieClip;
		public var stagePlaceholder1:MovieClip;
		public var stagePlaceholder2:MovieClip;
		public var stagePlaceholder3:MovieClip;
		public var stagePlaceholder4:MovieClip;
		public var boostPlaceholder1:MovieClip;
		public var boostPlaceholder2:MovieClip;
		public var boostPlaceholder3:MovieClip;
		public var boostPlaceholder4:MovieClip;
		
		public var bodySlot:Slot;
		public var launcherSlot:Slot;
		public var stageSlot0:Slot;
		public var stageSlot1:Slot;
		public var stageSlot2:Slot;
		public var stageSlot3:Slot;
		public var boostSlot0:Slot;
		public var boostSlot1:Slot;
		public var boostSlot2:Slot;
		public var boostSlot3:Slot;
		
		protected var _selectedSlot:Slot;
		
		public function ShopMainScreen() 
		{
			
			scanlines = above.scanlines;
			tvSweep = above.tvSweep;
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			scanlines.cacheAsBitmap = true;
			
			bodySlot = new Slot(bodyPlaceholder);
			launcherSlot = new Slot(launcherPlaceholder);
			
			stageSlot0 = new Slot(stagePlaceholder1);
			stageSlot1 = new Slot(stagePlaceholder2);
			stageSlot2 = new Slot(stagePlaceholder3);
			stageSlot3 = new Slot(stagePlaceholder4);
			
			boostSlot0 = new Slot(boostPlaceholder1);
			boostSlot1 = new Slot(boostPlaceholder2);
			boostSlot2 = new Slot(boostPlaceholder3);
			boostSlot3 = new Slot(boostPlaceholder4);
			
			loadFromState();
			
			if (ProfileState.instance.tutorialStages == false) {
				gotoAndStop(4);
				bodySlot.visible = false;
				stageSlot0.visible = false;
				stageSlot1.visible = false;
				stageSlot2.visible = false;
				stageSlot3.visible = false;
				boostSlot0.visible = false;
				boostSlot1.visible = false;
				boostSlot2.visible = false;
				boostSlot3.visible = false;
			}else if (ProfileState.instance.tutorialBoosts == false) {
				gotoAndStop(3);
				bodySlot.visible = false;
				boostSlot0.visible = false;
				boostSlot1.visible = false;
				boostSlot2.visible = false;
				boostSlot3.visible = false;
			}else if (ProfileState.instance.tutorialBodies == false) {
				gotoAndStop(2);
				bodySlot.visible = false;
			}else {
				gotoAndStop(1);
			}
			
			ShopEngine.signalSlotClick.add(onSlotClick);
			stage.addEventListener(MouseEvent.CLICK, onBgClick);
			Main.guiTickSignal.add(tickBP);
			
			UiScaler.addAbsoluteManually(above, 150, -150);
			UiScaler.addAbsoluteManually(below, 150, -150);
		}
		
		protected function tickBP(delta:Number):void {
			if (txtBP) txtBP.text = NumberUtils.numberDelimiter(ProfileState.instance.bonusPoints.value) + " BP";
		}
		
		protected function onBgClick(e:MouseEvent):void {
			//trace("onBgClick", e.stageX, Main.parentLayer.mouseX, UiScaler.maxWidthAtCurrentRatio * 0.625);
			if (Main.parentLayer.mouseX <= UiScaler.maxWidthAtCurrentRatio -280) {
				ShopEngine.gotoMenuScreen();
			}
			
		}
		
		public function previewSlots(previewLevel:int):void 
		{
			if (_selectedSlot == bodySlot) {
				var item:GameStateItem = _selectedSlot.getItem();
				
				var currentStages:int = item.getStageSlotsAt(item.level);
				var previewStages:int = item.getStageSlotsAt(previewLevel);
				
				var currentBoosts:int = item.getBoostSlotsAt(item.level);
				var previewBoosts:int = item.getBoostSlotsAt(previewLevel);
				
				var diffColor:uint;
				var low:int;
				var high:int;
				
				//Stage slots
				if (currentStages != previewStages) {
					low = Math.min(currentStages, previewStages);
					high = Math.max(currentStages, previewStages);
					diffColor = (previewStages >= currentStages) ? 0x007700: 0xFF0000;
					
					for (var i:int = low; i < high; i++) {
						DisplayObjectUtil.setObjectTint(getStageSlotByIndex(i), diffColor, 0.3);
					}
				}
				
				//Boost slots
				if (currentBoosts != previewBoosts) {
					low = Math.min(currentBoosts, previewBoosts);
					high = Math.max(currentBoosts, previewBoosts);
					diffColor = (previewBoosts >= currentBoosts) ? 0x007700: 0xFF0000;
					
					for (var i:int = low; i < high; i++) {
						DisplayObjectUtil.setObjectTint(getBoostSlotByIndex(i), diffColor, 0.3);
					}
				}
				
			}
		}
		
		public function onSlotClick(slot:Slot):void 
		{
			Sfx.playShopClick();
			_selectedSlot = slot;
			switch(slot.getItem().id) {
				case "empty":
				case "emptyBody":
				case "emptyLauncher":
				case "emptyStage":
				case "emptyBoost":
					//Slot is empty, open buyBar
					ShopEngine.gotoBuyBar(slot.getItem());
					break;
				default:
					//Slot is occupied, open upgradeBar
					ShopEngine.gotoUpgradeBar(slot.getItem());
					break;
			}
		}
		
		public function loadFromState():void {
			var gameState:GameState = ProfileState.instance.currentGameState;
			
			txtCash.text = "$ " + NumberUtils.numberDelimiter(gameState.cash.value);
			txtDay.text = "Day " + gameState.day.value.toFixed(0);
			
			var totalWeight:Number = 0;
			var weightMult:CompoundNumber = new CompoundNumber(1);
			
			bodySlot.setItem(gameState.body);
			totalWeight += gameState.body.statWeight;
			
			var bodyEntry:RegistryEntry = Registry.getEntry(gameState.body.id);
			var stageCount:uint = bodyEntry.statStageSlots.valueAt(gameState.body.level);
			var boostCount:uint = bodyEntry.statBoostSlots.valueAt(gameState.body.level);
			
			launcherSlot.setItem(gameState.launcher);
			totalWeight += gameState.launcher.statWeight;
			
			for (var i:int = 0; i <= 3; i++) {
				getStageSlotByIndex(i).setItem(gameState.stages[i]);
				
				if (i < stageCount) {
					//Slot open
					getStageSlotByIndex(i).openSlot();
					totalWeight += gameState.stages[i].statWeight;
				}else {
					//slot locked
					getStageSlotByIndex(i).lockSlot();
				}
			}
			
			for (i = 0; i <= 3; i++) {
				getBoostSlotByIndex(i).setItem(gameState.boosts[i]);
				
				if (getBoostSlotByIndex(i).isLocked == false && gameState.boosts[i].entry.id == "negativeMass") {
					weightMult.addMod2(0, gameState.boosts[i].statPower);
				}
				
				if (i < boostCount) {
					//Slot open
					getBoostSlotByIndex(i).openSlot();
					totalWeight += gameState.boosts[i].statWeight;
				}else {
					//slot locked
					getBoostSlotByIndex(i).lockSlot();
				}
			}
			
			totalWeight *= weightMult.value;
			
			totalWeight *= StatHooks.weightMult.value;
			
			totalWeight = Math.max(1, totalWeight); // Weight can never go below 1
			
			txtWeight.text = "Total weight: " + totalWeight.toFixed(1);
			
			weightMult.destroy();
			weightMult = null;
			
		}
		
		public function getSlotByItem(item:GameStateItem):Slot {
			switch(item) {
				case bodySlot.getItem():
					return bodySlot;
				case launcherSlot.getItem():
					return launcherSlot;
				case stageSlot0.getItem():
					return stageSlot0;
				case stageSlot1.getItem():
					return stageSlot1;
				case stageSlot2.getItem():
					return stageSlot2;
				case stageSlot3.getItem():
					return stageSlot3;
				case boostSlot0.getItem():
					return boostSlot0;
				case boostSlot1.getItem():
					return boostSlot1;
				case boostSlot2.getItem():
					return boostSlot2;
				case boostSlot3.getItem():
					return boostSlot3;
				default:
					throw new Error ("ShopMainScreen getSlotByItem() ERROR - could not find item in any slot");
					return null;
			}
		}
		
		public function getStageSlotByIndex(index:uint):Slot {
			switch(index) {
				case 0:
					return stageSlot0;
				case 1:
					return stageSlot1;
				case 2:
					return stageSlot2;
				case 3:
					return stageSlot3;
				default:
					throw new Error("Invalid slot index");
					return stageSlot0;
			}
		}
		
		public function getBoostSlotByIndex(index:uint):Slot {
			switch(index) {
				case 0:
					return boostSlot0;
				case 1:
					return boostSlot1;
				case 2:
					return boostSlot2;
				case 3:
					return boostSlot3;
				default:
					throw new Error("Invalid slot index");
					return boostSlot0;
			}
		}
		
		public function get selectedSlot():Slot 
		{
			return _selectedSlot;
		}
		
		public function set selectedSlot(value:Slot):void 
		{
			_selectedSlot = value;
		}
		
		public function destroy():void {
			Main.guiTickSignal.remove(tickBP);
			ShopEngine.signalSlotClick.remove(onSlotClick);
			if(stage) stage.removeEventListener(MouseEvent.CLICK, onBgClick);
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(MouseEvent.CLICK, onBgClick);
			txtCash = null;
			txtDay = null;
			txtWeight = null;
			bg = null;
			scanlines = null;
			tvSweep = null;
			
			if(bodySlot) bodySlot.destroy();
			if(launcherSlot) launcherSlot.destroy();
			if(stageSlot0) stageSlot0.destroy();
			if(stageSlot1) stageSlot1.destroy();
			if(stageSlot2) stageSlot2.destroy();
			if(stageSlot3) stageSlot3.destroy();
			if(boostSlot0) boostSlot0.destroy();
			if(boostSlot1) boostSlot1.destroy();
			if(boostSlot2) boostSlot2.destroy();
			if(boostSlot3) boostSlot3.destroy();
			
			if(_selectedSlot != null) _selectedSlot.destroy();
			_selectedSlot = null;
			
			bodySlot = null;
			launcherSlot = null;
			stageSlot0 = null;
			stageSlot1 = null;
			stageSlot2 = null;
			stageSlot3 = null;
			boostSlot0 = null;
			boostSlot1 = null;
			boostSlot2 = null;
			boostSlot3 = null;
			
			bodyPlaceholder = null;
			launcherPlaceholder = null;
			stagePlaceholder1 = null;
			stagePlaceholder2 = null;
			stagePlaceholder3 = null;
			stagePlaceholder4 = null;
			boostPlaceholder1 = null;
			boostPlaceholder2 = null;
			boostPlaceholder3 = null;
			boostPlaceholder4 = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}