package src.shop 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import lbg.utils.StringUtils;
	import org.osflash.signals.Signal;
	import src.gui.decorators.TweenPos;
	import src.shop.UpgradeBarUI;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class UpgradeBar extends MovieClip 
	{
		public var signalSellItem:Signal = new Signal();
		public var signalCloseBar:Signal = new Signal();
		
		public var ad:MovieClip;
		public var scanlines:MovieClip;
		public var tvSweep:TvSweepEffect;
		public var btnSell:SimpleButton;
		public var btnBack:SimpleButton;
		public var penguinReflection:MovieClip;
		public var upgradeBarTarget:MovieClip;
		public var btnWatchCutscenes:SimpleButton;
		
		public var txtName:TextField;
		public var txtLevel:TextField;
		public var txtInfo:TextField;
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
		
		protected var _item:GameStateItem;
		protected var _upgradeBarUI:UpgradeBarUI;
		
		protected var _maxInfoTextHeight:Number;
		protected var _defaultInfoTextY:Number;
		protected var _defaultStat1Y:Number;
		protected var _defaultStat2Y:Number;
		protected var _defaultStat3Y:Number;
		protected var _defaultStat4Y:Number;
		protected var _defaultStat5Y:Number;
		
		protected var _defaultNameFontSize:Number;
		protected const TXTNAME_MAX_TEXTWIDTH:Number = 210;
		
		protected const X_ANIMATION_OFFSET:Number = 350;
		protected var _tween:TweenPos;
		/** Is tweening "showing", "shown", "hiding", "hidden" */
		protected var _tweening:String = "hidden";
		
		public function UpgradeBar() 
		{
			setupUpgradeBarUI();//Inside a function for easier overriding with BonusUpgradeBar
			
			scanlines.cacheAsBitmap = true;
			scanlines.mouseEnabled = scanlines.mouseChildren = false;
			tvSweep.mouseEnabled = tvSweep.mouseChildren = false;
			penguinReflection.mouseEnabled = penguinReflection.mouseChildren = false;
			
			_upgradeBarUI.x = upgradeBarTarget.x;
			_upgradeBarUI.y = upgradeBarTarget.y;
			addChild(_upgradeBarUI);
			btnSell.addEventListener(MouseEvent.ROLL_OVER, sellOver);
			btnSell.addEventListener(MouseEvent.CLICK, sellClick);
			btnBack.addEventListener(MouseEvent.CLICK, backClick);
			
			_upgradeBarUI.signalMouseOut.add(updateStats);
			_upgradeBarUI.signalPreviewLevel.add(previewStats);
			
			_maxInfoTextHeight = txtInfo.height;
			_defaultInfoTextY = txtInfo.y;
			_defaultNameFontSize = Number(txtName.defaultTextFormat.size);
			
			_defaultStat1Y = txtStat1.y;
			_defaultStat2Y = txtStat2.y;
			_defaultStat3Y = txtStat3.y;
			_defaultStat4Y = txtStat4.y;
			_defaultStat5Y = txtStat5.y;
			
			visible = false;
			btnWatchCutscenes.visible = false;
			
		}
		
		protected function setupUpgradeBarUI():void {
			_upgradeBarUI = new UpgradeBarUI(0.42, 190);
		}
		
		protected function sellOver(e:MouseEvent):void 
		{
			ShopTooltip.showGreen(btnSell, "$ " + NumberUtils.numberDelimiter(_item.totalCostAtCurrentLevel));
		}
		
		protected function sellClick(e:MouseEvent):void 
		{
			signalSellItem.dispatch();
		}
		
		protected function backClick(e:MouseEvent):void 
		{
			signalCloseBar.dispatch();
		}
		
		public function show(item:GameStateItem):void {
			if (item.name == "Empty") {
				return;
			}
			
			
			if (_tweening == "hiding" || _tweening == "hidden") {
				_tweening = "showing";
				if (_tween) _tween.destroy();
				_tween = new TweenPos(this, new Point(X_ANIMATION_OFFSET, 0), new Point( -X_ANIMATION_OFFSET, 0), 40, 0, TweenPos.EASE_OUT_QUINT);
				_tween.finishedSignal.addOnce(tweenFinished);
			}
			_item = item;
			_upgradeBarUI.setShopItem(item);
			updateStats();
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
		
		public function updateStats():void {
			if (_item == null) return;
			
			try{
				ad.gotoAndStop(_item.statSpecialIds);
			}catch (err:Error) {
				Log.log("Shop ad error: item ID [", _item.id, "] not found in labels");
				try {
					//Try right from the ID
					ad.gotoAndStop(_item.id);
				}catch (err2:Error) {
					ad.gotoAndStop(1);
				}
			}
			
			txtName.text = _item.name;
			adjustNameFontSize();
			_upgradeBarUI.updateLevel();
			
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
			
			try {
				setAndAdjustItemInfo(_item.statShopDescription);
			}catch (err:Error) {
				Log.log("No shop description for item ID [", _item.id, "]");
				setAndAdjustItemInfo("");
			}
			
			txtStat1.text = _item.entry.getDisplayStatName1();
			txtStat2.text = _item.entry.getDisplayStatName2();
			txtStat3.text = _item.entry.getDisplayStatName3();
			txtStat4.text = _item.entry.getDisplayStatName4();
			txtStat5.text = _item.entry.getDisplayStatName5();
			
			txtLevel.textColor = 0xFFFFFF;
			txtLevel.alpha = 0.6;
			txtStatValue1.textColor = 0xFFFFFF;
			txtStatValue2.textColor = 0xFFFFFF;
			txtStatValue3.textColor = 0xFFFFFF;
			txtStatValue4.textColor = 0xFFFFFF;
			txtStatValue5.textColor = 0xFFFFFF;
			
			txtStatValue1.text = _item.entry.getDisplayStatString(1, _item.level);
			txtStatValue2.text = _item.entry.getDisplayStatString(2, _item.level);
			txtStatValue3.text = _item.entry.getDisplayStatString(3, _item.level);
			txtStatValue4.text = _item.entry.getDisplayStatString(4, _item.level);
			txtStatValue5.text = _item.entry.getDisplayStatString(5, _item.level);
			
			adjustStatsPosition();
		}
		
		protected function adjustNameFontSize():void {
			var format:TextFormat = new TextFormat(null, _defaultNameFontSize * nameWidthRatio);
			//txtName.setTextFormat(format);
			
			var fontSize:Number = (txtName.getTextFormat().size == null) ? 12:(txtName.getTextFormat().size as Number);
			var fontSizeRatio:Number = fontSize / _defaultNameFontSize;
			var nameWidthRatio:Number = TXTNAME_MAX_TEXTWIDTH / txtName.textWidth;
			
			if (nameWidthRatio < (1 * fontSizeRatio)) {
				//Name is too long, scale down font
				format = new TextFormat(null, _defaultNameFontSize * nameWidthRatio);
				txtName.setTextFormat(format);
			}
		}
		
		public function previewStats(level:uint):void {
			if (_item.maxLevel <= 0) {
				txtLevel.text = "";
			}else if (level < _item.maxLevel) {
				//Normal levels
				txtLevel.text = "Level " + (level + 1);
			}else if (level == _item.maxLevel) {
				//Max level
				txtLevel.text = "Max level";
			}else {
				//Over levels
				txtLevel.text = "Max level + " + (level - _item.maxLevel).toFixed();
			}
			
			setAndAdjustItemInfo(_item.statShopDescription);
			
			txtStat1.text = _item.entry.getDisplayStatName1();
			txtStat2.text = _item.entry.getDisplayStatName2();
			txtStat3.text = _item.entry.getDisplayStatName3();
			txtStat4.text = _item.entry.getDisplayStatName4();
			txtStat5.text = _item.entry.getDisplayStatName5();
			
			var diffColor:uint = (level >= _item.level) ? 0x77FF77: 0xFF7777;
			
			txtLevel.textColor = diffColor;
			txtLevel.alpha = 1;
			
			txtStatValue1.textColor = (_item.entry.getDisplayStatString(1, level) == _item.entry.getDisplayStatString(1, _item.level)) ? 0xFFFFFF: diffColor;
			txtStatValue2.textColor = (_item.entry.getDisplayStatString(2, level) == _item.entry.getDisplayStatString(2, _item.level)) ? 0xFFFFFF: diffColor;
			txtStatValue3.textColor = (_item.entry.getDisplayStatString(3, level) == _item.entry.getDisplayStatString(3, _item.level)) ? 0xFFFFFF: diffColor;
			txtStatValue4.textColor = (_item.entry.getDisplayStatString(4, level) == _item.entry.getDisplayStatString(4, _item.level)) ? 0xFFFFFF: diffColor;
			txtStatValue5.textColor = (_item.entry.getDisplayStatString(5, level) == _item.entry.getDisplayStatString(5, _item.level)) ? 0xFFFFFF: diffColor;
			
			txtStatValue1.text = _item.entry.getDisplayStatString(1, level);
			txtStatValue2.text = _item.entry.getDisplayStatString(2, level);
			txtStatValue3.text = _item.entry.getDisplayStatString(3, level);
			txtStatValue4.text = _item.entry.getDisplayStatString(4, level);
			txtStatValue5.text = _item.entry.getDisplayStatString(5, level);
			
			adjustStatsPosition();
		}
		
		protected function setAndAdjustItemInfo(str:String):void {
			txtInfo.text = str;
			txtInfo.y = _defaultInfoTextY + ((_maxInfoTextHeight - txtInfo.textHeight) / 2);
		}
		
		protected function adjustStatsPosition():void {
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
				txtStat1.y = _defaultStat3Y
			}else {
				//No stats, don't care
			}
			
			txtStatValue1.y = txtStat1.y;
			txtStatValue2.y = txtStat2.y;
			txtStatValue3.y = txtStat3.y;
			txtStatValue4.y = txtStat4.y;
			txtStatValue5.y = txtStat5.y;
		}
		
		
		public function get signalMouseOut():Signal {
			return _upgradeBarUI.signalMouseOut;
		}
		
		public function get signalPreviewLevel():Signal {
			return _upgradeBarUI.signalPreviewLevel;
		}
		
		public function get signalPlusClick():Signal {
			return _upgradeBarUI.signalPlusClick;
		}
		
		public function get signalMinusClick():Signal {
			return _upgradeBarUI.signalMinusClick;
		}
		
		public function get shown():Boolean {
			return (_tweening == "showing" || _tweening == "shown");
		}
		
		public function get item():GameStateItem 
		{
			return _item;
		}
		
		
		public function destroy():void {
			if(signalCloseBar) signalCloseBar.removeAll();
			signalCloseBar = null;
			
			if(signalSellItem) signalSellItem.removeAll();
			signalSellItem = null;
			
			if(_tween) _tween.destroy();
			_tween = null;
			
			ad = null;
			scanlines = null;
			tvSweep = null;
			btnSell = null;
			btnBack = null;
			penguinReflection = null;
			upgradeBarTarget = null;
			btnWatchCutscenes = null;
			
			txtName = null;
			txtLevel = null;
			txtInfo = null;
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
			
			_item = null;
			if(_upgradeBarUI) _upgradeBarUI.destroy();
			_upgradeBarUI = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
	}

}