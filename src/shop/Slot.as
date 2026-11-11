package src.shop 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.audio.Sfx;
	import src.ItemIcon;
	import src.reg.*;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class Slot extends MovieClip 
	{
		public var quickUpgradeBtn:QuickUpgradeButton;
		public var quickDowngradeBtn:QuickUpgradeButton;
		public var box:MovieClip;
		public var highlight:MovieClip;
		public var txtName:TextField;
		public var txtLevel:TextField;
		public var hitBox:MovieClip;
		
		
		protected var _item:GameStateItem;
		protected var _storedPosition:Point;
		
		protected var icon:ItemIcon;
		protected var _locked:Boolean = false;
		protected var _mouseOverThis:Boolean = false;
		
		protected var _quickSellDoubleClickTimer:Number = 0;//Used to detect double clicks
		
		public function Slot(placeholder:DisplayObjectContainer) 
		{
			_storedPosition = new Point();
			if(placeholder != null){
				placeholder.parent.addChild(this);
				x = _storedPosition.x = placeholder.x;
				y = _storedPosition.y = placeholder.y;
				scaleX = placeholder.scaleX;
				scaleY = placeholder.scaleY;
				rotation = placeholder.rotation;
				
				placeholder.parent.removeChild(placeholder);
			}else {
				//Object is created, but not placed nor scaled
			}
			
			hitBox.alpha = 0.0001;
			
			highlight.alpha = 0.2;
			
			hitBox.addEventListener(MouseEvent.CLICK, onShopSlotClick, false, 1);
			hitBox.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			hitBox.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			hitBox.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			quickUpgradeBtn.upgradeSignal.add(quickUpgrade);
			quickDowngradeBtn.upgradeSignal.add(quickDowngrade);
			
			Input.instance.basicCommands.ctrl.signalCommandDown.add(showQuickSellTooltip);
			Input.instance.basicCommands.ctrl.signalCommandUp.add(hideQuickSellTooltip);
			
		}
		
		protected function quickUpgrade():void {
			ShopEngine.upgradeItem(this);
		}
		
		protected function quickDowngrade():void {
			ShopEngine.downgradeItem(this);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			//if (_locked) return;
			if(_item.type == Registry.TYPE_BOOST || _item.type == Registry.TYPE_STAGE){
				var p:Point = new Point(e.stageX, e.stageY);
				p = parent.globalToLocal(p);
				
				//var p:Point = new Point(box.x, box.y);
				//p = DisplayObjectUtil.localToLocal(p, this, parent);
				new SlotDragArrow(this, this.parent, p.x, p.y);
			}
		}
		
		protected function showQuickSellTooltip():void {
			if (quickUpgradeBtn.getRect(this).contains(mouseX, mouseY)) {
				//Hovering quick btn, don't show tooltip
			}else {
				if(_mouseOverThis) ShopTooltip.showGreen(hitBox, "+$ " + NumberUtils.numberDelimiter(_item.totalCostAtCurrentLevel));
			}
		}
		
		protected function hideQuickSellTooltip():void {
			if (_mouseOverThis) ShopTooltip.hideAll();
		}
		
		protected function setUpgradeBarLevel(ratio:Number):void {
			var frame:Number = Math.ceil(ratio * box.totalFrames);
			box.gotoAndStop(frame);
		}
		
		private function onShopSlotClick(e:MouseEvent):void 
		{
			//trace("Slot clicked");
			if (e.ctrlKey && !e.shiftKey) {
				if (getTimer() - _quickSellDoubleClickTimer <= 500) {
					//Double click, sell directly
					Sfx.playCash();
					_quickSellDoubleClickTimer = 0;
					ShopEngine.directlySellItemInSlot(this);
					e.stopImmediatePropagation();
					e.stopPropagation();
					ShopEngine.signalSlotClick.dispatch(this);
				}else {
					//Open sell shop
					_quickSellDoubleClickTimer = getTimer();
					ShopEngine.startItemSaleInSlot(this);
					e.stopImmediatePropagation();
					e.stopPropagation();
				}
				
			}else if (isLocked && isEmpty) {
				//Don't open shop on locked empty slot
			}else {
				ShopEngine.signalSlotClick.dispatch(this);
				_quickSellDoubleClickTimer = 0;
				e.stopPropagation();
			}
			
			
			
			//trace("slot X:", x, _storedPosition.x);
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			highlight.alpha = 1;
			ShopMediator.slotOverSignal.dispatch(this);
			_mouseOverThis = true;
			if (Input.instance.basicCommands.ctrl.isDown) showQuickSellTooltip();
			//trace("Over slot:", this);
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			highlight.alpha = 0.2;
			ShopMediator.slotOutSignal.dispatch(this);
			_mouseOverThis = false;
			//trace("Out slot:", this);
		}
		
		public function setItem(item:GameStateItem):void {
			_item = item;
			txtName.text = _item.name;
			updateLevel();
			
			try {
				setIcon(item.statSpecialIds);
			}catch (err:Error){
				Log.log("Icon for ID [", item.statSpecialIds, "] not found in labels");
				try {
					setIcon(item.id);
				}catch (err2:Error) {
					icon.gotoAndStop(1);
				}
			}
		}
		
		public function getItem():GameStateItem {
			return _item;
		}
		
		public function upgradeItem(byLevels:int):void {
			_item.level += byLevels;
			updateLevel();
		}
		
		protected function setIcon(id:String):void {
			if (icon == null) {
				icon = new ItemIcon();
				icon.filters = [new GlowFilter(0xEEEEEE, 1, 4, 4, 8, 1)];
				box.addChild(icon);
			}
			icon.gotoAndStop(id);
			icon.setScale(0.6);
		}
		
		public function lockSlot():void {
			_locked = true;
			_item.locked = true;
			DisplayObjectUtil.setObjectSaturation(this, 0.3, 0.5);
			DisplayObjectUtil.setObjectTint(this, 0, 0);
			txtName.text = " - Locked -";
		}
		
		public function openSlot():void {
			_locked = false;
			_item.locked = false;
			DisplayObjectUtil.setObjectSaturation(this, 1, 1);
			DisplayObjectUtil.setObjectTint(this, 0, 0);
		}
		
		protected function updateLevel():void {
			setUpgradeBarLevel(_item.level / Math.max(1, _item.maxLevel));
			quickUpgradeBtn.setItem(_item);
			quickDowngradeBtn.setItem(_item);
			
			if (_item.maxLevel <= 0) {
				txtLevel.text = "";
			}else if (_item.level < _item.maxLevel) {
				//Normal levels
				txtLevel.text = "Level " + (_item.level + 1);
			}else if (_item.level == _item.maxLevel) {
				//Max level
				txtLevel.text = "Max level";
			}else {
				//Over levels
				txtLevel.text = "Max level + " + (_item.level - _item.maxLevel);
			}
		}
		
		public function get isEmpty():Boolean {
			if (_item.id == "emptyBody" || _item.id == "emptyLauncher" || _item.id == "emptyStage" || _item.id == "emptyBoost") {
				return true;
			}else {
				return false;
			}
		}
		
		public function get isLocked():Boolean 
		{
			return _locked;
		}
		
		public function destroy():void {
			if (hitBox) {
				hitBox.removeEventListener(MouseEvent.CLICK, onShopSlotClick, false);
				hitBox.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				hitBox.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				hitBox.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			hitBox = null;
			
			Input.instance.basicCommands.ctrl.signalCommandDown.remove(showQuickSellTooltip);
			Input.instance.basicCommands.ctrl.signalCommandUp.remove(hideQuickSellTooltip);
			
			if (quickUpgradeBtn) quickUpgradeBtn.destroy();
			quickUpgradeBtn = null;
			
			if (quickDowngradeBtn) quickDowngradeBtn.destroy();
			quickDowngradeBtn = null;
			
			box = null;
			highlight = null;
			txtName = null;
			txtLevel = null;
			
			_storedPosition = null;
			
			if(_item) _item.destroy();
			_item = null;
			
			icon = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}