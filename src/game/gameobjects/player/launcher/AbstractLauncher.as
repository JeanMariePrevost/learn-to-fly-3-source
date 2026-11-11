package src.game.gameobjects.player.launcher 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import lbg.compositetick.ICompositeLeaf;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import nape.phys.GravMassMode;
	import sound.SpringBoing;
	import src.audio.Audio;
	import src.audio.Music;
	import src.compound.TimedMod;
	import src.game.GameCamera;
	import src.game.GameEngine;
	import src.game.GameMediator;
	import src.game.gameobjects.player.boost.BoostController;
	import src.game.gameobjects.player.Player;
	import src.game.hud.Hud;
	import src.game.StatHooks;
	import src.Main;
	import src.system.GameStateItem;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class AbstractLauncher extends MovieClip implements ICompositeLeaf 
	{
		public static const DRAG_MULT_AT_LAUNCH:Number = 0.01;
		
		protected var _player:Player;
		protected var _item:GameStateItem;
		protected var _gameEngine:GameEngine;
		protected var _takeoffFinalized:Boolean = false;
		
		public function AbstractLauncher(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			_player = player;
			_player.getBody().gravMass = 0;
			_item = item;
			_gameEngine = gameEngine;
			_gameEngine.addSubscriber(this);
			StatHooks.cameraZoomFloor = _item.statZoomFloor;
		}
		
		/** Returns the item power adjusted with StatHooks launch mult*/
		public function get launcherBasePower():Number {
			var p:Number = _item.statPower * StatHooks.launchPowerMult.value;
			
			//Launcher soft-cap
			//trace("Launcher Power:", p); 
			//if (p >= 30000) p = NumberUtils.interpolate2(30000, 60000, 30000, 100000, p, 0.7, false);
			//trace("Launcher Power with cap:", p); 
			return p;
		}
		
		public function get powerAtCurrentWeight():Number {
			return _item.getPowerAtWeightMult(_player.getBody().mass);;
		}
		
		public function get item():GameStateItem 
		{
			return _item;
		}
		
		
		protected function movePlayerOnTarget(target:DisplayObjectContainer, anchor:String = Player.ANCHOR_BOTTOM):void {
			if (target == null || target.stage == null) return;
			
			var pos:Point = DisplayObjectUtil.localToLocal2(target, target.parent, GameCamera.instance.getMovingLayer(0));
			_player.rotation = Trig.toRadians(DisplayObjectUtil.globalRotationOf(target));
			_player.setPositionFromAnchor(pos.x, pos.y, Player.ANCHOR_BOTTOM);
			//_player.setPosition(pos.x, pos.y);
		}
		
		/* INTERFACE lbg.compositetick.ICompositeLeaf */
		
		public function tick(delta:Number):void 
		{
			//Nothing by default
		}
		
		/**
		 * Stage stops interacting with player, start of day
		 */
		protected function finalizeTakeoff():void {
			if (_takeoffFinalized) return;//Already done
			StatHooks.cameraZoomFloor = 0;
			StatHooks.cameraZoomCeil = 0;
			_takeoffFinalized = true;
			_gameEngine.initiateStatsOfTheDay();
			_player.getBody().gravMass = _player.getBody().mass;
			_player.enableTicking = true;
			Hud.instance.show();
			GameMediator.playerLaunched.dispatch();
			Music.playGameMusic();
			
			if (ProfileState.instance.bonusItems.bonusBetterStart.level >= 1) {
				var betterStartMult:Number = ProfileState.instance.bonusItems.bonusBetterStart.statPower;
				var betterStartDuration:Number = ProfileState.instance.bonusItems.bonusBetterStart.statFuel * 60;
				var mod:TimedMod = new TimedMod(0, betterStartMult, betterStartDuration, Main.unsafeTickSignal);
				mod.fadePower = 3;
				StatHooks.boostPowerMult.addMod(mod);
				StatHooks.stagePowerMult.addMod(mod);
			}
		}
		
		protected function playSoundEffect():void {
			Audio.playSound(SpringBoing);
		}
		
		/**
		 * Stage stops ticking, end of launcher visual generally
		 */
		protected function finalizeLauncher():void {
			if(_gameEngine) _gameEngine.removeSubscriber(this);
			_player = null;
			_gameEngine = null;
			_item = null;
		}
		
		protected function applyLauncherThrust(totalPower:Number, relativeAngle:Number = 0, nullifyMomentum:Boolean = true):void {
			if (nullifyMomentum) {
				_player.killMomentum();
				
				//trace("Launch power:", totalPower)
				
				//Drag buff after launch
				var buffDuration:Number = NumberUtils.interpolate2(220, 3000, 100, 700000, totalPower);//Buff duration increases with power
				var dragBuff:TimedMod = new TimedMod(0, DRAG_MULT_AT_LAUNCH, buffDuration, Main.unsafeTickSignal);
				dragBuff.fadePower = 1.6;
				StatHooks.dragMult.addMod(dragBuff);
				
				//Obstacle mass buff after launch
				var massBuffStrength:Number = NumberUtils.interpolate2(0.6, 0.05, 100, 6000, totalPower);
				var obstacleMassBuff:TimedMod = new TimedMod(0, massBuffStrength, buffDuration, Main.unsafeTickSignal);
				StatHooks.obstacleMassMult.addMod(obstacleMassBuff);
			}
			_player.applyThrust(totalPower, relativeAngle);
		}
		
		public function destroy():void {
			if(_gameEngine) _gameEngine.removeSubscriber(this);
			_player = null;
			_item = null;
			_gameEngine = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (stage) parent.removeChild(this);
		}
		
	}

}