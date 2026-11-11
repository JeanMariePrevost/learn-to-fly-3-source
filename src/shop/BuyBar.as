package src.shop 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import org.osflash.signals.Signal;
	import src.gui.decorators.TweenPos;
	import src.reg.Registry;
	import src.reg.RegistryEntry;
	import src.system.GameStateItem;
	/**
	 * ...
	 * @author 
	 */
	public class BuyBar extends MovieClip
	{
		public var ad:MovieClip;
		public var scanlines:MovieClip;
		public var tvSweep:TvSweepEffect
		public var listMask:MovieClip;
		public var sortButton:SortButton;
		public var listTarget:MovieClip;
		
		public var txtStat1:TextField;
		public var txtStat2:TextField;
		public var txtStat3:TextField;
		public var txtStat4:TextField;
		public var txtStat5:TextField;
		public var txtStatValue1:TextField;
		public var txtStatValue2:TextField;
		public var txtStatValue3:TextField;
		public var txtStatValue4:TextField;
		public var txtStatValue5:TextField;
		
		protected var _defaultStat1Y:Number;
		protected var _defaultStat2Y:Number;
		protected var _defaultStat3Y:Number;
		protected var _defaultStat4Y:Number;
		protected var _defaultStat5Y:Number;
		
		protected const X_ANIMATION_OFFSET:Number = 350;
		
		protected var _scrollList:ScrollList;
		protected var _tween:TweenPos;
		/** Is tweening "showing", "shown", "hiding", "hidden" */
		protected var _tweening:String = "hidden";
		
		public function BuyBar() 
		{
			scanlines.cacheAsBitmap = true;
			
			sortButton = new SortButton();
			addChild(sortButton);
			sortButton.x = listTarget.x;
			sortButton.y = listTarget.y - 112;
			
			_scrollList = new ScrollList(listMask);
			addChild(_scrollList);
			_scrollList.x = listTarget.x;
			_scrollList.y = listTarget.y;
			
			_scrollList.signalMouseOver.add(onSlotOver);
			_scrollList.signalMouseOut.add(onSlotOut);
			
			_defaultStat1Y = txtStat1.y;
			_defaultStat2Y = txtStat2.y;
			_defaultStat3Y = txtStat3.y;
			_defaultStat4Y = txtStat4.y;
			_defaultStat5Y = txtStat5.y;
			
			txtStat1.text = "";
			txtStat2.text = "";
			txtStat3.text = "";
			txtStat4.text = "";
			txtStat5.text = "";
			txtStatValue1.text = "";
			txtStatValue2.text = "";
			txtStatValue3.text = "";
			txtStatValue4.text = "";
			txtStatValue5.text = "";
		
		
			sortButton.addEventListener(Event.CHANGE, _scrollList.updateSortMethod);
			visible = false;
		}
		
		public function show(item:GameStateItem):void {
			if (_tweening == "hiding" || _tweening == "hidden") {
				_tweening = "showing";
				if (_tween) _tween.destroy();
				_tween = new TweenPos(this, new Point(X_ANIMATION_OFFSET, 0), new Point( -X_ANIMATION_OFFSET, 0), 40, 0, TweenPos.EASE_OUT_QUINT);
				_tween.finishedSignal.addOnce(tweenFinished);
			}
			var entry:RegistryEntry = Registry.getEntry(item.id);
			_scrollList.loadItemList(entry.type);
			visible = true;
			
		}
		
		public function hide():void {
			if (_tweening == "showing" || _tweening == "shown") {
				_tweening = "hiding";
				if (_tween) _tween.destroy();
				_tween = new TweenPos(this, new Point(0, 0), new Point(X_ANIMATION_OFFSET, 0), 40, 0, TweenPos.EASE_OUT_QUINT);
				_tween.finishedSignal.addOnce(tweenFinished);
			}
		}
		
		protected function tweenFinished():void {
			if (_tweening == "hiding") {
				visible = false;
				_tweening = "hidden";
			}else {
				_tweening = "shown";
			}
			
		}
		
		protected function onSlotOver(nodeEntry:RegistryEntry):void {
			updateStatsTexts(nodeEntry);
		}
		
		protected function onSlotOut(node:RegistryEntry):void {
			updateStatsTexts(null);
		}
		
		public function updateStatsTexts(entry:RegistryEntry):void {
			if (entry == null) {
				txtStat1.text = "";
				txtStat2.text = "";
				txtStat3.text = "";
				txtStat4.text = "";
				txtStat5.text = "";
				txtStatValue1.text = "";
				txtStatValue2.text = "";
				txtStatValue3.text = "";
				txtStatValue4.text = "";
				txtStatValue5.text = "";
			}else {
				txtStat1.text = entry.getDisplayStatName1();
				txtStat2.text = entry.getDisplayStatName2();
				txtStat3.text = entry.getDisplayStatName3();
				txtStat4.text = entry.getDisplayStatName4();
				txtStat5.text = entry.getDisplayStatName5();
				
				var selectedSlotEntry:RegistryEntry = ShopEngine.instance.mainScreen.selectedSlot.getItem().entry;
				var selectedSlotLevel:Number = ShopEngine.instance.mainScreen.selectedSlot.getItem().level;
				var value1:Number = Number(entry.getDisplayStatString(1, 0)) - Number(selectedSlotEntry.getDisplayStatString(1, selectedSlotLevel));
				var value2:Number = Number(entry.getDisplayStatString(2, 0)) - Number(selectedSlotEntry.getDisplayStatString(2, selectedSlotLevel));
				var value3:Number = Number(entry.getDisplayStatString(3, 0)) - Number(selectedSlotEntry.getDisplayStatString(3, selectedSlotLevel));
				var value4:Number = Number(entry.getDisplayStatString(4, 0)) - Number(selectedSlotEntry.getDisplayStatString(4, selectedSlotLevel));
				var value5:Number = Number(entry.getDisplayStatString(5, 0)) - Number(selectedSlotEntry.getDisplayStatString(5, selectedSlotLevel));
				
				
				txtStatValue1.text = entry.getDisplayStatString(1, 0);
				txtStatValue2.text = entry.getDisplayStatString(2, 0);
				txtStatValue3.text = entry.getDisplayStatString(3, 0);
				txtStatValue4.text = entry.getDisplayStatString(4, 0);
				txtStatValue5.text = entry.getDisplayStatString(5, 0);
				
				if (txtStat5.text != "") {
					//5 slots full
					txtStat1.y = _defaultStat1Y;
					txtStat2.y = _defaultStat2Y;
					txtStat3.y = _defaultStat3Y;
					txtStat4.y = _defaultStat4Y;
					txtStat5.y = _defaultStat5Y;
				}else if (txtStat4.text != "") {
					//4 stats
					txtStat1.y = (_defaultStat1Y + _defaultStat2Y) / 2;
					txtStat2.y = (_defaultStat2Y + _defaultStat3Y) / 2;
					txtStat3.y = (_defaultStat3Y + _defaultStat4Y) / 2;
					txtStat4.y = (_defaultStat4Y + _defaultStat5Y) / 2;
				}else if (txtStat3.text != "") {
					//3 stats
					txtStat1.y = _defaultStat2Y;
					txtStat2.y = _defaultStat3Y;
					txtStat3.y = _defaultStat4Y;
				}else if (txtStat2.text != "") {
					//2 stats
					txtStat1.y = (_defaultStat2Y + _defaultStat3Y) / 2;
					txtStat2.y = (_defaultStat3Y + _defaultStat4Y) / 2;
				}else if (txtStat1.text != "") {
					//1 stat
					txtStat1.y = _defaultStat3Y;
				}else {
					//No stats, don't care
				}
				
				txtStatValue1.y = txtStat1.y;
				txtStatValue2.y = txtStat2.y;
				txtStatValue3.y = txtStat3.y;
				txtStatValue4.y = txtStat4.y;
				txtStatValue5.y = txtStat5.y;
			}
		}
		
		public function get signalBuyItem():Signal {
			return _scrollList.signalBuyItem;
		}
		
		public function destroy():void {
			txtStat1 = null;
			txtStat2 = null;
			txtStat3 = null;
			txtStat4 = null;
			txtStat5 = null;
			txtStatValue1 = null;
			txtStatValue2 = null;
			txtStatValue3 = null;
			txtStatValue4 = null;
			txtStatValue5 = null;
			
			ad = null;
			scanlines = null;
			tvSweep = null;
			listMask = null;
			if (sortButton) sortButton.destroy();
			sortButton = null;
			_scrollList.destroy();
			_scrollList = null;
			listTarget = null
			
			if (_tween) _tween.destroy();
			_tween = null;
			
			if (stage) parent.removeChild(this);
		}
		
		
		
	}

}