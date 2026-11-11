package src
{
	import ca.esdot.stats.FastStats;
	import com.hurlant.util.Base64;
	import cutscene.*;
	import fl.transitions.Transition;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.*;
	import flash.utils.*;
	import lbg.anticheatengine.CheatDetector;
	import lbg.anticheatengine.SafeBoolean;
	import lbg.compositetick.DeltaTimer;
	import lbg.debug.Log;
	import lbg.fpsdisplay.FPSDisplay;
	import lbg.utils.*;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.shape.Circle;
	import nape.space.Space;
	import nape.util.ShapeDebug;
	import nape.phys.BodyType;
	import net.hires.debug.Stats;
	import org.osflash.signals.Signal;
	import src.audio.*;
	import src.customization.*;
	import src.game.*;
	import src.cards.CardBox;
	import src.game.classicmode.ClassicProgressScreen;
	import src.game.payloadmode.ProgressScreen;
	import src.game.sandboxmode.SandboxBg;
	import src.game.sandboxmode.SandBoxScreen;
	import src.game.spacestage.SpaceStage;
	import src.game.gameobjects.player.Player;
	import src.gui.*;
	import src.gui.decorators.PixelatedView;
	import src.gui.menus.CutsceneReplay;
	import src.gui.menus.EndGameScreen;
	import src.reg.*;
	import src.gui.progress.MainScreenClassic;
	import src.gui.progress.PayloadProgressScreen;
	import src.gui.progress.StoryProgressScreen;
	import src.shop.bonusshop.BonusShopEngine;
	import src.shop.medals.MedalBox;
	import src.shop.ShopEngine;
	import src.shop.ShopTooltip;
	import src.system.*;
	import src.steamapi.LtF3FRESteamWorks;
	
	/**
	 * ...
	 * @author 
	 */
	public class Main extends Sprite 
	{
		public static const VERSION:String = "1.2.13";//REMEBER TO UPDATE THE VERSION_SAFE_STRING if changing 1.X
		public static const VERSION_SAFE_STRING:String = "1.2.";//If a save file version starts with this string, it is compatible
		
		public static var gameLaunchedSignal:Signal = new Signal();
		public static var unsafeTickSignal:Signal = new Signal(Number);//Used to get a static ref to non-critical ticks
		public static var gameEngineTickSignal:Signal = new Signal(Number);//Should only be used by the gameEngine itself
		public static var guiTickSignal:Signal = new Signal(Number);//Signals that occur after everything, at the end of every frame
		public static var eachSecondSignal:Signal = new Signal();//Signals that occur one every second
		
		public static var visibleStageHeight:Number = 0;
		public static var visibleStageWidth:Number = 0;
		protected static var _lastStageWidth:Number = 0;//Used to determine when the stage has been resized
		
		//Cleanup signals
		public static var destroyGameSignal:Signal = new Signal();
		public static var destroyShopSignal:Signal = new Signal();
		public static var startGameMuted:Boolean = false;
		public static var cheatDetectionEnabled:Boolean = false;//Used to disable when importing new saves
		
		protected static var _timerOfLastMedal:Number = 0;//Timer of last medal to be displayed, gets ahead of time if medals are queued
		protected static var _minimumTimeBetweenMedals:Number = 2000;
		
		public var txtVersion:TextField;//The one that toggles with Log
		public var secondsTimer:Timer;
		
		/** Stops the game signal from ticking */
		public var gamePaused:Boolean = false;
		/** Used to prevent pausing when in certain menus */
		public var enableFocusLostPausing:Boolean = false;
		
		protected const DELTA_BASE_FRAMRERATE:uint = 60;//Determines the game speed, used for delta, not the actual FPS
		protected var _deltaTimer:DeltaTimer;
		protected var _lastDelta:Number = 1;
		
		
		protected static var _instance:Main;
		
		protected var _stageBorder:StageBorder = new StageBorder();//Black border to prevent funky stuff when stretching the screen in weird ways
		protected var _parentLayer:Sprite = new Sprite();//Layer that CONTAINS EVERY OTHER LAYER
		protected var _layerTransition:Sprite = new Sprite();
		protected var _layerMessage:Sprite = new Sprite();//Medals and popups
		protected var _layerDialogs:Sprite = new Sprite();//Clickable dialogs
		protected var _layerBabies:Sprite = new Sprite();//Easter eggs
		protected var _layerMain:Sprite = new Sprite();
		protected var _layerDebug:Sprite = new Sprite();
		protected var _layerSteamOverlay:Sprite = new Sprite();
		protected var _pauseScreen:PauseScreen;
		protected var _optionsButton:OptionsButton;
		protected var _muteButton:MuteButton;
		protected var _fullscreenButton:FullscreenButton;
		protected var _systemButtonsLabels:TextField;
		protected var _systemButtonsLabelsLastCaller:DisplayObject;//Used so that one button doesn't erase the other one's 
		
		protected var _debugStats:Stats;
		
		protected var _lastFullscrenForceTimer:Number = 0;
		
		public function Main(startMuted:Boolean = false) 
		{
			Log.log("v." + VERSION);
			
			startGameMuted = startMuted;
			
			//Nothing, waiting on init to be called
			//Needs a stage for init to work
			
			addEventListener(Event.ADDED_TO_STAGE, initSystem);
		}
		
		private function initSteamWorks():void 
		{
			//STEAM API
			//SteamWorks init
			
			LtF3FRESteamWorks.signalFresIsReady.addOnce(initSystem2);
			LtF3FRESteamWorks.init(_layerSteamOverlay);
		}
		
		
		
		/** The first real command to launch the game, most likely loading the first screen to be shown */
		public function gameStart():void {
			Log.log("---------------------------------------------------------");
			Log.log("---------------------------------------------------------");
			Log.log("gameStart()");
			Log.log("---------------------------------------------------------");
			Log.log("---------------------------------------------------------");
			
			//Test for the call stack trace functionality
			//Log.log("Testing the getCallStack function...");
			//Log.log("If you see \"at src::\" it's working fine");
			//var e:Error = new Error("NOT AN ERROR, this is a stack trace test...", 1337);
			//var ev:UncaughtErrorEvent = new UncaughtErrorEvent("uncauhghtError", true, true, e);
			//uncaughtErrorHandler(ev);
			
			
			
			//Skip intros
			//loadMainMenu();
			
			
			//REVIVE OLD SAVE STRINGS
			//Used to recover expired export strings
			
			
			////////////////////////////////////////////////
			//Debug game start
			//Insert misc commands here
			
			
			Input.instance.basicCommands.enter.signalCommandDown.add(onEnterDown);
			//for (var i:int = 0; i <= 360000; i += 5000) trace("Global.rewardForDuration ->", i, "->", Global.rewardForDuration(i, 1).toFixed(1));
			//return;
			//Debug game start
			////////////////////////////////////////////////
			
			//Normal game start
			cheatDetectionEnabled = true;
			//ProfileState.instance.mute = 0;
			//Audio.mute = true;
			
			//parentLayer.alpha = 0.6;
			
			gameLaunchedSignal.dispatch();
			
			Cutscene.playLBGIntro();
			
			
		}
		
		private function onEnterDown():void 
		{
			if (Input.instance.basicCommands.alt.isDown) {
				toggleFullScreen();
			}
			
		}
		
		public function toggleFullScreen(forceToFullscreen:Boolean = false):void {
				if (forceToFullscreen == false && (stage.displayState == StageDisplayState.FULL_SCREEN || stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)) {
					//Switch to windowed
					ProfileState.instance.fullscreenAtLaunch = false;
					stage.displayState = StageDisplayState.NORMAL;
					stage.fullScreenSourceRect = null; 
					onStageResize(null);
					return;
				}
				
				var rectW:Number;
				var rectH:Number;
				
				switch(ProfileState.instance.fullscreenMode) {
					case "0.7x":
						//Displaying at lower game resolution with correct aspect ratio
						var aspectRatio:Number = stage.fullScreenWidth / stage.fullScreenHeight;
						aspectRatio = Math.min(aspectRatio, UiScaler.MAX_ASPECT_RATIO);
						aspectRatio = Math.max(aspectRatio, UiScaler.MIN_ASPECT_RATIO);
						rectW = UiScaler.UNSCALED_STAGE_HEIGHT * aspectRatio * 0.7;
						rectH = UiScaler.UNSCALED_STAGE_HEIGHT * 0.7;
						break;
					case "1.5x":
						//Displaying at higher game resolution with correct aspect ratio
						var aspectRatio:Number = stage.fullScreenWidth / stage.fullScreenHeight;
						aspectRatio = Math.min(aspectRatio, UiScaler.MAX_ASPECT_RATIO);
						aspectRatio = Math.max(aspectRatio, UiScaler.MIN_ASPECT_RATIO);
						rectW = UiScaler.UNSCALED_STAGE_HEIGHT * aspectRatio * 1.66;
						rectH = UiScaler.UNSCALED_STAGE_HEIGHT * 1.66;
						break;
					case "FULL":
						//Using full monitor resolution
						rectW = stage.fullScreenWidth;
						rectH = stage.fullScreenHeight;
						break;
					case "1.0x":
					default:
						//Displaying at native game resolution with correct aspect ratio
						var aspectRatio:Number = stage.fullScreenWidth / stage.fullScreenHeight;
						aspectRatio = Math.min(aspectRatio, UiScaler.MAX_ASPECT_RATIO);
						aspectRatio = Math.max(aspectRatio, UiScaler.MIN_ASPECT_RATIO);
						rectW = UiScaler.UNSCALED_STAGE_HEIGHT * aspectRatio;
						rectH = UiScaler.UNSCALED_STAGE_HEIGHT;
						break;
						
				}
				
				//Never go beyond full available resolution
				rectW = Math.min(rectW, stage.fullScreenWidth);
				rectH = Math.min(rectH, stage.fullScreenHeight);
				
				rectW = Math.round(rectW);
				rectH = Math.round(rectH);
				
				stage.fullScreenSourceRect = new Rectangle(0, 0, rectW, rectH); 
				
				//stage.align = "";
				//stage.scaleMode = StageScaleMode.SHOW_ALL; 			
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				
				ProfileState.instance.fullscreenAtLaunch = true;
				
				onStageResize(null);
		}
		
		public function refreshFullscreenMode():void {
			if (stage.displayState == StageDisplayState.FULL_SCREEN || stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE) {
				toggleFullScreen();
				toggleFullScreen();
			}
		}
		
		
		
		public function initSystem(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, initSystem);
			
			if (_instance != null) {
				Log.log("initSystem() failed, _instance already exists...");
				return;
			}
			
			Log.log("initSystem() Capabilities.version:", Capabilities.version);
			Log.log("initSystem() Capabilities.isDebugger:", Capabilities.isDebugger);
			
			_instance = this;
			
			if(Global.traceGameInitLog) Log.log("Version " + VERSION);
			if(Global.traceGameInitLog) Log.log("initSystem()");
			if (!stage) {
				Log.log("initSystem() failed, no stage property...");
				return;
			}
			
			//Debugging stats
			_debugStats = new Stats();
			_debugStats.scaleX = _debugStats.scaleY = 1.5;
			_layerDebug.addChild(_debugStats);
			toggleStats();
			
			stage.addEventListener(Event.DEACTIVATE, onFocusOut);
			GuiSettings.setGuiTickSignal(guiTickSignal);
			
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			
			//INTIIATE DISPLAY
			addChild(_parentLayer);
			
			_parentLayer.addChild(_layerMain);
			_parentLayer.addChild(_layerBabies);
			_parentLayer.addChild(_layerDialogs);
			_parentLayer.addChild(_layerMessage);
			_parentLayer.addChild(_layerTransition);
			_parentLayer.addChild(_layerDebug);
			_layerTransition.addChild(_stageBorder);
			_parentLayer.addChild(_layerSteamOverlay);
			
			Log.initiate(_layerDebug);		
			
			//INITIATE INPUT
			if(Global.traceGameInitLog) Log.log("Initiating Input...");
			Input.initInputInstance(stage);
			
			//INIT REGISTRY AND DICTIONARY
			Registry.init();
			RegistryCompressionDictionary.buildDictionary(Registry.dic);
			
			stage.addEventListener(MouseEvent.RIGHT_CLICK, doNothing);
			addEventListener(MouseEvent.RIGHT_CLICK, doNothing);
			stage.frameRate = Global.defaultFramerate;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onStageKeyDown);
			
			initSteamWorks();
		}
		
		private function onStageKeyDown(ev:KeyboardEvent):void 
		{
			//escape
			if(ev.keyCode == 27){
				ev.preventDefault();
			}
		}
		
		private function doNothing(e:MouseEvent):void 
		{
			//disabled right click
			e.stopPropagation();
			e.stopImmediatePropagation();
		}
		
		public function initSystem2():void {
			//INITIATE ProfileState
			//Depends on Input
			//Depends on Dictionaries
			if(Global.traceGameInitLog) Log.log("Initiating Profile...");
			ProfileState.initProfileState();
			
			CheatDetector.cheatDetectedSignal.add(cheatingDetected);
			
			
			secondsTimer = new Timer(1000, 0);
			secondsTimer.addEventListener(TimerEvent.TIMER, onEachSecond);
			secondsTimer.start();
			
			//Input.F3.signalCommandDown.add(ScreenManager.unloadAllScreens);
			//Input.F6.signalCommandDown.add(returnToMainMenu);
			//Input.F6.signalCommandDown.add(loadEndGameScreen);
			Input.F7.signalCommandDown.add(toggleStats);
			Input.F8.signalCommandDown.add(toggleLog);
			//Input.asterisk.signalCommandDown.add(dropFPS);
			//Input.asterisk.signalCommandUp.add(raiseFPS);
			Input.updateDebugControls();
			if(Global.logVisibleOnStartup) Log.show();
			
			Links.rebuildRightClickMenu(this);
			
			if (Global.traceGameInitLog) Log.log("initSystem() complete.");
			
			//stage.addEventListener(Event.RESIZE, onStageResize);
			onStageResize(null);
			
			init();
		}
		
		
		private function onStageResize(e:Event):void 
		{
			if (e != null) {
				Log.log("onStageResize from event!", e, e.type);
				return;
			}
			var aspectRatio:Number = stage.stageWidth / stage.stageHeight;
			
			if (aspectRatio < UiScaler.MIN_ASPECT_RATIO) {
				//width-bound
				//Scale to width, black bars top and bottom
				//Move parent layer DOWN accordingly
				_parentLayer.scaleX = _parentLayer.scaleY = stage.stageWidth / UiScaler.UNSCALED_STAGE_WIDTH;
				aspectRatio = UiScaler.MIN_ASPECT_RATIO;
				
				//Move layer
				var heightDiff:Number = stage.stageHeight - _parentLayer.scaleX * UiScaler.UNSCALED_STAGE_HEIGHT;
				_parentLayer.y = heightDiff / 2;
				_parentLayer.x = 0;
				
			}else if (aspectRatio > UiScaler.MAX_ASPECT_RATIO) {
				//Top-bound
				//Scale to height, limit to 16:9 ratio, black sides
				//Move parent layer RIGHT accordingly
				_parentLayer.scaleX = _parentLayer.scaleY = stage.stageHeight / UiScaler.UNSCALED_STAGE_HEIGHT;
				aspectRatio = UiScaler.MAX_ASPECT_RATIO;
				
				//Move layer
				var widthDiff:Number = stage.stageWidth - _parentLayer.scaleX * UiScaler.SCREEN_WIDTH_AT_MAX_RATIO;
				_parentLayer.x = widthDiff / 2;
				_parentLayer.y = 0;
				
			}else {
				//In-between
				//Scale to height
				//UI moves according to anchors
				//Move parent layer to 0,0
				_parentLayer.scaleX = _parentLayer.scaleY = stage.stageHeight / UiScaler.UNSCALED_STAGE_HEIGHT;
				_parentLayer.x = _parentLayer.y = 0;
			}
			
			_layerDebug.scaleX = _layerDebug.scaleY = 1 / _parentLayer.scaleX;
			
			_stageBorder.update(stage.stageHeight, stage.stageWidth, aspectRatio);
			
			UiScaler.updateScale(aspectRatio);
			
			//Updat the size of the visible portion of the screen, as seen from within _parentLayer (i.e. _parentLayer coords, NOT global stage coords)
			var p:Point = new Point(UiScaler.maxWidthAtCurrentRatio, 540);
			p = DisplayObjectUtil.localToLocal(p, _stageBorder, _parentLayer);
			visibleStageHeight = p.y;
			visibleStageWidth = p.x;
			
			Log.refreshSizeManually(visibleStageHeight / _layerDebug.scaleX, visibleStageWidth / _layerDebug.scaleX);
		}
		
		public function init():void 
		{
			//Log.log("LtF3NAPE Started.");
			Log.log("Learn to Fly 3 version", VERSION);
			
			if (!stage) {
				Log.log("init() failed, no stage property...");
				return;
			}
			
			if (_instance == null) {
				//initSystem has not run yet
				initSystem(null);
			}
			
			var gameURL:String = loaderInfo.loaderURL;
			
			if(Global.traceGameInitLog) Log.log("LtF3NAPE loaderURL:", gameURL.replace("secureLtF3Loader.swf"));
			
			if(Global.traceGameInitLog) Log.log("LtF3NAPE init 1");
			
			stage.stageFocusRect = false;
			stage.tabChildren = false;
			stage.frameRate = Global.defaultFramerate;
			stage.quality = "medium";
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_deltaTimer = new DeltaTimer(DELTA_BASE_FRAMRERATE, stage.frameRate)
			
			addEventListener(Event.ENTER_FRAME, enterFrameTick);
			addEventListener(Event.RENDER, enterFrameTick);
			//addEventListener(Event.ENTER_FRAME, enterFrameTick);
			
			if(Global.traceGameInitLog) Log.log("LtF3NAPE init 2");
			
			txtVersion = new TextField();
			txtVersion.text = "v. " + VERSION;
			_layerDebug.addChild(txtVersion);
			txtVersion.y = 0; stage.stageHeight - (txtVersion.textHeight + 1);
			txtVersion.x = stage.stageWidth - (txtVersion.textWidth + 5 - 30);
			txtVersion.selectable = false;
			txtVersion.mouseEnabled = false;
			txtVersion.mouseWheelEnabled = false;
			txtVersion.tabEnabled = false;
			txtVersion.height = txtVersion.textHeight + 5;
			txtVersion.visible = false;
			
			
			//System buttons			
			_optionsButton = new OptionsButton();
			_muteButton = new MuteButton();
			_fullscreenButton = new FullscreenButton();
			
			_systemButtonsLabels = new TextField();
			_systemButtonsLabels.x = 0;
			_systemButtonsLabels.y = 40;
			var sysTxtFormat:TextFormat = new TextFormat("Arnold 2.1", 18, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			var sysTxtGlow:GlowFilter = new GlowFilter(0x000000, 1, 6, 6, 100, 1);
			_systemButtonsLabels.filters = [sysTxtGlow];
			_systemButtonsLabels.setTextFormat(sysTxtFormat);
			_systemButtonsLabels.defaultTextFormat = sysTxtFormat;
			_systemButtonsLabels.mouseEnabled = false;
			
			sysButtonsToTop();
			_optionsButton.x = 20;
			_optionsButton.y = 20;
			_muteButton.x = 54;
			_muteButton.y = 21;
			_fullscreenButton.x = 108;
			_fullscreenButton.y = 21;
			_fullscreenButton.visible = true;
			//_fullscreenButton.x = -1000;//108;
			//_fullscreenButton.y = -1000////21;
			//_fullscreenButton.visible = false;//true
			
			
			if (Global.traceGameInitLog) Log.log("LtF3NAPE has been fully initiated.");
			
			launchGame();
		}
		
		private function onEachSecond(e:TimerEvent):void 
		{
			if (gamePaused == false) ProfileState.instance.stats.totalPlayTime += 1;
			eachSecondSignal.dispatch();
		}
		
		private function uncaughtErrorHandler(e:UncaughtErrorEvent):void 
		{
			
			e.preventDefault();
			
			Log.log("\\\\UNCAUGHT ERROR EVENT----------------------------------------------//");
			try {
				Log.log("errorID:", e.errorID, " ->",  e.error, e.text);
				Log.log((e.error as Error).getStackTrace());
				//Log.log("errorID:", e.errorID);
				//Log.log(e.text);
				if(e.error.name) Log.log(e.error.name);
				if(e.error.message) Log.log(e.error.message);
				//Log.log(e);
				//Log.log(e.currentTarget);
				//Log.log(e.errorID);
			}catch (ee:Error) {
				Log.log("Couldn't get stack trace...", ee.name, ee.message);
			}
			Log.log("//END OF ERROR LOG------------------------------------------------\\\\");
			
			if (Global.haltOnError) {
				Log.show();
				Log.log("Game halted by debug mode. Press F8 to try and resume.");
				Log.log("Be aware that resuming after an error is likely to cause other errors");
				removeEventListener(Event.ENTER_FRAME, enterFrameTick);
			}
		}
		
		public function recursiveDestroy():void {
			//trace("recursiveDestroy!!!!!!!!!!!!!!!!!!!!!!!!");
			//trace("recursiveDestroy!!!!!!!!!!!!!!!!!!!!!!!!");
			//trace("recursiveDestroy()");
			var destroyed:Number = 0;
			destroyed += recursiveDestroy2(_layerDebug, 0, 0);
			destroyed += recursiveDestroy2(_layerMain, 0, 0);
			destroyed += recursiveDestroy2(_layerDialogs, 0, 0);
			destroyed += recursiveDestroy2(_layerMessage, 0, 0);
			destroyed += recursiveDestroy2(_layerBabies, 0, 0);
			//destroyed += recursiveDestroy2(_layerTransition, 0, 0);
			//trace("recursion destroyed", destroyed, "objects.");
		}
		
		protected function recursiveDestroy2(object:DisplayObjectContainer, recursionCount:Number, destroyCount:Number = 0):Number {
			var maxRecursion:Number = 20;
			
			if (recursionCount >= maxRecursion) return destroyCount;//Max reached
			
			//Safeguarded objects that cannot be destroyed just like that
			var whiteList:Array = [_optionsButton, _muteButton, _fullscreenButton, _systemButtonsLabels, _pauseScreen];
			
			var children:Array = new Array();
			
			for (var i:int = 0; i < object.numChildren; i++) {
				if(object.getChildAt(i) is DisplayObjectContainer) children.push(object.getChildAt(i));
			}
			
			for each (var o:DisplayObjectContainer in children) {
				if (o != object) {
					//trace("Found DisplayObjectContainer at depth", recursionCount);
					if (whiteList.indexOf(o) < 0) {
						destroyCount = recursiveDestroy2(o, recursionCount + 1, destroyCount);
						
						if ("destroy" in o) {
							try {
								//trace("Destroying object at depth", recursionCount);
								destroyCount += 1;
								o["destroy"]();
							}catch (e:Error) {
								//Skip errors
							}
							
							while (o.numChildren >= 1) o.removeChildAt(0);
							if (o.parent) o.parent.removeChild(o);
						}
					}
				}
			}
			
			return destroyCount;
		}
		
		public static function returnToMainMenu():void {
			ScreenManager.unloadAllScreens();
			//MainMenuController.destroy();
			ScreenManager.loadMainMenu();
			_instance.gamePaused = false;
		}
		
		protected function toggleLog():void {
			if (_layerDebug.stage) {
				Log.toggleVisibility();
				txtVersion.visible = Log.isVisible;
				txtVersion.parent.addChild(txtVersion);
			}else {
				Log.show();
			}
			
			if (Global.haltOnError) {
				addEventListener(Event.ENTER_FRAME, enterFrameTick);
			}
		}
		
		protected function dropFPS():void {
			if (Global.debugModeOn.value) {
				Log.log("dropFPS()");
				if (stage) stage.frameRate = 10;
			}
		}
		
		protected function raiseFPS():void {
			if (Global.debugModeOn.value) {
				Log.log("raiseFPS()");
				if (stage) stage.frameRate = Global.defaultFramerate;
			}
		}
		
		private function toggleStats():void 
		{
			_debugStats.visible = !_debugStats.visible;
		}
		
		public function sysButtonsToTop():void {
			_layerMain.addChild(_optionsButton);
			_layerMain.addChild(_muteButton);
			_layerMain.addChild(_fullscreenButton);
			_layerMain.addChild(_systemButtonsLabels);
		}
		
		public function muteButtonToTop():void {
			//_layerMain.addChild(_optionsButton);
			_layerMain.addChild(_muteButton);
			_layerMain.addChild(_fullscreenButton);
			_layerMain.addChild(_systemButtonsLabels);
		}
		
		public function setSysButtonLabel(txt:String, caller:DisplayObject):void {
			//trace("Caller:", caller, "Last:", _systemButtonsLabelsLastCaller, "txt:", txt);
			
			if (txt == "" && caller == _systemButtonsLabelsLastCaller) {
				_systemButtonsLabels.visible = false;
				_systemButtonsLabels.text = txt;
			}else if (txt != "") {
				_systemButtonsLabels.x = Math.max(-8, caller.x - 45);
				_systemButtonsLabelsLastCaller = caller;
				_systemButtonsLabels.visible = true;
				_systemButtonsLabels.text = txt;
			}
		}
		
		public function sysButtonsShow():void {
			//trace("Show system buttons!");
			if(_optionsButton) _optionsButton.visible = true;
			if (_muteButton) _muteButton.visible = true;
			if (_fullscreenButton) _fullscreenButton.visible = true;
			sysButtonsToTop();
		}
		
		public function sysButtonsHide():void {
			//trace("HIDE system buttons!");
			_optionsButton.visible = false;
			_muteButton.visible = false;
			_fullscreenButton.visible = false;
		}
		
		public function resumeGame():void {
			Log.log("resumeGame()");
			
			if (enableFocusLostPausing) {
				_deltaTimer.clearBuffer();
			}
			
			if (_pauseScreen) _pauseScreen.destroy();
			_pauseScreen = null;
			addEventListener(Event.ENTER_FRAME, enterFrameTick);
			gamePaused = false;
		}
		
		public function pauseGame():void {
			Log.log("resumeGame()");
			
			if (_pauseScreen) _pauseScreen.destroy();
			_pauseScreen = new PauseScreen();
			_layerTransition.addChild(_pauseScreen);
			removeEventListener(Event.ENTER_FRAME, enterFrameTick);
			gamePaused = true;
			GameMediator.gamePaused.dispatch();
		}
		
		protected function onFocusOut(e:Event):void {
			if (enableFocusLostPausing && ProfileState.instance.optionPauseOnFocusLost == "On") {
				pauseGame();
			}
		}
		
		private function cheatingDetected():void 
		{
			if (cheatDetectionEnabled) {
				Log.log("Data tampering detected...");
				ProfileState.instance.playerCheated.value = true;
			}else {
				Log.log("Data tampering detected during save import...");
			}
		}
		
		public function enterFrameTick(e:Event):void {
			//Visible Stage size stuff//////////////
			if (getTimer() - _lastFullscrenForceTimer >= 300 &&  stage.displayState != StageDisplayState.FULL_SCREEN_INTERACTIVE) { 
				_lastFullscrenForceTimer = getTimer();
				//toggleFullScreen(true);
			}
			
			if (_lastStageWidth != stage.stageWidth) {
				onStageResize(null);
				
				_lastStageWidth = stage.stageWidth;
				
				//var drawOn:Graphics = babiesLayer.graphics;
				//drawOn.clear();
				//drawOn.lineStyle(9, 0x00FF00);
				//drawOn.moveTo(0, 0);
				//drawOn.lineTo(0, visibleStageHeight);
				//drawOn.moveTo(visibleStageWidtht, 0);
				//drawOn.lineTo(visibleStageWidtht, visibleStageHeight);
				//drawOn.lineStyle(9, 0xFF0000);
				//drawOn.moveTo(0, 0);
				//drawOn.lineTo(visibleStageWidtht, 0);
				//drawOn.moveTo(0, visibleStageHeight);
				//drawOn.lineTo(visibleStageWidtht, visibleStageHeight);
				//
				//Log.log("Resize->Stage size->", stage.stageWidth, stage.stageHeight);
				//Log.log("Resize->Visible area->", visibleStageWidtht, visibleStageHeight);
			}
			
			
			var delta:Number = _deltaTimer.tickTimer();
			
			if (StatHooks.deltaTimeMult) {
				delta *= StatHooks.deltaTimeMult.value;
			}
			
			//Apply profile delta options
			if (ProfileState.instance.optionDeltaTime == "Off") {
				//Delta cannot go over 1
				delta = NumberUtils.constrain(delta, 0, 1);
			}else if (ProfileState.instance.optionDeltaTime == "Low") {
				//Delta cannot go over 2
				delta = NumberUtils.constrain(delta, 0, 2);
			}else {
				//Delta applied normally according to DeltaTimer settings
			}
			
			if (stage.scaleMode != StageScaleMode.NO_SCALE) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			
			_debugStats.trackCustom(delta.toFixed(2));
			_lastDelta = delta;
			
			if (!gamePaused) {
				gameEngineTickSignal.dispatch(delta);
				unsafeTickSignal.dispatch(delta);
			}else {
				//trace("Game is pause but Main is ticking!", Math.random().toFixed(3) );
			}
			guiTickSignal.dispatch(delta);
			
			if(ProfileState.instance.ultraLowQuality) ultraLowQualityFilterSweep();//Experimental
		}
		
		public function ultraLowQualityFilterSweep():void {
			ultraLowQualityFilterSweepRecursive(stage);
		}
		
		public function ultraLowQualityFilterSweepRecursive(o:DisplayObject):void {
			if (o == null) return;
			
			if (o.filters) {
				if(o.filters.length >=1) o.filters = [];
			}
			if (o is DisplayObjectContainer) {
				var c:DisplayObjectContainer = o as DisplayObjectContainer;
				if (c.numChildren >= 1) {
					for (var i:int = 0; i < c.numChildren; i++) {
						ultraLowQualityFilterSweepRecursive(c.getChildAt(i));
					}
				}
			}
		}
		
		public static function showOptionsMenu():void {
			var menu:OptionsMenu = new OptionsMenu();
			dialogLayer.addChild(menu);
		}
		
		public static function showControlsMenu():void {
			var menu:ControlsMenu = new ControlsMenu();
			dialogLayer.addChild(menu);
		}
		
		public static function gameToShop():void {
			Log.log("gameToShop()");
			
			ScreenManager.unloadGame();
			
			
			//Payload mode completion hack-job... this is what gives you cards for payload
			if (ProfileState.instance.currentGameState.gameMode == "Payload Mode"
			&& ProfileState.instance.currentGameState.payloadTopAltitude1.value >= 200000
			&& ProfileState.instance.currentGameState.payloadTopAltitude2.value >= 200000
			&& ProfileState.instance.currentGameState.payloadTopAltitude3.value >= 200000
			&& ProfileState.instance.currentGameState.payloadTopAltitude4.value >= 200000
			&& ProfileState.instance.currentGameState.gameCompleted.value == false) {
				MedalCheck.getMedal(Registry.getEntry("medalFreeMode"), 1);
				MedalCheck.checkChallengePayload();
				ScreenManager.loadEndGameScreen();
				return;
			}
			
			
			saveGame();
			
			ScreenManager.loadShop();
		}
		
		public static function saveGame():void {
			Log.log("Main.saveGame()");
			if (ProfileState.instance.lastTimePlayed != Tools.getTimeString(false, true, true, true, false, false, false)) {
				ProfileState.instance.realLifeDaysPlayed += 1;
				ProfileState.instance.lastTimePlayed = Tools.getTimeString(false, true, true, true, false, false, false);
				Log.log("First time playing today, added to profile.");
			}else {
				Log.log("Already played today, no bonus.");
			}
			
			ProfileState.instance.lastTimePlayed = Tools.getTimeString(false, true, true, true, false, false, false);
			ProfileState.instance.currentGameState.timeDateString = Tools.getTimeString(false, true, true, true, false, false, false);
			ProfileState.instance.currentGameState.timeHourString = Tools.getTimeString(false, false, false, false, true, true, true);
			
			ProfileState.instance.saveVersionCheck = Main.VERSION;
			
			//Save locally HERE
			SaveLoadModule.performSaveBackup();
			SaveLoadModule.saveProfileToFile(ProfileState.instance);
		}
		
		public static function get parentLayer():Sprite { return _instance._parentLayer }
		public static function get steamOverlayLayer():Sprite { return _instance._layerSteamOverlay }
		public static function get debugLayer():Sprite { return _instance._layerDebug }
		public static function get mainLayer():Sprite { return _instance._layerMain }
		public static function get messageLayer():Sprite { return _instance._layerMessage }
		public static function get dialogLayer():Sprite { return _instance._layerDialogs }
		public static function get babiesLayer():Sprite { return _instance._layerBabies }
		public static function get transitionLayer():Sprite { return _instance._layerTransition }
		
		static public function get instance():Main { return _instance }
		
		
		public function get lastDelta():Number 
		{
			return _lastDelta;
		}
		
		public static function displayMessage(message:String, marginFromTop:Number = 0):void {
			messageLayer.addChild(new MessageBar(message, marginFromTop));
		}
		
		public static function displayMessageBox(title:String, message:String, okFunction:Function = null, blur:Boolean = true):void {
			if (blur) {
				var b:ScreenBlurEffect = new ScreenBlurEffect();
				var box:MessageBox = new MessageBox(title, message, okFunction, b.deblurAndDestroy);
				dialogLayer.addChild(b);
			}else {
				var box:MessageBox = new MessageBox(title, message, okFunction);
			}
			dialogLayer.addChild(box);
		}
		
		/** Queue a new medal popup, level from 0 to 3 */
		public static function displayMedalGet(entry:RegistryEntry, level:uint):void {
			Log.log("Medal earned:", entry.name, level + 1);
			//Give BP reward
			ProfileState.earnBonusPoints(entry.statSpecial.valueAt(level));
			
			var timeSinceLastMedal:Number = getTimer() - _timerOfLastMedal;
			var delay:Number = Math.max(_minimumTimeBetweenMedals - timeSinceLastMedal, 0);
			_timerOfLastMedal = getTimer() + delay;
			
			//trace("Delay:", delay);
			//trace("_timerOfLastMedal:", _timerOfLastMedal);
			
			var medalMessage:MedalMessageBar = new MedalMessageBar(entry, 25, level + 1, delay + 1);
			medalMessage.mouseChildren = false;
			medalMessage.mouseEnabled = false;
			for (var i:int = 0; i < medalMessage.numChildren; i++) {
				if (medalMessage.getChildAt(i) is DisplayObjectContainer) {
					(medalMessage.getChildAt(i) as DisplayObjectContainer).mouseEnabled = false;
					(medalMessage.getChildAt(i) as DisplayObjectContainer).mouseChildren = false;
				}
			}
			messageLayer.addChild(medalMessage);
			messageLayer.mouseChildren = messageLayer.mouseEnabled = false;
			
		}
		
		/** level from 0 to 3 */
		public static function displayMedalGet2(entry:RegistryEntry, level:uint):void {
			//Give BP reward
			Sfx.playMedalSound2();
			ProfileState.earnBonusPoints(entry.statSpecial.valueAt(level));
			var medalMessage:MedalMessageBar = new MedalMessageBar(entry, 25, level + 1);
			medalMessage.mouseChildren = false;
			medalMessage.mouseEnabled = false;
			for (var i:int = 0; i < medalMessage.numChildren; i++) {
				if (medalMessage.getChildAt(i) is DisplayObjectContainer) {
					(medalMessage.getChildAt(i) as DisplayObjectContainer).mouseEnabled = false;
					(medalMessage.getChildAt(i) as DisplayObjectContainer).mouseChildren = false;
				}
			}
			messageLayer.addChild(medalMessage);
			messageLayer.mouseChildren = messageLayer.mouseEnabled = false;
		}
		
		/** Payload milestones popup */
		public static function displayPayloadProgress(entry:RegistryEntry, level:uint):void {
			Log.log("Payload Milestone:", entry.name, entry.statCost.valueAt(level));
			//Give BP reward
			ProfileState.earnBonusPoints(entry.statSpecial.valueAt(level));
			mainLayer.addChild(new PayloadMilestoneBar(entry, 25, level));
		}
		
		
		public function launchGame():void {
			gameStart();
		}
		
		//*****************************************************************************************************************************//
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	}

}