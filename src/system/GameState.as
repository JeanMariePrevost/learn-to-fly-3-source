package src.system 
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import lbg.anticheatengine.SafeBoolean;
	import lbg.anticheatengine.SafeNumber;
	import lbg.debug.Log;
	import lbg.utils.Serialize;
	import src.audio.Sfx;
	import src.game.gameobjects.player.boost.BoostController;
	import src.game.gameobjects.player.boost.SimpleBoost;
	import src.game.gameobjects.player.Player;
	import src.game.gameobjects.player.rudder.SimpleRudder;
	import src.game.gameobjects.player.stage.*;
	import src.reg.Registry;
	/**
	 * GameState holds all the info required in a single game
	 * Such as items, upgrades and cash...
	 * 
	 * It does NOT however store profile-related information
	 * Such as bonus points, bonus items, medals, character customization...
	 * 
	 * @author 
	 */
	public class GameState 
	{
		protected static var _instance:GameState;
		
		/** "Story Mode", "Payload Mode", "Classic Mode", "Sandbox" or "Empty" */
		public var gameMode:String = "Story Mode";
		public var storyModeSpaceLevel:Number = Global.SPACE_ALTITUDE1;
		public var day:SafeNumber = new SafeNumber(SafeNumber.SAFETY_BYTEXOR_BYTE, 1)
		public var cash:SafeNumber = new SafeNumber(SafeNumber.SAFETY_BYTEXOR_BYTE);
		
		public var body:GameStateItem;
		public var launcher:GameStateItem;
		public var boosts:Vector.<GameStateItem> = new Vector.<GameStateItem>();
		public var stages:Vector.<GameStateItem> = new Vector.<GameStateItem>();
		public var rudder:GameStateItem;
		
		public var gameCompleted:SafeBoolean = new SafeBoolean(false);
		public var moonDestroyed:SafeBoolean = new SafeBoolean(false);
		
		//These are only used for results progress bar
		public var bestAltitude:Number = 0;
		public var bestDuration:Number = 0;
		public var bestSpeed:Number = 0;
		public var bestBonusMoney:Number = 0;
		public var bestInterestEarnings:Number = 0;
		public var bestPayloadBonus:Number = 0;
		
		
		
		
		//Time and date shown on the save slot
		public var timeDateString:String = "";
		public var timeHourString:String = "";
		
		
		//Regular stats
		public var previousDaysScores:Vector.<Number> = new Vector.<Number>();//Used for progress screen
		
		//Payload mode stats
		public var payloadSelected:int = 1;
		public var payloadTopAltitude1:SafeNumber = new SafeNumber(SafeNumber.SAFETY_BYTE, 0);
		public var payloadTopAltitude2:SafeNumber = new SafeNumber(SafeNumber.SAFETY_BYTE, 0);
		public var payloadTopAltitude3:SafeNumber = new SafeNumber(SafeNumber.SAFETY_BYTE, 0);
		public var payloadTopAltitude4:SafeNumber = new SafeNumber(SafeNumber.SAFETY_BYTE, 0);
		
		//Classic mode stats
		public var classicTopDistance:SafeNumber = new SafeNumber(SafeNumber.SAFETY_BYTE, 0);
		
		public function GameState() 
		{
			registerClassAlias("GameState", GameState);
			registerClassAlias("GameStateItem", GameStateItem);
			registerClassAlias("SafeNumber", SafeNumber);
			registerClassAlias("SafeBoolean", SafeBoolean);
			
			fillEmptyDaysScores();
		}
		
		/** Used to fill missing days scores with empty data, especially when old saves are imported */
		public function fillEmptyDaysScores():void {
			if (previousDaysScores == null) previousDaysScores = new Vector.<Number>();
			
			//Fill with zeroes
			while (previousDaysScores.length < (day.value - 1)) {
				previousDaysScores.push(0);
			}
			
			
			//Trim if too many
			while (previousDaysScores.length >= day.value) {
				previousDaysScores.shift();
			}
			
		}
		
		
		public static function getDebugInstance():GameState {
			_instance = new GameState();
			
			//Starting cash bonus
			switch(ProfileState.instance.medals.cashTotal) {
				default:
				case 0:
					_instance.cash.value = 10;
					break;
				case 1:
					_instance.cash.value = 15;
					break;
				case 2:
					_instance.cash.value = 20;
					break;
				case 3:
					_instance.cash.value = 30;
					break;
				case 4:
					_instance.cash.value = 50;
					break;
					
			}
			
			_instance.body = GameStateItem.createFrom("emptyBody", 0);
			
			_instance.launcher = GameStateItem.createFrom("emptyLauncher", 0);
			
			_instance.stages = new Vector.<GameStateItem>();
			_instance.stages.push(GameStateItem.createFrom("emptyStage", 0), GameStateItem.createFrom("emptyStage", 0), GameStateItem.createFrom("emptyStage", 0), GameStateItem.createFrom("emptyStage", 0));
			
			_instance.boosts = new Vector.<GameStateItem>();
			_instance.boosts.push(GameStateItem.createFrom("emptyBoost", 0), GameStateItem.createFrom("emptyBoost", 0), GameStateItem.createFrom("emptyBoost", 0), GameStateItem.createFrom("emptyBoost", 0));
			
			_instance.rudder = GameStateItem.createFrom("simpleRudder", 0);
			
			return _instance;
		}
		
		public static function getEmptyInstance():GameState {
			_instance = new GameState();
			
			_instance.gameMode = "Empty";
			
			//_instance.body = GameStateItem.createFrom("emptyBody", 0);
			//
			//_instance.launcher = GameStateItem.createFrom("emptyLauncher", 0);
			//
			//_instance.rudder = GameStateItem.createFrom("simpleRudder", 0);
			//
			//_instance.stages = new Vector.<GameStateItem>();
			//_instance.stages.push(GameStateItem.createFrom("emptyStage", 0), GameStateItem.createFrom("emptyStage", 0), GameStateItem.createFrom("emptyStage", 0), GameStateItem.createFrom("emptyStage", 0));
			//
			//_instance.boosts = new Vector.<GameStateItem>();
			//_instance.boosts.push(GameStateItem.createFrom("emptyBoost", 0), GameStateItem.createFrom("emptyBoost", 0), GameStateItem.createFrom("emptyBoost", 0), GameStateItem.createFrom("emptyBoost", 0));
			
			return _instance;
		}
		
		
		
		//////////////////////////
		//To GameEngine functions	
		//////////////////////////
		public function getNewStageController(player:Player):StageController {
			var s:StageController = new StageController(player);
			var itemClass:Class;
			
			//Body stage hook before normal stages
			if (!body.entry.bodyStageBeforeGameClass.isEmpty) {
				//Body has a "before" stage
				var beforeItem:GameStateItem = GameStateItem.createFrom(body.statBodyStageBefore, body.level);
				itemClass = beforeItem.statGameClass;
				s.addStage(new itemClass(player, beforeItem));
			}
			
			
			//Normal stages
			for (var i:int = 0; i < stages.length; i++) {
				if (stages[i].locked == false) {
					itemClass = stages[i].statGameClass;
					if (itemClass != null) {
						s.addStage(new itemClass(player, stages[i]));
					}
				}
			}
			
			
			//Body stage hook after normal stages
			if (!body.entry.bodyStageAfterGameClass.isEmpty) {
				//Body has a "before" stage
				var afterItem:GameStateItem = GameStateItem.createFrom(body.statBodyStageAfter, body.level);
				itemClass = afterItem.statGameClass;
				s.addStage(new itemClass(player, afterItem));
			}
			
			
			return s;
		}
		
		public function getNewBoostController(player:Player):BoostController {
			var b:BoostController = new BoostController(player);
			for (var i:int = 0; i < boosts.length; i++) {
				if (boosts[i].locked == false) {
					var itemClass:Class = boosts[i].statGameClass;
					if (itemClass != null) {
						b.addBoost(new itemClass(player, boosts[i]));
					}
				}
			}
			return b;
		}
		
		public function destroy():void {
			if (cash) cash.destroy();
			cash = null;
			
			if (body) body.destroy();
			body = null;
			
			if (launcher) launcher.destroy();
			launcher = null;
			
			if (boosts) {
				for each (var b:GameStateItem in boosts) {
					b.destroy();
				}
			}
			boosts = null;
			
			if (stages) {
				for each (var s:GameStateItem in stages) {
					s.destroy();
				}
			}
			stages = null;
			
			if (rudder) rudder.destroy();
			rudder = null;
			
			_instance = null;
		}
		
		public function swapItems(item1:GameStateItem, item2:GameStateItem):void {
			if (item1.type == item2.type) {
				Sfx.playEquipSwap();
				var index1:int;
				var index2:int;
				if (item1.type == "stage") {
					index1 = stages.indexOf(item1);
					index2 = stages.indexOf(item2);
					if (index1 >= 0 || index2 >= 0) {
						stages[index1] = item2;
						stages[index2] = item1;
					}else {
						Log.log("GameState swapItems() Error - Item not found in GameState.");
					}
				}else if (item1.type == "boost") {
					index1 = boosts.indexOf(item1);
					index2 = boosts.indexOf(item2);
					if (index1 >= 0 || index2 >= 0) {
						boosts[index1] = item2;
						boosts[index2] = item1;
					}else {
						Log.log("GameState swapItems() Error - Item not found in GameState.");
					}
				}else {
					Log.log("GameState swapItems() Error - Trying to swap invalid item types.");
					Log.log("GameState swapItems() Error - Item1 -> [", item1.name, "]");
					Log.log("GameState swapItems() Error - Item2 -> [", item2.name, "]");
				}
			}else {
				Log.log("GameState swapItems() Error - Trying to swap mismatched item types.");
				Log.log("GameState swapItems() Error - Item1 -> [", item1.name, "]");
				Log.log("GameState swapItems() Error - Item2 -> [", item2.name, "]");
			}
		}
		
	}

}