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
	import src.UiScaler;
	import src.audio.Sfx;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	import src.gui.decorators.TweenPos;
	import src.Main;
	import src.system.GameState;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class NewGameMenu extends MovieClip 
	{
		public var story:NewGameModeButton;
		public var classic:NewGameModeButton;
		public var payload:NewGameModeButton;
		public var sandbox:NewGameModeButton;
		public var btnBack:SimpleButton;
		
		public var txtInfo:TextField;
		public var txtInfo2:TextField;
		
		protected var _controller:MainMenuController;
		protected var _buttonClicked:Object;
		protected var _backDeco:MouseBounce2;
		
		public function NewGameMenu(control:MainMenuController) 
		{
			super();
			
			_controller = control;
			
			txtInfo.text = txtInfo2.text = "";
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			TweenPos.tweenToCurrentPosition(this, new Point(0, 400), 30, 0, TweenPos.EASE_OUT_CUBIC);
			
			story.mc.gotoAndStop(1);
			classic.mc.gotoAndStop(2);
			payload.mc.gotoAndStop(3);
			sandbox.mc.gotoAndStop(4);
			
			story.bounce.signalClickTarget.add(onNewGameMenuClick);
			story.addEventListener(MouseEvent.ROLL_OVER, onOver);
			story.addEventListener(MouseEvent.ROLL_OUT, onOut);
			
			if (ProfileState.instance.modeUnlockedClassic) {
				classic.bounce.signalClickTarget.add(onNewGameMenuClick);
				classic.addEventListener(MouseEvent.ROLL_OVER, onOver);
				classic.addEventListener(MouseEvent.ROLL_OUT, onOut);
			}else {
				classic.mc.gotoAndStop(5);
				classic.disableDeco();
				classic.enable = false;
			}
			
			if (ProfileState.instance.modeUnlockedPayload) {
				payload.bounce.signalClickTarget.add(onNewGameMenuClick);
				payload.addEventListener(MouseEvent.ROLL_OVER, onOver);
				payload.addEventListener(MouseEvent.ROLL_OUT, onOut);
			}else {
				payload.mc.gotoAndStop(5);
				payload.disableDeco();
				payload.enable = false;
			}
			
			if (ProfileState.instance.modeUnlockedSandbox) {
				sandbox.bounce.signalClickTarget.add(onNewGameMenuClick);
				sandbox.addEventListener(MouseEvent.ROLL_OVER, onOver);
				sandbox.addEventListener(MouseEvent.ROLL_OUT, onOut);
			}else {
				sandbox.mc.gotoAndStop(5);
				sandbox.disableDeco();
				sandbox.enable = false;
			}
			
			
			_backDeco = new MouseBounce2(btnBack);
			_backDeco.signalClickTarget.add(onNewGameMenuClick);
			
			UiScaler.addAbsolute(this, true);
		}
		
		protected function onNewGameMenuClick(target:DisplayObject):void 
		{
			Sfx.playButtonClick();
			_buttonClicked = target;
			
			closeMenu();
		}
		
		protected function onOver(e:MouseEvent):void {
			var info:String = "";
			var info2:String = "";
			switch(e.currentTarget) {
				case story:
					info = "Earn money and get better upgrades to prove that \rpenguins can make it to space!";
					info2 = "(5 to 10 cards per game)";
					break;
				case classic:
					info = "No obstacles, the goal is to fly far away horizontally. The original Learn to Fly flavor.";
					info2 = "(5 cards per game)";
					break;
				case payload:
					info = "Sure you can fly to space, but can you make it with extra weight?";
					info2 = "(6 cards per game)";
					break;
				case sandbox:
					info = "Adjust every game constant as you please, crash your browser to your heart's content.";
					info2 = "(Cannot earn cards in this mode)\n(Cannot earn most medals in this mode)";
					break;
			}
			
			txtInfo.text = info;
			if (ProfileState.instance.modeUnlockedPayload || ProfileState.instance.modeUnlockedClassic) {
				txtInfo2.text = info2;
			}else {
				txtInfo2.text = "";
			}
			
		}
		
		protected function onOut(e:MouseEvent):void {
			txtInfo.text = "";
			txtInfo2.text = "";
		}
		
		public function closeMenu():void {
			TweenPos.tweenFromCurrentPosition(this, new Point(0, 400), 30, 0, TweenPos.EASE_IN).finishedSignal.addOnce(finishMenu);//Wait on tween to finish
			
			story.disableDeco();
			classic.disableDeco();
			payload.disableDeco();
			sandbox.disableDeco();
			_backDeco.destroy();
			
			btnBack.mouseEnabled = false;
			
			story.removeEventListener(MouseEvent.CLICK, onNewGameMenuClick);
			classic.removeEventListener(MouseEvent.CLICK, onNewGameMenuClick);
			payload.removeEventListener(MouseEvent.CLICK, onNewGameMenuClick);
			sandbox.removeEventListener(MouseEvent.CLICK, onNewGameMenuClick);
			btnBack.removeEventListener(MouseEvent.CLICK, onNewGameMenuClick);
			
			story.removeEventListener(MouseEvent.ROLL_OVER, onOver);
			classic.removeEventListener(MouseEvent.ROLL_OVER, onOver);
			payload.removeEventListener(MouseEvent.ROLL_OVER, onOver);
			sandbox.removeEventListener(MouseEvent.ROLL_OVER, onOver);
			
			story.removeEventListener(MouseEvent.ROLL_OUT, onOut);
			classic.removeEventListener(MouseEvent.ROLL_OUT, onOut);
			payload.removeEventListener(MouseEvent.ROLL_OUT, onOut);
			sandbox.removeEventListener(MouseEvent.ROLL_OUT, onOut);
			
		}
		
		protected function finishMenu():void 
		{
			switch(_buttonClicked) {
				default:
					throw new Error("NewGameMenu error - Unknown game type selected...");
				case story:
					_controller.selectedNewGameMode = "Story Mode";
					goToNextScreen();
					break;
				case classic:
					_controller.selectedNewGameMode = "Classic Mode";
					goToNextScreen();
					break;
				case payload:
					_controller.selectedNewGameMode = "Payload Mode";
					goToNextScreen();
					break;
				case sandbox:
					_controller.selectedNewGameMode = "Sandbox";
					goToNextScreen();
					break;
				case btnBack:
					_controller.gotoMainMenu();
					break;
			}
			
			destroy();
			
		}
		
		protected function goToNextScreen():void {
			if (_buttonClicked == story && (ProfileState.instance.medals.storyMode >= 1 || ProfileState.instance.modeUnlockedSandbox)) {
				//Completed story, can pick goal
				_controller.gotoNewGameGoalMenu();
			}else {
				_controller.startGameAtSlot();
			}
		}
		
		public function destroy():void {
			if (_backDeco) _backDeco.destroy();
			_backDeco = null;
			
			if (story) {
				story.removeEventListener(MouseEvent.CLICK, onNewGameMenuClick);
				story.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				story.removeEventListener(MouseEvent.ROLL_OUT, onOut);
				story.destroy();
			}
			if (classic) {
				classic.removeEventListener(MouseEvent.CLICK, onNewGameMenuClick);
				classic.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				classic.removeEventListener(MouseEvent.ROLL_OUT, onOut);
				classic.destroy();
			}
			if (payload) {
				payload.removeEventListener(MouseEvent.CLICK, onNewGameMenuClick);
				payload.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				payload.removeEventListener(MouseEvent.ROLL_OUT, onOut);
				payload.destroy();
			}
			if (sandbox) {
				sandbox.removeEventListener(MouseEvent.CLICK, onNewGameMenuClick);
				sandbox.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				sandbox.removeEventListener(MouseEvent.ROLL_OUT, onOut);
				sandbox.destroy();
			}
			
			
			classic = null;
			payload = null;
			sandbox = null;
			btnBack = null;
			
			story = null;
			classic = null;
			payload = null;
			sandbox = null;
			btnBack = null;
			
			txtInfo = null;
			
			_buttonClicked = null;
			_controller = null;
			
			if (stage) parent.removeChild(this);
			
			while (numChildren) removeChildAt(0);
		}
		
	}

}