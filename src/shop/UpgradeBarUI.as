package  src.shop
{
	import com.hybrid.ui.ToolTip;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	import src.audio.Sfx;
	import src.reg.Registry;
	import src.system.GameStateItem;
	import src.system.Global;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author LightBringer
	 */
	public class UpgradeBarUI extends MovieClip
	{
		public var signalMouseOut:Signal = new Signal();
		public var signalPreviewLevel:Signal = new Signal(uint);
		public var signalPlusClick:Signal = new Signal();
		public var signalMinusClick:Signal = new Signal();
		
		public var bar:MovieClip;
		public var barOver:MovieClip;
		public var barBonus:MovieClip;//bar for bonus owned levels
		public var barOverBonus:MovieClip;//bar for bonus owned levels
		public var divisions:MovieClip;
		public var minusButton:SimpleButton;
		public var plusButton:SimpleButton;
		public var minusDisabled:MovieClip;
		public var plusDisabled:MovieClip;
		
		protected var _shopItem:GameStateItem;
		
		
		
		public function UpgradeBarUI(scale:Number = 1, length:Number = 300) 
		{
			divisions.gotoAndStop(1);
			bar.gotoAndStop(1);
			barOver.gotoAndStop(1);
			barBonus.gotoAndStop(1);
			barOverBonus.gotoAndStop(1);
			barBonus.visible = false;
			barOverBonus.visible = false;
			
			barOverBonus.gotoAndStop(1);
			minusDisabled.gotoAndStop(1);
			plusDisabled.gotoAndStop(1);
			//x = X;
			//y = Y;
			minusButton.scaleX = minusButton.scaleY = minusDisabled.scaleX = minusDisabled.scaleY = scale;
			plusButton.scaleX = plusButton.scaleY = plusDisabled.scaleX = plusDisabled.scaleY = scale;
			plusButton.x = plusDisabled.x = length;
			
			bar.scaleX = bar.scaleY = scale;
			barOver.scaleX = barOver.scaleY = scale;
			barBonus.scaleX = barBonus.scaleY = scale;
			barOverBonus.scaleX = barOverBonus.scaleY = scale;
			
			bar.width = length * 2;//times 2 because of masked portion which makes it twice as long
			barOver.width = length * 2;//times 2 because of masked portion which makes it twice as long
			barBonus.width = length * 2;//times 2 because of masked portion which makes it twice as long
			barOverBonus.width = length * 2;//times 2 because of masked portion which makes it twice as long
			
			divisions.scaleX = divisions.scaleY = scale;
			divisions.width = length;
			
			minusButton.addEventListener(MouseEvent.MOUSE_OVER, minusOver);
			minusButton.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			minusButton.addEventListener(MouseEvent.CLICK, minusClick);
			
			plusButton.addEventListener(MouseEvent.MOUSE_OVER, plusOver);
			plusButton.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			plusButton.addEventListener(MouseEvent.CLICK, plusClick);
			
			plusDisabled.addEventListener(MouseEvent.MOUSE_OVER, plusOver);
			plusDisabled.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			
		}
		
		protected function mouseOut(e:MouseEvent):void 
		{
			signalMouseOut.dispatch();
		}
		
		/** Set an item to use as reference for levels and costs*/
		public function setShopItem(item:GameStateItem):void {
			_shopItem = item;
			//trace("Max level:",item.entryOf.maxLevel);
			if (item.maxLevel <= 0) {
				//Item has no levels
				visible = false;
			}else {
				visible = true;
			}
			updateLevel();
		}
		
		protected function minusOver(e:MouseEvent):void {
			if (_shopItem.level <= 0) return;
			
			var toolTipValue:Number;
			
			if (_shopItem.type == Registry.TYPE_BONUS) {
				//No selling for bonus items
				toolTipValue = 0;
			}else {
				toolTipValue = (-_shopItem.getCostAt(0));
			}
			showTooltip(toolTipValue);
			
			signalPreviewLevel.dispatch(_shopItem.level - 1);
		}
		
		protected function plusOver(e:MouseEvent):void {
			var maxLevel:int = _shopItem.maxLevel;
			
			if (_shopItem.bonusUnlockedLevel > _shopItem.level) {
				//Item level already unlocked, free to upgrade (bonus shop items)
				showTooltip(0);
				signalPreviewLevel.dispatch(_shopItem.level + 1);
			}else {
				if (_shopItem.level < (_shopItem.maxLevel + _shopItem.overLevelsAvailable)) {
					var toolTipValue:Number;
					toolTipValue = _shopItem.getCostAt(1);
					showTooltip(toolTipValue);
					
					signalPreviewLevel.dispatch(_shopItem.level + 1);
				}
			}
		}
		
		protected function showTooltip(value:Number):void {
			var title:String = NumberUtils.numberDelimiter(value);
			
			if (value >= 0) {
				//buying
				if (value <= ProfileState.instance.currentGameState.cash.value) {
					//Can afford
					ShopTooltip.show(this, "$" + title);
				}else {
					//Cannot afford
					ShopTooltip.showRed(this, "$" + title);
				}
			}else {
				//selling
				ShopTooltip.showGreen(this, "+$" + title.replace("-", ""));
			}
		}
		
		public function setEnable(minus:Boolean = true, plus:Boolean = true):void {
			if (minus) {
				minusButton.visible = true;
				minusButton.enabled = true;
				minusDisabled.visible = false;
			}else {
				minusButton.visible = false;
				minusButton.enabled = false;
				minusDisabled.visible = true;
			}
			if(plus){
				plusButton.visible = true;
				plusButton.enabled = true;
				plusDisabled.visible = false;
			}else {
				plusButton.visible = false;
				plusButton.enabled = false;
				plusDisabled.visible = true;
			}
		}
		
		protected function plusClick(e:MouseEvent):void {
			Sfx.playShopClick();
			signalPlusClick.dispatch();
			updateLevel();
			ShopTooltip.hideAll();
			plusOver(e);
		}
		
		protected function minusClick(e:MouseEvent):void {
			Sfx.playShopClick();
			signalMinusClick.dispatch();
			updateLevel();
			minusOver(e);
		}
		
		public function updateLevel():void {
			divisions.gotoAndStop(Math.max(1, _shopItem.maxLevel));
			if (_shopItem.level == 0) {
				bar.gotoAndStop(1);
				barOver.visible = false;
			}else if (_shopItem.level > _shopItem.maxLevel) {
				//Overleveled
				bar.gotoAndStop(bar.totalFrames);
				barOver.visible = true;
				barOver.gotoAndStop(Math.ceil(barOver.totalFrames * ((_shopItem.level - _shopItem.maxLevel) / _shopItem.overLevelsAvailable)));
			}else{
				bar.gotoAndStop(Math.ceil(bar.totalFrames * (_shopItem.level / _shopItem.maxLevel)));
				barOver.visible = false;
			}
			checkButtons();
			//trace(_shopItem.level);
		}
		
		protected function checkButtons():void {
			if (_shopItem.level == 0) {
				//Cannot level down
				if (_shopItem.level == _shopItem.maxLevel) {
					//Non-upgradable item
					setEnable(false, false);
				}else {
					if (_shopItem.getCostAt(1) <= ProfileState.instance.currentGameState.cash.value) {
						//Can afford
						setEnable(false, true);
					}else {
						//Cannot afford
						setEnable(false, false);
					}
				}
			}else {
				if (_shopItem.level >= _shopItem.maxLevel) {
					//Max level reached, over-level enabled?
					if (_shopItem.overLevelEnabled && _shopItem.level < (_shopItem.maxLevel + _shopItem.overLevelsAvailable)) {
						if (_shopItem.getCostAt(1) <= ProfileState.instance.currentGameState.cash.value) {
							//Can afford upgrade
							setEnable(true, true);
						}else {
							//Cannot afford upgrade
							setEnable(true, false);
						}
					}else {
						setEnable(true, false);
					}
				}else {
					if (_shopItem.getCostAt(1) <= ProfileState.instance.currentGameState.cash.value) {
						//Can afford upgrade
						setEnable(true, true);
					}else {
						//Cannot afford upgrade
						setEnable(true, false);
					}
				}
			}
		}
		
		
		
		public function destroy():void {
			plusButton.removeEventListener(MouseEvent.MOUSE_OVER, plusOver);
			plusButton.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			plusButton.removeEventListener(MouseEvent.CLICK, plusClick);
			
			minusButton.removeEventListener(MouseEvent.MOUSE_OVER, minusOver);
			minusButton.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			minusButton.removeEventListener(MouseEvent.CLICK, minusClick);
			
			plusDisabled.removeEventListener(MouseEvent.MOUSE_OVER, plusOver);
			plusDisabled.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			
			signalMouseOut.removeAll();
			signalMouseOut = null;
			signalPreviewLevel.removeAll();
			signalPreviewLevel = null;
			signalPlusClick.removeAll();
			signalPlusClick = null;
			signalMinusClick.removeAll();
			signalMinusClick = null;
			
			bar = null;
			barOver = null;
			barBonus = null;
			barOverBonus = null;
			divisions = null;
			minusButton = null;
			plusButton = null;
			minusDisabled = null;
			plusDisabled = null;
			if(_shopItem) _shopItem.destroy();
			_shopItem = null;
			
			while (numChildren != 0) removeChildAt(0);
			if (stage) parent.removeChild(this);
		}
		
	}

}