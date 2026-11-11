package src.shop.bonusshop 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import lbg.utils.DisplayObjectUtil;
	import org.osflash.signals.Signal;
	import src.ItemIcon;
	import src.shop.ShopTooltip;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class Slot extends MovieClip 
	{
		public var maxedMc:MovieClip;
		public var slotMask:MovieClip;
		public var signalClick:Signal = new Signal(Slot);
		public var item:GameStateItem;
		
		
		protected var _icon:ItemIcon;
		protected var _mouseIsOver:Boolean = false;
		protected var _isSelectedSlot:Boolean = false;
		
		public function Slot(item:GameStateItem) 
		{
			this.item = item;
			_icon = new ItemIcon(item.id);
			_icon.mask = slotMask;
			_icon.setScale(0.8);
			addChild(_icon);
			
			updateItem();
			mouseChildren = false;
			
			addEventListener(MouseEvent.CLICK, onBonusSlotClick);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		public function updateItem():void {
			var saturation:Number = 1;
			var brightness:Number = 1;
			var tint:uint = 0xFFFFCC;
			var tintMult:Number = 0;
			
			if (item.level == 0) {
				if (item.bonusUnlockedLevel) {
					//Item owned but turned off
					saturation = 0.7;
					brightness = 0.6;
				}else {
					saturation = 0;
				}
			}else {
				saturation = 1;
				
				if (item.isMaxed || (item.level==1 && item.maxLevel == 1)) {
					if (maxedMc == null) maxedMc = new OverlayMaxed();
					if (!maxedMc.stage) addChild(maxedMc);
					maxedMc.visible = true;
				}else {
					if (maxedMc) maxedMc.visible = false;
				}
			}
			
			if (_isSelectedSlot) {
				saturation = 1;
				brightness = 1.1;
				tintMult = 0.4;
			}else if (_mouseIsOver) {
				saturation = 1;
				brightness = 1.1;
				tintMult = 0.2;
			} 
			
			DisplayObjectUtil.setObjectSaturation(this, saturation, brightness);
			DisplayObjectUtil.setObjectTint(this, tint, tintMult);
			
			if (_isSelectedSlot) {
				var f:Array = filters;
				var glow:GlowFilter = new GlowFilter(0xFFFF44, 1, 7, 7, 3, 2, false);
				f.push(glow);
				var glow:GlowFilter = new GlowFilter(0xFFFF44, 1, 25, 25, 3, 1, true);
				f.push(glow);
				filters = f;
			}
			
		}
		
		private function onBonusSlotClick(e:MouseEvent):void 
		{
			signalClick.dispatch(this);
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			ShopTooltip.show(this, item.name, item.statShopDescription);
			_mouseIsOver = true;
			updateItem();
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			_mouseIsOver = false;
			updateItem();
		}
		
		public function destroy():void {
			maxedMc = null;
			slotMask = null;
			if(signalClick) signalClick.removeAll();
			signalClick = null;
			item = null;
			_icon = null;
			removeEventListener(MouseEvent.CLICK, onBonusSlotClick);
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
		public function get isSelectedSlot():Boolean 
		{
			return _isSelectedSlot;
		}
		
		public function set isSelectedSlot(value:Boolean):void 
		{
			_isSelectedSlot = value;
			updateItem();
		}
		
	}

}