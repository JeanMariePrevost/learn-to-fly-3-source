package src.shop.bonusshop 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.UiScaler;
	import src.audio.Sfx;
	import src.gui.decorators.TweenPos;
	import src.Main;
	import src.MedalCheck;
	import src.shop.bonusshop.Slot;
	import src.shop.ComputerOverlay;
	import src.system.GameState;
	import src.system.GameStateItem;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class BonusShopEngine extends MovieClip 
	{
		public static var playerCameFromMainMenu:Boolean = false;
		
		protected static var _instance:BonusShopEngine;
		
		protected const MARGIN_LEFT:Number = 90;
		protected const MARGIN_TOP:Number = 110;
		protected const SPACING_X:Number = 90;
		protected const SPACING_Y:Number = 95;
		
		protected const ROW_LENGTH:uint = 4;
		
		public var slots:Vector.<Slot> = new Vector.<Slot>();
		public var glassBoard:GlassBoard;
		public var baby:BonusShopBaby;
		public var bg:MovieClip;
		
		protected var _upgradeBar:BonusUpgradeBar;
		
		protected var _selectedSlot:Slot;
		
		public function BonusShopEngine() 
		{
			gotoAndStop(1);
			
			baby.mouseChildren = baby.mouseEnabled = false;
			
			_upgradeBar = new BonusUpgradeBar();
			addChild(_upgradeBar);
			_upgradeBar.hide();
			
			_upgradeBar.signalPlusClick.add(upgradeItem);
			_upgradeBar.signalMinusClick.add(downgradeItem);
			_upgradeBar.signalCloseBar.add(closeUpgradeBar);
			
			
			//Slots setup/////////////////
			var s:Slot;
			
			s = new Slot(ProfileState.instance.bonusItems.bonusMoney);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusInterest);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusLaunchPower);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusStagePower);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusBoostPower);
			slots.push(s);
			
			
			s = new Slot(ProfileState.instance.bonusItems.bonusStageFuel);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusBoostFuel);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusDrag);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusWind);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusImpact);
			slots.push(s);
			
			
			s = new Slot(ProfileState.instance.bonusItems.bonusBetterStart);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusLessObstacles);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusOverBodiesAndLaunchers);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusOverStages);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusOverBoosts);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusOver);
			slots.push(s);
			
			
			s = new Slot(ProfileState.instance.bonusItems.bonusSpeed);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusGravity);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusBpPerDay);
			slots.push(s);
			
			s = new Slot(ProfileState.instance.bonusItems.bonusVCR);
			slots.push(s);
			
			
			//////////////////////////////
			
			
			//Arange slots
			for (var i:int = 0; i < slots.length; i++) {
				var row:int = i % ROW_LENGTH;
				var column:int = Math.floor(i / ROW_LENGTH);
				
				glassBoard.addChild(slots[i]);
				slots[i].x = MARGIN_LEFT + (row * SPACING_X);
				slots[i].y = MARGIN_TOP + (column * SPACING_Y);
				
				slots[i].signalClick.add(slotClick);
			}
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			Main.instance.sysButtonsHide();
			
			TweenPos.tweenToCurrentPosition(glassBoard, new Point(0, 540), 65, 0, TweenPos.EASE_OUT_QUINT);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			
			//The sidebar moves with this screen, so adjust the offset here.
			//2nd var -720 sticks to left, 720 doubles it, 0 sticks to right
			//3rd var is as you'd expect, -to the left, + to the right 
			UiScaler.addAbsoluteManually(glassBoard, -650, 652);
			UiScaler.addAbsoluteManually(bg, -190, 70);
			UiScaler.addAbsoluteManually(baby, -75, 75);
			UiScaler.addAbsoluteManually(this, UiScaler.UNSCALED_STAGE_WIDTH, -UiScaler.UNSCALED_STAGE_WIDTH);
		}
		
		private function closeUpgradeBar():void 
		{
			_upgradeBar.hide();
			baby.toGlassBoard();
		}
		
		private function upgradeItem():void 
		{
			if (Input.instance.isKeyDown(16)) {
				for (var i:int = 0; i <= 10; i++) {
					upgradeItem2();	
				}
			}else {
				upgradeItem2();	
			}
			
			for each(var s:Slot in slots) {
				s.updateItem();
			}
			
			MedalCheck.checkAllBonus();
		}
		
		private function upgradeItem2():void 
		{
			//Everything about leveling / buying bonus shop items happens HERE
			var item:GameStateItem = _selectedSlot.item;
			var cost:Number = item.getCostAt(1);
			
			if (item.isMaxed) return;
			
			if (item.bonusUnlockedLevel > item.level) {
				cost = 0;
			}
			
			if (cost > ProfileState.instance.bonusPoints.value) {
				//Not enough points
			}else {
				if (item.bonusUnlockedLevel <= item.level) {
					//Only substract point if item level not unlocked
					ProfileState.spendBonusPoints(cost);
				}
				
				item.level += 1;
				item.bonusUnlockedLevel = Math.max(item.level, item.bonusUnlockedLevel);
				//trace("Item unlocked level:", item.bonusUnlockedLevel);
				_upgradeBar.updateStats();
			}
		
		}
		
		
		private function downgradeItem():void 
		{
			//Everything about leveling / buying bonus shop items happens HERE
			var item:GameStateItem = _selectedSlot.item;
			var cost:Number = item.getCostAt(0);
			
			if (Input.instance.isKeyDown(16)) {
				for (var i:int = 0; i <= 10; i++) {
					if (item.level<=0) {
						//Cannot downgrade
					}else{
						item.level -= 1;
						_upgradeBar.updateStats();
					}
				}
			}else {
				if (item.level<=0) {
					//Cannot downgrade
				}else{
					item.level -= 1;
					_upgradeBar.updateStats();
				}
			}
			
			for each(var s:Slot in slots) {
				s.updateItem();
			}
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			if (e.target == this || e.target == glassBoard) {
				closeUpgradeBar();
				if (_selectedSlot) _selectedSlot.isSelectedSlot = false;
			}
		}
		
		private function slotClick(s:Slot):void 
		{
			Sfx.playShopClick();
			if (_selectedSlot) _selectedSlot.isSelectedSlot = false;
			_selectedSlot = s;
			_selectedSlot.isSelectedSlot = true;
			
			//trace(s.item.id);
			_upgradeBar.show(s.item);
			baby.toUpgradeBar();
			if (getChildIndex(baby) <= getChildIndex(_upgradeBar)) {
				swapChildren(baby, _upgradeBar);
			}
			
		}
		
		public function destroy():void {
			_instance = null;
			
			if (slots) {
				for each( var i:Slot in slots) {
					i.destroy();
				}
				slots.length = 0;
			}
			slots = null;
			
			if (glassBoard) glassBoard.destroy();
			glassBoard = null;
			if (baby) baby.destroy();
			baby = null;
			if (_upgradeBar) _upgradeBar.destroy();
			_upgradeBar = null;
			
			if (_selectedSlot) _selectedSlot.destroy();
			_selectedSlot = null;
			
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
		static public function get instance():BonusShopEngine 
		{
			if (_instance == null) _instance = new BonusShopEngine();
			return _instance;
		}
		
		public static function destroy():void {
		if (_instance) _instance.destroy();	
		}
		
	}

}