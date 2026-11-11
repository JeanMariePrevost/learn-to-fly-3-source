package src.cards 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.Sfx;
	import src.gui.decorators.MouseBounce2;
	import src.gui.Transition;
	import src.Main;
	import src.shop.medals.MedalInfo;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class CardBox extends MovieClip 
	{
		protected static const BASE_X:Number = 105;
		protected static const BASE_Y:Number = 175;
		protected static const SCROLL_AMOUNT:Number = 1930;
		protected static const MEDALS_SCALE:Number = 0.78;
		
		protected static var _instance:CardBox;
		
		public var backButton:SimpleButton;
		public var medalInfo:CardInfo;
		
		protected var _backButtonBounce:MouseBounce2;
		protected var _medals:CardDisplay;
		protected var _targetX:Number;
		
		public function CardBox(singleton:Enforcer) 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			///////////////////////////////
			//INIT ////////////////////////
			_medals = new CardDisplay();
			addChild(_medals.sprite);
			_medals.sprite.scaleX = _medals.sprite.scaleY = MEDALS_SCALE;
			_targetX = BASE_X;
			_medals.sprite.x = BASE_X;
			_medals.sprite.y = BASE_Y + 50;
			_backButtonBounce = new MouseBounce2(backButton);
			
			swapChildren(_medals.sprite, medalInfo);
			
			backButton.addEventListener(MouseEvent.CLICK, backClick);
			
			_medals.overSignal.add(medalOver);
			_medals.outSignal.add(medalOut);
			
			Main.unsafeTickSignal.add(tick);
			Main.instance.sysButtonsHide();
			
			//Move scroll to the right spot right away
			for (var i:int = 0; i <= 30; i++) {
				tick(1);
			}
			
			
			var btnContainer:Sprite = new Sprite();
			addChild(btnContainer);
			DisplayObjectUtil.changeContainer(backButton, btnContainer);
			UiScaler.addAbsolute(btnContainer, true);
			UiScaler.addAbsolute(medalInfo, false, 300, 35);
		}
		
		protected function medalOver(button:CardButton):void {
			medalInfo.showMedal(button);
		}
		
		protected function medalOut(button:CardButton):void {
			medalInfo.hideMedal(button);
		}
		
		private function backClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			Transition.transitionTo(destroy, ScreenManager.unloadAllScreens, ScreenManager.loadMainMenu);
		}
		
		protected function tick(delta:Number):void {
			if (!stage) return;
			_targetX = Easing.easeBothInOutQuad(Main.parentLayer.mouseX, BASE_X, NumberUtils.interpolate2( -SCROLL_AMOUNT, -SCROLL_AMOUNT + 250, UiScaler.SCREEN_WIDTH_AT_MIN_RATIO, UiScaler.SCREEN_WIDTH_AT_MAX_RATIO, UiScaler.maxWidthAtCurrentRatio), UiScaler.maxWidthAtCurrentRatio);
			_medals.sprite.x += (_targetX - _medals.sprite.x) * 0.05;
		}
		
		/** Returns singleton instance, creates one if null */
		static public function get instance():CardBox 
		{
			if (_instance == null) {
				_instance = new CardBox(new Enforcer);
			}
			
			return _instance;
		}
		
		static public function get instanceIsNull():Boolean {
			return (_instance == null);
		}
		
		public function destroy():void {
			if(medalInfo) medalInfo.destroy();
			medalInfo = null;
			
			if (backButton) backButton.removeEventListener(MouseEvent.CLICK, backClick);
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			if (_backButtonBounce) _backButtonBounce.destroy();
			_backButtonBounce = null;
			
			backButton = null;
			_instance = null;
			Main.unsafeTickSignal.remove(tick);
			
			if (_medals) _medals.destroy();
			_medals = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (stage) parent.removeChild(this);
		}
		
	}

}

class Enforcer{}