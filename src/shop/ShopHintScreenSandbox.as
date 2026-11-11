package src.shop 
{
	import flash.events.MouseEvent;
	import lbg.anticheatengine.SafeNumber;
	import lbg.utils.DisplayObjectUtil;
	import src.ScreenManager;
	import src.gui.Transition;
	import src.Main;
	/**
	 * ...
	 * @author 
	 */
	public class ShopHintScreenSandbox extends ShopHintScreen 
	{
		
		public function ShopHintScreenSandbox() 
		{
			super();
			
			//tipWidget = null;
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.CLICK, onSandboxClick);
		}
		
		override protected function init():void 
		{
			scanlines.cacheAsBitmap = true;
			scanlines.mouseEnabled = scanlines.mouseChildren = false;
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			DisplayObjectUtil.setObjectTint(this, 0xFFFFFF, 0.15);
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			DisplayObjectUtil.setObjectTint(this, 0xFFFFFF, 0);
		}
		
		private function onSandboxClick(e:MouseEvent):void 
		{
			Transition.transitionTo(ScreenManager.unloadShop, ScreenManager.loadSandBoxScreen);
		}
		
	}

}