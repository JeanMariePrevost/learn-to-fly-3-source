package src.gui 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.Sfx;
	import src.gui.decorators.MouseBounce2;
	import src.gui.decorators.TweenPos;
	import src.shop.medals.MedalBox;
	
	/**
	 * ...
	 * @author 
	 */
	public class ExtrasMenu extends MovieClip 
	{
		public var btnCards:SimpleButton;
		public var btnMedals:SimpleButton;
		public var btnStats:SimpleButton;
		public var btnCredits:SimpleButton;
		public var btnBack:SimpleButton;
		
		protected var _controller:MainMenuController;
		protected var _decorators:Vector.<MouseBounce2> = new Vector.<MouseBounce2>();
		protected var _buttonClicked:Object;

		public function ExtrasMenu(control:MainMenuController) 
		{
			super();
			
			_controller = control;
			
			//btnCards.cacheAsBitmap = true;
			//btnMedals.cacheAsBitmap = true;
			//btnStats.cacheAsBitmap = true;
			//btnCredits.cacheAsBitmap = true;
			//btnBack.cacheAsBitmap = true;
			
			//btnCards.enabled = false;
			//btnMedals.enabled = false;
			//btnStats.enabled = false;
			//btnCredits.enabled = false;
			//btnBack.enabled = false;

			_decorators.push(new MouseBounce2(btnCards));
			_decorators.push(new MouseBounce2(btnMedals));
			_decorators.push(new MouseBounce2(btnStats));
			//btnCards.y += 15;
			//btnMedals.y += 15;
			//btnStats.y += 15;
			//btnCredits.y -= 25;

			_decorators.push(new MouseBounce2(btnCredits));
			_decorators.push(new MouseBounce2(btnBack));
			
			TweenPos.tweenToCurrentPosition(this, new Point( 0, 540), 30, 0, TweenPos.EASE_OUT_CUBIC);
			
			btnCards.addEventListener(MouseEvent.CLICK, onCardsClick);
			btnMedals.addEventListener(MouseEvent.CLICK, onMedalsClick);
			btnStats.addEventListener(MouseEvent.CLICK, onSoLongClick);
			btnCredits.addEventListener(MouseEvent.CLICK, onCreditsClick);
			btnBack.addEventListener(MouseEvent.CLICK, btnBackClick);

			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			UiScaler.addAbsolute(this, true);
		}
		
		private function onCardsClick(e:MouseEvent):void 
		{
			_buttonClicked = btnCards;
			closeMenu();
		}
		
		private function onMedalsClick(e:MouseEvent):void 
		{
			MedalBox.playerCameFromMainMenu = true;
			_buttonClicked = btnMedals;
			closeMenu();
		}
		
		protected function onSoLongClick(e:MouseEvent):void 
		{
			_buttonClicked = e.currentTarget;
			closeMenu();
		}
		
		protected function onCreditsClick(e:MouseEvent):void 
		{
			Sfx.playButtonClick();
			Transition.transitionTo(ScreenManager.unloadAllScreens, Cutscene.playCreditsFromMenu);
		}
		
		protected function btnBackClick(e:MouseEvent):void 
		{
			Sfx.playButtonClick();
			_buttonClicked = e.currentTarget;
			closeMenu();
		}
		
		protected function closeMenu():void {
			clearListeners();
			TweenPos.tweenFromCurrentPosition(this, new Point( 0, 540), 30, 0, TweenPos.EASE_IN).finishedSignal.addOnce(finishMenu);
		}
		
		protected function clearListeners():void {
			btnCards.removeEventListener(MouseEvent.CLICK, onCardsClick);
			btnMedals.removeEventListener(MouseEvent.CLICK, onMedalsClick);
			btnStats.removeEventListener(MouseEvent.CLICK, onSoLongClick);
			btnCredits.removeEventListener(MouseEvent.CLICK, onCreditsClick);
			btnBack.removeEventListener(MouseEvent.CLICK, btnBackClick);
		}
		
		protected function finishMenu():void {
			switch(_buttonClicked) {
				case btnBack:
					_controller.gotoMainMenu();
					break;
				case btnCards:
					Transition.transitionTo(MainMenuController.destroy, ScreenManager.unloadAllScreens, ScreenManager.loadCardBox);
					break;
				case btnMedals:
					Transition.transitionTo(MainMenuController.destroy, ScreenManager.unloadAllScreens, ScreenManager.loadMedalBox);
					break;
				case btnStats:
					Transition.transitionTo(MainMenuController.destroy, ScreenManager.unloadAllScreens, ScreenManager.loadProfileStatsScreen);
					break;
			}
			destroy();
		}
		
		public function destroy():void {
			clearListeners();
			
			if (_decorators) {
				for each(var i:MouseBounce2 in _decorators) i.destroy();
				_decorators.length = 0;
			}
			_decorators = null;
			
			btnMedals = null;
			btnStats = null;
			btnCredits = null;
			btnBack = null;
			
			_controller = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}