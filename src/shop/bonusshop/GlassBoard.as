package src.shop.bonusshop 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import lbg.anticheatengine.SafeNumber;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.ScreenManager;
	import src.audio.Sfx;
	import src.gui.Transition;
	import src.Main;
	import src.gui.decorators.MouseBounce2;
	import src.system.ProfileState;
	import src.system.SaveLoadModule;
	
	/**
	 * ...
	 * @author 
	 */
	public class GlassBoard extends MovieClip 
	{
		public var bpBar:BPBar;
		public var btnBack:SimpleButton;
		
		public function GlassBoard() 
		{
			super();
			
			btnBack.addEventListener(MouseEvent.CLICK, onBackClick);
		}
		
		protected function onBackClick(e:Event):void {
			Sfx.playMediumClick();
			Main.saveGame();
			
			if (BonusShopEngine.playerCameFromMainMenu) {
				BonusShopEngine.playerCameFromMainMenu = false;
				Transition.transitionTo(BonusShopEngine.destroy, ScreenManager.unloadAllScreens, ScreenManager.loadMainMenu);
			}else {
				Transition.transitionTo(BonusShopEngine.destroy, ScreenManager.loadShop);
			}
		}
		
		public function destroy():void {
			btnBack.removeEventListener(MouseEvent.CLICK, onBackClick);
			
			btnBack = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}