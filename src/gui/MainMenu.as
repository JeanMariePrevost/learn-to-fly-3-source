package src.gui 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.Sfx;
	import src.gui.decorators.MouseBounce2;
	import src.gui.decorators.TweenPos;
	import src.Main;
	import src.shop.bonusshop.BonusShopEngine;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class MainMenu extends MovieClip 
	{
		public var btnPlay:SimpleButton;
		public var btnMoreGames:SimpleButton;
		public var btnBonusShop:SimpleButton;
		public var btnExtras:SimpleButton;
		public var txtVersion:TextField;
		
		protected var _controller:MainMenuController;
		protected var _deco:Vector.<MouseBounce2> = new Vector.<MouseBounce2>();
		
		protected var _buttonClicked:DisplayObject;
		
		public function MainMenu(control:MainMenuController) 
		{
			super();
			
			_controller = control;
			
			var mb:MouseBounce2;
			
			mb = new MouseBounce2(btnPlay, true);
			mb.signalClickTarget.add(onMainMenuClick);
			_deco.push(mb);
			mb = new MouseBounce2(btnMoreGames, true);
			mb.signalClickTarget.add(onQuitGameClick);
			_deco.push(mb);
			mb = new MouseBounce2(btnBonusShop, true);
			mb.signalClickTarget.add(onMainMenuClick);
			_deco.push(mb);
			mb = new MouseBounce2(btnExtras, true);
			mb.signalClickTarget.add(onMainMenuClick);
			_deco.push(mb);
			
			TweenPos.tweenToCurrentPosition(btnPlay, new Point( -409, 0), 20, 0, TweenPos.EASE_OUT_CUBIC);
			TweenPos.tweenToCurrentPosition(btnExtras, new Point( -409, 0), 20, 3, TweenPos.EASE_OUT_CUBIC);
			TweenPos.tweenToCurrentPosition(btnBonusShop, new Point( -409, 0), 20, 6, TweenPos.EASE_OUT_CUBIC);
			TweenPos.tweenToCurrentPosition(btnMoreGames, new Point( -409, 0), 20, 12, TweenPos.EASE_OUT_CUBIC);

			//btnPlay.addEventListener(MouseEvent.CLICK, onMainMenuClick);
			//btnMoreGames.addEventListener(MouseEvent.CLICK, onMainMenuClick);
			//btnBonusShop.addEventListener(MouseEvent.CLICK, onMainMenuClick);
			//btnExtras.addEventListener(MouseEvent.CLICK, onMainMenuClick);

			if (ProfileState.instance.tutorialBonusShop == false) {
				btnBonusShop.visible = false;
				MainMenuTitle.cheatUsedSignal.addOnce(unlockCheatUsed);
			}
			
			txtVersion.text = "version " + Main.VERSION;

			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			var buttonsUiScalerOffset:Number = 270;
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(btnPlay), buttonsUiScalerOffset, -buttonsUiScalerOffset);
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(btnExtras), buttonsUiScalerOffset, -buttonsUiScalerOffset);
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(btnBonusShop), buttonsUiScalerOffset, -buttonsUiScalerOffset);
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(btnMoreGames), buttonsUiScalerOffset, -buttonsUiScalerOffset);
			
		}
		
		protected function unlockCheatUsed():void {
			btnBonusShop.visible = true;
		}
		
		private function onQuitGameClick(target:DisplayObject = null):void 
		{
			Main.saveGame();
			
			var nativeApp:Object =  getDefinitionByName("flash.desktop.NativeApplication");
			nativeApp.nativeApplication.exit();
		}
		
		protected function onMainMenuClick(target:DisplayObject):void 
		{
			Sfx.playButtonClick();
			_buttonClicked = target;
			closeMenu();
		}

		public function closeMenu():void {
			
			for each(var i:MouseBounce2 in _deco) {
				i.destroy();
			}
			
			_controller.title.hide();
			
			TweenPos.tweenFromCurrentPosition(btnPlay, new Point( -409, 0), 20, 0, TweenPos.EASE_IN);
			TweenPos.tweenFromCurrentPosition(btnExtras, new Point( -409, 0), 20, 3, TweenPos.EASE_IN);
			TweenPos.tweenFromCurrentPosition(btnBonusShop, new Point( -409, 0), 20, 6, TweenPos.EASE_IN);
			TweenPos.tweenFromCurrentPosition(btnMoreGames, new Point( -409, 0), 20, 12, TweenPos.EASE_IN).finishedSignal.addOnce(menuFinished);//Listen to last tween to finish menu action
			
			btnPlay.removeEventListener(MouseEvent.CLICK, onMainMenuClick);
			btnMoreGames.removeEventListener(MouseEvent.CLICK, onQuitGameClick);
			btnBonusShop.removeEventListener(MouseEvent.CLICK, onMainMenuClick);
			btnExtras.removeEventListener(MouseEvent.CLICK, onMainMenuClick);
			
			btnPlay.enabled = false;
			btnMoreGames.enabled = false;
			btnBonusShop.enabled = false;
			btnExtras.enabled = false;
		}
		
		protected function menuFinished():void {
			switch(_buttonClicked) {
				case btnPlay:
					_controller.gotoLoadGameMenu();
					break;
				case btnMoreGames:
					var nativeApp:Object =  getDefinitionByName("flash.desktop.NativeApplication");
					nativeApp.nativeApplication.exit();
					return;
				case btnExtras:
					_controller.gotoExtras();
					break;
				case btnBonusShop:
					BonusShopEngine.playerCameFromMainMenu = true;
					Transition.transitionTo(destroy, ScreenManager.unloadAllScreens, ScreenManager.loadBonusShop);
					break;
				default:
					throw new Error("Main menu error - unknown button clicked...");
					//_controller.gotoNewGameMenu();
					break;
			}
			
			destroy();
		}
		
		public function destroy():void 
		{
			if (_deco) {
				for each(var b:MouseBounce2 in _deco) {
					b.destroy();
				}
				_deco.length = 0;
			}
			_deco = null;
			
			MainMenuTitle.cheatUsedSignal.remove(unlockCheatUsed);

			//if(btnPlay)btnPlay.removeEventListener(MouseEvent.CLICK, onMainMenuClick);
			//if(btnMoreGames)btnMoreGames.removeEventListener(MouseEvent.CLICK, onMainMenuClick);
			//if(btnBonusShop)btnBonusShop.removeEventListener(MouseEvent.CLICK, onMainMenuClick);
			//if(btnExtras)btnExtras.removeEventListener(MouseEvent.CLICK, onMainMenuClick);
			
			btnPlay = null;
			btnMoreGames = null;
			btnBonusShop = null;
			btnExtras = null;
			
			_buttonClicked = null;
			
			while (numChildren) removeChildAt(0);
			if (stage) parent.removeChild(this);
		}
		
	}

}