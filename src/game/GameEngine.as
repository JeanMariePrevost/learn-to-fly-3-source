/*
GameEngine really is a "Setup" class, responsible for the construction of a game "stage".
(e.g. adds the ground, sky, player, physics engine...)
This base class should have the bare minimum that will be present in every game mode
plus it should already implement the GameEngin's correct interface.
 */

package src.game
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import lbg.compositetick.*
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import lbg.camera.Camera;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import nape.util.ShapeDebug;
	import org.osflash.signals.Signal;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.Music;
	import src.game.gameobjects.*;
	import src.game.gameobjects.environment.*;
	import src.game.gameobjects.obstacles.ObstaclesController;
	import src.game.gameobjects.player.boost.*;
	import src.game.gameobjects.player.launcher.AbstractLauncher;
	import src.game.gameobjects.player.Player;
	import src.game.gameobjects.player.rudder.*;
	import src.game.gameobjects.player.stage.*;
	import src.game.hud.Hud;
	import src.game.hud.WeightHudController;
	import src.game.result.*;
	import src.gui.OptionsButton;
	import src.Main;
	import src.reg.Registry;
	import src.system.ProfileState;
	import src.system.Global;
	import src.system.Input;
	/**
	 * ...
	 * @author 
	 */
	public class GameEngine implements ICompositeNode
	{
		protected static var _instance:GameEngine;
		
		protected var _compositeNode:CompositeNode;
		protected var _physicsEngine:PhysicsEngine;
		protected var _windEngine:WindEngine;
		protected var _windVisual:WindVisual;
		protected var _clouds:Clouds;
		protected var _cloudsOver:Clouds;
		protected var _ground:Ground;
		protected var _camera:GameCamera;
		protected var _obstacleController:ObstaclesController;
		protected var _player:Player;
		protected var _launcher:AbstractLauncher;
		protected var _weightHud:WeightHudController;
		protected var _hud:Hud;
		protected var _abortButton:AbortButton;
		protected var _spaceIndicator:SpaceIndicator;
		protected var _flightTimer:FlightTimer;
		
		protected var _result:Result;
		protected var _fader:ResultFader = new ResultFader();
		
		static public function get instance():GameEngine 
		{
			//if (_instance == null) _instance = new GameEngine();
			return _instance;
		}
		
		/** Starts a flight with optional effects. If several are enabled, the first listed takes precedence. */
		static public function initInstance(earninator:Boolean = false, floatifier:Boolean = false, speedifier:Boolean = false):GameEngine
		{
			if (_instance == null) {
				_instance = new GameEngine(earninator, floatifier, speedifier);
				return _instance;
			}else {
				throw new Error("GameEngine.initInstance() Instance already exists");
				return _instance;
			}
		}
		
		static public function destroy():void 
		{
			if (_instance) _instance.destroy();
		}
		
		public function get player():Player 
		{
			return _player;
		}
		
		public function get ground():Ground 
		{
			return _ground;
		}
		
		public function get physicsEngine():PhysicsEngine 
		{
			return _physicsEngine;
		}
		
		protected function setupGameEngine():void {
			Log.log("GameEngine.setupGameEngine()");
			
			_instance = this;
			
			/*-------------------------------
			* Current setup order should be:
			*
			* StatHooks
			* system (e.g. physics, composite, input...)
			* Visual layers
			* Objects (player, obstacles, environment...)
			* Camera
			-------------------------------*/
			
			
			_compositeNode = new CompositeNode();
			_physicsEngine = new PhysicsEngine();
			_windEngine = new WindEngine();
			addSubscriber(_windEngine);
			_windVisual = new WindVisual();
			
			//Objects Setup
			_player = new (ProfileState.instance.currentGameState.body.statGameClass)(ProfileState.instance.currentGameState);//body
			
			_camera = new GameCamera(Main.mainLayer.stage, Main.mainLayer, _player);
			
			_ground = new Ground(_physicsEngine);
			_ground.groundLevel = 1000;
			
			_launcher = new (ProfileState.instance.currentGameState.launcher.statGameClass)(_player, ProfileState.instance.currentGameState.launcher, this);
			
			var boostController:BoostController;
			var stageController:StageController;
			boostController = ProfileState.instance.currentGameState.getNewBoostController(_player);
			stageController = ProfileState.instance.currentGameState.getNewStageController(_player);
			_player.addGearItem(boostController);
			_player.addGearItem(stageController);
			_player.addGearItem(new (ProfileState.instance.currentGameState.rudder.statGameClass)(_player, ProfileState.instance.currentGameState.rudder));//rudder
			
			_player.setPhysicsEngine(_physicsEngine);
			
			
			_obstacleController = new ObstaclesController(_physicsEngine, _player);
			addSubscriber(_obstacleController);
			
			_player.setPositionFromAnchor(0, _ground.groundLevel, Player.ANCHOR_BOTTOM);
			_launcher.x = 0;
			_launcher.y = _ground.groundLevel;
			
			switch(ProfileState.instance.optionClouds) {
				case "High (blur)":
				case "Medium":
				case "Low":
					_clouds = new Clouds();
					break;
				case "Off":
					_clouds = new CloudsNull();
					break;
				default:
					_clouds = new CloudsNull();
					Log.log("GameEngine error - could not read ProfileState.instance.optionClouds.");
					break;
			}
			addSubscriber(_clouds);
			
			switch(ProfileState.instance.optionClouds) {
				case "High (blur)":
				case "Medium":
					_cloudsOver = new CloudsOver();
					break;
				case "Low":
				case "Off":
					_cloudsOver = new CloudsNull();
					break;
				default:
					_cloudsOver = new CloudsNull();
					Log.log("GameEngine error - could not read ProfileState.instance.optionClouds.");
					break;
			}
			addSubscriber(_cloudsOver);
			
			_weightHud = new WeightHudController(boostController, stageController);
			_hud = new Hud(ProfileState.instance.hudComponentList);
			
			_spaceIndicator = new SpaceIndicator();
			_flightTimer = new FlightTimer();
			
			_abortButton = new AbortButton();
			
			_player.updateBodyMass();//Used to update HudWeight at start of day, otherwise the required signal fires before HudWeight exists
			
			//Fixed layers
			_camera.addChildToFixedLayer(_weightHud, 4);
			_camera.addChildToFixedLayer(_hud, 4);
			_camera.addChildToFixedLayer(_spaceIndicator, 4);
			_camera.addChildToFixedLayer(_windVisual, 3);
			_camera.addChildToFixedLayer(Sky.instance.visual, -2);
			_camera.addChildToFixedLayer(_fader, 1);
			
			//Moving layers
			_camera.addChildToMovingLayer(_cloudsOver, 3);
			_camera.addChildToMovingLayer(_player.getMovieClip(), 2);
			_camera.addChildToMovingLayer(_launcher, 2);
			_camera.addChildToMovingLayer(_ground, -1);
			_camera.addChildToMovingLayer(_clouds, -3);
			_camera.addChildToMovingLayer(_obstacleController, 0);
			
			//We have to run a phycis tick to align movieclip with the NAPE body
			//THEN we can really center cam at mc position
			//_physicsEngine.tick(1);
			_camera.centerCam();
			
			_clouds.init();//Create clouds only once everything is in place
			_cloudsOver.init();
			
			Main.instance.sysButtonsShow();
			Main.instance.sysButtonsToTop();
		}
		
		protected function initStatHooks():void {
			StatHooks.initHooks();
		}
		
		/** Applies the selected effect for this flight after the normal flight stats have been initialized. */
		public function GameEngine(earninator:Boolean = false, floatifier:Boolean = false, speedifier:Boolean = false)
		{
			Log.log("GameEngine()");
			Main.instance.gamePaused = true;
			initStatHooks();
			applyFlightEffects(earninator, floatifier, speedifier);
			startGameEngine();
		}

		protected function applyFlightEffects(earninator:Boolean, floatifier:Boolean, speedifier:Boolean):void {
			if (earninator) {
				StatHooks.moneyMult.addMod2(1, 1);
			}else if (floatifier) {
				StatHooks.gravityMult.addMod2(0, 0.3);
				StatHooks.dragMult.addMod2(0, 0.7);
				StatHooks.boostPowerMult.addMod2(0.08, 1);
				StatHooks.stagePowerMult.addMod2(0.08, 1);
				StatHooks.launchPowerMult.addMod2(0.2, 1);
			}else if (speedifier) {
				StatHooks.boostPowerMult.addMod2(0.4, 1);
				StatHooks.stagePowerMult.addMod2(0.4, 1);
				StatHooks.launchPowerMult.addMod2(0.1, 1);
				StatHooks.dragMult.addMod2(0, 0.4);
			}
		}
		
		protected function startGameEngine():void {
			setupGameEngine();
			Main.instance.resumeGame();
			Main.instance.gamePaused = false;
			
			Main.gameEngineTickSignal.add(tick);
			
			GameMediator.gameResumed.add(enableEscKey);
			GameMediator.gamePaused.add(disableEscKey);
			
			enableEscKey();
		}
		
		
		
		public function enableEscKey():void {
			Input.esc.signalCommandDown.add(escPressed);
		}
		
		public function disableEscKey():void {
			Input.esc.signalCommandDown.remove(escPressed);
		}
		
		public function escPressed():void {
			disableEscKey();
			Main.showOptionsMenu();
		}
		
		public function initiateStatsOfTheDay():void {
			//Called right at takeoff
			StatsOfTheDay.init();
			
			_camera.addChildToFixedLayer(_flightTimer, 4);
			_camera.addChildToFixedLayer(_abortButton, 4);
		}
		
		
		public function tick(delta:Number):void {
			/*--------------------------
			 * Order-sensitive stuff:
			 * 
			 * _physicsEngine has to be run before any view elements
			 *		else there's a delay between model and view
			 *--------------------------*/
			_physicsEngine.tick(delta);
			//_physicsEngine.tick(delta);
			_compositeNode.tick(delta);
			_camera.tick(delta);
			
			
			//Day end event
			_fader.setFader(_player.dayEndTicks / Global.ticksToEndDay);
			
			if (_player.dayEndTicks >= 1) {
				Music.fadeGameMusic(1 -((_player.dayEndTicks / Global.ticksToEndDay) * 0.3));
			}
			
			if (_player.dayEndTicks >= Global.ticksToEndDay) {
				showResults();
			}
			
		}
		
		public function addSubscriber(obj:ICompositeLeaf):void {
			if(_compositeNode) _compositeNode.addSubscriber(obj);
		}
		
		public function removeSubscriber(obj:ICompositeLeaf):void {
			if(_compositeNode) _compositeNode.removeSubscriber(obj);
		}
		
		public function addToPhysicsEngine(object:GameObject):void {
			object.setPhysicsEngine(_physicsEngine);
		}
		
		/** @param	depthOffset <0 to put behind, >0 to put up front */
		public function addChildToFixedLayer(child:DisplayObject, depthOffset:int = 0):void {
			_camera.addChildToFixedLayer(child, depthOffset);
		}
		
		/** @param	depthOffset <0 to put behind, >0 to put up front */
		public function addChildToMovingLayer(child:DisplayObject, depthOffset:int = 0):void {
			_camera.addChildToMovingLayer(child, depthOffset);
		}
		
		public function toSpaceMiniGame():void {
			_abortButton.stopAbortSequence();
			Main.gameEngineTickSignal.remove(tick);
			ScreenManager.loadSpaceMiniGame(_player.speed, _player.speedAngle);
		}
		
		public function showResults():void {
			Main.gameEngineTickSignal.remove(tick);
			GameMediator.finishDay.dispatch();
			
			if (_result != null) return;
			
			_result = new Result(StatsOfTheDay.instance);
			addChildToFixedLayer(_result, 5);
		}
		
		public function showResultsWithSnapshot(target:DisplayObject = null):void {
			if (target == null) {
				target = Main.mainLayer;
			}
			
			var bmd:BitmapData = new BitmapData(UiScaler.SCREEN_WIDTH_AT_MAX_RATIO, UiScaler.UNSCALED_STAGE_HEIGHT);
			bmd.draw(target);
			
			var bm:Bitmap = new Bitmap(bmd);
			
			addChildToFixedLayer(bm, 5);
			showResults();
		}
		
		public function destroy():void{
			_instance = null;
			
			Main.gameEngineTickSignal.remove(tick);
			
			if(_compositeNode) _compositeNode.destroy();
			_compositeNode = null;
			if(_windEngine) _windEngine.destroy();
			_windEngine = null;
			if(_windVisual) _windVisual.destroy();
			_windVisual = null;
			if(_clouds) _clouds.destroy();
			_clouds = null;
			if(_cloudsOver) _cloudsOver.destroy();
			_cloudsOver = null;
			if(_ground) _ground.destroy();
			_clouds = null;
			if(_camera) _camera.destroy();
			_camera = null;
			if(_obstacleController) _obstacleController.destroy();
			_obstacleController = null;
			if(_player) _player.destroy();
			_player = null;
			if (_launcher) _launcher.destroy();
			_launcher = null;
			if(_hud) _hud.destroy();
			_hud = null;
			if(_weightHud) _weightHud.destroy();
			_weightHud = null;
			if(_abortButton) _abortButton.destroy();
			_abortButton = null;
			if(_spaceIndicator) _spaceIndicator.destroy();
			_spaceIndicator = null;
			if(_flightTimer) _flightTimer.destroy();
			_flightTimer = null;
			if(_result) _result.destroy();
			_result = null;
			_fader = null;
			Sky.destroy();
			
			if(_physicsEngine) _physicsEngine.destroy();
			_physicsEngine = null;
			
			GameMediator.removeAll();
			Input.esc.signalCommandDown.removeAll();
			StatsOfTheDay.instance.destroy();
		}
		
	}

}