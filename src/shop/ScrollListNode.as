package src.shop 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	import src.ItemIcon;
	import src.reg.RegistryEntry;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ScrollListNode extends MovieClip
	{
		/** Signal(RegistryEntry) */
		public var signalBuyItem:Signal = new Signal(RegistryEntry);
		/** Signal(RegistryEntry) */
		public var signalMouseOver:Signal = new Signal(RegistryEntry);
		/** Signal(RegistryEntry) */
		public var signalMouseOut:Signal = new Signal(RegistryEntry);
		
		public var txtName:TextField;
		public var txtCost:TextField;
		public var iconTarget:MovieClip;
		
		protected var _icon:ItemIcon;
		protected var _entry:RegistryEntry;
		
		
		public function ScrollListNode(entry:RegistryEntry) 
		{
			_entry = entry;
			
			gotoAndStop(1);
			
			txtName.text = entry.name;
			if (entry.name.length > 13) {
				var format:TextFormat = txtName.getTextFormat();
				format.size = NumberUtils.interpolate2((format.size as Number), (format.size as Number) * 0.5, 13, 24, entry.name.length);
				txtName.setTextFormat(format);
				//trace(entry.name, " -> size =", format.size);
			}
			
			//trace("cost:", itemCost, itemCost.toFixed(), itemCost.toFixed(0));
			txtCost.text = "$ " + itemCost.toFixed();
			//txtCost.text = "$ " + entry.statCost.valueAt(0).toFixed();
			
			_icon = new ItemIcon(entry.id);
			_icon.filters = [new GlowFilter(0xEEEEEE, 1, 4, 4, 8, 1)];
			
			addChild(_icon);
			_icon.x = iconTarget.x;
			_icon.y = iconTarget.y;
			_icon.setSizeInPixels(45);
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver2);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut2);
			
			cashUpdate(ProfileState.instance.currentGameState.cash.value);
			ShopEngine.singalCashChanged.add(cashUpdate);
		}
		
		protected function get itemCost():Number {
			var cost:Number = _entry.statCost.valueAt(0);
			cost = cost - ShopEngine.instance.mainScreen.selectedSlot.getItem().totalCostAtCurrentLevel;
			return cost;
		}
		
		private function onScrollListNodeClick(e:MouseEvent):void 
		{
			signalBuyItem.dispatch(_entry);
		}
		
		private function onRollOver2(e:MouseEvent):void 
		{
			signalMouseOver.dispatch(_entry);
		}
		
		private function onRollOut2(e:MouseEvent):void 
		{
			signalMouseOut.dispatch(_entry);
		}
		
		protected function cashUpdate(cash:Number):void {
			if (cash >= itemCost) {
				//Enough money to purchase
				DisplayObjectUtil.setObjectSaturation(this, 1, 1);
				addEventListener(MouseEvent.CLICK, onScrollListNodeClick);
				addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				addEventListener(MouseEvent.ROLL_OUT, onRollOut);
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}else {
				//Insufficient money
				DisplayObjectUtil.setObjectSaturation(this, 0, 0.6);
				removeEventListener(MouseEvent.CLICK, onScrollListNodeClick);
				removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			DisplayObjectUtil.setObjectSaturation(this, 1, 1.25);
			gotoAndStop(3);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if (hitTestPoint(e.stageX, e.stageY, true)) {
				DisplayObjectUtil.setObjectSaturation(this, 1, 1.15);
				gotoAndStop(2);
			}else {
				DisplayObjectUtil.setObjectSaturation(this, 1, 1);
				gotoAndStop(1);
			}
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			DisplayObjectUtil.setObjectSaturation(this, 1, 1.15);
			gotoAndStop(2);
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			DisplayObjectUtil.setObjectSaturation(this, 1, 1);
			gotoAndStop(1);
		}
		
		
		public function destroy():void {
			removeEventListener(MouseEvent.CLICK, onScrollListNodeClick);
			removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			removeEventListener(MouseEvent.ROLL_OVER, onRollOver2);
			removeEventListener(MouseEvent.ROLL_OUT, onRollOut2);
			
			
			removeEventListener(MouseEvent.CLICK, onScrollListNodeClick);
			ShopEngine.singalCashChanged.remove(cashUpdate);
			
			if(signalBuyItem) signalBuyItem.removeAll();
			if(signalMouseOver) signalMouseOver.removeAll();
			if(signalMouseOut) signalMouseOut.removeAll();
			
			signalBuyItem = null;
			signalMouseOver = null;
			signalMouseOut = null;
			
			txtName = null;
			txtCost = null;
			
			iconTarget = null;
			
			_icon = null;
			_entry = null;
			
			if (stage) parent.removeChild(this);
			while (numChildren >= 1) removeChildAt(0);
		}
		
	}

}