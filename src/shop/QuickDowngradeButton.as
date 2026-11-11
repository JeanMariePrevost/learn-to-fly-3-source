package src.shop 
{
	import flash.events.MouseEvent;
	import lbg.utils.NumberUtils;
	import src.system.GameStateItem;
	import src.system.Input;
	/**
	 * ...
	 * @author 
	 */
	public class QuickDowngradeButton extends QuickUpgradeButton 
	{
		
		public function QuickDowngradeButton() 
		{
			super();
			
		}
		
		override protected function tick(delta:Number):void 
		{
			checkVisibility(!Input.instance.basicCommands.ctrl.isDown);
			//visible = Input.instance.basicCommands.ctrl.isDown;
		}
		
		override protected function showTooltip(value:Number):void 
		{
			var title:String = "Quick-downgrade";
			var message:String = NumberUtils.numberDelimiter(value);
			
			ShopTooltip.showGreen(this, title, "+$" + message);
		}
		
		override protected function onOver(e:MouseEvent):void 
		{
			if (_item.level >=1) {
				var toolTipValue:Number;
				toolTipValue = _item.getCostAt(0);
				showTooltip(toolTipValue);
			}
		}
		
		//override public function setItem(item:GameStateItem):void 
		//{
			//super.setItem(item);
		//}
		
		override protected function checkCash(item:GameStateItem):void 
		{
			if (item.level >= 1) {
				turnOn();
			}else {
				turnOff();
			}
		}
		
		//override protected function turnOff():void 
		//{
			//turnOn();
		//}
		
	}

}