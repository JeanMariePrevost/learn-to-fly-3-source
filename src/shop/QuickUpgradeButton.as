package src.shop 
{
	import com.hybrid.ui.ToolTip;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	import src.audio.Sfx;
	import src.Main;
	import src.system.CustomizationData;
	import src.system.GameStateItem;
	import src.system.Global;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class QuickUpgradeButton extends SimpleButton 
	{
		public var upgradeSignal:Signal = new Signal();
		
		protected var _item:GameStateItem;
		
		public function QuickUpgradeButton() 
		{
			super(upState, overState, downState, hitTestState);
			
			turnOff();
			visible = false;
			
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.CLICK, onQuickUpgradeClick);
			
			Main.guiTickSignal.add(tick);
		}
		
		private function onQuickUpgradeClick(e:MouseEvent):void 
		{
			Sfx.playShopClick();
			e.stopImmediatePropagation();
			upgradeSignal.dispatch();
			ShopEngine.quickUpgradeBarCheck(_item);
			onOver(null);
		}
		
		protected function tick(delta:Number):void {
			checkVisibility(Input.instance.basicCommands.ctrl.isDown);
			//visible = !Input.instance.basicCommands.ctrl.isDown;
		}
		
		protected function onOver(e:MouseEvent):void {
			var maxLevel:int = _item.maxLevel;
			if (_item.overLevelEnabled) {
				maxLevel = _item.maxLevel + Global.OVER_LEVELS
			}
			
			if (_item.level < maxLevel) {
				var toolTipValue:Number;
				toolTipValue = _item.getCostAt(1);
				showTooltip(toolTipValue);
			}
		}
		
		protected function showTooltip(value:Number):void {
			var title:String = "Quick-upgrade";
			var message:String = NumberUtils.numberDelimiter(value);
			
			if (value <= ProfileState.instance.currentGameState.cash.value) {
				//Can afford
				ShopTooltip.show(this, title, "$" + message);
			}else {
				//Cannot afford
				ShopTooltip.showRed(this, title, "$" + message);
			}
		}
		
		public function setItem(item:GameStateItem):void {
			//trace("setItem()", item.name, item.maxLevel);
			
			_item = item;
			checkVisibility();
			checkCash(item);
		}
		
		protected function checkVisibility(hideNoMatter:Boolean = false):void {
			if (_item == null) return; 
			
			
			if (hideNoMatter || _item.maxLevel <= 0) {
				visible = false;
			}else {
				//Normal levels
				visible = true;
			}
		}
		
		protected function checkCash(item:GameStateItem):void {
			var cost:Number = item.getCostAt(1);
			if (ProfileState.instance.currentGameState.cash.value < cost) {
				turnOff();
			}else if (item.maxLevel <= 0) {
				turnOff();				
			}else {
				if(item.isMaxed) {
					//Level maxed
					turnOff();
				}else {
					//Can level up
					turnOn();
				}
			}
		}
		
		protected function turnOn():void {
			DisplayObjectUtil.setObjectSaturation(this, 1, 1);
			enabled = true;
			mouseEnabled = true;
		}
		
		protected function turnOff():void {
			DisplayObjectUtil.setObjectSaturation(this, 0, 0.8);
			enabled = false;
			//mouseEnabled = false;
		}
		
		public function destroy():void {
			Main.guiTickSignal.remove(tick);
			
			removeEventListener(MouseEvent.ROLL_OVER, onOver);
			removeEventListener(MouseEvent.CLICK, onQuickUpgradeClick);
			
			if(upgradeSignal) upgradeSignal.removeAll();
			upgradeSignal = null;
			
			if(_item) _item.destroy();
			_item = null;
		}
		
	}

}