package src.system 
{
	import flash.display.StageQuality;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import lbg.anticheatengine.SafeBoolean;
	import lbg.anticheatengine.SafeNumber;
	import lbg.anticheatengine.SafeString;
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	import lbg.utils.StringUtils;
	import src.audio.Audio;
	import src.game.hud.HudComponentList;
	import src.Main;
	import src.reg.RegistryCompressionDictionary;
	import src.reg.RegistryEntry;
	import src.shop.SortButton;
	import src.steamapi.SteamTransaction;
	/**
	 * ProfileState holds all the info that spreads across the game but not related to a particular save file
	 * Such as bonus points, bonus items, medals, character customization...
	 * 
	 * It does NOT however store game-slot-related information
	 * Such as items, upgrades and cash...
	 * 
	 * There is never any need to "save" a GameState, as all states are always existing in memory
	 * "Loading" a state is merely selecting it as the current game state
	 * 
	 * @author 
	 */
	public class ProfileState 
	{
		protected static var _instance:ProfileState;
		protected static const RESET_SAVES_ON_DIFFERENT_VERSION:Boolean = false;
		
		public var saveVersionCheck:String = "";//Used to force new save if version changed, 
		public var lastTimePlayed:String = "0000-00-00"//YYYY-MM-DD
		public var realLifeDaysPlayed:int = 0;
		
		
		//OPTIONS//----------------------------------------------------------------------------------------------------------------
		public var fullscreenAtLaunch:Boolean = true;
		public var ultraLowQuality:Boolean = false;//Experimental features that removes every filter and disables some effects
		/** "LOW", "DEFAULT" or "FULL" */
		public var fullscreenMode:String = "1.0x";
		/** "HIGH", "MEDIUM" or "LOW" */
		public var optionQuality:String = StageQuality.MEDIUM;
		/** "On" or "Off" */
		public var optionFallingObjects:String = "On";
		/** "On" or "Off" */
		public var optionSmoke:String = "On";
		/** "High (blur)", "Medium", "Low" or "Off" */
		public var optionClouds:String = "High (blur)";
		/** "On" or "Off" */
		public var optionPauseOnFocusLost:String = "Off";
		
		public var musicVolume:Number = 0.75;
		public var soundVolume:Number = 0.75;
		public var mute:Number = 1;
		
		/** "Normal", "Low" or "Off" */
		public var optionDeltaTime:String = "Normal";
		public var optionEnableShopAnim:Boolean = true;
		public var optionEnableTransition:Boolean = true;
		/** 0->"Off", 1->"With Indicator" or 2->"W/o Indicator" */
		public var optionMouseControl:int = 0;
		/** Norm mult **/
		public var optionSteeringPower:Number = 1;
		public var optionSmoothSteering:Number = 0;
		public var optionEndDayAuto:Boolean = true;		
		
		
		
		//ADS STUFF
		
		//Music preferences
		public var musicShop:String = "MusicShop1";
		public var musicBonusShop:String = "MusicBonusShop1";
		public var musicGame1:String = "MusicPunk1";
		public var musicGame2:String = "MusicPunk2";
		public var musicGame3:String = "MusicPunk3";
		
		//Controls options, -1 = default to allow for multiple keys when using defaults
		public var controlsBoosts:int = -1;
		public var controlsBrake:int = -1;
		public var controlsTurnLeft:int = -1;
		public var controlsTurnRight:int = -1;
		public var controlsBoost1:int = -1;
		public var controlsBoost2:int = -1;
		public var controlsBoost3:int = -1;
		public var controlsBoost4:int = -1;
		public var controlsReadyAbort:int = -1;
		public var controlsUseMouseBoost:Boolean = true;
		
		public var shopSortMethod:String = SortButton.EVENT_SORT_BY_PRICE;
		//END OF OPTIONS//----------------------------------------------------------------------------------------------------------------
		
		
		
		
		//GAME DATA//---------------------------------------------------------------------------------------------------------------------
		public var dodoInvaderDiscovered:Boolean = false;
		public var dodoInvaderHighscore:Number = Global.DODO_INVADER_BASIC_SCORE;
		public var dodoInvaderHighscoreForSteam:Number = 0;
		public var dodoInvaderHighscoreRewardGiven:Boolean = false;
		
		//CHEAT OPTIONS
		public var cheatObstaclesTimes10:Boolean = false;
		public var cheatObstaclesTimes100:Boolean = false;
		public var cheatHugeObstacles:Boolean = false;
		public var cheatHeavyObstacles:Boolean = false;
		public var cheatHugePlayer:Boolean = false;
		public var cheatMichaelBay:Boolean = false;
		public var cheatPixel:Boolean = false;
		public var cheatGravityTimes2:Boolean = false;
		public var cheatGravityTimes10:Boolean = false;
		public var cheatUpsideDown:Boolean = false;
		public var cheatNyanCat:Boolean = false;
		public var cheatLSD:Boolean = false;
		public var cheatDodos:Boolean = false;
		
		public function get isAnyCheatEnabled():Boolean {
			return (cheatObstaclesTimes10
			|| cheatObstaclesTimes100
			|| cheatHugeObstacles
			|| cheatHeavyObstacles
			|| cheatHugePlayer
			|| cheatMichaelBay
			|| cheatPixel
			|| cheatGravityTimes2
			|| cheatGravityTimes10
			|| cheatUpsideDown
			|| cheatNyanCat
			|| cheatLSD
			|| cheatDodos);
		}
		
		
		public var playerCheated:SafeBoolean = new SafeBoolean(false);
		public var bonusPoints:SafeNumber = new SafeNumber(SafeNumber.SAFETY_BYTEXOR_BYTE, 0);
		public var bonusItems:GameStateBonusItems = new GameStateBonusItems();
		public var medals:Medals = new Medals();
		public var stats:ProfileStateStats = new ProfileStateStats();
		
		public var hudComponentList:HudComponentList = HudComponentList.getDefaultList();
		public var customizationData:CustomizationData = new CustomizationData();
		
		public var modeUnlockedPayload:Boolean = false;
		public var modeUnlockedClassic:Boolean = false;
		public var modeUnlockedSandbox:Boolean = false;
		public var modeUnlockCheatRevealed:Boolean = false;
		
		//Tutorial progress
		public var tutorialBuyLauncher:Boolean = false;
		public var tutorialBuyUpgrade:Boolean = false;
		public var tutorialStages:Boolean = false;
		public var tutorialBoosts:Boolean = false;
		public var tutorialBodies:Boolean = false;
		public var tutorialBonusShop:Boolean = false;
		public var tutorialCustomization:Boolean = false;
		public var tutorialHUD:Boolean = false;
		public var tutorialMusic:Boolean = false;
		public var tutorialClassicHud:Boolean = false;
		public var tutorialSandbox:Boolean = false;
		
		
		//Cutscenes viewed
		public var cutsceneViewedStoryEnding:Boolean = false;
		public var cutsceneViewedMoonCrusher:Boolean = false;
		public var cutsceneViewedClassicEnding:Boolean = false;
		public var easterEggsFound:int = 0;
		public var daysWithoutEasterEgg:int = 0;//Used to prevent being way unlucky
		
		/** "track1" class name are used as keys */
		public var musicBoughtKeys:Vector.<SafeString> = new Vector.<SafeString>();
		
		public var hudBoughtKeys:Vector.<SafeString> = new Vector.<SafeString>();
		public var itemUnlockKeys:Vector.<SafeString> = new Vector.<SafeString>();//Holds keys that are compared to registry entries to lock/unlock special items
		
		public var saveSlots:Vector.<GameState> = new Vector.<GameState>();
		protected var _currentGameState:int = 0;
		
		
		//END OF GAME DATA//---------------------------------------------------------------------------------------------------------------------
		
		public function ProfileState() 
		{
			registerClassAlias("ProfileState", ProfileState);
			registerClassAlias("SafeNumber", SafeNumber);
			registerClassAlias("SafeBoolean", SafeBoolean);
			registerClassAlias("GameStateBonusItems", GameStateBonusItems);
			registerClassAlias("Medals", Medals);
			registerClassAlias("ProfileStateStats", ProfileStateStats);
			registerClassAlias("HudComponentList", HudComponentList);
			registerClassAlias("CustomizationData", CustomizationData);
			registerClassAlias("Vector", Vector);
			registerClassAlias("SafeString", SafeString);
			registerClassAlias("GameState", GameState);
			registerClassAlias("GameStateItem", GameStateItem);
			registerClassAlias("Class", Class);
			registerClassAlias("Dictionary", Dictionary);
			registerClassAlias("RegistryEntry", RegistryEntry);
			registerClassAlias("SteamTransaction", SteamTransaction);
			
			while (saveSlots.length <= 5) {
				saveSlots.push(GameState.getEmptyInstance());
			}
			
			addMusicUnlockKey("MusicShop1");
			addMusicUnlockKey("MusicBonusShop1");
			addMusicUnlockKey("MusicPunk1");
		}
		
		public static function initProfileState():void {
			var localSave:ProfileState = SaveLoadModule.loadProfileFromSaveFile();
			if (localSave) {
				Log.log("Version compare:", "  Saved ->", localSave.saveVersionCheck, "   Client->",  Main.VERSION);
				
				if (isProfileVersionCompatible(localSave) == false) {
					//Save not compatible, interface was broken
					Log.log("Save file not compatible with current version, attempting to load...");
				}
				Log.log("Local save found and loaded successfully.");
				_instance = localSave
				Audio.musicVolume = localSave.musicVolume;
				Audio.soundVolume = localSave.soundVolume;
			}else {
				Log.log("No local save found, creating new profile...");
				loadDebugInstance();
			}
			
			
			//SaveLoadModule.verifyProfileDicionaries(_instance);
			
			Input.updateControlsFromProfile(_instance);
			
			if (Main.startGameMuted) {
				ProfileState._instance.mute = 0;
			}else {
				ProfileState._instance.mute = 1;
			}
			
			Audio.mute = (_instance.mute == 0);
			
			
		}
		
		public static function isProfileVersionCompatible(profileState:ProfileState):Boolean {
			if (profileState.saveVersionCheck.indexOf(Main.VERSION_SAFE_STRING) != 0) {
				Log.log("isProfileVersionCompatible ->", profileState.saveVersionCheck);
				return false;
			}else {
				return true;
			}
		}
		
		public static function get instance():ProfileState {
			if (_instance == null) {
				//throw new Error("ProfileState get instance ERROR: _instance is null, ProfileState was not initiated");
				initProfileState();
			}
			return _instance;
		}
		
		public static function loadDebugInstance():ProfileState {
			var p:ProfileState = new ProfileState();
			_instance = p;
			
			p.bonusPoints.value = 0;
			p.saveVersionCheck = Main.VERSION;
			
			p._currentGameState = 0;
			
			return p;
		}
		
		/** Adds bonus points to the profile */
		public static function earnBonusPoints(amount:Number):void {
			_instance.stats.totalBonusPoints += amount
			_instance.bonusPoints.value += amount;
		}
		
		/** Removes bonus points from the profile */
		public static function spendBonusPoints(amount:Number):void {
			_instance.bonusPoints.value -= amount;
		}
		
		/**
		 * Adds a key if it isn't already in the list
		 * @return True if added, false if already present
		 */
		public function addUnlockKey(key:String):Boolean {
			if (hasItemUnlockKey(key) == false) {
				var ss:SafeString = new SafeString();
				ss.value = key;
				itemUnlockKeys.push(ss);
				return true;
			}
			return false;
		}
		
		public function hasItemUnlockKey(key:String):Boolean {
			for each(var ss:SafeString in itemUnlockKeys) {
				if (ss.value == key) return true;
			}
			
			return false;
		}
		
		/**
		 * Adds a key if it isn't already in the list
		 * @return True if added, false if already present
		 */
		public function addMusicUnlockKey(key:String):Boolean {
			if (hasMusicUnlockKey(key) == false) {
				var ss:SafeString = new SafeString();
				ss.value = key;
				musicBoughtKeys.push(ss);
				return true;
			}
			return false;
		}
		
		public function hasMusicUnlockKey(key:String):Boolean {
			for each(var ss:SafeString in musicBoughtKeys) {
				if (ss.value == key) return true;
			}
			
			return false;
		}
		
		/** Check for omega progress which reached >=3 and add their keys if so */
		public function refreshOmegaItems():void {
			if (ProfileState.instance.stats.omegaBalloonCardsEarned >= 3) {
				addUnlockKey("omegaBalloon");
				ProfileState.instance.stats.omegaBalloonCardsEarned = 3;
			}
			
			if (ProfileState.instance.stats.omegaBoostersCardsEarned >= 3) {
				addUnlockKey("omegaBoosters");
				ProfileState.instance.stats.omegaBoostersCardsEarned = 3;
			}
			
			if (ProfileState.instance.stats.omegaBrickCardsEarned >= 3) {
				addUnlockKey("omegaBrick");
				ProfileState.instance.stats.omegaBrickCardsEarned = 3;
			}
			
			if (ProfileState.instance.stats.omegaCoilCardsEarned >= 3) {
				addUnlockKey("omegaCoil");
				ProfileState.instance.stats.omegaCoilCardsEarned = 3;
			}
			
			if (ProfileState.instance.stats.omegaRocketCardsEarned >= 3) {
				addUnlockKey("omegaRocket");
				ProfileState.instance.stats.omegaRocketCardsEarned = 3;
			}
			
			if (ProfileState.instance.stats.omegaShuttleCardsEarned >= 3) {
				addUnlockKey("omegaShuttle");
				ProfileState.instance.stats.omegaShuttleCardsEarned = 3;
			}
		}
		
		
		
		public function get currentGameState():GameState 
		{
			return saveSlots[_currentGameState];
		}
		
		public function loadState(state:GameState):void {
			if (saveSlots.indexOf(state) < 0) {
				Log.log("ProfileState.loadState() ERROR - handed state not part of local game states...");
				Log.log("loadState() aborted...");
				return;
			}
			
			_currentGameState = saveSlots.indexOf(state);
		}
		
		public static function destroy():void {
			if (_instance) {
				_instance.destroy();
			}
		}
		
		public function destroy():void {
			
			_instance = null;
			
			if (playerCheated) playerCheated.destroy();
			playerCheated = null;
			if (bonusPoints) bonusPoints.destroy();
			bonusPoints = null;
			if (bonusItems) bonusItems.destroy();
			bonusItems = null;
			medals = null;
			stats = null;
			
			if (hudComponentList) hudComponentList.destroy();
			hudComponentList = null;
			if (customizationData) customizationData.destroy();
			customizationData = null;
			
			var ss:SafeString;
			if (musicBoughtKeys) {
				for each (ss in musicBoughtKeys) ss.destroy();
				musicBoughtKeys.length = 0;
			}
			musicBoughtKeys = null;
		
			if (hudBoughtKeys) {
				for each (ss in hudBoughtKeys) ss.destroy();
				hudBoughtKeys.length = 0;
			}
			hudBoughtKeys = null;
		
			if (itemUnlockKeys) {
				for each (ss in itemUnlockKeys) ss.destroy();
				itemUnlockKeys.length = 0;
			}
			itemUnlockKeys = null;
		
			
			
			if (saveSlots) {
				for each (var gs:GameState in saveSlots) gs.destroy();
				saveSlots.length = 0;
			}
			saveSlots = null;
		}
		
		
		
	}

}
