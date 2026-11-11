package src.shop.bonusshop 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import org.osflash.signals.Signal;
	import src.ScreenManager;
	import src.gui.Transition;
	import src.Main;
	import src.shop.UpgradeBar;
	import src.shop.UpgradeBarUI;
	import src.system.GameStateItem;
	
	/**
	 * Similar to UpgradeBar, but different visual AND options can be added at the bottom (e.g. turn bonus on or off, adjust bonus, trigger special function...)
	 * @author 
	 */
	public class BonusUpgradeBar extends UpgradeBar 
	{
		public function BonusUpgradeBar() 
		{
			super();
			
			btnSell.visible = false;
		}
		
		override protected function setupUpgradeBarUI():void 
		{
			//super.setupUpgradeBarUI();
			_upgradeBarUI = new BonusUpgradeBarUI(0.5, 200);
		}
		
		override protected function sellClick(e:MouseEvent):void
		{
			//Nothing, cannot sell in the bonus shop
		}
		
		override public function updateStats():void 
		{
			super.updateStats();
			
			if (_item.id == "bonusVCR" && _item.level > 0) {
				btnWatchCutscenes.visible = true;
				btnWatchCutscenes.addEventListener(MouseEvent.CLICK, onVcrClick);
			}else {
				btnWatchCutscenes.removeEventListener(MouseEvent.CLICK, onVcrClick);
				btnWatchCutscenes.visible = false;
			}
		}
		
		private function onVcrClick(e:MouseEvent):void 
		{
			if (_item.id == "bonusVCR" && _item.level > 0) {
				//trace("From upgrade bar!");
				Transition.transitionTo(BonusShopEngine.destroy, ScreenManager.loadVCR);
				if (btnWatchCutscenes) btnWatchCutscenes.removeEventListener(MouseEvent.CLICK, onVcrClick);
			}
		}
		
		override public function destroy():void 
		{
			if (btnWatchCutscenes) btnWatchCutscenes.removeEventListener(MouseEvent.CLICK, onVcrClick);
			btnWatchCutscenes = null;
			
			super.destroy();
		}
	}

}