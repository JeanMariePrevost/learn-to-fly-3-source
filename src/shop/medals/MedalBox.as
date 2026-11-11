package src.shop.medals 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.MedalCheck;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.Sfx;
	import src.gui.decorators.MouseBounce2;
	import src.gui.Transition;
	import src.Main;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class MedalBox extends MovieClip 
	{
		public static var playerCameFromMainMenu:Boolean = false;
		
		protected static const BASE_X:Number = 105;
		protected static const BASE_Y:Number = 175;
		protected static const SCROLL_AMOUNT:Number = 1320;
		protected static const MEDALS_SCALE:Number = 0.78;
		
		protected static var _instance:MedalBox;
		
		public var backButton:SimpleButton;
		public var medalInfo:MedalInfo;
		
		protected var _backButtonBounce:MouseBounce2;
		protected var _medals:MedalDisplay;
		protected var _targetX:Number;
		
		public function MedalBox(singleton:Enforcer) 
		{
			super();
			
			MedalCheck.checkCash(ProfileState.instance.currentGameState.cash.value);
			MedalCheck.checkCashTotal(ProfileState.instance.stats.totalCash);
			MedalCheck.checkDays(ProfileState.instance.stats.totalDays);
			MedalCheck.checkCheater(ProfileState.instance.playerCheated.value);
			MedalCheck.checkObstaclesHit(ProfileState.instance.stats.totalObstaclesHit);
			MedalCheck.checkAltitudeTotal(ProfileState.instance.stats.totalAltitude);
			MedalCheck.checkAllBonus();
			MedalCheck.checkComeBack(ProfileState.instance.realLifeDaysPlayed);
			MedalCheck.checkFlightTimeTotal(ProfileState.instance.stats.totalFlightTime);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			///////////////////////////////
			//INIT ////////////////////////
			_medals = new MedalDisplay();
			addChild(_medals.sprite);
			_medals.sprite.scaleX = _medals.sprite.scaleY = MEDALS_SCALE;
			_targetX = BASE_X;
			_medals.sprite.x = BASE_X;
			_medals.sprite.y = BASE_Y;
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
			UiScaler.addAbsolute(medalInfo, false, 300, 50);
		}
		
		protected function medalOver(button:MedalButton):void {
			medalInfo.showMedal(button);
		}
		
		protected function medalOut(button:MedalButton):void {
			medalInfo.hideMedal(button);
		}
		
		private function backClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			
			if (playerCameFromMainMenu) {
				playerCameFromMainMenu = false;
				Transition.transitionTo(destroy, ScreenManager.loadMainMenu);
			}else {
				Transition.transitionTo(destroy, ScreenManager.loadShop);
			}
		}
		
		protected function tick(delta:Number):void {
			if (!stage) return;
			_targetX = Easing.easeBothInOutQuad(Main.parentLayer.mouseX, BASE_X, NumberUtils.interpolate2( -SCROLL_AMOUNT, -SCROLL_AMOUNT + 250, UiScaler.SCREEN_WIDTH_AT_MIN_RATIO, UiScaler.SCREEN_WIDTH_AT_MAX_RATIO, UiScaler.maxWidthAtCurrentRatio), UiScaler.maxWidthAtCurrentRatio);
			//_targetX = Easing.easeBothInOutQuad(stage.mouseX, BASE_X, -SCROLL_AMOUNT, 720);
			_medals.sprite.x += (_targetX - _medals.sprite.x) * 0.05;
		}
		
		/** Returns singleton instance, creates one if null */
		static public function get instance():MedalBox 
		{
			if (_instance == null) {
				_instance = new MedalBox(new Enforcer);
			}
			
			return _instance;
		}
		
		public static function destroy():void {
		if (_instance) _instance.destroy();	
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