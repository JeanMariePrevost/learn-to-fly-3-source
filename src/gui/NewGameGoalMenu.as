package src.gui 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.UiScaler;
	import src.audio.Sfx;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	import src.gui.decorators.TweenPos;
	import src.Main;
	import src.system.GameState;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class NewGameGoalMenu extends MovieClip 
	{
		public var btnGoal1:NewGameGoalButton;
		public var btnGoal2:NewGameGoalButton;
		public var btnGoal3:NewGameGoalButton;
		public var btnGoal4:NewGameGoalButton;
		public var btnBack:SimpleButton;
		
		protected var _controller:MainMenuController;
		protected var _buttonClicked:Object;
		protected var _backDeco:MouseBounce2;
		
		public function NewGameGoalMenu(control:MainMenuController) 
		{
			super();
			
			_controller = control;
			
			btnGoal1.txtLabel.text = NumberUtils.numberDelimiter(Global.SPACE_ALTITUDE1) + " (default)";
			btnGoal2.txtLabel.text = NumberUtils.numberDelimiter(Global.SPACE_ALTITUDE2);
			btnGoal3.txtLabel.text = NumberUtils.numberDelimiter(Global.SPACE_ALTITUDE3);
			btnGoal4.txtLabel.text = NumberUtils.numberDelimiter(Global.SPACE_ALTITUDE4);
			
			btnGoal1.txtCards.text = "5 cards per game";
			btnGoal2.txtCards.text = "6 cards per game";
			btnGoal3.txtCards.text = "7 cards per game";
			btnGoal4.txtCards.text = "10 cards per game";
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			TweenPos.tweenToCurrentPosition(this, new Point(0, 400), 30, 0, TweenPos.EASE_OUT_CUBIC);
			
			btnGoal1.bounce.signalClickTarget.add(onGameGoalClick);
			btnGoal2.bounce.signalClickTarget.add(onGameGoalClick);
			btnGoal3.bounce.signalClickTarget.add(onGameGoalClick);
			btnGoal4.bounce.signalClickTarget.add(onGameGoalClick);
			
			_backDeco = new MouseBounce2(btnBack);
			_backDeco.signalClickTarget.add(onGameGoalClick);
			
			UiScaler.addAbsolute(this, true);
		}
		
		protected function onGameGoalClick(target:DisplayObject):void 
		{
			Sfx.playButtonClick();
			_buttonClicked = target;
			closeMenu();
		}
		
		public function closeMenu():void {
			TweenPos.tweenFromCurrentPosition(this, new Point(0, 400), 30, 0, TweenPos.EASE_IN).finishedSignal.addOnce(finishMenu);//Wait on tween to finish
			
			btnGoal1.disableDeco();
			btnGoal2.disableDeco();
			btnGoal3.disableDeco();
			btnGoal4.disableDeco();
			_backDeco.destroy();
			
			btnBack.mouseEnabled = false;
		}
		
		protected function finishMenu():void 
		{
			switch(_buttonClicked) {
				default:
					throw new Error("NewGameGoalMenu error - Unknown goal selected...");
				case btnGoal1:
					_controller.storyModeGoal = Global.SPACE_ALTITUDE1;
					_controller.startGameAtSlot();
					break;
				case btnGoal2:
					_controller.storyModeGoal = Global.SPACE_ALTITUDE2;
					_controller.startGameAtSlot();
					break;
				case btnGoal3:
					_controller.storyModeGoal = Global.SPACE_ALTITUDE3;
					_controller.startGameAtSlot();
					break;
				case btnGoal4:
					_controller.storyModeGoal = Global.SPACE_ALTITUDE4;
					_controller.startGameAtSlot();
					break;
				case btnBack:
					_controller.gotoNewGameMenu();
					break;
			}
			
			destroy();
			
		}
		
		public function destroy():void {
			if (_backDeco) _backDeco.destroy();
			_backDeco = null;
			
			if (btnGoal1) btnGoal1.destroy();
			if (btnGoal2) btnGoal2.destroy();
			if (btnGoal3) btnGoal3.destroy();
			if (btnGoal4) btnGoal4.destroy();
			
			btnGoal1 = null;
			btnGoal2 = null;
			btnGoal3 = null;
			btnGoal4 = null;
			btnBack = null;
			
			_buttonClicked = null;
			_controller = null;
			
			if (stage) parent.removeChild(this);
			
			while (numChildren) removeChildAt(0);
		}
		
	}

}