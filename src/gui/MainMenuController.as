package src.gui 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import lbg.debug.Log;
	import lbg.utils.Tools;
	import src.UiScaler;
	import src.audio.Music;
	import src.Main;
	import src.MedalCheck;
	import src.system.GameState;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class MainMenuController extends Sprite 
	{
		protected static var _instance:MainMenuController;
		
		public var selectedNewGameMode:String = "Story Mode";//Used to carry the selected mode to the slot screen
		public var storyModeGoal:Number = Global.SPACE_ALTITUDE1;//Used to carry the selected story goal
		public var selectedSlotIndex:Number = 0;//Used to carry the selected slot index
		
		protected var _cloudBg:CloudBg;
		protected var _title:MainMenuTitle;
		protected var _txtVersion:TextField;
		
		public function MainMenuController(singleton:Enforcer) 
		{
			//Log.log("MainMenuController()");
			
			super();
			
			_cloudBg = new CloudBg();
			addChild(_cloudBg);
			
			_title = new MainMenuTitle();
			addChild(_title);
			_title.hide(true);
			_title.show();
			
			Music.playMenuMusic();
			
			//Check for real life days player
			if (ProfileState.instance.lastTimePlayed != Tools.getTimeString(false, true, true, true, false, false, false)) {
				ProfileState.instance.realLifeDaysPlayed += 1;
				ProfileState.instance.lastTimePlayed = Tools.getTimeString(false, true, true, true, false, false, false);
				Log.log("First time playing today, added to profile.");
				MedalCheck.checkComeBack(ProfileState.instance.realLifeDaysPlayed);
			}else {
				Log.log("Already played today, no bonus.");
				MedalCheck.checkComeBack(ProfileState.instance.realLifeDaysPlayed);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);

			UiScaler.addAbsolute(_title, true);
			
			checkProfileVersion();
		}

		public static function get instance():MainMenuController {
			if (_instance == null) {
				_instance = new MainMenuController(new Enforcer());
			}
			
			return _instance;
		}
		
		public function get title():MainMenuTitle 
		{
			return _title;
		}
		
		public function checkProfileVersion():void {
			//Log.log("checkProfileVersion");
			if (ProfileState.isProfileVersionCompatible(ProfileState.instance)) {
				openMainMenu();
			}else {
				var blur:ScreenBlurEffect = new ScreenBlurEffect();
				var box:QuestionBox6 = new QuestionBox6("", "", OptionsMenu2.eraseAllData, openMainMenu, blur.deblurAndDestroy);
				Main.dialogLayer.addChild(blur);
				Main.dialogLayer.addChild(box);
			}
		}
		
		protected function openMainMenu():void {
			//Log.log("openMainMenu");
			Main.saveGame();
			gotoMainMenu();
		}
		
		public function gotoMainMenu():void {
			//Log.log("gotoMainMenu");
			_title.show();
			var mainMenu:MainMenu = new MainMenu(this);
			addChild(mainMenu);
		}
		
		public function startGameAtSlot():void {
			ProfileState.instance.saveSlots[selectedSlotIndex] = GameState.getDebugInstance();
			ProfileState.instance.saveSlots[selectedSlotIndex].gameMode = selectedNewGameMode;
			ProfileState.instance.saveSlots[selectedSlotIndex].storyModeSpaceLevel = storyModeGoal;
			ProfileState.instance.loadState(ProfileState.instance.saveSlots[selectedSlotIndex]);
			
			ProfileState.instance.stats.totalGamesStarted += 1;
			
			if (selectedNewGameMode == "Story Mode") {
				Cutscene.playNewGameIntro();
				destroy();
			}else {
				Transition.transitionTo(destroy, Main.gameToShop);
			}
			
		}
		
		public function gotoNewGameMenu():void {
			//Log.log("gotoNewGameMenu");
			addChild(new NewGameMenu(this));
		}
		
		public function gotoNewGameGoalMenu():void {
			//Log.log("gotoNewGameGoalMenu");
			addChild(new NewGameGoalMenu(this));
		}
		
		public function gotoNewGameSlotSelect():void {
			//Log.log("gotoNewGameSlotSelect");
			addChild(new NewGameSlotSelect(this));
		}
		
		public function gotoLoadGameMenu():void {
			//Log.log("gotoLoadGameMenu");
			addChild(new LoadGameMenu(this));
		}
		
		public function gotoOptions():void {
			//Log.log("gotoOptions");
			//addChild(new OptionsMenuWindow(this));
		}
		
		public function gotoControls():void {
			//Log.log("gotoControls");
			addChild(new ControlsMenu());
		}
		
		public function gotoControlInput():void {
			//Log.log("gotoControlInput");
			//addChild(new OptionsMenuWindow(this));
		}
		
		public function gotoExtras():void {
			//Log.log("gotoExtras");
			addChild(new ExtrasMenu(this));
		}
		
		public function gotoWhySoLong():void {
			//Log.log("gotoWhySoLong");
			addChild(new WhySoLong(this));
		}
		
		public function addScreenBlur():ScreenBlurEffect {
			var blur:ScreenBlurEffect = new ScreenBlurEffect();
			addChild(blur);
			return blur;
		}
		
		public function addMessageBox(title:String, message:String, okFunction:Function = null, closingFunction:Function = null):MessageBox {
			var box:MessageBox = new MessageBox(title, message, okFunction, closingFunction);
			addChild(box);
			return box;
		}
		
		public function addQuestionBox(title:String, message:String, yesFunction:Function = null, noFunction:Function = null, closingFunction:Function = null):QuestionBox {
			var box:QuestionBox = new QuestionBox(title, message, yesFunction, noFunction, closingFunction);
			addChild(box);
			return box;
		}
		
		public function addQuestionBox2(title:String, message:String, yesFunction:Function = null, noFunction:Function = null, closingFunction:Function = null):QuestionBox {
			var box:QuestionBox = new QuestionBox2(title, message, yesFunction, noFunction, closingFunction);
			addChild(box);
			return box;
		}
		
		public function addInputBox(title:String, message:String, yesFunction:Function = null, noFunction:Function = null, closingFunction:Function = null):InputBox {
			var box:InputBox = new InputBox(title, message, yesFunction, noFunction, closingFunction);
			stage.focus = box.txtInput;
			addChild(box);
			return box;
		}
		
		public static function destroy():void {
			if (_instance) _instance.destroy();
		}
		
		public function destroy():void {
			_instance = null;
			
			Music.fadeOutAll();
			
			_cloudBg.destroy();
			
			while (numChildren >= 1) {
				if ("destroy" in getChildAt(0)) {
					if (getChildAt(0)["destroy"] != destroy) getChildAt(0)["destroy"]();
					if(numChildren >= 1) removeChildAt(0);
				}else {
					removeChildAt(0);
				}
			}
			
			if (parent) parent.removeChild(this);
		}

	}

}

class Enforcer { }
