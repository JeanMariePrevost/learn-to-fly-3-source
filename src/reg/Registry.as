package src.reg 
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import lbg.debug.Log;
	import sound.*;
	import src.game.gameobjects.player.body.*;
	import src.game.gameobjects.player.boost.*;
	import src.game.gameobjects.player.launcher.*;
	import src.game.gameobjects.player.rudder.*;
	import src.game.gameobjects.player.stage.*;
	import src.game.hud.huds.*;
	import src.system.Global;
	/**
	 * ...
	 * @author 
	 */
	public class Registry  
	{
		public static const TYPE_BODY:String = "body";
		public static const TYPE_LAUNCHER:String = "launcher";
		public static const TYPE_BOOST:String = "boost";
		public static const TYPE_STAGE:String = "stage";
		public static const TYPE_MISC:String = "misc";
		public static const TYPE_BONUS:String = "bonus";//Not shop items, but bonus shop upgradeables
		public static const TYPE_MEDAL:String = "medals";//Not shop items, but medals
		public static const TYPE_HUD:String = "huds";//Not shop items, but HUD elements
		public static const TYPE_PAYLOAD:String = "payloads";//Not shop items, but payload entries
		
		protected static const EMPTY_ITEM_CLASS:* = null;//Game class of empty items
		protected static const BONUS_ITEM_CLASS:* = null;//Game class of bonus shop items
		
		
		
		protected static var _dic:Dictionary;
		protected static var _entryCounter:int = 0;
		
		
		protected static function addEntry(id:String, name:String, itemType:String, maxLevel:uint, baseGameClass:Class):RegistryEntry {
			var entry:RegistryEntry = new RegistryEntry();
			entry.index = _entryCounter;
			_entryCounter ++;
			entry.id = id;
			
			entry.specialIds.addLevel(0, id);//Default special id is basic id
			
			entry.type = itemType;
			entry.name = name;
			entry.maxLevel = maxLevel;
			entry.gameClass.addLevel(0, baseGameClass);
			
			if (_dic[id]) {
				throw new Error("Registry error - duplicate entry ID [" + id + "]");
			}
			
			_dic[id] = entry;
			return entry;
		}
		
		protected static function getClass(fullClassName:String):Class {
			try {
				var c:Class = getDefinitionByName(fullClassName) as Class;
			}catch (e:Error) {
				Log.log("Registry.getClass([",fullClassName,"]) Error:");
				Log.log(e.errorID);
				Log.log(e.name);
				Log.log(e.message);
				return null;
			}
			
			if (c == null) {
				Log.log("Registry.getClass([",fullClassName,"]) Error: could not retrieve class with getDefinitionByName()");
				return null;
			}
			
			return c;
		}
		
		public static function getEntry(id:String):RegistryEntry {
			init();
			
			var entry:RegistryEntry = _dic[id];
			if (entry == null) {
				throw new Error("Entry ID [" + id + "] not found");
			}
			
			return entry;
		}
		
		public static function getEntriesOfType(type:String):Vector.<RegistryEntry> {
			var vec:Vector.<RegistryEntry> = new Vector.<RegistryEntry>();
			
			for each(var i:RegistryEntry in _dic) {
				if (i.type == type) {
					//trace(i.id);
					vec.push(i);
				}
			}
			
			vec = vec.sort(sortEntriesByIndex);
			
			return vec;
		}
		
		protected static function sortEntriesByIndex(itemA:RegistryEntry, itemB:RegistryEntry):Number {
			if (itemA.index < itemB.index) return -1; //ITEM A is before ITEM B
			else if (itemA.index > itemB.index) return 1; //ITEM A is after ITEM B
			else return 0; //ITEM A and ITEM B have same date
		}	
		

		
		
		/////////////////////////////////////////////////////
		//***************************************************
		//Every game item stats are here
		//***************************************************
		/////////////////////////////////////////////////////
		public static function init():void {
			if (_dic != null) {
				//throw new Error("Dictionary already exists.");
				return;
			}
			/////////////////
			//REGISTRY
			/////////////////
			_dic = new Dictionary();
			
			var tempEntry:RegistryEntry;//Holds an entry to manipulate it temporarily
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//Null Items//////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			tempEntry = addEntry("emptyBody", "Empty", TYPE_BODY, 0, EmptyBody);//{
				//tempEntry.setUnlockKeys("hidden");
				tempEntry.shopDescription.addLevel(0, "Your everyday penguin mk.I body, equipped with flippers and all");
				tempEntry.statZoomAtSpeed.addLevel(0, 1, 2.5, 30);
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statWeight.addLevel(0, 3);
				tempEntry.statTopSpeed.addLevel(0, 6);
				tempEntry.statTorque.addLevel(0, 0.15);
				tempEntry.statStageSlots.addLevel(0, 1);
				tempEntry.statBoostSlots.addLevel(0, 1);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(4, "Boost Slots", tempEntry.statBoostSlots);//}
			
			tempEntry = addEntry("emptyLauncher", "Empty", TYPE_LAUNCHER, 0, EmptyLauncher);
				//tempEntry.setUnlockKeys("hidden");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statBoostSlots.addLevel(0, 0);
			tempEntry = addEntry("emptyBoost", "Empty", TYPE_BOOST, 0, EMPTY_ITEM_CLASS);
				//tempEntry.setUnlockKeys("hidden");
				tempEntry.statCost.addLevel(0, 0);
			tempEntry = addEntry("emptyStage", "Empty", TYPE_STAGE, 0, EMPTY_ITEM_CLASS);
				//tempEntry.setUnlockKeys("hidden");
				tempEntry.statCost.addLevel(0, 0);
			tempEntry = addEntry("emptyMisc", "Empty", TYPE_MISC, 0, EMPTY_ITEM_CLASS);
				tempEntry.setUnlockKeys("hidden");
				tempEntry.statCost.addLevel(0, 0);
			
			
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//Rudders/////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			tempEntry = addEntry("simpleRudder", "Simple Rudder", TYPE_MISC, 10, SimpleRudder);
				tempEntry.setUnlockKeys("hidden");
			
			
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//Bodies//////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			tempEntry = addEntry("omegaPenguin", "Omega Penguin", TYPE_BODY, 10, OmegaBody);//{
				tempEntry.setUnlockKeys("masterUnlock", "omegaPenguin");
				tempEntry.shopDescription.addLevel(0, "We have rebuilt him. We have the technology.");
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1, 2.5, 30);
				
				tempEntry.statCost.addLevel(0, 20, 2.7);
				tempEntry.statCost.addLevel(10, 10000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 50000);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS + 1, 25000, 1.5);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 100000);
				
				tempEntry.statWeight.addLevel(0, 3);
				
				tempEntry.statTopSpeed.addLevel(0, 10);
				tempEntry.statTopSpeed.addLevel(10, 40, 1.3);
				tempEntry.statTopSpeed.addLevel(10 + Global.OVER_LEVELS, 120);
				tempEntry.statTopSpeed.addLevel(10 + Global.MEGA_LEVELS, 300);
				
				tempEntry.statTorque.addLevel(0, 0.15);
				tempEntry.statTorque.addLevel(10, 0.2);
				tempEntry.statTorque.addLevel(10 + Global.MEGA_LEVELS, 0.25);
				
				tempEntry.statStageSlots.addLevel(0, 1);
				tempEntry.statStageSlots.addLevel(2, 2);
				tempEntry.statStageSlots.addLevel(6, 3);
				tempEntry.statStageSlots.addLevel(9, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 1);
				tempEntry.statBoostSlots.addLevel(4, 2);
				tempEntry.statBoostSlots.addLevel(8, 3);
				tempEntry.statBoostSlots.addLevel(10, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(4, "Boost Slots", tempEntry.statBoostSlots);
			//}
			
			tempEntry = addEntry("crate", "Crate", TYPE_BODY, 4, Crate);//{
				tempEntry.shopDescription.addLevel(0, "This cardboard is pretty thick. Space-grade I'd say.");
				tempEntry.shopDescription.addLevel(2, "Plastic beats cardboard, and there are speed holes too.");
				tempEntry.shopDescription.addLevel(4, "Nothing says space-program like a wooden box.");
				tempEntry.specialIds.addLevel(2, "crate2");
				tempEntry.specialIds.addLevel(4, "crate3");
				
				tempEntry.gameClass.addLevel(2, Crate2);
				tempEntry.gameClass.addLevel(4, Crate3);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1, 2.5, 30);
				tempEntry.statZoomAtSpeed.addLevel(4 + Global.MEGA_LEVELS, 1.5, 3, 30);
				
				tempEntry.statCost.addLevel(0, 20);
				tempEntry.statCost.addLevel(1, 15);
				tempEntry.statCost.addLevel(2, 25);
				tempEntry.statCost.addLevel(3, 35);
				tempEntry.statCost.addLevel(4, 50, 2);
				tempEntry.statCost.addLevel(4 + Global.OVER_LEVELS, 10000, 1.5);
				tempEntry.statCost.addLevel(4 + Global.MEGA_LEVELS, 25000);
				
				tempEntry.statWeight.addLevel(0, 5);
				
				tempEntry.statTopSpeed.addLevel(0, 8);
				tempEntry.statTopSpeed.addLevel(4, 12, 1.2);
				tempEntry.statTopSpeed.addLevel(4 + Global.OVER_LEVELS, 55);
				tempEntry.statTopSpeed.addLevel(4 + Global.MEGA_LEVELS, 125);
				
				tempEntry.statTorque.addLevel(0, 0.15);
				
				tempEntry.statStageSlots.addLevel(0, 2);
				tempEntry.statStageSlots.addLevel(4, 2);
				tempEntry.statStageSlots.addLevel(4 + 5, 3);
				tempEntry.statStageSlots.addLevel(4 + Global.OVER_LEVELS + 1, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 1);
				tempEntry.statBoostSlots.addLevel(4, 2);
				tempEntry.statBoostSlots.addLevel(4 + Global.OVER_LEVELS, 3);
				tempEntry.statBoostSlots.addLevel(4 + Global.OVER_LEVELS + 20, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(4, "Boost Slots", tempEntry.statBoostSlots);
			//}
			
			tempEntry = addEntry("trashCan", "Trash Can", TYPE_BODY, 4, TrashCan);//{
				tempEntry.shopDescription.addLevel(0, "Superior aerodynamics through the use of banana.");
				tempEntry.shopDescription.addLevel(2, "Less trash makes it less comfy but lighter too.");
				tempEntry.shopDescription.addLevel(4, "Recycling is superior to garbage in flight too!");
				tempEntry.specialIds.addLevel(2, "trashCan2");
				tempEntry.specialIds.addLevel(4, "trashCan3");
				
				tempEntry.gameClass.addLevel(2, TrashCan2);
				tempEntry.gameClass.addLevel(4, TrashCan3);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1, 2.5, 30);
				
				tempEntry.statCost.addLevel(0, 12);
				tempEntry.statCost.addLevel(1, 10);
				tempEntry.statCost.addLevel(2, 15);
				tempEntry.statCost.addLevel(3, 25);
				tempEntry.statCost.addLevel(4, 40, 2);
				tempEntry.statCost.addLevel(4 + Global.OVER_LEVELS, 10000, 1.5);
				tempEntry.statCost.addLevel(4 + Global.MEGA_LEVELS, 25000);
				
				tempEntry.statWeight.addLevel(0, 4, 10000);
				tempEntry.statWeight.addLevel(2, 3.5, 10000);
				tempEntry.statWeight.addLevel(4, 5, 2);
				
				tempEntry.statTopSpeed.addLevel(0, 8);
				tempEntry.statTopSpeed.addLevel(4, 12, 1.2);
				tempEntry.statTopSpeed.addLevel(4 + Global.OVER_LEVELS, 55);
				tempEntry.statTopSpeed.addLevel(4 + Global.MEGA_LEVELS, 125);
				
				tempEntry.statTorque.addLevel(0, 0.15);
				
				tempEntry.statStageSlots.addLevel(0, 1);
				tempEntry.statStageSlots.addLevel(4 + 5, 2);
				tempEntry.statStageSlots.addLevel(4 + Global.OVER_LEVELS + 10, 3);
				tempEntry.statStageSlots.addLevel(4 + Global.OVER_LEVELS + 30, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				tempEntry.statBoostSlots.addLevel(4, 3);
				tempEntry.statBoostSlots.addLevel(4 + Global.OVER_LEVELS, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(4, "Boost Slots", tempEntry.statBoostSlots);
			//}
			
			tempEntry = addEntry("glider", "Glider", TYPE_BODY, 8, Glider);//{
				tempEntry.setUnlockKeys("masterUnlock");
				tempEntry.shopDescription.addLevel(0, "Has hearts on it so you know it's made with love.");
				tempEntry.shopDescription.addLevel(4, "It is light-blue colored to hide from predators while in the sky");
				tempEntry.shopDescription.addLevel(8, "You know it's high-tech because of the hexagonal pattern.");
				tempEntry.specialIds.addLevel(4, "glider2");
				tempEntry.specialIds.addLevel(8, "glider3");
				
				tempEntry.gameClass.addLevel(4, Glider2);
				tempEntry.gameClass.addLevel(8, Glider3);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1, 2.5, 30);
				tempEntry.statZoomAtSpeed.addLevel(8 + Global.MEGA_LEVELS, 1.5, 3, 30);
				
				tempEntry.statCost.addLevel(0, 35);
				tempEntry.statCost.addLevel(1, 40);
				tempEntry.statCost.addLevel(2, 55);
				tempEntry.statCost.addLevel(3, 65);
				tempEntry.statCost.addLevel(4, 80, 1.7);
				tempEntry.statCost.addLevel(8, 1000, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 10000, 1.5);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 50000);
				
				tempEntry.statWeight.addLevel(0, 4);
				
				tempEntry.statTopSpeed.addLevel(0, 10);
				tempEntry.statTopSpeed.addLevel(4, 14);
				tempEntry.statTopSpeed.addLevel(8, 25, 1.2);
				tempEntry.statTopSpeed.addLevel(8 + Global.OVER_LEVELS, 70);
				tempEntry.statTopSpeed.addLevel(8 + Global.MEGA_LEVELS, 200);
				
				tempEntry.statTorque.addLevel(0, 0.2);
				
				tempEntry.statStageSlots.addLevel(0, 1);
				tempEntry.statStageSlots.addLevel(2, 2);
				tempEntry.statStageSlots.addLevel(6, 3);
				tempEntry.statStageSlots.addLevel(8 + 5, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 1);
				tempEntry.statBoostSlots.addLevel(4, 2);
				tempEntry.statBoostSlots.addLevel(8, 3);
				tempEntry.statBoostSlots.addLevel(8 + Global.OVER_LEVELS, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(4, "Boost Slots", tempEntry.statBoostSlots);
			//}
			
			tempEntry = addEntry("jet", "Jet", TYPE_BODY, 8, Jet);//{
				tempEntry.shopDescription.addLevel(0, "I feel the need... the need for SPEED.");
				tempEntry.specialIds.addLevel(4, "jet2");
				
				tempEntry.gameClass.addLevel(4, Jet2);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1.5, 3, 30);
				
				tempEntry.statCost.addLevel(0, 750);
				tempEntry.statCost.addLevel(1, 500);
				tempEntry.statCost.addLevel(2, 600);
				tempEntry.statCost.addLevel(3, 700);
				tempEntry.statCost.addLevel(4, 1500);
				tempEntry.statCost.addLevel(5, 800);
				tempEntry.statCost.addLevel(6, 900);
				tempEntry.statCost.addLevel(7, 1000);
				tempEntry.statCost.addLevel(8, 5000);
				tempEntry.statCost.addLevel(8 + 1, 5000, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 10000, 1.5);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 50000);
				
				tempEntry.statWeight.addLevel(0, 15);
				
				tempEntry.statTopSpeed.addLevel(0, 18);
				tempEntry.statTopSpeed.addLevel(8, 35, 1.2);
				tempEntry.statTopSpeed.addLevel(8 + Global.OVER_LEVELS, 75);
				tempEntry.statTopSpeed.addLevel(8 + Global.MEGA_LEVELS, 225);
				
				tempEntry.statTorque.addLevel(0, 0.18);
				
				tempEntry.statStageSlots.addLevel(0, 2);
				tempEntry.statStageSlots.addLevel(4, 3);
				tempEntry.statStageSlots.addLevel(8 + 5, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 3);
				tempEntry.statBoostSlots.addLevel(8, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(4, "Boost Slots", tempEntry.statBoostSlots);
			//}
			
			tempEntry = addEntry("inlineBody", "Pixels", TYPE_BODY, 10, InlineBody);//{
				tempEntry.shopDescription.addLevel(0, "Back in my days we had a handful of pixels and that was enough to go for the entire year");
				tempEntry.specialIds.addLevel(4, "inlineBody2");
				tempEntry.specialIds.addLevel(8, "inlineBody3");
				
				tempEntry.gameClass.addLevel(4, InlineBody2);
				tempEntry.gameClass.addLevel(8, InlineBody3);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1.5, 3, 30);
				tempEntry.statZoomAtSpeed.addLevel(7, 1.5, 3, 30);
				tempEntry.statZoomAtSpeed.addLevel(8, 2, 3, 30);
				
				tempEntry.statCost.addLevel(0, 500);
				tempEntry.statCost.addLevel(1, 500, 1.5);
				tempEntry.statCost.addLevel(10, 7500);
				tempEntry.statCost.addLevel(10 + 1, 7000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 10000, 1.5);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 50000);
				
				tempEntry.statWeight.addLevel(0, 10, 9999);
				tempEntry.statWeight.addLevel(4, 8, 9999);
				tempEntry.statWeight.addLevel(8, 6, 9999);
				
				tempEntry.statTopSpeed.addLevel(0, 15);
				tempEntry.statTopSpeed.addLevel(10, 50, 1.2);
				tempEntry.statTopSpeed.addLevel(10 + Global.OVER_LEVELS, 80);
				tempEntry.statTopSpeed.addLevel(10 + Global.MEGA_LEVELS, 235);
				
				tempEntry.statTorque.addLevel(0, 0.17);
				
				tempEntry.statStageSlots.addLevel(0, 2);
				tempEntry.statStageSlots.addLevel(4, 3);
				tempEntry.statStageSlots.addLevel(8, 4);
				
				tempEntry.statBoostSlots.addLevel(2, 2);
				tempEntry.statBoostSlots.addLevel(6, 3);
				tempEntry.statBoostSlots.addLevel(10, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(4, "Boost Slots", tempEntry.statBoostSlots);
			//}
			
			
			tempEntry = addEntry("thunderbird", "Thonderburd 1", TYPE_BODY, 8, Thunderbird1);//{
				tempEntry.setUnlockKeys("masterUnlock", "thunderbird");
				
				tempEntry.shopDescription.addLevel(0, "Thonderburds are GO!");
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1.5, 3, 30);
				
				tempEntry.statCost.addLevel(0, 1000);
				tempEntry.statCost.addLevel(1, 800);
				tempEntry.statCost.addLevel(2, 900);
				tempEntry.statCost.addLevel(3, 1000);
				tempEntry.statCost.addLevel(4, 1500);
				tempEntry.statCost.addLevel(5, 1000);
				tempEntry.statCost.addLevel(6, 1100);
				tempEntry.statCost.addLevel(7, 1200);
				tempEntry.statCost.addLevel(8, 5500);
				tempEntry.statCost.addLevel(8 + 1, 5500, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 10000, 1.5);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 50000);
				
				tempEntry.statWeight.addLevel(0, 20);
				
				tempEntry.statTopSpeed.addLevel(0, 20);
				tempEntry.statTopSpeed.addLevel(8, 35, 1.2);
				tempEntry.statTopSpeed.addLevel(8 + Global.OVER_LEVELS, 75);
				tempEntry.statTopSpeed.addLevel(8 + Global.MEGA_LEVELS, 225);
				
				tempEntry.statTorque.addLevel(0, 0.17);
				
				tempEntry.statStageSlots.addLevel(0, 3);
				tempEntry.statStageSlots.addLevel(4, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				tempEntry.statBoostSlots.addLevel(8, 3);
				tempEntry.statBoostSlots.addLevel(8 + 5, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(4, "Boost Slots", tempEntry.statBoostSlots);
			//}
			
			tempEntry = addEntry("bullet", "The Bullet", TYPE_BODY, 4, Bullet);//{
				tempEntry.shopDescription.addLevel(0, "What goes fast? Bullets. How do you go fast? By being the bullet.");
				tempEntry.specialIds.addLevel(2, "bullet2");
				tempEntry.specialIds.addLevel(4, "bullet3");
				
				tempEntry.gameClass.addLevel(2, Bullet2);
				tempEntry.gameClass.addLevel(4, Bullet3);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1.5, 3, 30);
				
				tempEntry.statCost.addLevel(0, 1000);
				tempEntry.statCost.addLevel(1, 1000);
				tempEntry.statCost.addLevel(2, 2000);
				tempEntry.statCost.addLevel(3, 1000);
				tempEntry.statCost.addLevel(4, 6000);
				tempEntry.statCost.addLevel(4 + 1, 3000, 2);
				tempEntry.statCost.addLevel(4 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(4 + Global.MEGA_LEVELS, 100000);
				
				tempEntry.statWeight.addLevel(0, 30);
				
				tempEntry.statTopSpeed.addLevel(0, 30);
				tempEntry.statTopSpeed.addLevel(4, 50, 1.2);
				tempEntry.statTopSpeed.addLevel(4 + Global.OVER_LEVELS, 90);
				tempEntry.statTopSpeed.addLevel(4 + Global.MEGA_LEVELS, 350);
				
				tempEntry.statTorque.addLevel(0, 0.025);
				
				tempEntry.statStageSlots.addLevel(0, 3);
				tempEntry.statStageSlots.addLevel(4, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 0);
				tempEntry.statBoostSlots.addLevel(2, 1);
				tempEntry.statBoostSlots.addLevel(4 + 5, 2);
				tempEntry.statBoostSlots.addLevel(4 + Global.OVER_LEVELS, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(4, "Boost Slots", tempEntry.statBoostSlots);
			//}
			
			tempEntry = addEntry("spearhead", "Spearhead", TYPE_BODY, 4, Spearhead);//{
				tempEntry.setUnlockKeys("masterUnlock", "spearhead");
				tempEntry.shopDescription.addLevel(0, "Fastest ship we got. Shame it cannot be controlled...");
				tempEntry.specialIds.addLevel(2, "spearhead2");
				tempEntry.specialIds.addLevel(4, "spearhead3");
				
				tempEntry.gameClass.addLevel(2, Spearhead2);
				tempEntry.gameClass.addLevel(4, Spearhead3);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1.5, 3, 30);
				
				tempEntry.statCost.addLevel(0, 600);
				tempEntry.statCost.addLevel(1, 1200);
				tempEntry.statCost.addLevel(2, 2400);
				tempEntry.statCost.addLevel(3, 4000);
				tempEntry.statCost.addLevel(4, 6000);
				tempEntry.statCost.addLevel(4 + 1, 3000, 2);
				tempEntry.statCost.addLevel(4 + Global.OVER_LEVELS, 12000);
				tempEntry.statCost.addLevel(4 + Global.MEGA_LEVELS, 100000);
				
				tempEntry.statWeight.addLevel(0, 15);
				
				tempEntry.statTopSpeed.addLevel(0, 25);
				tempEntry.statTopSpeed.addLevel(4, 60, 1.2);
				tempEntry.statTopSpeed.addLevel(4 + Global.OVER_LEVELS, 125);
				tempEntry.statTopSpeed.addLevel(4 + Global.MEGA_LEVELS, 375);
				
				tempEntry.statTorque.addLevel(0, 0.002);
				
				tempEntry.statStageSlots.addLevel(0, 1);
				tempEntry.statStageSlots.addLevel(2, 2);
				tempEntry.statStageSlots.addLevel(3, 3);
				tempEntry.statStageSlots.addLevel(4, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 0);
				tempEntry.statBoostSlots.addLevel(2, 1);
				tempEntry.statBoostSlots.addLevel(4, 2);
				tempEntry.statBoostSlots.addLevel(4 + 5, 3);
				tempEntry.statBoostSlots.addLevel(4 + Global.OVER_LEVELS, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(4, "Boost Slots", tempEntry.statBoostSlots);
			//}
			
			tempEntry = addEntry("shuttle", "Space Shuttle", TYPE_BODY, 10, Shuttle);//{
				tempEntry.shopDescription.addLevel(0, "Like new 1961 USSR space material, mint condition and lightly used.");
				tempEntry.shopDescription.addLevel(5, "Refurbished NASA orbiter with a 7-days money-back guarantee!");
				tempEntry.shopDescription.addLevel(10, "First original, all penguin-labor space shuttle.");
				tempEntry.specialIds.addLevel(5, "shuttle2");
				tempEntry.specialIds.addLevel(10, "shuttle3");
				
				tempEntry.gameClass.addLevel(5, Shuttle2);
				tempEntry.gameClass.addLevel(10, Shuttle3);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 2.2, 3, 30);
				
				tempEntry.statCost.addLevel(0, 3500);
				tempEntry.statCost.addLevel(1, 1500);
				tempEntry.statCost.addLevel(2, 1750);
				tempEntry.statCost.addLevel(3, 2000);
				tempEntry.statCost.addLevel(4, 2250);
				tempEntry.statCost.addLevel(5, 7500);
				tempEntry.statCost.addLevel(6, 2500);
				tempEntry.statCost.addLevel(7, 2750);
				tempEntry.statCost.addLevel(8, 3000);
				tempEntry.statCost.addLevel(9, 3250);
				tempEntry.statCost.addLevel(10, 3500, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 100000);
				
				tempEntry.statWeight.addLevel(0, 40);
				tempEntry.statWeight.addLevel(10, 40);
				tempEntry.statWeight.addLevel(10 + Global.OVER_LEVELS, 30);
				
				tempEntry.statTopSpeed.addLevel(0, 20);
				tempEntry.statTopSpeed.addLevel(10, 35, 1.2);
				tempEntry.statTopSpeed.addLevel(10 + Global.OVER_LEVELS, 80);
				tempEntry.statTopSpeed.addLevel(10 + Global.MEGA_LEVELS, 300);
				
				tempEntry.statTorque.addLevel(0, 0.08);
				tempEntry.statTorque.addLevel(10 + Global.MEGA_LEVELS, 0.15);
				
				tempEntry.statStageSlots.addLevel(0, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 3);
				tempEntry.statBoostSlots.addLevel(5, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(4, "Boost Slots", tempEntry.statBoostSlots);
				//}
			
			tempEntry = addEntry("omegaShuttle", "Omega Shuttle", TYPE_BODY, 10, OmegaShuttle);//{
				tempEntry.setUnlockKeys("masterUnlock", "omegaShuttle");
				tempEntry.shopDescription.addLevel(0, "Its technology was passed on to us by The Great One in a dream.");
				
				tempEntry.statZoomAtSpeed.addLevel(0, 2.2, 3, 30);
				
				tempEntry.statCost.addLevel(0, 50000);
				tempEntry.statCost.addLevel(1, 25000, 1.5);
				tempEntry.statCost.addLevel(10, 50000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 50000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 500000);
				
				tempEntry.statWeight.addLevel(0, 60);
				
				tempEntry.statTopSpeed.addLevel(0, 50);
				tempEntry.statTopSpeed.addLevel(10, 90, 1.2);
				tempEntry.statTopSpeed.addLevel(10 + Global.OVER_LEVELS, 225);
				tempEntry.statTopSpeed.addLevel(10 + Global.MEGA_LEVELS, 500);
				
				tempEntry.statTorque.addLevel(0, 0.12);
				
				tempEntry.statStageSlots.addLevel(0, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(4, "Boost Slots", tempEntry.statBoostSlots);
				//}
			
			tempEntry = addEntry("dodo", "Dodo", TYPE_BODY, 10, Dodo);//{
				tempEntry.setUnlockKeys("masterUnlock", "dodoBody");
				tempEntry.shopDescription.addLevel(0, "Got so pissed at us that he wanted to prove dodos fly too.");
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1, 2.5, 30);
				
				tempEntry.statCost.addLevel(0, 40, 2.4);
				tempEntry.statCost.addLevel(10, 12000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 25000);
				
				tempEntry.statWeight.addLevel(0, 8);
				
				tempEntry.statTopSpeed.addLevel(0, 12);
				tempEntry.statTopSpeed.addLevel(10, 35);
				tempEntry.statTopSpeed.addLevel(10 + Global.OVER_LEVELS, 50);
				tempEntry.statTopSpeed.addLevel(10 + Global.MEGA_LEVELS, 80);
				
				tempEntry.statTorque.addLevel(0, 0.04);
				tempEntry.statTorque.addLevel(10, 0.09);
				tempEntry.statTorque.addLevel(10 + Global.MEGA_LEVELS, 0.15);
				
				tempEntry.statStageSlots.addLevel(0, 0);
				tempEntry.statStageSlots.addLevel(4, 1);
				tempEntry.statStageSlots.addLevel(8, 2);
				tempEntry.statStageSlots.addLevel(10, 3);
				tempEntry.statStageSlots.addLevel(20, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 0);
				tempEntry.statBoostSlots.addLevel(2, 1);
				tempEntry.statBoostSlots.addLevel(6, 2);
				tempEntry.statBoostSlots.addLevel(10, 3);
				tempEntry.statBoostSlots.addLevel(15, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(4, "Boost Slots", tempEntry.statBoostSlots);
			//}
			
			tempEntry = addEntry("hedgehog", "Hedgehog Suit", TYPE_BODY, 10, Hedgehog);//{
				tempEntry.setUnlockKeys("masterUnlock", "hedgehog");
				
				tempEntry.shopDescription.addLevel(0, "Inspired by the renowned hedgehog space program, you'll get extra fundings when wearing this suit.");
				tempEntry.specialIds.addLevel(5, "hedgehog2");
				tempEntry.specialIds.addLevel(10, "hedgehog3");
				
				tempEntry.gameClass.addLevel(5, Hedgehog2);
				tempEntry.gameClass.addLevel(10, Hedgehog3);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1, 2.5, 30);
				
				tempEntry.statCost.addLevel(0, 100);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 125);
				tempEntry.statCost.addLevel(3, 200, 2);
				tempEntry.statCost.addLevel(10, 5000, 1.5);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 75000);
				
				tempEntry.statWeight.addLevel(0, 5);
				
				tempEntry.statTopSpeed.addLevel(0, 8, 1.4);
				tempEntry.statTopSpeed.addLevel(10, 18, 1.2);
				tempEntry.statTopSpeed.addLevel(10 + Global.OVER_LEVELS, 65);
				tempEntry.statTopSpeed.addLevel(10 + Global.MEGA_LEVELS, 150);
				
				tempEntry.statTorque.addLevel(0, 0.2);
				
				tempEntry.statSpecial.addLevel(0, 1.1, 1.4);//Cash mult
				tempEntry.statSpecial.addLevel(10, 1.25);
				tempEntry.statSpecial.addLevel(10 + Global.OVER_LEVELS, 1.55);
				tempEntry.statSpecial.addLevel(10 + Global.MEGA_LEVELS, 2);
				
				tempEntry.statStageSlots.addLevel(0, 1);
				tempEntry.statStageSlots.addLevel(3, 2);
				tempEntry.statStageSlots.addLevel(8, 3);
				tempEntry.statStageSlots.addLevel(10 + Global.OVER_LEVELS, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 1);
				tempEntry.statBoostSlots.addLevel(6, 2);
				tempEntry.statBoostSlots.addLevel(10, 3);
				tempEntry.statBoostSlots.addLevel(10 + Global.OVER_LEVELS + 10, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Money Mult", tempEntry.statSpecial, 3);
				tempEntry.setDisplayStat(4, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(5, "Boost Slots", tempEntry.statBoostSlots);
				//tempEntry.setDisplayStat(4, "Pod Fuel", tempEntry.statFuel);
			//}
			
			tempEntry = addEntry("rocketKit", "Rocket Kit", TYPE_BODY, 8, RocketKit);//{
				tempEntry.shopDescription.addLevel(0, "Be - the - rocket");
				tempEntry.specialIds.addLevel(4, "rocketKit2");
				tempEntry.specialIds.addLevel(8, "rocketKit3");
				
				tempEntry.gameClass.addLevel(4, RocketKit2);
				tempEntry.gameClass.addLevel(8, RocketKit3);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1, 3, 30);
				
				tempEntry.statCost.addLevel(0, 450, 2);
				tempEntry.statCost.addLevel(8, 1000, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 125000);
				
				tempEntry.statWeight.addLevel(0, 10, 9999);
				tempEntry.statWeight.addLevel(4, 12, 9999);
				tempEntry.statWeight.addLevel(8, 14, 9999);
				
				tempEntry.statTopSpeed.addLevel(0, 12);
				tempEntry.statTopSpeed.addLevel(8, 20, 1.2);
				tempEntry.statTopSpeed.addLevel(8 + Global.OVER_LEVELS, 70);
				tempEntry.statTopSpeed.addLevel(8 + Global.MEGA_LEVELS, 250);
				
				tempEntry.statTorque.addLevel(0, 0.15);
				
				tempEntry.statPower.addLevel(0, 3);//Stage power mult, DISPLAY ONLY! for actual stat go to "rocketKitStage"
				tempEntry.statPower.addLevel(8, 4);
				tempEntry.statPower.addLevel(8 + Global.OVER_LEVELS, 6);
				tempEntry.statPower.addLevel(8 + Global.MEGA_LEVELS, 10);
				
				tempEntry.statFuel.addLevel(0, 600);//DISPLAY ONLY! for actual stat go to "rocketKitStage"
				tempEntry.statFuel.addLevel(8, 1800);
				tempEntry.statFuel.addLevel(8 + Global.OVER_LEVELS, 2500);
				tempEntry.statFuel.addLevel(8 + Global.MEGA_LEVELS, 6000);
				
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "rocketKitStage");
				
				tempEntry.statStageSlots.addLevel(0, 0);
				tempEntry.statStageSlots.addLevel(4, 1);
				tempEntry.statStageSlots.addLevel(8 + Global.OVER_LEVELS, 2);
				tempEntry.statStageSlots.addLevel(8 + Global.OVER_LEVELS + 25, 3);
				tempEntry.statStageSlots.addLevel(8 + Global.OVER_LEVELS + 50, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				tempEntry.statBoostSlots.addLevel(8, 3);
				tempEntry.statBoostSlots.addLevel(8 + Global.OVER_LEVELS + 10, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Rocket Power", tempEntry.statPower);
				tempEntry.setDisplayStat(4, "Rocket Fuel", tempEntry.statFuel);
			//}
			
			tempEntry = addEntry("rocketKitStage", "", TYPE_MISC, 8, RocketKitStage);//{ //MISC, not an actual stage but an addon stage for RocketKit body
				tempEntry.setUnlockKeys("hidden");
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.RocketKitStageVisual"));
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statWeight.addLevel(0, 0);
				
				tempEntry.statSound1.addLevel(0, Fire1);
				tempEntry.statSound1Volume.addLevel(0, 0.9);
				
				tempEntry.statPower.addLevel(0, 3);
				tempEntry.statPower.addLevel(8, 4);
				tempEntry.statPower.addLevel(8 + Global.OVER_LEVELS, 6);
				tempEntry.statPower.addLevel(8 + Global.MEGA_LEVELS, 10);
				
				tempEntry.statFuel.addLevel(0, 600);
				tempEntry.statFuel.addLevel(8, 1800);
				tempEntry.statFuel.addLevel(8 + Global.OVER_LEVELS, 2800);
				tempEntry.statFuel.addLevel(8 + Global.MEGA_LEVELS, 6000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.05, 20, 30);
			//}
			
			tempEntry = addEntry("bigBird", "Big B.I.R.D.", TYPE_BODY, 10, BigBird);//{
				tempEntry.setUnlockKeys("masterUnlock");
				tempEntry.specialIds.addLevel(5, "bigBird2");
				
				tempEntry.gameClass.addLevel(5, BigBird2);
				tempEntry.shopDescription.addLevel(0, "Large Beryllium Induction Reactor Drive. We call it big bird.");
				tempEntry.shopDescription.addLevel(5, "The added wings give much needed control during flight.");
				
				tempEntry.statZoomAtSpeed.addLevel(0, 2.2, 3, 30);
				
				tempEntry.statCost.addLevel(0, 5000, 2);
				tempEntry.statCost.addLevel(1, 5000, 2);
				tempEntry.statCost.addLevel(2, 6000, 2);
				tempEntry.statCost.addLevel(3, 7000, 2);
				tempEntry.statCost.addLevel(4, 8500, 2);
				tempEntry.statCost.addLevel(5, 11000, 2);
				tempEntry.statCost.addLevel(10, 18000, 2);
				tempEntry.statCost.addLevel(10 + 1, 15000, 1.45);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 110000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 200000);
				
				tempEntry.statWeight.addLevel(0, 250, 9999);
				
				tempEntry.statTopSpeed.addLevel(0, 15);
				tempEntry.statTopSpeed.addLevel(10, 40, 1.2);
				tempEntry.statTopSpeed.addLevel(10 + Global.OVER_LEVELS, 90);
				tempEntry.statTopSpeed.addLevel(10 + Global.MEGA_LEVELS, 350);
				
				tempEntry.statTorque.addLevel(0, 0.02, 0);
				tempEntry.statTorque.addLevel(4, 0.02, 0);
				tempEntry.statTorque.addLevel(5, 0.075);
				tempEntry.statTorque.addLevel(10 + Global.MEGA_LEVELS, 0.1);
				
				tempEntry.statPower.addLevel(0, 3);//Stage power mult, DISPLAY ONLY! for actual stat go to "rocketKitStage"
				tempEntry.statPower.addLevel(10, 6);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 10);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 25);
				
				tempEntry.statFuel.addLevel(0, 2000);//DISPLAY ONLY! for actual stat go to "rocketKitStage"
				tempEntry.statFuel.addLevel(10, 9500);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 20000, 1.2);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 60000);
				
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "bigBirdStage");
				
				tempEntry.statStageSlots.addLevel(0, 0);
				
				tempEntry.statBoostSlots.addLevel(0, 0);
				tempEntry.statBoostSlots.addLevel(10, 1);
				tempEntry.statBoostSlots.addLevel(10 + 10, 2);
				tempEntry.statBoostSlots.addLevel(10 + 20, 3);
				tempEntry.statBoostSlots.addLevel(10 + 30, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Rocket Power", tempEntry.statPower);
				tempEntry.setDisplayStat(4, "Rocket Fuel", tempEntry.statFuel);
			//}
			
			tempEntry = addEntry("bigBirdStage", "", TYPE_MISC, 10, BigBirdStage);//{ //MISC, not an actual stage but an addon stage for RocketKit body
				tempEntry.setUnlockKeys("hidden");
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.BigBirdStageVisual"));
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statWeight.addLevel(0, 0);
				
				tempEntry.statSound1.addLevel(0, Fire1);
				tempEntry.statSound1Volume.addLevel(0, 0.9);
				
				tempEntry.statPower.addLevel(0, 3);
				tempEntry.statPower.addLevel(10, 6);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 10);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 25);
				
				tempEntry.statFuel.addLevel(0, 2000);
				tempEntry.statFuel.addLevel(10, 9500);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 20000, 1.2);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 60000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.25, 350, 350);
			//}
			
			tempEntry = addEntry("beerKeg", "Beer Keg", TYPE_BODY, 8, BeerKeg);//{
				tempEntry.setUnlockKeys("masterUnlock", "beerKeg");
				tempEntry.shopDescription.addLevel(0, "Because it's cheaper than jet fuel!");
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1, 3, 30);
				
				tempEntry.statCost.addLevel(0, 650, 2);
				tempEntry.statCost.addLevel(8, 1250, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 100000);
				
				tempEntry.statWeight.addLevel(0, 18, 9999);
				
				tempEntry.statTopSpeed.addLevel(0, 12);
				tempEntry.statTopSpeed.addLevel(8, 20, 1.2);
				tempEntry.statTopSpeed.addLevel(8 + Global.OVER_LEVELS, 64);
				tempEntry.statTopSpeed.addLevel(Global.MEGA_LEVELS, 250);
				
				tempEntry.statTorque.addLevel(0, 0.15);
				
				tempEntry.statPower.addLevel(0, 4);//Stage power mult, DISPLAY ONLY! for actual stat go to "rocketKitStage"
				tempEntry.statPower.addLevel(8, 5);
				tempEntry.statPower.addLevel(8 + Global.OVER_LEVELS, 9);
				tempEntry.statPower.addLevel(8 + Global.MEGA_LEVELS, 40);
				
				tempEntry.statFuel.addLevel(0, 100);//DISPLAY ONLY! for actual stat go to "rocketKitStage"
				tempEntry.statFuel.addLevel(8, 400);
				tempEntry.statFuel.addLevel(8 + Global.OVER_LEVELS, 900);
				tempEntry.statFuel.addLevel(8 + Global.MEGA_LEVELS, 2500);
				
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "beerKegStage");
				
				tempEntry.statStageSlots.addLevel(0, 2);
				tempEntry.statStageSlots.addLevel(4, 3);
				tempEntry.statStageSlots.addLevel(8 + Global.OVER_LEVELS, 3);
				tempEntry.statStageSlots.addLevel(8 + Global.OVER_LEVELS + 50, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				tempEntry.statBoostSlots.addLevel(8, 3);
				tempEntry.statBoostSlots.addLevel(8 + Global.OVER_LEVELS + 25, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Rocket Power", tempEntry.statPower);
				tempEntry.setDisplayStat(4, "Rocket Fuel", tempEntry.statFuel);
			//}
			
			tempEntry = addEntry("beerKegStage", "", TYPE_MISC, 8, BeerKegStage);//{ //MISC, not an actual stage but an addon stage for RocketKit body
				tempEntry.setUnlockKeys("hidden");
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.BeerKegStageVisual"));
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statWeight.addLevel(0, 0);
				
				tempEntry.statPower.addLevel(0, 4);
				tempEntry.statPower.addLevel(8, 5);
				tempEntry.statPower.addLevel(8 + Global.OVER_LEVELS, 9);
				tempEntry.statPower.addLevel(8 + Global.MEGA_LEVELS, 40);
				
				tempEntry.statFuel.addLevel(0, 100);
				tempEntry.statFuel.addLevel(8, 400);
				tempEntry.statFuel.addLevel(8 + Global.OVER_LEVELS, 900);
				tempEntry.statFuel.addLevel(8 + Global.MEGA_LEVELS, 2500);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.2, 50, 50);
			//}
				
			tempEntry = addEntry("rocketeer", "Jetpack", TYPE_BODY, 10, Rocketeer);//{
				tempEntry.setUnlockKeys("masterUnlock", "rocketeer");
				
				tempEntry.shopDescription.addLevel(0, "It's a Jet pack. What more do you need to hear? A JET PACK!");
				tempEntry.specialIds.addLevel(5, "rocketeer2");
				tempEntry.specialIds.addLevel(10, "rocketeer3");
				
				tempEntry.gameClass.addLevel(5, Rocketeer2);
				tempEntry.gameClass.addLevel(10, Rocketeer3);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1, 3, 30);
				
				tempEntry.statCost.addLevel(0, 1000, 2);
				tempEntry.statCost.addLevel(1, 1000, 2.5);
				tempEntry.statCost.addLevel(10, 12000);
				tempEntry.statCost.addLevel(10 + 1, 6000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 150000);
				
				tempEntry.statWeight.addLevel(0, 10, 0);
				tempEntry.statWeight.addLevel(5, 13, 0);
				tempEntry.statWeight.addLevel(10, 16);
				
				tempEntry.statTopSpeed.addLevel(0, 8);
				tempEntry.statTopSpeed.addLevel(10, 20, 1.2);
				tempEntry.statTopSpeed.addLevel(10 + Global.OVER_LEVELS, 62);
				tempEntry.statTopSpeed.addLevel(10 + Global.MEGA_LEVELS, 250);
				
				tempEntry.statTorque.addLevel(0, 0.3);
				
				tempEntry.statPower.addLevel(0, 5);//Stage power mult, DISPLAY ONLY! for actual stat go to "rocketeerStage"
				tempEntry.statPower.addLevel(10, 10);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 14);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 24);
				
				tempEntry.statFuel.addLevel(0, 1000, 1.4);//DISPLAY ONLY! for actual stat go to "rocketeerStage"
				tempEntry.statFuel.addLevel(10, 3500);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 5500);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 10000);
				
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "rocketeerStage");
				
				tempEntry.statStageSlots.addLevel(0, 0);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				tempEntry.statBoostSlots.addLevel(5, 3);
				tempEntry.statBoostSlots.addLevel(10, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Jetpack Power", tempEntry.statPower);
				tempEntry.setDisplayStat(4, "Jetpack Fuel", tempEntry.statFuel);
			//}
			
			tempEntry = addEntry("rocketeerStage", "", TYPE_MISC, 10, RocketeerStage);//{ //MISC, not an actual stage but an addon stage for Rocketeer body
				tempEntry.setUnlockKeys("hidden");
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.RocketeerStageVisual"));
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statWeight.addLevel(0, 0);
				
				//tempEntry.statSound1.addLevel(0, Fire1);
				tempEntry.statSound1.addLevel(0, JetSound3);
				tempEntry.statSound1Volume.addLevel(0, 0.75);
				
				tempEntry.statPower.addLevel(0, 5);//Stage power mult, DISPLAY ONLY! for actual stat go to "rocketeerStage"
				tempEntry.statPower.addLevel(10, 10);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 14);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 24);
				
				tempEntry.statFuel.addLevel(0, 1000, 1.4);//DISPLAY ONLY! for actual stat go to "rocketeerStage"
				tempEntry.statFuel.addLevel(10, 3500);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 5500);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 10000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1, 20, 20);
			//}
			
			tempEntry = addEntry("superman", "Hero Costume", TYPE_BODY, 10, Superman);//{
				tempEntry.setUnlockKeys("masterUnlock", "superman");
				
				tempEntry.shopDescription.addLevel(0, "Hero costume that INCLUDES the super-powers!");
				tempEntry.shopDescription.addLevel(5, "I can see the code... man the developer sucks");
				tempEntry.shopDescription.addLevel(10, "IT'S OVER NINE THOUSAAAAAAAAAAAND");
				tempEntry.specialIds.addLevel(5, "superman2");
				tempEntry.specialIds.addLevel(10, "superman3");
				
				tempEntry.gameClass.addLevel(5, Superman2);
				tempEntry.gameClass.addLevel(10, Superman3);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1, 2.5, 30);
				
				tempEntry.statCost.addLevel(0, 4000, 2);
				tempEntry.statCost.addLevel(0, 3250, 1.5);
				tempEntry.statCost.addLevel(10, 15000);
				tempEntry.statCost.addLevel(10 + 1, 5000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 25000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 150000);
				
				tempEntry.statWeight.addLevel(0, 10);
				tempEntry.statWeight.addLevel(0, 25);
				
				tempEntry.statTopSpeed.addLevel(0, 18);
				tempEntry.statTopSpeed.addLevel(10, 28, 1.1);
				tempEntry.statTopSpeed.addLevel(10 + Global.OVER_LEVELS, 48);
				tempEntry.statTopSpeed.addLevel(10 + Global.MEGA_LEVELS, 300);
				
				tempEntry.statTorque.addLevel(0, 0.45);
				tempEntry.statTorque.addLevel(10, 0.40);
				tempEntry.statTorque.addLevel(10 + Global.OVER_LEVELS, 0.35);
				
				tempEntry.statPower.addLevel(0, 10);//Stage power mult, DISPLAY ONLY! for actual stat go to "supermanStage"
				tempEntry.statPower.addLevel(9, 20);
				tempEntry.statPower.addLevel(10, 9001);//JOKE for super sayan, not actual stage power
				tempEntry.statPower.addLevel(11, 25);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 75);
				
				tempEntry.statFuel.addLevel(0, 1600, 1.4);//DISPLAY ONLY! for actual stat go to "supermanStage"
				tempEntry.statFuel.addLevel(10, 3600);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 6000);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 9000);
				
				
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "supermanStage");
				
				tempEntry.statStageSlots.addLevel(0, 0);
				
				tempEntry.statBoostSlots.addLevel(0, 0);
				tempEntry.statBoostSlots.addLevel(5, 1);
				tempEntry.statBoostSlots.addLevel(10, 2);
				tempEntry.statBoostSlots.addLevel(10 + 5, 3);
				tempEntry.statBoostSlots.addLevel(10 + Global.OVER_LEVELS, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Flight Power", tempEntry.statPower);
				tempEntry.setDisplayStat(4, "Flight Time", tempEntry.statFuel);
			//}
			
			tempEntry = addEntry("supermanStage", "", TYPE_MISC, 10, SupermanStage);//{ //MISC, not an actual stage but an addon stage for Superman body
				tempEntry.setUnlockKeys("hidden");
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.SupermanStageVisual"));
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statWeight.addLevel(0, 0);
				
				tempEntry.statPower.addLevel(0, 30);
				
				tempEntry.statFuel.addLevel(0, 1600, 1.4);
				tempEntry.statFuel.addLevel(10, 3600);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 6000);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 9000);
				
				tempEntry.statSpecial.addLevel(0, 0.94, 1.2);//Constant drag to give this boost a special feel
				tempEntry.statSpecial.addLevel(10, 0.96);//Constant drag to give this boost a special feel
				tempEntry.statSpecial.addLevel(10 + Global.OVER_LEVELS, 0.975);//Constant drag to give this boost a special feel
				tempEntry.statSpecial.addLevel(10 + Global.OVER_LEVELS, 0.99);//Constant drag to give this boost a special feel
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.15, 30, 35);
				//}
				
			tempEntry = addEntry("captainSupporter", "Capt. Supporter", TYPE_BODY, 10, CaptainSupporter);//{
				tempEntry.setUnlockKeys("masterUnlock");
				
				tempEntry.shopDescription.addLevel(0, "With the power of extra money!");
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1, 2.5, 30);
				
				tempEntry.statCost.addLevel(0, 3000, 2);
				tempEntry.statCost.addLevel(0, 2000, 1.5);
				tempEntry.statCost.addLevel(10, 15000);
				tempEntry.statCost.addLevel(10 + 1, 5000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 160000);
				
				tempEntry.statWeight.addLevel(0, 10);
				
				tempEntry.statTopSpeed.addLevel(0, 15);
				tempEntry.statTopSpeed.addLevel(10, 25);
				tempEntry.statTopSpeed.addLevel(10 + Global.OVER_LEVELS, 50);
				tempEntry.statTopSpeed.addLevel(10 + Global.MEGA_LEVELS, 315);
				
				tempEntry.statTorque.addLevel(0, 0.45);
				tempEntry.statTorque.addLevel(10, 0.40);
				tempEntry.statTorque.addLevel(10 + Global.OVER_LEVELS, 0.35);
				
				tempEntry.statPower.addLevel(0, 8);//Stage power mult, DISPLAY ONLY! for actual stat go to "supermanStage"
				tempEntry.statPower.addLevel(9, 16);//Stage power mult, DISPLAY ONLY! for actual stat go to "supermanStage"
				tempEntry.statPower.addLevel(10, 20);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 40);
				
				tempEntry.statFuel.addLevel(0, 2000);//DISPLAY ONLY! for actual stat go to "supermanStage"
				tempEntry.statFuel.addLevel(10, 3850);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 5400);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 10000);
				
				tempEntry.statSpecial.addLevel(0, 1.05, 1.4);//Cash mult
				tempEntry.statSpecial.addLevel(10, 1.20);
				tempEntry.statSpecial.addLevel(10 + Global.OVER_LEVELS, 1.5);
				tempEntry.statSpecial.addLevel(10 + Global.MEGA_LEVELS, 2);
				
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "captainSupporterStage");
				
				tempEntry.statStageSlots.addLevel(0, 0);
				
				tempEntry.statBoostSlots.addLevel(0, 0);
				tempEntry.statBoostSlots.addLevel(5, 1);
				tempEntry.statBoostSlots.addLevel(10, 2);
				tempEntry.statBoostSlots.addLevel(10 + 5, 3);
				tempEntry.statBoostSlots.addLevel(10 + Global.OVER_LEVELS, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Flight Power", tempEntry.statPower);
				tempEntry.setDisplayStat(4, "Cash Mult", tempEntry.statSpecial);
			//}
			
			tempEntry = addEntry("captainSupporterStage", "", TYPE_MISC, 10, SupermanStage);//{ //MISC, not an actual stage but an addon stage for Superman body
				tempEntry.setUnlockKeys("hidden");
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.SupermanStageVisual"));
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statWeight.addLevel(0, 0);
				
				tempEntry.statPower.addLevel(0, 25);
				
				tempEntry.statFuel.addLevel(0, 1800);
				tempEntry.statFuel.addLevel(10, 3850);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 5400);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 10000);
				
				tempEntry.statSpecial.addLevel(0, 0.94);//Constant drag to give this boost a special feel
				tempEntry.statSpecial.addLevel(10, 0.96);//Constant drag to give this boost a special feel
				tempEntry.statSpecial.addLevel(10 + Global.OVER_LEVELS, 0.975);//Constant drag to give this boost a special feel
				tempEntry.statSpecial.addLevel(10 + Global.OVER_LEVELS, 0.99);//Constant drag to give this boost a special feel
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.2, 20, 35);
				//}
			
			tempEntry = addEntry("ejector", "Ejector Seat", TYPE_BODY, 4, Ejector);//{
				tempEntry.shopDescription.addLevel(0, "Gives you a boost when you run out of fuel!");
				tempEntry.specialIds.addLevel(2, "ejector2");
				tempEntry.specialIds.addLevel(4, "ejector3");
				
				tempEntry.gameClass.addLevel(2, Ejector2);
				tempEntry.gameClass.addLevel(4, Ejector3);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1, 2.5, 30);
				
				tempEntry.statCost.addLevel(0, 160, 2.5);
				tempEntry.statCost.addLevel(4, 1500);
				tempEntry.statCost.addLevel(4 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(4 + Global.MEGA_LEVELS, 50000);
				
				tempEntry.statWeight.addLevel(0, 8);
				
				tempEntry.statTopSpeed.addLevel(0, 14);
				tempEntry.statTopSpeed.addLevel(4, 18, 1.2);
				tempEntry.statTopSpeed.addLevel(4 + Global.OVER_LEVELS, 55);
				tempEntry.statTopSpeed.addLevel(4 + Global.MEGA_LEVELS, 180);
				
				tempEntry.statTorque.addLevel(0, 0.1);
				
				tempEntry.statPower.addLevel(0, 300);//Power from ejection
				tempEntry.statPower.addLevel(4, 900);
				tempEntry.statPower.addLevel(4 + Global.OVER_LEVELS, 3500);
				tempEntry.statPower.addLevel(4 + Global.MEGA_LEVELS, 32000);
				
				tempEntry.statStageSlots.addLevel(0, 2);
				tempEntry.statStageSlots.addLevel(2, 3);
				tempEntry.statStageSlots.addLevel(4 + Global.OVER_LEVELS + 1, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 1);
				tempEntry.statBoostSlots.addLevel(4, 2);
				tempEntry.statBoostSlots.addLevel(4 + Global.OVER_LEVELS, 3);
				tempEntry.statBoostSlots.addLevel(4 + Global.OVER_LEVELS + 25, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Ejection Force", tempEntry.statPower);
				tempEntry.setDisplayStat(4, "Stage Slots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(5, "Boost Slots", tempEntry.statBoostSlots);
				//}
				
			tempEntry = addEntry("escapePod", "Escape Pod", TYPE_BODY, 5, EscapePod);//{
				tempEntry.shopDescription.addLevel(0, "Extra rocket for when you run out of fuel!");
				tempEntry.specialIds.addLevel(3, "escapePod2");
				
				tempEntry.gameClass.addLevel(3, EscapePod2);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1.2, 3, 30);
				
				tempEntry.statCost.addLevel(0, 2000);
				tempEntry.statCost.addLevel(5, 6000);
				tempEntry.statCost.addLevel(5 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(5 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statWeight.addLevel(0, 14);
				
				tempEntry.statTopSpeed.addLevel(0, 20);
				tempEntry.statTopSpeed.addLevel(5, 32, 1.2);
				tempEntry.statTopSpeed.addLevel(5 + Global.OVER_LEVELS, 66);
				tempEntry.statTopSpeed.addLevel(5 + Global.MEGA_LEVELS, 250);
				
				tempEntry.statTorque.addLevel(0, 0.1);
				
				tempEntry.statPower.addLevel(0, 4);//Stage power mult, DISPLAY ONLY! for actual stat go to "escapePodStage"
				tempEntry.statPower.addLevel(5, 6.5);
				tempEntry.statPower.addLevel(5 + Global.OVER_LEVELS, 9);
				tempEntry.statPower.addLevel(5 + Global.MEGA_LEVELS, 25);
				
				tempEntry.statFuel.addLevel(0, 350);//DISPLAY ONLY! for actual stat go to "escapePodStage"
				tempEntry.statFuel.addLevel(5, 950);
				tempEntry.statFuel.addLevel(5 + Global.OVER_LEVELS, 1800);
				tempEntry.statFuel.addLevel(5 + Global.MEGA_LEVELS, 3500);
				
				tempEntry.statStageSlots.addLevel(0, 1);
				tempEntry.statStageSlots.addLevel(4, 2);
				tempEntry.statStageSlots.addLevel(5 + Global.OVER_LEVELS + 1, 3);
				tempEntry.statStageSlots.addLevel(5 + Global.OVER_LEVELS + 50, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				tempEntry.statBoostSlots.addLevel(2, 3);
				tempEntry.statBoostSlots.addLevel(5, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Pod Power", tempEntry.statPower);
				tempEntry.setDisplayStat(4, "Pod Fuel", tempEntry.statFuel);
			//}
			
			tempEntry = addEntry("escapePodStage", "", TYPE_MISC, 5, EscapePodStage);//{ //MISC, not an actual stage but an addon stage for EscapePod body
				tempEntry.setUnlockKeys("hidden");
				tempEntry.statVisualClass.addLevel(0, getClass("DebugStageVisual"));
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statWeight.addLevel(0, 0);
				
				tempEntry.statSound1.addLevel(0, Fire1);
				tempEntry.statSound1Volume.addLevel(0, 0.9);
				
				tempEntry.statPower.addLevel(0, 4);
				tempEntry.statPower.addLevel(5, 6.5);
				tempEntry.statPower.addLevel(5 + Global.OVER_LEVELS, 9);
				tempEntry.statPower.addLevel(5 + Global.MEGA_LEVELS, 25);
				
				tempEntry.statFuel.addLevel(0, 350);
				tempEntry.statFuel.addLevel(5, 950);
				tempEntry.statFuel.addLevel(5 + Global.OVER_LEVELS, 1800);
				tempEntry.statFuel.addLevel(5 + Global.MEGA_LEVELS, 3500);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 30, 30);
			//}
			
			tempEntry = addEntry("elFuego", "El Fuego!", TYPE_BODY, 5, ElFuego);//{
				tempEntry.setUnlockKeys("masterUnlock", "elFuego");
				
				tempEntry.shopDescription.addLevel(0, "Increase stage power for a short period!");
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1.5, 3, 30);
				
				tempEntry.statCost.addLevel(0, 1000);
				tempEntry.statCost.addLevel(1, 1000);
				tempEntry.statCost.addLevel(2, 2000);
				tempEntry.statCost.addLevel(3, 1000);
				tempEntry.statCost.addLevel(4, 1000);
				tempEntry.statCost.addLevel(5, 5000, 2);
				tempEntry.statCost.addLevel(5 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(5 + Global.MEGA_LEVELS, 100000);
				
				tempEntry.statWeight.addLevel(0, 12);
				tempEntry.statWeight.addLevel(0, 13);
				tempEntry.statWeight.addLevel(0, 15);
				
				tempEntry.statTopSpeed.addLevel(0, 15);
				tempEntry.statTopSpeed.addLevel(5, 30, 1.2);
				tempEntry.statTopSpeed.addLevel(5 + Global.OVER_LEVELS, 75);
				tempEntry.statTopSpeed.addLevel(5 + Global.MEGA_LEVELS, 275);
				
				tempEntry.statTorque.addLevel(0, 0.1);
				
				tempEntry.statPower.addLevel(0, 2);//Stage power mult
				tempEntry.statPower.addLevel(5, 3);
				tempEntry.statPower.addLevel(5 + Global.OVER_LEVELS, 4);
				tempEntry.statPower.addLevel(5 + Global.MEGA_LEVELS, 10);
				
				tempEntry.statFuel.addLevel(0, 250);
				tempEntry.statFuel.addLevel(5, 500);
				tempEntry.statFuel.addLevel(5 + Global.OVER_LEVELS, 750);
				tempEntry.statFuel.addLevel(5 + Global.MEGA_LEVELS, 1500);
				
				tempEntry.statStageSlots.addLevel(0, 2);
				tempEntry.statStageSlots.addLevel(2, 3);
				tempEntry.statStageSlots.addLevel(5 + Global.OVER_LEVELS + 25, 4);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				tempEntry.statBoostSlots.addLevel(4, 3);
				tempEntry.statBoostSlots.addLevel(5 + 5, 4);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Power Increase", tempEntry.statPower);
				tempEntry.setDisplayStat(4, "Effect Duration", tempEntry.statFuel);
			//}
			
			tempEntry = addEntry("volcano", "Volcano", TYPE_BODY, 10, Volcano);//{
				tempEntry.setUnlockKeys("masterUnlock", "volcano");
				
				tempEntry.shopDescription.addLevel(0, "Stronger first stage, but others are weakened.");
				tempEntry.specialIds.addLevel(5, "volcano2");
				tempEntry.specialIds.addLevel(10, "volcano3");
				
				tempEntry.gameClass.addLevel(5, Volcano2);
				tempEntry.gameClass.addLevel(10, Volcano3);
				
				tempEntry.statZoomAtSpeed.addLevel(0, 1.2, 2.5, 30);
				
				tempEntry.statCost.addLevel(0, 1300, 2);
				tempEntry.statCost.addLevel(10, 11111);
				tempEntry.statCost.addLevel(10 + 1, 5000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 150000);
				
				tempEntry.statWeight.addLevel(0, 35);
				
				tempEntry.statTopSpeed.addLevel(0, 30);
				tempEntry.statTopSpeed.addLevel(10, 45, 1.2);
				tempEntry.statTopSpeed.addLevel(10 + Global.OVER_LEVELS, 80);
				tempEntry.statTopSpeed.addLevel(10 + Global.MEGA_LEVELS, 280);
				
				tempEntry.statTorque.addLevel(0, 0.15);
				
				tempEntry.statPower.addLevel(0, 1.25);
				tempEntry.statPower.addLevel(10, 1.35);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 1.50);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 3);
				
				tempEntry.statSpecial.addLevel(0, 0.75);//Reduced power for subsequent stages
				tempEntry.statSpecial.addLevel(10, 0.85);//Reduced power for subsequent stages
				tempEntry.statSpecial.addLevel(10 + Global.OVER_LEVELS, 0.9);//Reduced power for subsequent stages
				tempEntry.statSpecial.addLevel(10 + Global.MEGA_LEVELS, 0.95);//Reduced power for subsequent stages
				
				tempEntry.statStageSlots.addLevel(0, 2);
				tempEntry.statStageSlots.addLevel(10, 3);
				
				tempEntry.statBoostSlots.addLevel(0, 1);
				tempEntry.statBoostSlots.addLevel(5, 2);
				
				tempEntry.setDisplayStat(1, "Top Speed", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(2, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Power Increase", tempEntry.statPower, 3);
				tempEntry.setDisplayStat(4, "Power Decrease", tempEntry.statSpecial, 3);
			//}
			
			
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//Launchers///////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//statBoostSlots is used for classic mode to determine which slope to use. 0 = none, (1 not in use atm) and 2 = regular
			//
			tempEntry = addEntry("coil", "Coil", TYPE_LAUNCHER, 6, Coil);//{
				tempEntry.shopDescription.addLevel(0, "A big spring. Pretty stiff, should take us to space give or take a few inches.");
				tempEntry.specialIds.addLevel(3, "coil2");
				tempEntry.specialIds.addLevel(6, "coil3");
				
				tempEntry.gameClass.addLevel(3, Coil2);
				tempEntry.gameClass.addLevel(6, Coil3);
				
				tempEntry.statCost.addLevel(0, 10);
				tempEntry.statCost.addLevel(1, 10, 2.08);
				tempEntry.statCost.addLevel(6, 100, 2);
				tempEntry.statCost.addLevel(6 + Global.OVER_LEVELS, 5000);
				tempEntry.statCost.addLevel(6 + Global.MEGA_LEVELS, 25000);
				
				tempEntry.statPower.addLevel(0, 170);
				tempEntry.statPower.addLevel(6, 400);
				tempEntry.statPower.addLevel(6 + Global.OVER_LEVELS, 5000);
				tempEntry.statPower.addLevel(6 + Global.MEGA_LEVELS, 25000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.5, 10, 15);
				tempEntry.statPowerAtWeightMult.addLevel(6, 1.5, 15, 20);
				tempEntry.statPowerAtWeightMult.addLevel(6 + Global.OVER_LEVELS, 1.5, 60, 60);
				tempEntry.statPowerAtWeightMult.addLevel(6 + Global.MEGA_LEVELS, 1.5, 200, 100);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("launchPad", "Launch Pad", TYPE_LAUNCHER, 8, LaunchPad);//{
				tempEntry.setUnlockKeys("masterUnlock");
				tempEntry.shopDescription.addLevel(0, "Extra stages fuel, but no powered launch.");
				tempEntry.specialIds.addLevel(4, "launchPad2");
				tempEntry.specialIds.addLevel(8, "launchPad3");
				
				tempEntry.gameClass.addLevel(4, LaunchPad2);
				tempEntry.gameClass.addLevel(8, LaunchPad3);
				
				tempEntry.statZoomFloor.addLevel(0, 1.5);
				tempEntry.statZoomFloor.addLevel(4, 2);
				tempEntry.statZoomFloor.addLevel(8, 2.5);
				
				tempEntry.statCost.addLevel(0, 2500, 2);
				tempEntry.statCost.addLevel(8, 10000, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 25000);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 100000);
				
				tempEntry.statPower.addLevel(0, 0);
				
				tempEntry.statFuel.addLevel(0, 1.25);//Fuel mult
				tempEntry.statFuel.addLevel(8, 1.35);
				tempEntry.statFuel.addLevel(8 + Global.OVER_LEVELS, 1.45);
				tempEntry.statFuel.addLevel(8 + Global.MEGA_LEVELS, 1.6);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1, 0, 0);
				
				tempEntry.statBoostSlots.addLevel(0, 0);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
				tempEntry.setDisplayStat(3, "Fuel Mult", tempEntry.statFuel, 3);
			//}
			
			tempEntry = addEntry("omegaCoil", "Omega Coil", TYPE_LAUNCHER, 10, OmegaCoil);//{
				tempEntry.setUnlockKeys("masterUnlock", "omegaCoil");
				tempEntry.shopDescription.addLevel(0, "A big spring. A big, -BIG- spring.");
				
				tempEntry.statCost.addLevel(0, 50000);
				tempEntry.statCost.addLevel(1, 25000, 1.5);
				tempEntry.statCost.addLevel(10, 50000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 50000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 500000);
				
				tempEntry.statPower.addLevel(0, 13000, 1.5);
				tempEntry.statPower.addLevel(10, 30000);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 65000);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 250000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.4, 250, 250);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.4, 400, 400);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.4, 700, 700);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.4, 1500, 200);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("explosive", "Explosives", TYPE_LAUNCHER, 8, Explosive);//{
				tempEntry.shopDescription.addLevel(0, "The box goes boom and the penguin goes up.");
				tempEntry.specialIds.addLevel(5, "explosive2");
				tempEntry.specialIds.addLevel(10, "explosive3");
				
				tempEntry.gameClass.addLevel(5, Explosive2);
				tempEntry.gameClass.addLevel(10, Explosive3);
				
				tempEntry.statZoomFloor.addLevel(0, 1.5);
				
				tempEntry.statCost.addLevel(0, 800);
				tempEntry.statCost.addLevel(1, 800, 2);
				tempEntry.statCost.addLevel(8, 3000, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 45000);
				
				tempEntry.statPower.addLevel(0, 950, 1.2);
				tempEntry.statPower.addLevel(8, 8800);
				tempEntry.statPower.addLevel(8 + Global.OVER_LEVELS, 26500);
				tempEntry.statPower.addLevel(8 + Global.MEGA_LEVELS, 55000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.45, 15, 15);
				tempEntry.statPowerAtWeightMult.addLevel(8, 1.45, 50, 50);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.OVER_LEVELS, 1.45, 100, 100);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.MEGA_LEVELS, 1.45, 500, 200);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("nuclearReactor", "Nuclear Reactor", TYPE_LAUNCHER, 10, NuclearReactor);//{
				tempEntry.shopDescription.addLevel(0, "Sit on top, let the pressure build up and off you go! \nScience.");
				tempEntry.specialIds.addLevel(5, "nuclearReactor2");
				tempEntry.specialIds.addLevel(10, "nuclearReactor3");
				
				tempEntry.gameClass.addLevel(5, NuclearReactor2);
				tempEntry.gameClass.addLevel(10, NuclearReactor3);
				
				tempEntry.statZoomFloor.addLevel(0, 1.5);
				
				tempEntry.statCost.addLevel(0, 5000);
				tempEntry.statCost.addLevel(1, 3500, 2.08);
				tempEntry.statCost.addLevel(10, 10000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(Global.MEGA_LEVELS, 100000);
				
				tempEntry.statPower.addLevel(0, 2600, 1.2);
				tempEntry.statPower.addLevel(10, 15000);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 38000);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.5, 40, 40);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.5, 80, 80);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.5, 200, 100);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.5, 700, 200);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("tiltCannon", "Tilt Cannon", TYPE_LAUNCHER, 8, TiltCannon);//{
				tempEntry.shopDescription.addLevel(0, "Gotta keep this thing pointing up or else...");
				tempEntry.specialIds.addLevel(4, "tiltCannon2");
				tempEntry.specialIds.addLevel(8, "tiltCannon3");
				
				tempEntry.gameClass.addLevel(4, TiltCannon2);
				tempEntry.gameClass.addLevel(8, TiltCannon3);
				
				tempEntry.statZoomFloor.addLevel(0, 1.1);
				
				tempEntry.statCost.addLevel(0, 80);
				tempEntry.statCost.addLevel(1, 80, 2.08);
				tempEntry.statCost.addLevel(8, 400, 2);
				tempEntry.statCost.addLevel(8 + 1, 600, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 5000);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 50000);
				
				tempEntry.statPower.addLevel(0, 300);
				tempEntry.statPower.addLevel(8, 1200);
				tempEntry.statPower.addLevel(8 + Global.OVER_LEVELS, 9500);
				tempEntry.statPower.addLevel(8 + Global.MEGA_LEVELS, 50000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.5, 15, 30);
				tempEntry.statPowerAtWeightMult.addLevel(8, 1.5, 80, 80);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.OVER_LEVELS, 1.5, 120, 120);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.MEGA_LEVELS, 1.5, 400, 200);
				
				tempEntry.statBoostSlots.addLevel(0, 0);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower)
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);;
			//}
			
			tempEntry = addEntry("bigBertha", "Big Bertha", TYPE_LAUNCHER, 10, BigBertha);//{
				tempEntry.setUnlockKeys("masterUnlock", "bigBertha");
				
				tempEntry.shopDescription.addLevel(0, "If size does matter, we're set up!");
				tempEntry.specialIds.addLevel(5, "bigBertha2");
				tempEntry.specialIds.addLevel(10, "bigBertha3");
				
				tempEntry.gameClass.addLevel(5, BigBertha2);
				tempEntry.gameClass.addLevel(10, BigBertha3);
				tempEntry.gameClass.addLevel(10, BigBertha3);
				
				tempEntry.statZoomFloor.addLevel(0, 2);
				
				tempEntry.statVisualClass.addLevel(0, src.game.gameobjects.player.launcher.BigBerthaBubble1);
				
				tempEntry.statCost.addLevel(0, 5500);
				tempEntry.statCost.addLevel(1, 3500, 2.08);
				tempEntry.statCost.addLevel(10, 10500);
				tempEntry.statCost.addLevel(10 + 1, 3000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 100000);
				
				tempEntry.statPower.addLevel(0, 2500, 1.1);
				tempEntry.statPower.addLevel(10, 17000);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 43000);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 95000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.45, 50, 20);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.45, 100, 100);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.45, 240, 180);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.45, 750, 200);
				
				tempEntry.statBoostSlots.addLevel(0, 0);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("slingshot", "Slingshot", TYPE_LAUNCHER, 6, Slingshot);//{
				tempEntry.shopDescription.addLevel(0, "Harness the power of rubber bands.");
				tempEntry.specialIds.addLevel(3, "slingshot2");
				tempEntry.specialIds.addLevel(6, "slingshot3");
				
				tempEntry.gameClass.addLevel(3, Slingshot2);
				tempEntry.gameClass.addLevel(6, Slingshot3);
				
				tempEntry.statZoomFloor.addLevel(0, 1.5);
				
				tempEntry.statCost.addLevel(0, 40);
				tempEntry.statCost.addLevel(1, 40, 2.08);
				tempEntry.statCost.addLevel(6, 400, 2);
				tempEntry.statCost.addLevel(6 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(6 + Global.MEGA_LEVELS, 50000);
				
				tempEntry.statPower.addLevel(0, 450);
				tempEntry.statPower.addLevel(6, 1000);
				tempEntry.statPower.addLevel(6 + Global.OVER_LEVELS, 23000);
				tempEntry.statPower.addLevel(6 + Global.MEGA_LEVELS, 60000);
				
				tempEntry.statSpecial.addLevel(0, 0.0035);//Pull speed
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.45, 15, 15);
				tempEntry.statPowerAtWeightMult.addLevel(6, 1.45, 30, 30);
				tempEntry.statPowerAtWeightMult.addLevel(6 + Global.OVER_LEVELS, 1.45, 70, 70);
				tempEntry.statPowerAtWeightMult.addLevel(6 + Global.MEGA_LEVELS, 1.45, 150, 150);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("catapult", "Catapult", TYPE_LAUNCHER, 8, Catapult);//{
				tempEntry.setUnlockKeys("masterUnlock", "catapult");
				
				tempEntry.shopDescription.addLevel(0, "Takes a little effort, but gets the job done.");
				tempEntry.specialIds.addLevel(5, "catapult2");
				tempEntry.specialIds.addLevel(10, "catapult3");
				
				tempEntry.gameClass.addLevel(5, Catapult2);
				tempEntry.gameClass.addLevel(10, Catapult3);
				
				tempEntry.statZoomFloor.addLevel(0, 1.5);
				
				tempEntry.statCost.addLevel(0, 600);
				tempEntry.statCost.addLevel(1, 500, 2.08);
				tempEntry.statCost.addLevel(8, 1000, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 45000);
				
				tempEntry.statPower.addLevel(0, 700, 1.1);
				tempEntry.statPower.addLevel(8, 5500);
				tempEntry.statPower.addLevel(8 + Global.OVER_LEVELS, 30000);
				tempEntry.statPower.addLevel(8 + Global.MEGA_LEVELS, 65000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.45, 30, 30);
				tempEntry.statPowerAtWeightMult.addLevel(8, 1.45, 60, 60);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.OVER_LEVELS, 1.45, 90, 90);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.MEGA_LEVELS, 1.45, 240, 200);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("kickstarter", "\"Kick\" Starter", TYPE_LAUNCHER, 8, Kickstarter);//{
				tempEntry.setUnlockKeys("masterUnlock");
				
				tempEntry.shopDescription.addLevel(0, "All you need is a little \"kick\".");
				
				tempEntry.statZoomFloor.addLevel(0, 1.5);
				
				tempEntry.statCost.addLevel(0, 600);
				tempEntry.statCost.addLevel(1, 500, 2.08);
				tempEntry.statCost.addLevel(8, 1000, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 35000);
				
				tempEntry.statPower.addLevel(0, 1200, 1.1);
				tempEntry.statPower.addLevel(8, 7200);
				tempEntry.statPower.addLevel(8 + Global.OVER_LEVELS, 45000);
				tempEntry.statPower.addLevel(8 + Global.MEGA_LEVELS, 90000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.4, 30, 40);
				tempEntry.statPowerAtWeightMult.addLevel(8, 1.4, 60, 60);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.OVER_LEVELS, 1.4, 140, 100);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.MEGA_LEVELS, 1.4, 280, 200);
				
				tempEntry.statBoostSlots.addLevel(0, 0);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("cannonPowder", "Powder Cannon", TYPE_LAUNCHER, 10, CannonPowder);//{
				tempEntry.shopDescription.addLevel(0, "Put a little too much and...");
				tempEntry.specialIds.addLevel(5, "cannonPowder2");
				tempEntry.specialIds.addLevel(10, "cannonPowder3");
				
				tempEntry.gameClass.addLevel(5, CannonPowder2);
				tempEntry.gameClass.addLevel(10, CannonPowder3);
				
				tempEntry.statZoomFloor.addLevel(0, 1.8);
				
				tempEntry.statCost.addLevel(0, 1000);
				tempEntry.statCost.addLevel(1, 750, 2);
				tempEntry.statCost.addLevel(10, 7500);
				tempEntry.statCost.addLevel(10 + 1, 5000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 35000);
				
				tempEntry.statPower.addLevel(0, 1200, 1.2);
				tempEntry.statPower.addLevel(10, 12500);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 32500);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 60000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.4, 15, 15);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.4, 60, 60);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.4, 130, 100);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.4, 300, 200);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("steamLauncher", "Steamshot", TYPE_LAUNCHER, 10, Steamshot);//{
				tempEntry.setUnlockKeys("masterUnlock", "steamLauncher");
				
				tempEntry.shopDescription.addLevel(0, "Pretty sure NASA still hasn't thought about steam power.");
				tempEntry.specialIds.addLevel(5, "steamLauncher2");
				tempEntry.specialIds.addLevel(10, "steamLauncher3");
				
				tempEntry.gameClass.addLevel(5, Steamshot2);
				tempEntry.gameClass.addLevel(10, Steamshot3);
				
				tempEntry.statZoomFloor.addLevel(0, 1.75);
				tempEntry.statZoomFloor.addLevel(5, 1.85);
				tempEntry.statZoomFloor.addLevel(10, 1.95);
				
				tempEntry.statCost.addLevel(0, 1600);
				tempEntry.statCost.addLevel(1, 1200, 2.08);
				tempEntry.statCost.addLevel(10, 8000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 60000);
				
				tempEntry.statPower.addLevel(0, 1900, 1.2);
				tempEntry.statPower.addLevel(10, 16000);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 46000);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 100000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.4, 40, 40);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.4, 95, 95);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.4, 210, 160);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.4, 420, 200);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("grenade", "Grenade", TYPE_LAUNCHER, 8, Grenade);//{
				tempEntry.shopDescription.addLevel(0, "Throwing grenades at our feet. I mean why didn't we figure this out sooner?");
				tempEntry.specialIds.addLevel(4, "grenade2");
				tempEntry.specialIds.addLevel(8, "grenade3");
				
				tempEntry.gameClass.addLevel(4, Grenade2);
				tempEntry.gameClass.addLevel(8, Grenade3);
				
				tempEntry.statVisualClass.addLevel(0, src.game.gameobjects.player.launcher.GrenadeProjectile);
				tempEntry.statVisualClass.addLevel(4, src.game.gameobjects.player.launcher.GrenadeProjectile2);
				tempEntry.statVisualClass.addLevel(8, src.game.gameobjects.player.launcher.GrenadeProjectile3);
				
				tempEntry.statZoomFloor.addLevel(0, 1.5);
				
				tempEntry.statCost.addLevel(0, 275);
				tempEntry.statCost.addLevel(1, 275, 2.08);
				tempEntry.statCost.addLevel(8, 1800, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 35000);
				
				tempEntry.statPower.addLevel(0, 720);
				tempEntry.statPower.addLevel(8, 3000);
				tempEntry.statPower.addLevel(8 + Global.OVER_LEVELS, 26500);
				tempEntry.statPower.addLevel(8 + Global.MEGA_LEVELS, 52500);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.45, 30, 30);
				tempEntry.statPowerAtWeightMult.addLevel(8, 1.45, 55, 55);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.OVER_LEVELS, 1.45, 125, 85);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.MEGA_LEVELS, 1.45, 500, 200);
				
				tempEntry.statBoostSlots.addLevel(0, 0);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("bazooka", "Bazooka", TYPE_LAUNCHER, 10, Bazooka);//{
				tempEntry.setUnlockKeys("masterUnlock", "bazooka");
				
				tempEntry.shopDescription.addLevel(0, "Instead of strapping the rocket on to you, we shoot right in your face! Genius.");
				tempEntry.specialIds.addLevel(5, "bazooka2");
				tempEntry.specialIds.addLevel(10, "bazooka3");
				
				tempEntry.gameClass.addLevel(5, Bazooka2);
				tempEntry.gameClass.addLevel(10, Bazooka3);
				
				tempEntry.statZoomFloor.addLevel(0, 1.35);
				
				tempEntry.statCost.addLevel(0, 1900);
				tempEntry.statCost.addLevel(1, 1300, 2.08);
				tempEntry.statCost.addLevel(10, 6500, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 17500);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 45000);
				
				tempEntry.statSpecial.addLevel(0, 1);//Multiplies the visible score on the HUD, NO GAMEPLAY IMPACT
				tempEntry.statSpecial.addLevel(5, 2);
				tempEntry.statSpecial.addLevel(10, 3);
				
				tempEntry.statPower.addLevel(0, 2200);
				tempEntry.statPower.addLevel(10, 14000);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 39000);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 90000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.45, 35, 35);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.45, 80, 80);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.45, 130, 110);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.45, 380, 380);
				
				tempEntry.statBoostSlots.addLevel(0, 0);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("russianRoulette", "Russian Roulette", TYPE_LAUNCHER, 10, RussianRoulette);//{
				tempEntry.shopDescription.addLevel(0, "Spin the cylinder and hope to get a killer shot.");
				tempEntry.specialIds.addLevel(5, "russianRoulette2");
				tempEntry.specialIds.addLevel(10, "russianRoulette3");
				
				tempEntry.gameClass.addLevel(5, RussianRoulette2);
				tempEntry.gameClass.addLevel(10, RussianRoulette3);
				
				//tempEntry.statZoomFloor.addLevel(0, 1.35);
				
				tempEntry.statCost.addLevel(0, 350);
				tempEntry.statCost.addLevel(1, 400, 2);
				tempEntry.statCost.addLevel(10, 9000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statStageSlots.addLevel(0, 1);//Number of great shots
				tempEntry.statStageSlots.addLevel(5, 1, 9999);
				tempEntry.statStageSlots.addLevel(10, 2);
				tempEntry.statStageSlots.addLevel(10 + Global.OVER_LEVELS, 3);
				
				tempEntry.statSpecial.addLevel(0, 3,9999);//Number of bad shots
				tempEntry.statSpecial.addLevel(3, 2,9999);
				tempEntry.statSpecial.addLevel(7, 1,9999);
				
				tempEntry.statPower.addLevel(0, 777, 1.65);
				tempEntry.statPower.addLevel(10, 10000);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 30000);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.45, 25, 25);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.45, 60, 60);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.45, 100, 95);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.45, 260, 260);
				
				tempEntry.statBoostSlots.addLevel(0, 2);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
				tempEntry.setDisplayStat(3, "Killer shots", tempEntry.statStageSlots);
				tempEntry.setDisplayStat(4, "Duds", tempEntry.statSpecial);
			//}
			
			tempEntry = addEntry("ufo", "Alien Bait", TYPE_LAUNCHER, 10, Ufo);//{
				tempEntry.shopDescription.addLevel(0, "Get help from... \"them\"...");
				tempEntry.specialIds.addLevel(5, "ufo2");
				tempEntry.specialIds.addLevel(10, "ufo3");
				
				tempEntry.gameClass.addLevel(5, Ufo2);
				tempEntry.gameClass.addLevel(10, Ufo3);
				
				tempEntry.statZoomFloor.addLevel(0, 1.25);
				
				tempEntry.statCost.addLevel(0, 4500);
				tempEntry.statCost.addLevel(1, 4500, 2.08);
				tempEntry.statCost.addLevel(10, 11500, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 25000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 70000);
				
				tempEntry.statPower.addLevel(0, 9);
				tempEntry.statPower.addLevel(10, 10);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 22);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 50);
				
				tempEntry.statFuel.addLevel(0, 200);
				tempEntry.statFuel.addLevel(10, 700);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 800);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 1000);
				
				tempEntry.statSpecial.addLevel(0, 0.982);//Drag per tick
				
				tempEntry.statTorque.addLevel(0, 300);//Tolerance before falling off the beam
				tempEntry.statTorque.addLevel(10, 350);//Tolerance before falling off the beam
				tempEntry.statTorque.addLevel(10 + Global.OVER_LEVELS, 400);//Tolerance before falling off the beam
				tempEntry.statTorque.addLevel(10 + Global.MEGA_LEVELS, 500);//Tolerance before falling off the beam
				
				tempEntry.statTopSpeed.addLevel(0, 1.1);//BEAM WIDTH
				tempEntry.statTopSpeed.addLevel(10, 2);//BEAM WIDTH
				tempEntry.statTopSpeed.addLevel(10 + Global.MEGA_LEVELS, 3.6);//BEAM WIDTH
				
				tempEntry.statVisualClass.addLevel(0, src.game.gameobjects.player.launcher.UfoMessageStart);
				
				tempEntry.statVisualClass2.addLevel(0, src.game.gameobjects.player.launcher.UfoMessageEnd);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1, 50, 50);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1, 90, 90);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1, 120, 120);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1, 275, 200);
				
				tempEntry.statBoostSlots.addLevel(0, 0);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("orbital", "Orbital Cannon", TYPE_LAUNCHER, 10, OrbitalCannon);//{
				tempEntry.setUnlockKeys("masterUnlock", "orbital");
				
				tempEntry.shopDescription.addLevel(0, "We hack military satellites to shoot at us, it's a flawless plan.");
				tempEntry.specialIds.addLevel(5, "orbital2");
				tempEntry.specialIds.addLevel(10, "orbital3");
				
				tempEntry.gameClass.addLevel(5, OrbitalCannon2);
				tempEntry.gameClass.addLevel(10, OrbitalCannon3);
				
				tempEntry.statZoomFloor.addLevel(0, 1.5);
				
				tempEntry.statCost.addLevel(0, 5000);
				tempEntry.statCost.addLevel(1, 3500, 2.08);
				tempEntry.statCost.addLevel(10, 11500, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 100000);
				
				tempEntry.statSpecial.addLevel(0, 1);//Multiplies the visible score on the HUD, NO GAMEPLAY IMPACT
				tempEntry.statSpecial.addLevel(5, 2);
				tempEntry.statSpecial.addLevel(10, 3);
				tempEntry.statSpecial.addLevel(10 +  + Global.OVER_LEVELS, 4);
				tempEntry.statSpecial.addLevel(10 + Global.MEGA_LEVELS, 10);
				
				tempEntry.statPower.addLevel(0, 3150, 1.2);
				tempEntry.statPower.addLevel(10, 18000);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 46000);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 120000);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.4, 60, 60);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.4, 120, 120);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.4, 260, 160);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.4, 400, 200);
				
				tempEntry.statBoostSlots.addLevel(0, 0);
				
				tempEntry.setDisplayStat(1, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//Boosts//////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			tempEntry = addEntry("auxiliaryRocket", "Auxiliary Rockets", TYPE_BOOST, 4, AuxiliaryRocket);//{
				tempEntry.shopDescription.addLevel(0, "A very simple boost unit.");
				
				tempEntry.specialIds.addLevel(2, "auxiliaryRocket2");
				tempEntry.specialIds.addLevel(4, "auxiliaryRocket3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.AuxiliaryRocketVisual"));
				tempEntry.statVisualClass.addLevel(2, getClass("src.game.gameobjects.player.booost.AuxiliaryRocketVisual2"));
				tempEntry.statVisualClass.addLevel(4, getClass("src.game.gameobjects.player.booost.AuxiliaryRocketVisual3"));
				
				tempEntry.statSound1.addLevel(0, JetSound2);
				tempEntry.statSound1Volume.addLevel(0, 0.5);
				
				tempEntry.statCost.addLevel(0, 20);
				tempEntry.statCost.addLevel(1, 20);
				tempEntry.statCost.addLevel(2, 30);
				tempEntry.statCost.addLevel(3, 50);
				tempEntry.statCost.addLevel(4, 75, 2);
				tempEntry.statCost.addLevel(4 + Global.OVER_LEVELS, 5000);
				tempEntry.statCost.addLevel(4 + Global.MEGA_LEVELS, 25000);
				
				tempEntry.statWeight.addLevel(0, 1);
				
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(4, 1.2);
				tempEntry.statPower.addLevel(4 + Global.OVER_LEVELS, 1.85);
				tempEntry.statPower.addLevel(4 + Global.MEGA_LEVELS, 3.5);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 15, 8);
				tempEntry.statPowerAtWeightMult.addLevel(4, 1.35, 25, 15);
				tempEntry.statPowerAtWeightMult.addLevel(4 + Global.OVER_LEVELS, 1.35, 50, 40);
				tempEntry.statPowerAtWeightMult.addLevel(4 + Global.MEGA_LEVELS, 1.35, 120, 80);
				
				tempEntry.statFuel.addLevel(0, 300, 1);
				tempEntry.statFuel.addLevel(4, 650, 1);
				tempEntry.statFuel.addLevel(4 + Global.OVER_LEVELS, 1700);
				tempEntry.statFuel.addLevel(4 + Global.MEGA_LEVELS, 2950);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("cashDrive", "Cash Drive", TYPE_BOOST, 10, CashDrive);//{
				tempEntry.setUnlockKeys("masterUnlock", "cashDrive");
				tempEntry.shopDescription.addLevel(0, "Quite powerful, but lowers the earnings for the day");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.CashDriveVisual"));
				
				tempEntry.statSound1.addLevel(0, JetSound2);
				tempEntry.statSound1Volume.addLevel(0, 0.5);
				
				tempEntry.statCost.addLevel(0, 25);
				tempEntry.statCost.addLevel(1, 25);
				tempEntry.statCost.addLevel(2, 35);
				tempEntry.statCost.addLevel(3, 55);
				tempEntry.statCost.addLevel(4, 80, 2);
				tempEntry.statCost.addLevel(10, 1000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 100000);
				
				tempEntry.statWeight.addLevel(0, 1);
				
				tempEntry.statPower.addLevel(0, 1.2);
				tempEntry.statPower.addLevel(4, 1.4);
				tempEntry.statPower.addLevel(10, 1.8);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 2.5);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 10);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 15, 8, 1.5);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.35, 50, 50);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.35, 80, 80);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.35, 200, 200);
				
				tempEntry.statFuel.addLevel(0, 300, 1);
				tempEntry.statFuel.addLevel(4, 650, 1);
				tempEntry.statFuel.addLevel(10, 900, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 1850);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 3400);
				
				tempEntry.statSpecial.addLevel(0, 0.9, 1);//Money mult
				tempEntry.statSpecial.addLevel(10, 0.925, 1);//Money mult
				tempEntry.statSpecial.addLevel(10 + Global.OVER_LEVELS, 0.95, 1);//Money mult
				tempEntry.statSpecial.addLevel(10 + Global.MEGA_LEVELS, 0.98, 1);//Money mult
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				tempEntry.setDisplayStat(5, "Money Mult", tempEntry.statSpecial, 3);
			//}
			
			tempEntry = addEntry("gasCan", "Pressurized gas", TYPE_BOOST, 6, GasCan);//{
				tempEntry.shopDescription.addLevel(0, "Can't be stopped once started, but more eco-friendly I think.");
				
				tempEntry.specialIds.addLevel(3, "gasCan2");
				tempEntry.specialIds.addLevel(6, "gasCan3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.GasCanVisual"));
				tempEntry.statVisualClass.addLevel(3, getClass("src.game.gameobjects.player.booost.GasCanVisual2"));
				tempEntry.statVisualClass.addLevel(6, getClass("src.game.gameobjects.player.booost.GasCanVisual3"));
				
				tempEntry.statSound1.addLevel(0, Steam1);
				tempEntry.statSound1Volume.addLevel(0, 0.4);
				
				tempEntry.statCost.addLevel(0, 30, 2);
				tempEntry.statCost.addLevel(6, 250, 2);
				tempEntry.statCost.addLevel(6 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(6 + Global.MEGA_LEVELS, 50000);
				
				tempEntry.statWeight.addLevel(0, 2);
				
				tempEntry.statPower.addLevel(0, 1.6);
				tempEntry.statPower.addLevel(6, 2.2);
				tempEntry.statPower.addLevel(6 + Global.OVER_LEVELS, 4.8);
				tempEntry.statPower.addLevel(6 + Global.MEGA_LEVELS, 14);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 12, 8);
				tempEntry.statPowerAtWeightMult.addLevel(6, 1.35, 20, 20);
				tempEntry.statPowerAtWeightMult.addLevel(6 + Global.OVER_LEVELS, 1.35, 50, 50);
				tempEntry.statPowerAtWeightMult.addLevel(6 + Global.MEGA_LEVELS, 1.35, 150, 150);
				
				tempEntry.statFuel.addLevel(0, 150, 1);
				tempEntry.statFuel.addLevel(6, 600, 1);
				tempEntry.statFuel.addLevel(6 + Global.OVER_LEVELS, 1000, 1);
				tempEntry.statFuel.addLevel(6 + Global.MEGA_LEVELS, 2000, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("propellerBoost", "Propellers", TYPE_BOOST, 4, Propeller);//{
				tempEntry.setUnlockKeys("masterUnlock", "propellerBoost");
				
				tempEntry.shopDescription.addLevel(0, "Starts slow but last longer!");
				
				tempEntry.specialIds.addLevel(2, "propellerBoost2");
				tempEntry.specialIds.addLevel(4, "propellerBoost3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.PropellerVisual"));
				tempEntry.statVisualClass.addLevel(2, getClass("src.game.gameobjects.player.booost.PropellerVisual2"));
				tempEntry.statVisualClass.addLevel(4, getClass("src.game.gameobjects.player.booost.PropellerVisual3"));
				
				
				tempEntry.statSound1.addLevel(0, Prop2);
				tempEntry.statSound1Volume.addLevel(0, 1);
				
				tempEntry.statCost.addLevel(0, 50);
				tempEntry.statCost.addLevel(1, 50);
				tempEntry.statCost.addLevel(2, 60);
				tempEntry.statCost.addLevel(3, 70);
				tempEntry.statCost.addLevel(4, 80, 2);
				tempEntry.statCost.addLevel(4 + Global.OVER_LEVELS, 8000);
				tempEntry.statCost.addLevel(4 + Global.MEGA_LEVELS, 35000);
				
				tempEntry.statWeight.addLevel(0, 1);
				
				tempEntry.statPower.addLevel(0, 0.8);
				tempEntry.statPower.addLevel(4, 0.9);
				tempEntry.statPower.addLevel(4 + Global.OVER_LEVELS, 1.4);
				tempEntry.statPower.addLevel(4 + Global.MEGA_LEVELS, 2.4);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 10, 10);
				tempEntry.statPowerAtWeightMult.addLevel(4, 1.35, 10, 10);
				tempEntry.statPowerAtWeightMult.addLevel(4 + Global.OVER_LEVELS, 1.35, 30, 30);
				tempEntry.statPowerAtWeightMult.addLevel(4 + Global.MEGA_LEVELS, 1.35, 100, 100);
				
				tempEntry.statFuel.addLevel(0, 600, 1);
				tempEntry.statFuel.addLevel(4, 1000, 1);
				tempEntry.statFuel.addLevel(4 + Global.OVER_LEVELS, 2800, 1);
				tempEntry.statFuel.addLevel(4 + Global.MEGA_LEVELS, 5000, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("multiRocket", "Multi Rockets", TYPE_BOOST, 10, MultiRocket);//{
				tempEntry.shopDescription.addLevel(0, "Gives you several small boosts.");
				
				tempEntry.specialIds.addLevel(5, "multiRocket2");
				tempEntry.specialIds.addLevel(10, "multiRocket3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.MultiRocketVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.booost.MultiRocketVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.booost.MultiRocketVisual3"));
				
				tempEntry.statSound1.addLevel(0, JetCrackling);
				tempEntry.statSound1Volume.addLevel(0, 0.35);
				
				tempEntry.statCost.addLevel(0, 600, 2.6);
				tempEntry.statCost.addLevel(10, 3600);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statWeight.addLevel(0, 2);
				
				tempEntry.statPower.addLevel(0, 1.35);
				tempEntry.statPower.addLevel(10, 1.75);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 2);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 5);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 30, 40);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.35, 40, 50);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.35, 60, 70);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.35, 160, 160);
				
				tempEntry.statFuel.addLevel(0, 120, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 150, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 300, 1);
				
				tempEntry.statBoostSlots.addLevel(0, 5);
				tempEntry.statBoostSlots.addLevel(1, 6);
				tempEntry.statBoostSlots.addLevel(2, 7);
				tempEntry.statBoostSlots.addLevel(3, 8);
				tempEntry.statBoostSlots.addLevel(4, 9);
				tempEntry.statBoostSlots.addLevel(5, 10);
				tempEntry.statBoostSlots.addLevel(6, 11);
				tempEntry.statBoostSlots.addLevel(7, 12);
				tempEntry.statBoostSlots.addLevel(8, 13);
				tempEntry.statBoostSlots.addLevel(9, 14);
				tempEntry.statBoostSlots.addLevel(10, 15);
				//Hard-coded up to level 30, any change in over-lvl # and we must change this too
				tempEntry.statBoostSlots.addLevel(11, 16);
				tempEntry.statBoostSlots.addLevel(15, 17);
				tempEntry.statBoostSlots.addLevel(20, 18);
				tempEntry.statBoostSlots.addLevel(25, 19);
				tempEntry.statBoostSlots.addLevel(30, 20);
				tempEntry.statBoostSlots.addLevel(35, 21);
				tempEntry.statBoostSlots.addLevel(40, 22);
				//MEGA levels
				tempEntry.statBoostSlots.addLevel(45, 23);
				tempEntry.statBoostSlots.addLevel(50, 24);
				tempEntry.statBoostSlots.addLevel(60, 25);
				tempEntry.statBoostSlots.addLevel(70, 26);
				tempEntry.statBoostSlots.addLevel(80, 27);
				tempEntry.statBoostSlots.addLevel(90, 28);
				tempEntry.statBoostSlots.addLevel(100, 29);
				tempEntry.statBoostSlots.addLevel(110, 30);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Rockets", tempEntry.statBoostSlots);
				tempEntry.setDisplayStat(5, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("multiJump", "Multi Jumps", TYPE_BOOST, 10, MultiJump);//{
				tempEntry.setUnlockKeys("masterUnlock", "multiJump");
				
				tempEntry.shopDescription.addLevel(0, "Gives you very quick burst of speed.");
				
				tempEntry.specialIds.addLevel(5, "multiJump2");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.MultiJumpVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.booost.MultiJumpVisual2"));
				
				tempEntry.statSound1.addLevel(0, Explode2);
				tempEntry.statSound1Volume.addLevel(0, 0.7);
				
				tempEntry.statCost.addLevel(0, 1250, 2);
				tempEntry.statCost.addLevel(10, 6000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statWeight.addLevel(0, 3);
				
				tempEntry.statPower.addLevel(0, 25, 1.5);
				tempEntry.statPower.addLevel(10, 100);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 160);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 400);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 30, 40);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.35, 45, 55);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.35, 70, 60);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.35, 140, 100);
				
				tempEntry.statFuel.addLevel(0, 5, 1);
				tempEntry.statFuel.addLevel(10, 10, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 22, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 48, 1);
				
				tempEntry.statSpecial.addLevel(0, 25);//Jump thrust duration
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("rocketBoost", "Rocket Boost", TYPE_BOOST, 10, RocketBoost);//{
				tempEntry.setUnlockKeys("masterUnlock", "rocketBoost");
				
				tempEntry.shopDescription.addLevel(0, "WAY cooler than the auxilliary rockets!");
				
				tempEntry.specialIds.addLevel(5, "rocketBoost2");
				tempEntry.specialIds.addLevel(10, "rocketBoost3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.RocketBoostVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.booost.RocketBoostVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.booost.RocketBoostVisual3"));
				
				tempEntry.statSound1.addLevel(0, JetSound2);
				tempEntry.statSound1Volume.addLevel(0, 0.5);
				
				tempEntry.statCost.addLevel(0, 2500, 2);
				tempEntry.statCost.addLevel(10, 7000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statWeight.addLevel(0, 2);
				
				tempEntry.statPower.addLevel(0, 1.1);
				tempEntry.statPower.addLevel(10, 1.6);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 2.15);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 5);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.4, 40, 30);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.4, 70, 60);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.4, 160, 160);
				
				tempEntry.statFuel.addLevel(0, 1000, 1);
				tempEntry.statFuel.addLevel(10, 1800, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 3000, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 6000, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("bellNozzle", "F1 Bell Nozzle", TYPE_BOOST, 10, BellNozzle);//{
				tempEntry.shopDescription.addLevel(0, "Might or might not be stolen from human space shuttles.");
				
				tempEntry.specialIds.addLevel(5, "bellNozzle2");
				tempEntry.specialIds.addLevel(10, "bellNozzle3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.BellNozzleVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.booost.BellNozzleVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.booost.BellNozzleVisual3"));
				
				tempEntry.statSound1.addLevel(0, Fire1);
				tempEntry.statSound1Volume.addLevel(0, 0.6);
				
				tempEntry.statCost.addLevel(0, 4500, 2);
				tempEntry.statCost.addLevel(1, 3000, 2);
				tempEntry.statCost.addLevel(10, 7000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statWeight.addLevel(0, 8);
				
				tempEntry.statPower.addLevel(0, 3);
				tempEntry.statPower.addLevel(10, 4);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 6);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 12);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.4, 65, 40);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.4, 100, 90);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.4, 120, 100);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.4, 320, 200);
				
				tempEntry.statFuel.addLevel(0, 400, 1);
				tempEntry.statFuel.addLevel(10, 750, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 2200, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 4500, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("omegaBoosters", "Omega Boosters", TYPE_BOOST, 10, OmegaBoosters);//{
				tempEntry.setUnlockKeys("masterUnlock", "omegaBoosters");
				tempEntry.shopDescription.addLevel(0, "Might or might not be stolen from human space shuttles.");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.OmegaBoostersVisual"));
				
				tempEntry.statSound1.addLevel(0, JetAlien);
				tempEntry.statSound1Volume.addLevel(0, 1);
				
				tempEntry.statCost.addLevel(0, 50000);
				tempEntry.statCost.addLevel(1, 25000, 1.5);
				tempEntry.statCost.addLevel(10, 50000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 50000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 500000);
				
				tempEntry.statWeight.addLevel(0, 10);
				
				tempEntry.statPower.addLevel(0, 8);
				tempEntry.statPower.addLevel(10, 10);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 14);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 24);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 200, 200);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.35, 300, 300);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.35, 400, 400);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.35, 1400, 200);
				
				tempEntry.statFuel.addLevel(0, 800, 1);
				tempEntry.statFuel.addLevel(10, 1600, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 5500, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 10000, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("miniHelpers", "Mini Helpers", TYPE_BOOST, 10, MiniHelpers);//{
				tempEntry.shopDescription.addLevel(0, "Need more power at takeoff? You need babies!");
				
				tempEntry.specialIds.addLevel(5, "miniHelpers2");
				tempEntry.specialIds.addLevel(10, "miniHelpers3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.MiniHelpersVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.booost.MiniHelpersVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.booost.MiniHelpersVisual3"));
				
				tempEntry.statSound1.addLevel(0, JetSound2);
				tempEntry.statSound1Volume.addLevel(0, 0.5);
				
				tempEntry.statCost.addLevel(0, 250, 2);
				tempEntry.statCost.addLevel(10, 4500, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statWeight.addLevel(0, 0);
				
				tempEntry.statPower.addLevel(0, 3);
				tempEntry.statPower.addLevel(10, 4);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 5);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 10);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.2, 40, 50);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.2, 100, 100);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.2, 200, 200);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.2, 800, 400);
				
				tempEntry.statFuel.addLevel(0, 250, 1);
				tempEntry.statFuel.addLevel(10, 500, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 1400, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 2800, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("recurringBoost", "Bug-Drive", TYPE_BOOST, 10, RecurringBoost);//{
				tempEntry.setUnlockKeys("masterUnlock", "recurringBoost");
				
				tempEntry.shopDescription.addLevel(0, "The only boost that replenishes fuel!");
				
				tempEntry.specialIds.addLevel(5, "recurringBoost2");
				tempEntry.specialIds.addLevel(10, "recurringBoost3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.RecurringBoostVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.booost.RecurringBoostVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.booost.RecurringBoostVisual3"));
				
				tempEntry.statSound1.addLevel(0, Prop2);
				tempEntry.statSound1Volume.addLevel(0, 0.8);
				
				tempEntry.statCost.addLevel(0, 900, 2);
				tempEntry.statCost.addLevel(10, 6000);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 16000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 60000);
				
				tempEntry.statWeight.addLevel(0, 1);
				
				tempEntry.statPower.addLevel(0, 0.5);
				tempEntry.statPower.addLevel(10, 0.8);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 0.98);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 1.8);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 15, 25);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.35, 35, 45);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.25, 50, 60);
				tempEntry.statPowerAtWeightMult.addLevel(Global.MEGA_LEVELS, 1.25, 100, 100);
				
				tempEntry.statFuel.addLevel(0, 150, 1);
				tempEntry.statFuel.addLevel(10, 350, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 600, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 1000, 1);
				
				tempEntry.statSpecial.addLevel(0, 0.2);//Refueling per frame
				tempEntry.statSpecial.addLevel(10, 0.5);//Refueling per frame
				tempEntry.statSpecial.addLevel(10 + Global.OVER_LEVELS, 0.65);//Refueling per frame
				tempEntry.statSpecial.addLevel(10 + Global.MEGA_LEVELS, 0.85);//Refueling per frame
				
				tempEntry.statTorque.addLevel(0, 6000);//Amount of fuel that can effectively be refilled, slowing down as we progress
				tempEntry.statTorque.addLevel(10, 9000);//Amount of fuel that can effectively be refilled, slowing down as we progress
				tempEntry.statTorque.addLevel(10 + Global.OVER_LEVELS, 25000);//Amount of fuel that can effectively be refilled, slowing down as we progress
				tempEntry.statTorque.addLevel(10 + Global.MEGA_LEVELS, 50000);//Amount of fuel that can effectively be refilled, slowing down as we progress
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Recharge Rate", tempEntry.statSpecial);
				tempEntry.setDisplayStat(5, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("steamBoost", "Steam Booster", TYPE_BOOST, 10, SteamBoost);//{
				tempEntry.setUnlockKeys("masterUnlock", "steamBoost");
				
				tempEntry.shopDescription.addLevel(0, "Build up pressure and release it to blast away!");
				
				tempEntry.specialIds.addLevel(5, "steamBoost2");
				tempEntry.specialIds.addLevel(10, "steamBoost3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.SteamBoostVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.booost.SteamBoostVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.booost.SteamBoostVisual3"));
				
				tempEntry.statSound1.addLevel(0, Steam1);
				tempEntry.statSound1Volume.addLevel(0, 0.7);
				
				tempEntry.statCost.addLevel(0, 1250, 2);
				tempEntry.statCost.addLevel(10, 6000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statWeight.addLevel(0, 4);
				
				tempEntry.statPower.addLevel(0, 8.0);
				tempEntry.statPower.addLevel(10, 12.0);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 24);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 70);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 40, 30);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.35, 105, 90);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.35, 150, 90);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.35, 400, 150);
				
				tempEntry.statFuel.addLevel(0, 600, 1);
				tempEntry.statFuel.addLevel(10, 800, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 1800, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 3350, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("fins", "Fins", TYPE_BOOST, 10, Fins);//{
				tempEntry.shopDescription.addLevel(0, "Increases control and top speed and reduced wind effect.");
				
				tempEntry.specialIds.addLevel(5, "fins2");
				tempEntry.specialIds.addLevel(10, "fins3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.FinsVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.booost.FinsVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.booost.FinsVisual3"));
				
				tempEntry.statCost.addLevel(0, 50, 2.4);
				tempEntry.statCost.addLevel(10, 8000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 11500);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 75000);
				
				tempEntry.statWeight.addLevel(0, 3);
				tempEntry.statWeight.addLevel(5, 4);
				tempEntry.statWeight.addLevel(10, 5);
				
				tempEntry.statPower.addLevel(0, 0.9);//Wind effect mult
				tempEntry.statPower.addLevel(10, 0.6);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 0.5);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 0.25);
				
				tempEntry.statFuel.addLevel(0, 1);//Top speed bonus
				tempEntry.statFuel.addLevel(10, 10);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 30);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 80);
				
				tempEntry.statTorque.addLevel(0, 1.04);//Control effect mult, also adds a flat bonus from this -1 X 0.0x torque
				tempEntry.statTorque.addLevel(10, 1.08);
				tempEntry.statTorque.addLevel(10 + Global.OVER_LEVELS, 1.12);
				tempEntry.statTorque.addLevel(10 + Global.MEGA_LEVELS, 1.20);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Bonus top Speed", tempEntry.statFuel, 1);
				tempEntry.setDisplayStat(3, "Control Mult", tempEntry.statTorque, 2);
				tempEntry.setDisplayStat(4, "Wind mult", tempEntry.statPower, 2);
			//}
			
			tempEntry = addEntry("spinBooster", "Spin Booster", TYPE_BOOST, 10, SpinBooster);//{
				tempEntry.shopDescription.addLevel(0, "Super steering power on anything.");
				
				tempEntry.specialIds.addLevel(5, "spinBooster2");
				tempEntry.specialIds.addLevel(10, "spinBooster3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.SpinBoosterVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.booost.SpinBoosterVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.booost.SpinBoosterVisual3"));
				
				tempEntry.statSound1.addLevel(0, JetSound2);
				tempEntry.statSound1Volume.addLevel(0, 0.4);
				
				tempEntry.statCost.addLevel(0, 50, 2);
				tempEntry.statCost.addLevel(10, 1000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 50000);
				
				tempEntry.statWeight.addLevel(0, 1);
				
				tempEntry.statPower.addLevel(0, 0.05);
				tempEntry.statPower.addLevel(10, 0.2);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 0.3);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 0.4);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1, 20, 60);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1, 100, 150);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1, 200, 200);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1, 800, 200);
				
				tempEntry.statFuel.addLevel(0, 800, 1);
				tempEntry.statFuel.addLevel(10, 1200, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 5000, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 18000, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("dodgers", "Dodgers", TYPE_BOOST, 10, Dodgers);//{
				tempEntry.shopDescription.addLevel(0, "Double-tap left or right to strafe!");
				
				tempEntry.specialIds.addLevel(5, "dodgers2");
				tempEntry.specialIds.addLevel(10, "dodgers3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.DodgersVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.booost.DodgersVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.booost.DodgersVisual3"));
				
				tempEntry.statSound1.addLevel(0, JetLow1);
				tempEntry.statSound1Volume.addLevel(0, 0.7);
				tempEntry.statSound1Volume.addLevel(10, 0.9);
				
				tempEntry.statCost.addLevel(0, 100);
				tempEntry.statCost.addLevel(1, 100, 2);
				tempEntry.statCost.addLevel(10, 1000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 50000);
				
				tempEntry.statWeight.addLevel(0, 1);
				
				tempEntry.statPower.addLevel(0, 3);
				tempEntry.statPower.addLevel(10, 4);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 4.5);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 12.5);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.55, 30, 40);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.55, 70, 70);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.55, 100, 100);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.55, 800, 200);
				
				tempEntry.statFuel.addLevel(0, 300, 1);
				tempEntry.statFuel.addLevel(10, 800, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 1550, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 3450, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("brickBoost", "The Brick", TYPE_BOOST, 10, Brick);//{
				tempEntry.setUnlockKeys("masterUnlock");
				
				tempEntry.shopDescription.addLevel(0, "It's back, and it's as useless as ever!");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.boost.BrickVisual"));
				
				tempEntry.statCost.addLevel(0, 10, 2);
				tempEntry.statCost.addLevel(10, 1000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(Global.MEGA_LEVELS, 10000);
				
				tempEntry.statWeight.addLevel(0, 1);
				tempEntry.statWeight.addLevel(1, 2);
				tempEntry.statWeight.addLevel(2, 4);
				tempEntry.statWeight.addLevel(3, 6);
				tempEntry.statWeight.addLevel(4, 8);
				tempEntry.statWeight.addLevel(5, 10);
				tempEntry.statWeight.addLevel(10, 20);
				tempEntry.statWeight.addLevel(10 + Global.OVER_LEVELS, 50);
				tempEntry.statWeight.addLevel(10 + Global.MEGA_LEVELS, 666);
				
				tempEntry.statPower.addLevel(0, 0);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1, 1, 1);
				
				tempEntry.statFuel.addLevel(0, 1, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 1000);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 9999);
				
				tempEntry.statSpecial.addLevel(0, 225, 1);
				tempEntry.statSpecial.addLevel(10 + Global.OVER_LEVELS, 777, 1);
				
				tempEntry.statTopSpeed.addLevel(0, 2, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(3, "Raw sex appeal", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Amount of bricks", tempEntry.statTopSpeed);
				tempEntry.setDisplayStat(5, "Amount of worries", tempEntry.statPower);
				tempEntry.setDisplayStat(2, "Usefulness", tempEntry.statPower);
				//}
			
			tempEntry = addEntry("omegaBrick", "The Omega Brick", TYPE_BOOST, 10, Brick);//{
				tempEntry.setUnlockKeys("masterUnlock", "omegaBrick");
				
				tempEntry.shopDescription.addLevel(0, "Now I am become Death, the destroyer of worlds.");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.boost.OmegaBrickVisual"));
				
				tempEntry.statCost.addLevel(0, 10000, 2);
				tempEntry.statCost.addLevel(10, 10000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 10000, 2);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 15000, 2);
				
				tempEntry.statWeight.addLevel(0, 50);
				tempEntry.statWeight.addLevel(10, 300);
				tempEntry.statWeight.addLevel(10 + Global.OVER_LEVELS, 1000);
				tempEntry.statWeight.addLevel(10 + Global.MEGA_LEVELS, 10000);
				
				tempEntry.statPower.addLevel(0, 666);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1, 1, 1);
				
				tempEntry.statFuel.addLevel(0, 1000, 1);
				
				tempEntry.statSpecial.addLevel(0, 225, 1);
				tempEntry.statSpecial.addLevel(10 + Global.OVER_LEVELS, 777, 1);
				
				tempEntry.statTopSpeed.addLevel(0, 8, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "CONQUEST", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "WAR", tempEntry.statPower);
				tempEntry.setDisplayStat(4, "FAMINE", tempEntry.statPower);
				tempEntry.setDisplayStat(5, "DEATH", tempEntry.statPower);
				//}
			
			tempEntry = addEntry("balloonBoost", "Pingu Balloon", TYPE_BOOST, 10, Brick);//{
				tempEntry.setUnlockKeys("masterUnlock", "balloonBoost");
				
				tempEntry.shopDescription.addLevel(0, "It's the penguin face that makes your whole ship lighter.");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.BalloonBoostVisual"));
				
				tempEntry.statCost.addLevel(0, 5, 2);
				tempEntry.statCost.addLevel(10, 200, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 4000, 2);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 20000, 2);
				
				tempEntry.statWeight.addLevel(0, -1);
				tempEntry.statWeight.addLevel(10, -5);
				tempEntry.statWeight.addLevel(10 + Global.OVER_LEVELS, -20);
				tempEntry.statWeight.addLevel(10 + Global.MEGA_LEVELS, -50);
				
				tempEntry.statPower.addLevel(0, 0);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1, 1, 1);
				
				tempEntry.statFuel.addLevel(0, 1, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 1000);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 10000);
				
				tempEntry.statSpecial.addLevel(0, 225, 1);
				tempEntry.statSpecial.addLevel(10 + Global.OVER_LEVELS, 777, 1);
				
				tempEntry.statTopSpeed.addLevel(0, 1, 100);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Roundness", tempEntry.statFuel);
				tempEntry.setDisplayStat(3, "Penguiness", tempEntry.statTopSpeed);
				//}
			
			tempEntry = addEntry("extraFuel", "Fuel Canister", TYPE_BOOST, 10, ExtraFuel);//{
				tempEntry.setUnlockKeys("masterUnlock", "extraFuel");
				tempEntry.shopDescription.addLevel(0, "Carries extra fuel for all other stages and boosts.");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.ExtraFuelVisual"));
				
				tempEntry.statCost.addLevel(0, 150);
				tempEntry.statCost.addLevel(10, 8000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 75000);
				
				tempEntry.statWeight.addLevel(0, 15);
				tempEntry.statWeight.addLevel(5, 20);
				tempEntry.statWeight.addLevel(10, 25);
				tempEntry.statWeight.addLevel(10 + Global.OVER_LEVELS, 55);
				tempEntry.statWeight.addLevel(10 + Global.MEGA_LEVELS, 150);
				
				tempEntry.statPower.addLevel(0, 0.15);
				tempEntry.statPower.addLevel(10, 0.3);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 0.6);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 1.5);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Fuel Mult", tempEntry.statPower, 2);
			//}
			
			tempEntry = addEntry("shield", "Repeller", TYPE_BOOST, 10, Shield);//{
				tempEntry.shopDescription.addLevel(0, "Pushes back anything in your way!");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.ShieldVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.booost.ShieldVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.booost.ShieldVisual3"));
				
				tempEntry.statCost.addLevel(0, 225, 1.8);
				tempEntry.statCost.addLevel(10, 5500, 1.8);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 75000);
				
				tempEntry.statWeight.addLevel(0, 4);
				tempEntry.statWeight.addLevel(5, 5);
				tempEntry.statWeight.addLevel(10, 6);
				
				tempEntry.statPower.addLevel(0, 0.9);
				tempEntry.statPower.addLevel(10, 0.45);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 0.2);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 0.05);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Impact Mult", tempEntry.statPower);
			//}
			
			tempEntry = addEntry("energyShield", "Shields", TYPE_BOOST, 10, EnergyShield);//{
				tempEntry.setUnlockKeys("masterUnlock");
				tempEntry.specialIds.addLevel(5, "energyShield2");
				tempEntry.specialIds.addLevel(10, "energyShield3");
				tempEntry.shopDescription.addLevel(0, "Obliterate the first few obstacles that cross your path! It's heavy though...");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.EnergyShieldVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.booost.EnergyShieldVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.booost.EnergyShieldVisual3"));
				
				tempEntry.statCost.addLevel(0, 350, 1.8);
				tempEntry.statCost.addLevel(1, 350, 2);
				tempEntry.statCost.addLevel(10, 9500, 1.8);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 12500);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 50000);
				
				tempEntry.statWeight.addLevel(0, 12);
				tempEntry.statWeight.addLevel(10, 30);
				tempEntry.statWeight.addLevel(10 + Global.OVER_LEVELS, 50);
				tempEntry.statWeight.addLevel(10 + Global.MEGA_LEVELS, 120);
				
				tempEntry.statFuel.addLevel(0, 10);
				tempEntry.statFuel.addLevel(9, 55);
				tempEntry.statFuel.addLevel(10, 65);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 150);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 600);
				
				tempEntry.statPower.addLevel(0, 1);//N/A
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Shield strength", tempEntry.statFuel);
			//}
			
			tempEntry = addEntry("moneyTurbine", "Money Turbine", TYPE_BOOST, 10, MoneyTurbine);//{
				tempEntry.setUnlockKeys("masterUnlock", "moneyTurbine");
				tempEntry.shopDescription.addLevel(0, "Takes speed and turns it into dollar bills thanks to science stuff.");
				
				tempEntry.specialIds.addLevel(5, "moneyTurbine2");
				tempEntry.specialIds.addLevel(10, "moneyTurbine3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.MoneyTurbineVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.booost.MoneyTurbineVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.booost.MoneyTurbineVisual3"));
				
				tempEntry.statCost.addLevel(0, 400, 2.2);
				tempEntry.statCost.addLevel(1, 400, 2.2);
				tempEntry.statCost.addLevel(10, 6000, 2.2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 65000);
				
				tempEntry.statWeight.addLevel(0, 4);
				tempEntry.statWeight.addLevel(5, 6);
				tempEntry.statWeight.addLevel(10, 8);
				
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(10, 4);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 8);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 20);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
			//}
			
			tempEntry = addEntry("negativeMass", "Dark Matter", TYPE_BOOST, 10, NegativeMass);//{
				tempEntry.setUnlockKeys("masterUnlock", "negativeMass");
				tempEntry.shopDescription.addLevel(0, "Reduces your weight because it looks pretty high-tech according to us.");
				
				tempEntry.specialIds.addLevel(5, "negativeMass2");
				tempEntry.specialIds.addLevel(10, "negativeMass3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.booost.NegativeMassVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.booost.NegativeMassVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.booost.NegativeMassVisual3"));
				
				tempEntry.statCost.addLevel(0, 800, 2);
				tempEntry.statCost.addLevel(10, 7500, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 100000);
				
				tempEntry.statWeight.addLevel(0, 2);
				
				tempEntry.statPower.addLevel(0, 0.9);
				tempEntry.statPower.addLevel(10, 0.65);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 0.5);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 0.2);
				
				tempEntry.statSpecial.addLevel(0, 0.5);
				tempEntry.statSpecial.addLevel(10, 1);
				tempEntry.statSpecial.addLevel(10 + Global.OVER_LEVELS, 0.5);
				tempEntry.statSpecial.addLevel(10 + Global.MEGA_LEVELS, 0.2);
				
				tempEntry.statTorque.addLevel(0, 0);
				tempEntry.statTorque.addLevel(10, 10);
				tempEntry.statTorque.addLevel(10 + Global.OVER_LEVELS, 40);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Weight Mult", tempEntry.statPower);
			//}
			
			
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//Stages//////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			tempEntry = addEntry("balloon", "Balloon", TYPE_STAGE, 4, Balloon);//{
				tempEntry.shopDescription.addLevel(0, "Space-program grade balloons!");
				
				tempEntry.specialIds.addLevel(2, "balloon2");
				tempEntry.specialIds.addLevel(4, "balloon3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.BalloonVisual"));
				tempEntry.statVisualClass.addLevel(2, getClass("src.game.gameobjects.player.stage.BalloonVisual2"));
				tempEntry.statVisualClass.addLevel(4, getClass("src.game.gameobjects.player.stage.BalloonVisual3"));
				
				tempEntry.statSound1.addLevel(0, JetTiny);
				tempEntry.statSound1Volume.addLevel(0, 0.35);
				
				tempEntry.statCost.addLevel(0, 5);
				tempEntry.statCost.addLevel(1, 5, 1.5);
				tempEntry.statCost.addLevel(4, 60, 2);
				tempEntry.statCost.addLevel(4 + Global.OVER_LEVELS, 5000);
				tempEntry.statCost.addLevel(40 + Global.MEGA_LEVELS, 25000);
				
				tempEntry.statWeight.addLevel(0, 0.1);
				
				tempEntry.statPower.addLevel(0, 1.25);
				tempEntry.statPower.addLevel(4, 1.7);
				tempEntry.statPower.addLevel(4 + Global.OVER_LEVELS, 2.5);
				tempEntry.statPower.addLevel(40 + Global.MEGA_LEVELS, 7);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 6, 6);
				tempEntry.statPowerAtWeightMult.addLevel(4, 1.35, 10, 6);
				tempEntry.statPowerAtWeightMult.addLevel(4 + Global.OVER_LEVELS, 1.35, 40, 25);
				tempEntry.statPowerAtWeightMult.addLevel(40 + Global.MEGA_LEVELS, 1.35, 100, 75);
				
				tempEntry.statFuel.addLevel(0, 90, 1);
				tempEntry.statFuel.addLevel(4, 350, 1);
				tempEntry.statFuel.addLevel(4 + Global.OVER_LEVELS, 900);
				tempEntry.statFuel.addLevel(40 + Global.MEGA_LEVELS, 2500);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("rodeo", "Rodeo", TYPE_STAGE, 10, Rodeo);//{
				tempEntry.setUnlockKeys("masterUnlock");
				tempEntry.shopDescription.addLevel(0, "A jet engine tied to a chain. What could go wrong?");
				
				tempEntry.specialIds.addLevel(5, "rodeo2");
				tempEntry.specialIds.addLevel(10, "rodeo3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.RodeoVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.stage.RodeoVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.stage.RodeoVisual3"));
				
				tempEntry.statSound1.addLevel(0, Fire1);
				tempEntry.statSound1Volume.addLevel(0, 0.85);
				
				tempEntry.statCost.addLevel(0, 1000);
				tempEntry.statCost.addLevel(1, 1000, 1.5);
				tempEntry.statCost.addLevel(10, 8000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 50000);
				
				tempEntry.statWeight.addLevel(0, 0.1);
				
				tempEntry.statTorque.addLevel(0, 0.25);
				
				tempEntry.statPower.addLevel(0, 7);
				tempEntry.statPower.addLevel(10, 11);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 17);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 19);
				
				//SPECIAL CASE! Affects the mass of the engine (makes it heavier), and thus its ability to lift the player off the ground
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.3, 40, 20);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.3, 75, 35);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.3, 150, 75);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.3, 450, 250);
				
				//Multiply the player's mass while the stage is active, depending on the weight (See Rodeo class)
				tempEntry.statSpecial.addLevel(0, 0.9, 1);
				tempEntry.statSpecial.addLevel(10, 0.75, 1);
				tempEntry.statSpecial.addLevel(10 + Global.OVER_LEVELS, 0.6, 1);
				tempEntry.statSpecial.addLevel(10 + Global.MEGA_LEVELS, 0.4, 1);
				
				tempEntry.statFuel.addLevel(0, 425, 1);
				tempEntry.statFuel.addLevel(10, 1200, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 2650);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 4250);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("omegaBalloon", "Omega Balloon", TYPE_STAGE, 10, Balloon);//{
				tempEntry.setUnlockKeys("masterUnlock", "omegaBalloon");
				tempEntry.shopDescription.addLevel(0, "One balloon to end all.");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.OmegaBalloonVisual"));
				
				tempEntry.statSound1.addLevel(0, JetTiny);
				tempEntry.statSound1Volume.addLevel(0, 0.45);
				
				tempEntry.statCost.addLevel(0, 100000);
				tempEntry.statCost.addLevel(1, 50000, 1.5);
				tempEntry.statCost.addLevel(10, 75000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 500000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 500000);
				
				tempEntry.statWeight.addLevel(0, 0.5);
				
				tempEntry.statPower.addLevel(0, 6);
				tempEntry.statPower.addLevel(10, 10);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 15);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 45);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 50, 50);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.35, 150, 150);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.35, 250, 250);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.35, 1250, 250);
				
				tempEntry.statFuel.addLevel(0, 2000, 1);
				tempEntry.statFuel.addLevel(10, 3000, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 5500);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 9500);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("omegaRocket", "Omega Rocket", TYPE_STAGE, 10, OmegaRocket);//{
				tempEntry.setUnlockKeys("masterUnlock", "omegaRocket");
				tempEntry.shopDescription.addLevel(0, "We're gonna need a bigger rocket.");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.OmegaRocketVisual"));
				
				tempEntry.statSound1.addLevel(0, Fire2);
				tempEntry.statSound1Volume.addLevel(0, 0.9);
				
				tempEntry.statCost.addLevel(0, 100000);
				tempEntry.statCost.addLevel(1, 50000, 1.5);
				tempEntry.statCost.addLevel(10, 750000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 50000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 500000);
				
				tempEntry.statWeight.addLevel(0, 0.5);
				
				tempEntry.statPower.addLevel(0, 5);
				tempEntry.statPower.addLevel(10, 8);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 13);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 35);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 120, 120);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.35, 350, 350);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.35, 550, 550);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.35, 1550, 550);
				
				tempEntry.statFuel.addLevel(0, 3200, 1);
				tempEntry.statFuel.addLevel(10, 4500, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 7500);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 15000);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("balloonArray", "Balloon Array", TYPE_STAGE, 10, BalloonArray);//{
				tempEntry.setUnlockKeys("masterUnlock", "balloonArray");
				tempEntry.shopDescription.addLevel(0, "Where 1 ballon fails, 3 ballon should do the trick!");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.BalloonArrayVisual"));
				
				tempEntry.statSound1.addLevel(0, JetTiny);
				tempEntry.statSound1Volume.addLevel(0, 0.7);
				
				tempEntry.statCost.addLevel(0, 15);
				tempEntry.statCost.addLevel(1, 10, 2);
				tempEntry.statCost.addLevel(10, 500, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 7500);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 75000);
				
				tempEntry.statWeight.addLevel(0, 2);
				
				tempEntry.statPower.addLevel(0, 2.2);
				tempEntry.statPower.addLevel(10, 3.2);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 4.5);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 15);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 16, 16);
				tempEntry.statPowerAtWeightMult.addLevel(4, 1.35, 24, 24);
				tempEntry.statPowerAtWeightMult.addLevel(4 + Global.OVER_LEVELS, 1.35, 80, 30);
				tempEntry.statPowerAtWeightMult.addLevel(Global.MEGA_LEVELS, 1.35, 300, 200);
				
				tempEntry.statFuel.addLevel(0, 90, 1);
				tempEntry.statFuel.addLevel(4, 350, 1);
				tempEntry.statFuel.addLevel(4 + Global.OVER_LEVELS, 900);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 3000);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("potatoStage", "Tater Reactor", TYPE_STAGE, 8, PotatoStage);//{
				tempEntry.setUnlockKeys("masterUnlock", "potatoStage");
				tempEntry.shopDescription.addLevel(0, "We've finally harnessed the limitless power of the potato.");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.PotatoStageVisual"));
				
				tempEntry.statSound1.addLevel(0, JetAlien);
				
				tempEntry.statCost.addLevel(0, 200, 2);
				tempEntry.statCost.addLevel(1, 200, 2);
				tempEntry.statCost.addLevel(8, 1000, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 12500);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 65000);
				
				tempEntry.statWeight.addLevel(0, 2);
				
				tempEntry.statPower.addLevel(0, 2);
				tempEntry.statPower.addLevel(8, 2.7);
				tempEntry.statPower.addLevel(8 + Global.OVER_LEVELS, 4.5);
				tempEntry.statPower.addLevel(8 + Global.MEGA_LEVELS, 12);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 30, 30);
				tempEntry.statPowerAtWeightMult.addLevel(8, 1.35, 50, 50);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.OVER_LEVELS, 1.35, 100, 100);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.MEGA_LEVELS, 1.35, 300, 200);
				
				tempEntry.statFuel.addLevel(0, 350, 1);
				tempEntry.statFuel.addLevel(8, 750, 1);
				tempEntry.statFuel.addLevel(8 + Global.OVER_LEVELS, 1400, 1);
				tempEntry.statFuel.addLevel(8 + Global.MEGA_LEVELS, 3300, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("rocket", "Rocket", TYPE_STAGE, 6, Rocket);//{
				tempEntry.shopDescription.addLevel(0, "Fire comes out, penguin goes up.");
				
				tempEntry.specialIds.addLevel(3, "rocket2");
				tempEntry.specialIds.addLevel(6, "rocket3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.RocketVisual"));
				tempEntry.statVisualClass.addLevel(3, getClass("src.game.gameobjects.player.stage.RocketVisual2"));
				tempEntry.statVisualClass.addLevel(6, getClass("src.game.gameobjects.player.stage.RocketVisual3"));
				
				tempEntry.statSound1.addLevel(0, JetCrackling);
				tempEntry.statSound1Volume.addLevel(0, 0.5);
				
				tempEntry.statCost.addLevel(0, 90, 2);
				tempEntry.statCost.addLevel(1, 75, 2);
				tempEntry.statCost.addLevel(6, 500, 2);
				tempEntry.statCost.addLevel(6 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(6 + Global.MEGA_LEVELS, 30000);
				
				tempEntry.statWeight.addLevel(0, 2);
				
				tempEntry.statPower.addLevel(0, 1.65);
				tempEntry.statPower.addLevel(6, 2.2);
				tempEntry.statPower.addLevel(6 + Global.OVER_LEVELS, 2.9);
				tempEntry.statPower.addLevel(6 + Global.MEGA_LEVELS, 6);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 10, 10);
				tempEntry.statPowerAtWeightMult.addLevel(6, 1.35, 25, 25);
				tempEntry.statPowerAtWeightMult.addLevel(6 + Global.OVER_LEVELS, 1.35, 80, 80);
				tempEntry.statPowerAtWeightMult.addLevel(6 + Global.MEGA_LEVELS, 1.35, 180, 180);
				
				tempEntry.statFuel.addLevel(0, 325, 1);
				tempEntry.statFuel.addLevel(6, 1000, 1);
				tempEntry.statFuel.addLevel(6 + Global.OVER_LEVELS, 1550, 1);
				tempEntry.statFuel.addLevel(6 + Global.MEGA_LEVELS, 3600, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("diy", "The DIY", TYPE_STAGE, 8, TheDIY);//{
				tempEntry.setUnlockKeys("masterUnlock");
				tempEntry.shopDescription.addLevel(0, "Ugly. Dangerous. Unreliable. But it's cheap and made with love.");
				
				tempEntry.specialIds.addLevel(4, "diy2");
				tempEntry.specialIds.addLevel(8, "diy3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.TheDIYVisual"));
				tempEntry.statVisualClass.addLevel(4, getClass("src.game.gameobjects.player.stage.TheDIYVisual2"));
				tempEntry.statVisualClass.addLevel(8, getClass("src.game.gameobjects.player.stage.TheDIYVisual3"));
				
				//Good
				tempEntry.statSound1.addLevel(0, JetSound2);
				tempEntry.statSound1Volume.addLevel(0, 0.8);
				
				//Weak phase
				tempEntry.statSound2.addLevel(0, Fire1);
				tempEntry.statSound2Volume.addLevel(0, 0.8);
				
				//Bad phase
				tempEntry.statSound3.addLevel(0, JetCrackling);
				tempEntry.statSound3Volume.addLevel(0, 0.9);
				
				tempEntry.statCost.addLevel(0, 90, 2);
				tempEntry.statCost.addLevel(1, 75, 2);
				tempEntry.statCost.addLevel(8, 500, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 40000);
				
				tempEntry.statWeight.addLevel(0, 2);
				
				tempEntry.statPower.addLevel(0, 2.5);
				tempEntry.statPower.addLevel(8, 5);
				tempEntry.statPower.addLevel(8 + Global.OVER_LEVELS, 8);
				tempEntry.statPower.addLevel(8 + Global.MEGA_LEVELS, 15);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 20, 20);
				tempEntry.statPowerAtWeightMult.addLevel(8, 1.35, 60, 60);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.OVER_LEVELS, 1.35, 90, 90);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.MEGA_LEVELS, 1.35, 190, 150);
				
				tempEntry.statFuel.addLevel(0, 325, 1);
				tempEntry.statFuel.addLevel(8, 1000, 1);
				tempEntry.statFuel.addLevel(8 + Global.OVER_LEVELS, 1550, 1);
				tempEntry.statFuel.addLevel(8 + Global.MEGA_LEVELS, 3450, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("vector", "Vector", TYPE_STAGE, 8, VectorStage);//{
				tempEntry.setUnlockKeys("masterUnlock");
				tempEntry.shopDescription.addLevel(0, "Gimbaled thrust allows for extra maneuverability. Kinda weak and heavy.");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.VectorStageVisual"));
				
				tempEntry.statSound1.addLevel(0, Fire1);
				tempEntry.statSound1Volume.addLevel(0, 0.9);
				
				tempEntry.statCost.addLevel(0, 2500, 2);
				tempEntry.statCost.addLevel(1, 2000, 2);
				tempEntry.statCost.addLevel(8, 8000, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 60000);
				
				tempEntry.statWeight.addLevel(0, 20);
				tempEntry.statWeight.addLevel(8, 30);
				tempEntry.statWeight.addLevel(8 + Global.MEGA_LEVELS, 50);
				
				tempEntry.statPower.addLevel(0, 1.8);
				tempEntry.statPower.addLevel(8, 3.5);
				tempEntry.statPower.addLevel(8 + Global.OVER_LEVELS, 6);
				tempEntry.statPower.addLevel(8 + Global.MEGA_LEVELS, 12);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 40, 30);
				tempEntry.statPowerAtWeightMult.addLevel(8, 1.35, 70, 60);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.OVER_LEVELS, 1.35, 150, 150);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.MEGA_LEVELS, 1.35, 250, 250);
				
				tempEntry.statFuel.addLevel(0, 550, 1);
				tempEntry.statFuel.addLevel(8, 1000, 1);
				tempEntry.statFuel.addLevel(8 + Global.OVER_LEVELS, 1500, 1);
				tempEntry.statFuel.addLevel(8 + Global.MEGA_LEVELS, 3500, 1);
				
				tempEntry.statTorque.addLevel(0, 0.05);
				tempEntry.statTorque.addLevel(8, 0.1);
				tempEntry.statTorque.addLevel(8 + Global.OVER_LEVELS, 0.15);
				tempEntry.statTorque.addLevel(8 + Global.MEGA_LEVELS, 0.2);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				tempEntry.setDisplayStat(5, "Torque", tempEntry.statTorque, 3);
				//}
				
			tempEntry = addEntry("monsterTruck", "Monster Engine", TYPE_STAGE, 10, MonsterTruck);//{
				tempEntry.setUnlockKeys("masterUnlock", "monsterTruck");
				
				tempEntry.shopDescription.addLevel(0, "A monster-truck engine rocket hybrid. Because.");
				
				tempEntry.specialIds.addLevel(5, "monsterTruck2");
				tempEntry.specialIds.addLevel(10, "monsterTruck3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.MonsterTruckVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.stage.MonsterTruckVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.stage.MonsterTruckVisual3"));
				
				tempEntry.statSound1.addLevel(0, MonsterTruck1);
				tempEntry.statSound1Volume.addLevel(0, 1);
				
				tempEntry.statCost.addLevel(0, 2650, 2);
				tempEntry.statCost.addLevel(10, 7000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statWeight.addLevel(0, 20);
				tempEntry.statWeight.addLevel(10, 20);
				tempEntry.statWeight.addLevel(10 + Global.OVER_LEVELS, 15);
				
				tempEntry.statPower.addLevel(0, 8.0);
				tempEntry.statPower.addLevel(10, 12.5);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 22);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 70);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 150, 150);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.35, 250, 200);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.35, 450, 350);
				tempEntry.statPowerAtWeightMult.addLevel(Global.MEGA_LEVELS, 1.35, 1350, 350);
				
				tempEntry.statFuel.addLevel(0, 280, 1);
				tempEntry.statFuel.addLevel(10, 580, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 1050, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 2000, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("torpedo", "Torpedo", TYPE_STAGE, 10, Torpedo);//{
				tempEntry.setUnlockKeys("masterUnlock", "torpedo");
				
				tempEntry.shopDescription.addLevel(0, "Modified to work out of water! Guess you could call it a missile...");
				
				tempEntry.specialIds.addLevel(5, "torpedo2");
				tempEntry.specialIds.addLevel(10, "torpedo3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.TorpedoVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.stage.TorpedoVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.stage.TorpedoVisual3"));
				
				tempEntry.statSound1.addLevel(0, Fire1);
				tempEntry.statSound1Volume.addLevel(0, 0.9);
				
				tempEntry.statCost.addLevel(0, 5000, 2);
				tempEntry.statCost.addLevel(1, 3000, 2);
				tempEntry.statCost.addLevel(10, 7000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 75000);
				
				tempEntry.statWeight.addLevel(0, 12);
				
				tempEntry.statPower.addLevel(0, 5.5);
				tempEntry.statPower.addLevel(10, 9);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 18);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 22);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.65, 30, 30);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.65, 50, 50);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.65, 70, 150);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.65, 250, 250);
				
				tempEntry.statFuel.addLevel(0, 550, 1);
				tempEntry.statFuel.addLevel(10, 1000, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 2000, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 3800, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
			//}
			
			tempEntry = addEntry("cruiseMissile", "Cruise Missile", TYPE_STAGE, 10, ShuttleReactor);//{
				tempEntry.setUnlockKeys("masterUnlock");
				tempEntry.shopDescription.addLevel(0, "Nostalgia is a huge rocket.");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.CruiseMissileVisual"));
				
				tempEntry.statSound1.addLevel(0, Fire2);
				tempEntry.statSound1Volume.addLevel(0, 0.9);
				
				tempEntry.statCost.addLevel(0, 5500, 2);
				tempEntry.statCost.addLevel(10, 7000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statWeight.addLevel(0, 15);
				
				tempEntry.statPower.addLevel(0, 4);
				tempEntry.statPower.addLevel(10,7);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 9);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 18);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 60, 50);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.35, 85, 80);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.35, 160, 200);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.35, 400, 400);
				
				tempEntry.statFuel.addLevel(0, 600, 1);
				tempEntry.statFuel.addLevel(10, 1150, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 2550, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 5250, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("shuttleReactor", "Shuttle Reactor", TYPE_STAGE, 10, ShuttleReactor);//{
				tempEntry.shopDescription.addLevel(0, "If it's good enough for humans, it should work for penguins.");
				
				tempEntry.specialIds.addLevel(5, "shuttleReactor2");
				tempEntry.specialIds.addLevel(10, "shuttleReactor3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.ShuttleReactorVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.stage.ShuttleReactorVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.stage.ShuttleReactorVisual3"));
				
				tempEntry.statSound1.addLevel(0, Fire2);
				tempEntry.statSound1Volume.addLevel(0, 1);
				
				tempEntry.statCost.addLevel(0, 6000, 2);
				tempEntry.statCost.addLevel(1, 4000, 2);
				tempEntry.statCost.addLevel(10, 9000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statWeight.addLevel(0, 25);
				
				tempEntry.statPower.addLevel(0, 2.6);
				tempEntry.statPower.addLevel(10, 3.8);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 4.75);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 8);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.1, 70, 60);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.1, 120, 100);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.1, 250, 250);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.1, 750, 250);
				
				tempEntry.statFuel.addLevel(0, 1400, 1);
				tempEntry.statFuel.addLevel(10, 2550, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 4500, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 9500, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("rcCopter", "RC Helicopter", TYPE_STAGE, 4, RcCopter);//{
				tempEntry.setUnlockKeys("masterUnlock", "rcCopter");
				
				tempEntry.shopDescription.addLevel(0, "Crappy things come in crappy packages...");
				
				tempEntry.specialIds.addLevel(2, "rcCopter2");
				tempEntry.specialIds.addLevel(4, "rcCopter3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.RcCopterVisual"));
				tempEntry.statVisualClass.addLevel(2, getClass("src.game.gameobjects.player.stage.RcCopterVisual2"));
				tempEntry.statVisualClass.addLevel(4, getClass("src.game.gameobjects.player.stage.RcCopterVisual3"));
				
				tempEntry.statSound1.addLevel(0, Prop2);
				tempEntry.statSound1.addLevel(4, Prop1);
				tempEntry.statSound1Volume.addLevel(0, 1);
				tempEntry.statSound1Volume.addLevel(3, 0.35);
				
				tempEntry.statCost.addLevel(0, 15);
				tempEntry.statCost.addLevel(1, 15);
				tempEntry.statCost.addLevel(2, 35);
				tempEntry.statCost.addLevel(3, 60);
				tempEntry.statCost.addLevel(4, 80, 2);
				tempEntry.statCost.addLevel(4 + Global.OVER_LEVELS, 6000);
				tempEntry.statCost.addLevel(4 + Global.MEGA_LEVELS, 25000);
				
				tempEntry.statWeight.addLevel(0, 0.5);
				
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(4, 1.1);
				tempEntry.statPower.addLevel(4 + Global.OVER_LEVELS, 1.55);
				tempEntry.statPower.addLevel(4 + Global.MEGA_LEVELS, 2.5);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.2, 8, 8);
				tempEntry.statPowerAtWeightMult.addLevel(4, 1.2, 10, 10);
				tempEntry.statPowerAtWeightMult.addLevel(4 + Global.OVER_LEVELS, 1.2, 50, 50);
				tempEntry.statPowerAtWeightMult.addLevel(4 + Global.MEGA_LEVELS, 1.2, 100, 100);
				
				tempEntry.statFuel.addLevel(0, 400, 1);
				tempEntry.statFuel.addLevel(4, 1000, 1);
				tempEntry.statFuel.addLevel(4 + Global.OVER_LEVELS, 2200, 1);
				tempEntry.statFuel.addLevel(4 + Global.MEGA_LEVELS, 5000, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("banshee", "Banshee", TYPE_STAGE, 10, Banshee);//{
				tempEntry.shopDescription.addLevel(0, "Who said propellers were weak?");
				
				tempEntry.gameClass.addLevel(10, Banshee2);
				
				tempEntry.specialIds.addLevel(5, "banshee2");
				tempEntry.specialIds.addLevel(10, "banshee3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.BansheeVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.stage.BansheeVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.stage.BansheeVisual3"));
				
				tempEntry.statSound1.addLevel(0, Prop3);
				tempEntry.statSound1.addLevel(10, Turbine1);
				tempEntry.statSound1Volume.addLevel(0, 0.65);
				tempEntry.statSound1Volume.addLevel(0, 0.8);
				
				tempEntry.statCost.addLevel(0, 1750);
				tempEntry.statCost.addLevel(1, 1250, 2);
				tempEntry.statCost.addLevel(10, 7000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 65000);
				
				tempEntry.statWeight.addLevel(0, 4);
				
				tempEntry.statPower.addLevel(0, 1.4);
				tempEntry.statPower.addLevel(10, 1.7);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 2.4);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 4.5);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.5, 20, 20);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.5, 40, 40);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.5, 70, 80);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.5, 150, 120);
				
				tempEntry.statFuel.addLevel(0, 1400, 1);
				tempEntry.statFuel.addLevel(10, 2800, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 5050);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 12000);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("firework", "Fireworks", TYPE_STAGE, 6, Firework);//{
				tempEntry.shopDescription.addLevel(0, "Cheaper than an actual rocket, and prettier too!");
				
				tempEntry.specialIds.addLevel(3, "firework2");
				tempEntry.specialIds.addLevel(6, "firework3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.FireworkVisual"));
				tempEntry.statVisualClass.addLevel(3, getClass("src.game.gameobjects.player.stage.FireworkVisual2"));
				tempEntry.statVisualClass.addLevel(6, getClass("src.game.gameobjects.player.stage.FireworkVisual3"));
				
				tempEntry.statSound1.addLevel(0, JetCrackling);
				tempEntry.statSound2.addLevel(0, FireworkExplosion);
				tempEntry.statSound1Volume.addLevel(0, 0.6);
				tempEntry.statSound2Volume.addLevel(0, 0.9);
				
				tempEntry.statCost.addLevel(0, 75);
				tempEntry.statCost.addLevel(1, 75, 2);
				tempEntry.statCost.addLevel(6, 500, 2);
				tempEntry.statCost.addLevel(6 + Global.OVER_LEVELS, 7500);
				tempEntry.statCost.addLevel(6 + Global.MEGA_LEVELS, 27500);
				
				tempEntry.statWeight.addLevel(0, 0.8);
				
				tempEntry.statPower.addLevel(0, 1.75);
				tempEntry.statPower.addLevel(6, 3.2);
				tempEntry.statPower.addLevel(6 + Global.OVER_LEVELS, 6);
				tempEntry.statPower.addLevel(6 + Global.MEGA_LEVELS, 15);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.6, 10, 10);
				tempEntry.statPowerAtWeightMult.addLevel(6, 1.6, 28, 28);
				tempEntry.statPowerAtWeightMult.addLevel(6 + Global.OVER_LEVELS, 1.6, 60, 60);
				tempEntry.statPowerAtWeightMult.addLevel(Global.MEGA_LEVELS, 1.6, 160, 160);
				
				tempEntry.statFuel.addLevel(0, 220, 1);
				tempEntry.statFuel.addLevel(6, 500, 1);
				tempEntry.statFuel.addLevel(6 + Global.OVER_LEVELS, 800);
				tempEntry.statFuel.addLevel(6 + Global.MEGA_LEVELS, 1800);
				
				tempEntry.statSpecial.addLevel(0, 100);//Launch power from explosion
				tempEntry.statSpecial.addLevel(6, 250);//Launch power from explosion
				tempEntry.statSpecial.addLevel(6 + Global.OVER_LEVELS, 550);//Launch power from explosion
				tempEntry.statSpecial.addLevel(6 + Global.MEGA_LEVELS, 1550);//Launch power from explosion
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
			
			tempEntry = addEntry("rpg", "RPG", TYPE_STAGE, 8, RPG);//{
				tempEntry.shopDescription.addLevel(0, "Rocket Propelled Goodies, at least that's what we think it means.");
				
				tempEntry.specialIds.addLevel(4, "rpg2");
				tempEntry.specialIds.addLevel(8, "rpg3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.RPGVisual"));
				tempEntry.statVisualClass.addLevel(4, getClass("src.game.gameobjects.player.stage.RPGVisual2"));
				tempEntry.statVisualClass.addLevel(8, getClass("src.game.gameobjects.player.stage.RPGVisual3"));
				
				tempEntry.statSound1.addLevel(0, JetSound2);
				tempEntry.statSound2.addLevel(0, Explode1);
				tempEntry.statSound1Volume.addLevel(0, 0.5);
				tempEntry.statSound2Volume.addLevel(0, 0.6);
				
				tempEntry.statCost.addLevel(0, 600, 2.5);
				tempEntry.statCost.addLevel(8, 1750, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 45000);
				
				tempEntry.statWeight.addLevel(0, 4);
				
				tempEntry.statPower.addLevel(0, 4);
				tempEntry.statPower.addLevel(8, 5.5);
				tempEntry.statPower.addLevel(8 + Global.OVER_LEVELS, 8);
				tempEntry.statPower.addLevel(8 + Global.MEGA_LEVELS, 20);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.6, 20, 20);
				tempEntry.statPowerAtWeightMult.addLevel(8, 1.6, 45, 60);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.OVER_LEVELS, 1.5, 95, 95);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.MEGA_LEVELS, 1.5, 345, 245);
				
				tempEntry.statFuel.addLevel(0, 180, 1);
				tempEntry.statFuel.addLevel(8, 650, 1);
				tempEntry.statFuel.addLevel(8 + Global.OVER_LEVELS, 950, 1);
				tempEntry.statFuel.addLevel(8 + Global.MEGA_LEVELS, 1900, 1);
				
				tempEntry.statSpecial.addLevel(0, 150, 1);//Explosion power
				tempEntry.statSpecial.addLevel(8, 450, 1);
				tempEntry.statSpecial.addLevel(8 + Global.OVER_LEVELS, 1050, 1);
				tempEntry.statSpecial.addLevel(8 + Global.MEGA_LEVELS, 2500, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("pulseJet", "Pulse Jet", TYPE_STAGE, 8, PulseJet);//{
				tempEntry.shopDescription.addLevel(0, "Requires a bit of speed to work 100%.");
				
				tempEntry.specialIds.addLevel(4, "pulseJet2");
				tempEntry.specialIds.addLevel(8, "pulseJet3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.PulseJetVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.stage.PulseJetVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.stage.PulseJetVisual3"));
				
				tempEntry.statSound1.addLevel(0, JetSound3);
				tempEntry.statSound1Volume.addLevel(0, 0.5);
				
				tempEntry.statCost.addLevel(0, 400, 2);
				tempEntry.statCost.addLevel(8, 3500, 2);
				tempEntry.statCost.addLevel(8 + Global.OVER_LEVELS, 10000);
				tempEntry.statCost.addLevel(8 + Global.MEGA_LEVELS, 40000);
				
				tempEntry.statWeight.addLevel(0, 3.5);
				
				tempEntry.statPower.addLevel(0, 1.75, 1.2);
				tempEntry.statPower.addLevel(8, 3, 1.2);
				tempEntry.statPower.addLevel(8 + Global.OVER_LEVELS, 5);
				tempEntry.statPower.addLevel(8 + Global.MEGA_LEVELS, 8);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.45, 15, 15);
				tempEntry.statPowerAtWeightMult.addLevel(8, 1.45, 45, 45);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.OVER_LEVELS, 1.45, 100, 100);
				tempEntry.statPowerAtWeightMult.addLevel(8 + Global.MEGA_LEVELS, 1.45, 200, 200);
				
				tempEntry.statSpecial.addLevel(0, 0.7, 1);//Minimum power mult (at zero speed)
				
				tempEntry.statTopSpeed.addLevel(0, 10, 1);//Minimum speed for top power
				
				tempEntry.statFuel.addLevel(0, 800, 1);
				tempEntry.statFuel.addLevel(8, 1450, 1);
				tempEntry.statFuel.addLevel(8 + Global.OVER_LEVELS, 2250, 1);
				tempEntry.statFuel.addLevel(8 + Global.MEGA_LEVELS, 5250, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				tempEntry.setDisplayStat(5, "Min Speed", tempEntry.statTopSpeed);
				//}
			
			tempEntry = addEntry("ramJet", "Ram Jet", TYPE_STAGE, 10, RamJet);//{
				tempEntry.shopDescription.addLevel(0, "Requires speed in order to function efficiently.");
				
				tempEntry.specialIds.addLevel(5, "ramJet2");
				tempEntry.specialIds.addLevel(10, "ramJet3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.RamJetVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.stage.RamJetVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.stage.RamJetVisual3"));
				
				tempEntry.statSound1.addLevel(0, Fire1);
				tempEntry.statSound1Volume.addLevel(0, 0.8);
				
				tempEntry.statCost.addLevel(0, 3500, 2);
				tempEntry.statCost.addLevel(1, 2000, 2);
				tempEntry.statCost.addLevel(10, 6000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statWeight.addLevel(0, 7.5);
				
				tempEntry.statPower.addLevel(0, 3);
				tempEntry.statPower.addLevel(10, 5.0);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 7.2);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 12.5);
				
				tempEntry.statSpecial.addLevel(0, 0.35, 1);//Minimum power mult (at zero speed)
				
				tempEntry.statTopSpeed.addLevel(0, 30, 1);//Minimum speed for top power
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.4, 30, 25);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.4, 50, 50);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.4, 100, 100);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.4, 200, 200);
				
				tempEntry.statFuel.addLevel(0, 900, 1);
				tempEntry.statFuel.addLevel(10, 1800, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 3000, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 6500, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				tempEntry.setDisplayStat(5, "Min Speed", tempEntry.statTopSpeed);
				//}
				
			tempEntry = addEntry("sonicBurst", "Sonic Burst", TYPE_STAGE, 10, SonicBurst);//{
				tempEntry.shopDescription.addLevel(0, "All in one big blast!");
				
				tempEntry.specialIds.addLevel(5, "sonicBurst2");
				tempEntry.specialIds.addLevel(10, "sonicBurst3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.SonicBurstVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.stage.SonicBurstVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.stage.SonicBurstVisual3"));
				
				tempEntry.statVisualClass2.addLevel(0, getClass("src.game.gameobjects.player.stage.SonicBurstPartVisual"));
				tempEntry.statVisualClass2.addLevel(5, getClass("src.game.gameobjects.player.stage.SonicBurstPartVisual"));//Same for first 2
				tempEntry.statVisualClass2.addLevel(10, getClass("src.game.gameobjects.player.stage.SonicBurstPartVisual3"));
				
				tempEntry.statSound1.addLevel(0, Explode3);
				tempEntry.statSound1Volume.addLevel(0, 0.8);
				
				tempEntry.statCost.addLevel(0, 400, 2.7);
				tempEntry.statCost.addLevel(10, 8500, 2);
				tempEntry.statCost.addLevel(10 + 1, 5000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 15000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 65000);
				
				tempEntry.statWeight.addLevel(0, 4);
				
				var sonicBurstFuel:Number = 6;//Used to be 0, adjusts power with fuel
				
				tempEntry.statPower.addLevel(0, 325 / sonicBurstFuel, 1.6);
				tempEntry.statPower.addLevel(10, 2700 / sonicBurstFuel);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 5950 / sonicBurstFuel);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 12750 / sonicBurstFuel);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.99, 30, 25);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.99, 60, 50);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.99, 200, 200);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.99, 450, 200);
				
				tempEntry.statFuel.addLevel(0, sonicBurstFuel, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("sonicDrive", "Sonic Drive", TYPE_STAGE, 10, SonicDrive);//{
				tempEntry.setUnlockKeys("masterUnlock", "sonicDrive");
				
				tempEntry.shopDescription.addLevel(0, "I like that BOOM BOOM POW!");
				
				tempEntry.specialIds.addLevel(5, "sonicDrive2");
				tempEntry.specialIds.addLevel(10, "sonicDrive3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.SonicDriveVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.stage.SonicDriveVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.stage.SonicDriveVisual3"));
				
				tempEntry.statSound1.addLevel(0, Explode5);
				tempEntry.statSound1Volume.addLevel(0, 1);
				
				tempEntry.statCost.addLevel(0, 2400, 2);
				tempEntry.statCost.addLevel(1, 1750, 2);
				tempEntry.statCost.addLevel(10, 7000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 80000);
				
				tempEntry.statWeight.addLevel(0, 6);
				
				tempEntry.statPower.addLevel(0, 255.0);
				tempEntry.statPower.addLevel(10, 385.0);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 770);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 1520);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.8, 70, 65);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.8, 100, 85);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.8, 130, 130);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.8, 280, 200);
				
				tempEntry.statFuel.addLevel(0, 5, 99999);
				tempEntry.statFuel.addLevel(2, 6, 99999);
				tempEntry.statFuel.addLevel(4, 7, 99999);
				tempEntry.statFuel.addLevel(6, 8, 99999);
				tempEntry.statFuel.addLevel(8, 9, 99999);
				tempEntry.statFuel.addLevel(10, 10, 99999);
				//hard-coded levels have to be changed if OVER_LEVELS != 30 anymore
				tempEntry.statFuel.addLevel(10 + 5, 11, 99999);
				tempEntry.statFuel.addLevel(10 + 10, 12, 99999);
				tempEntry.statFuel.addLevel(10 + 15, 13, 99999);
				tempEntry.statFuel.addLevel(10 + 20, 14, 99999);
				tempEntry.statFuel.addLevel(10 + 25, 15, 99999);
				tempEntry.statFuel.addLevel(10 + 30, 16, 99999);
				//MEGA LEVELS
				tempEntry.statFuel.addLevel(45, 17, 99999);
				tempEntry.statFuel.addLevel(50, 18, 99999);
				tempEntry.statFuel.addLevel(60, 19, 99999);
				tempEntry.statFuel.addLevel(70, 20, 99999);
				tempEntry.statFuel.addLevel(80, 21, 99999);
				tempEntry.statFuel.addLevel(90, 22, 99999);
				tempEntry.statFuel.addLevel(100, 23, 99999);
				tempEntry.statFuel.addLevel(120, 24, 99999);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("dubstepDrive", "Dubstep Drive", TYPE_STAGE, 10, DubstepDrive);//{
				tempEntry.setUnlockKeys("masterUnlock", "dubstepDrive");
				
				tempEntry.shopDescription.addLevel(0, "Rise as the bass drops.");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.DubstepDriveVisual"));
				
				tempEntry.statSound1.addLevel(0, Dubstep1);
				tempEntry.statSound1Volume.addLevel(0, 1);
				
				tempEntry.statCost.addLevel(0, 2800, 2);
				tempEntry.statCost.addLevel(0, 2100, 2);
				tempEntry.statCost.addLevel(10, 9000, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 88888);
				
				tempEntry.statWeight.addLevel(0, 10);
				
				tempEntry.statPower.addLevel(0, 15.0);
				tempEntry.statPower.addLevel(10, 35.0);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 120);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 340);
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.9, 40, 35);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.9, 80, 70);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.9, 110, 150);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.9, 300, 200);
				
				tempEntry.statFuel.addLevel(0, 800, 99999);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Dub", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Wub", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				//}
				
			tempEntry = addEntry("solar", "Solar Turbine", TYPE_STAGE, 10, SolarPower);//{
				tempEntry.setUnlockKeys("masterUnlock", "solar");
				
				tempEntry.shopDescription.addLevel(0, "Requires altitude to function at max power.");
				
				tempEntry.specialIds.addLevel(5, "solar2");
				tempEntry.specialIds.addLevel(10, "solar3");
				
				tempEntry.statVisualClass.addLevel(0, getClass("src.game.gameobjects.player.stage.SolarVisual"));
				tempEntry.statVisualClass.addLevel(5, getClass("src.game.gameobjects.player.stage.SolarVisual2"));
				tempEntry.statVisualClass.addLevel(10, getClass("src.game.gameobjects.player.stage.SolarVisual3"));
				
				tempEntry.statVisualClass2.addLevel(0, getClass("src.game.gameobjects.player.stage.SolarPanelVisual"));
				tempEntry.statVisualClass2.addLevel(5, getClass("src.game.gameobjects.player.stage.SolarPanelVisual2"));
				tempEntry.statVisualClass2.addLevel(10, getClass("src.game.gameobjects.player.stage.SolarPanelVisual3"));
				
				tempEntry.statSound1.addLevel(0, JetLow1);
				tempEntry.statSound1Volume.addLevel(0, 0.5);
				
				tempEntry.statCost.addLevel(0, 1400);
				tempEntry.statCost.addLevel(1, 1400, 2);
				tempEntry.statCost.addLevel(10, 8500, 2);
				tempEntry.statCost.addLevel(10 + Global.OVER_LEVELS, 20000);
				tempEntry.statCost.addLevel(10 + Global.MEGA_LEVELS, 70000);
				
				tempEntry.statWeight.addLevel(0, 1);
				
				tempEntry.statPower.addLevel(0, 1.2);
				tempEntry.statPower.addLevel(10, 1.6);
				tempEntry.statPower.addLevel(10 + Global.OVER_LEVELS, 2.35);
				tempEntry.statPower.addLevel(10 + Global.MEGA_LEVELS, 4.5);
				
				tempEntry.statSpecial.addLevel(0, 150000, 1);//Altitude for max power
				tempEntry.statSpecial.addLevel(10, 100000, 1);//Altitude for max power
				
				tempEntry.statPowerAtWeightMult.addLevel(0, 1.35, 30, 30);
				tempEntry.statPowerAtWeightMult.addLevel(10, 1.35, 35, 35);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.OVER_LEVELS, 1.35, 45, 45);
				tempEntry.statPowerAtWeightMult.addLevel(10 + Global.MEGA_LEVELS, 1.35, 100, 100);
				
				tempEntry.statFuel.addLevel(0, 2000, 1);
				tempEntry.statFuel.addLevel(10, 5500, 1);
				tempEntry.statFuel.addLevel(10 + Global.OVER_LEVELS, 9000, 1);
				tempEntry.statFuel.addLevel(10 + Global.MEGA_LEVELS, 25000, 1);
				
				tempEntry.setDisplayStat(1, "Weight", tempEntry.statWeight);
				tempEntry.setDisplayStat(2, "Power", tempEntry.statPower);
				tempEntry.setDisplayStat(3, "Fuel", tempEntry.statFuel);
				tempEntry.setDisplayStat(4, "Max Lift", tempEntry.statPowerAtWeightMult);
				tempEntry.setDisplayStat(5, "Full Power Alt.", tempEntry.statSpecial);
				//}
				
				
				
				
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//Bonus Shop Items////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//Generally speaking, only "cost" and "power" should be used, "special" for unique characteristics
			
			tempEntry = addEntry("bonusBetterStart", "Secret Ingredient", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Increases stage and boost power for a limited time after takeoff");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1.3);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_END);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.300);//mult on thrust
				tempEntry.statPower.addLevel(2, 1.400);
				tempEntry.statPower.addLevel(3, 1.500);
				tempEntry.statPower.addLevel(3 + Global.OVER_LEVELS, 1.750);
				tempEntry.statPower.addLevel(3 + Global.MEGA_LEVELS, 2.000);
				tempEntry.statFuel.addLevel(0, 0);//Duration in seconds
				tempEntry.statFuel.addLevel(1, 5);
				tempEntry.statFuel.addLevel(2, 10);
				tempEntry.statFuel.addLevel(3, 15);
				tempEntry.statFuel.addLevel(3 + Global.OVER_LEVELS, 25);
				tempEntry.statFuel.addLevel(3 + Global.MEGA_LEVELS, 40);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Power mult", tempEntry.statPower, 4);
				tempEntry.setDisplayStat(2, "Duration", tempEntry.statFuel, 2);
			//}
			
			tempEntry = addEntry("bonusBoostFuel", "Fuel Compression", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Better compression means we can pack more fuel in the same boosts");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_END);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.05);//mult on boost fuel
				tempEntry.statPower.addLevel(2, 1.12);
				tempEntry.statPower.addLevel(3, 1.20);
				tempEntry.statPower.addLevel(3 + Global.OVER_LEVELS, 1.5);
				tempEntry.statPower.addLevel(3 + Global.MEGA_LEVELS, 2.5);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Boost Fuel", tempEntry.statPower, 4);
				//}
			
			tempEntry = addEntry("bonusBoostPower", "Potentiometer", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Turning the knob on this thing increases your boosts potential. Because science.");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1.3);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_END);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.05);//mult
				tempEntry.statPower.addLevel(2, 1.12);
				tempEntry.statPower.addLevel(3, 1.20);
				tempEntry.statPower.addLevel(3 + Global.OVER_LEVELS, 1.5);
				tempEntry.statPower.addLevel(3 + Global.MEGA_LEVELS, 2.5);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Boost power", tempEntry.statPower, 4);
				//}
			
			tempEntry = addEntry("bonusBpPerDay", "Fidelity Card", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "For every day passing by, we'll reward you with free Bonus Points!");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1.3);
				tempEntry.statCost.addLevel(3 + Global.OVER_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_START);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_START);
				tempEntry.statPower.addLevel(0, 0);
				tempEntry.statPower.addLevel(1, 1);
				tempEntry.statPower.addLevel(2, 2);
				tempEntry.statPower.addLevel(3, 3);
				tempEntry.statPower.addLevel(3 + 10, 4);
				tempEntry.statPower.addLevel(3 + 20, 5);
				tempEntry.statPower.addLevel(3 + 20, 5);
				tempEntry.statPower.addLevel(3 + 30, 6);
				tempEntry.statPower.addLevel(Global.MEGA_LEVELS, 15);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Daily BP", tempEntry.statPower, 2);
				//}
			
			tempEntry = addEntry("bonusGravity", "My lil black hole", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Reduce gravity on earth. Effects on solar system are unknown.");
				
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1.3);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_END);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 0.98);//Gravity mult
				tempEntry.statPower.addLevel(2, 0.96);
				tempEntry.statPower.addLevel(3, 0.94);
				tempEntry.statPower.addLevel(3 + Global.OVER_LEVELS, 0.88);
				tempEntry.statPower.addLevel(Global.MEGA_LEVELS, 0.7);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Gravity mult", tempEntry.statPower, 4);
				//}
				
			tempEntry = addEntry("bonusInterest", "Money Interest", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Earn interest on any money left at start of a day");
				
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1.3);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_END);
				tempEntry.statPower.addLevel(0, 0);
				tempEntry.statPower.addLevel(1, 0.01);//Interest on money left on start of day
				tempEntry.statPower.addLevel(2, 0.02);
				tempEntry.statPower.addLevel(3, 0.03);
				tempEntry.statPower.addLevel(3 + Global.OVER_LEVELS, 0.05);
				tempEntry.statPower.addLevel(3 + Global.MEGA_LEVELS, 0.15);
				tempEntry.statFuel.addLevel(0, 5000);//Max amount, to limit abuse and bugs
				tempEntry.statFuel.addLevel(1, 6500);//Max amount, to limit abuse and bugs
				tempEntry.statFuel.addLevel(2, 8000);//Max amount, to limit abuse and bugs
				tempEntry.statFuel.addLevel(3, 10000);
				tempEntry.statFuel.addLevel(3 + Global.OVER_LEVELS, 15000);
				tempEntry.statFuel.addLevel(3 + Global.MEGA_LEVELS, 100000);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Interest", tempEntry.statPower, 4);
				tempEntry.setDisplayStat(2, "Daily max", tempEntry.statFuel, 0);
				//}
				
			tempEntry = addEntry("bonusLaunchPower", "Premium Spring", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Get more \"oompf\" out of your launchers!");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1.3);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_END);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.10);//mult
				tempEntry.statPower.addLevel(2, 1.22);
				tempEntry.statPower.addLevel(3, 1.35);
				tempEntry.statPower.addLevel(3 + Global.OVER_LEVELS, 1.6);
				tempEntry.statPower.addLevel(3 + Global.MEGA_LEVELS, 3.2);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Launch power", tempEntry.statPower, 4);
				//}
				
			tempEntry = addEntry("bonusLessObstacles", "Traffic Control", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Reduce the number of obstacles above our flying zone");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1.3);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_END);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 0.85);//mult
				tempEntry.statPower.addLevel(2, 0.70);
				tempEntry.statPower.addLevel(3, 0.50);
				tempEntry.statPower.addLevel(3 + Global.OVER_LEVELS, 0.35);
				tempEntry.statPower.addLevel(3 + Global.MEGA_LEVELS, 0.15);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Obstacles amount", tempEntry.statPower, 4);
				//}
				
			tempEntry = addEntry("bonusDrag", "Aerodynamics", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Reduce the effect of air drag. Gotta go faaast!");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1.3);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_END);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 0.95);//mult
				tempEntry.statPower.addLevel(2, 0.88);
				tempEntry.statPower.addLevel(3, 0.80);
				tempEntry.statPower.addLevel(3 + Global.OVER_LEVELS, 0.65);
				tempEntry.statPower.addLevel(3 + Global.MEGA_LEVELS, 0.5);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Drag", tempEntry.statPower, 4);
				//}
				
			tempEntry = addEntry("bonusWind", "Counter-winds", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Our trusty fans will reduce the effect of wind! I promise it works!");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1.3);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_START);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 0.85);//mult
				tempEntry.statPower.addLevel(2, 0.70);
				tempEntry.statPower.addLevel(3, 0.50);
				tempEntry.statPower.addLevel(3 + Global.OVER_LEVELS, 0.25);
				tempEntry.statPower.addLevel(3 + Global.MEGA_LEVELS, 0.05);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Wind strength", tempEntry.statPower, 4);
				//}
				
			tempEntry = addEntry("bonusMoney", "Boost Income", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Increases the money earned after each day");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1.3);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_END);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.05);//mult
				tempEntry.statPower.addLevel(2, 1.12);
				tempEntry.statPower.addLevel(3, 1.20);
				tempEntry.statPower.addLevel(3 + Global.OVER_LEVELS, 1.35);
				tempEntry.statPower.addLevel(3 + Global.MEGA_LEVELS, 2);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Money mult", tempEntry.statPower, 4);
				//}
				
			tempEntry = addEntry("bonusOverBodiesAndLaunchers", "The Golden Wrench", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Upgrade bodies and launchers beyond their regular max level!");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 150);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 250);
				tempEntry.statCost.addLevel(4, 300);
				tempEntry.statCost.addLevel(5, 300);
				tempEntry.statCost.addLevel(6, 300);
				tempEntry.statCost.addLevel(7, 300);
				tempEntry.statCost.addLevel(8, 300);
				tempEntry.statCost.addLevel(9, 300);
				tempEntry.statCost.addLevel(10, 500);
				tempEntry.statPower.addLevel(0, 0);
				tempEntry.statPower.addLevel(3, Global.OVER_LEVELS);
				tempEntry.statPower.addLevel(10, Global.MEGA_LEVELS);
				
				tempEntry.statSpecial.addLevel(0, 0);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Over-levels", tempEntry.statPower);
				//}
				
			tempEntry = addEntry("bonusOverStages", "The Golden Hammer", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Upgrade stages beyond their regular max level!");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 150);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 250);
				tempEntry.statCost.addLevel(4, 300);
				tempEntry.statCost.addLevel(5, 300);
				tempEntry.statCost.addLevel(6, 300);
				tempEntry.statCost.addLevel(7, 300);
				tempEntry.statCost.addLevel(8, 300);
				tempEntry.statCost.addLevel(9, 300);
				tempEntry.statCost.addLevel(10, 500);
				tempEntry.statPower.addLevel(0, 0);
				tempEntry.statPower.addLevel(3, Global.OVER_LEVELS);
				tempEntry.statPower.addLevel(10, Global.MEGA_LEVELS);
				
				tempEntry.statSpecial.addLevel(0, 0);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Over-levels", tempEntry.statPower);
				//}
				
			tempEntry = addEntry("bonusOverBoosts", "The Golden Pliers", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Upgrade boosts beyond their regular max level!");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 150);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 250);
				tempEntry.statCost.addLevel(4, 300);
				tempEntry.statCost.addLevel(5, 300);
				tempEntry.statCost.addLevel(6, 300);
				tempEntry.statCost.addLevel(7, 300);
				tempEntry.statCost.addLevel(8, 300);
				tempEntry.statCost.addLevel(9, 300);
				tempEntry.statCost.addLevel(10, 300);
				tempEntry.statPower.addLevel(0, 0);
				tempEntry.statPower.addLevel(3, Global.OVER_LEVELS);
				tempEntry.statPower.addLevel(10, Global.MEGA_LEVELS);
				
				tempEntry.statSpecial.addLevel(0, 0);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Over-levels", tempEntry.statPower);
				//}
				
			tempEntry = addEntry("bonusOver", "The Golden Scope", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Upgrade bonus items beyond their regular max level! Costly and inefficient though...");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 150);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 250);
				tempEntry.statCost.addLevel(4, 300);
				tempEntry.statCost.addLevel(5, 300);
				tempEntry.statCost.addLevel(6, 300);
				tempEntry.statCost.addLevel(7, 300);
				tempEntry.statCost.addLevel(8, 300);
				tempEntry.statCost.addLevel(9, 300);
				tempEntry.statCost.addLevel(10, 500);
				tempEntry.statPower.addLevel(0, 0);
				tempEntry.statPower.addLevel(3, Global.OVER_LEVELS);
				tempEntry.statPower.addLevel(10, Global.MEGA_LEVELS);
				
				tempEntry.statSpecial.addLevel(0, 0);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Over-levels", tempEntry.statPower);
				//}
				
			tempEntry = addEntry("bonusImpact", "Spring-Plating", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Reduce the effects of colliding with obstacles");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1.3);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_END);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 0.85);//mult
				tempEntry.statPower.addLevel(2, 0.70);
				tempEntry.statPower.addLevel(3, 0.50);
				tempEntry.statPower.addLevel(3 + Global.OVER_LEVELS, 0.30);
				tempEntry.statPower.addLevel(3 + Global.MEGA_LEVELS, 0.125);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Impact reduction", tempEntry.statPower, 4);
				//}
				
			tempEntry = addEntry("bonusStageFuel", "Improved Fuel", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Make stages last longer. Yes balloons too.");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1.3);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_END);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.05);//mult
				tempEntry.statPower.addLevel(2, 1.12);
				tempEntry.statPower.addLevel(3, 1.20);
				tempEntry.statPower.addLevel(3 + Global.OVER_LEVELS, 1.5);
				tempEntry.statPower.addLevel(3 + Global.MEGA_LEVELS, 2.5);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Stage fuel", tempEntry.statPower, 4);
				//}
				
			tempEntry = addEntry("bonusSpeed", "Polishing", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "The superior finish increases top speed");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1.3);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_END);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.05);//mult
				tempEntry.statPower.addLevel(2, 1.12);
				tempEntry.statPower.addLevel(3, 1.20);
				tempEntry.statPower.addLevel(3 + Global.OVER_LEVELS, 1.5);
				tempEntry.statPower.addLevel(3 + Global.MEGA_LEVELS, 2);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Top speed mult", tempEntry.statPower, 4);
				//}
				
			tempEntry = addEntry("bonusStagePower", "Turbocompressor", TYPE_BONUS, 3, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Increase the thrust of stages");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 100);
				tempEntry.statCost.addLevel(2, 200);
				tempEntry.statCost.addLevel(3, 300);
				tempEntry.statCost.addLevel(3 + 1, Global.BONUS_ITEM_OVERLEVEL_COST_START, 1.3);
				tempEntry.statCost.addLevel(3 + Global.MEGA_LEVELS, Global.BONUS_ITEM_OVERLEVEL_COST_END);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.05);//mult
				tempEntry.statPower.addLevel(2, 1.12);
				tempEntry.statPower.addLevel(3, 1.20);
				tempEntry.statPower.addLevel(3 + Global.OVER_LEVELS, 1.5);
				tempEntry.statPower.addLevel(3 + Global.MEGA_LEVELS, 2.5);
				
				tempEntry.statSpecial.addLevel(0, 1);//Bonus downgradeable if 1, static if 0
				
				tempEntry.setDisplayStat(1, "Stage power", tempEntry.statPower, 4);
				//}
				
				
			tempEntry = addEntry("bonusVCR", "VCR", TYPE_BONUS, 1, BONUS_ITEM_CLASS);//{
				tempEntry.shopDescription.addLevel(0, "Use it to replay cutscenes in full\rlow-definition glory!");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statCost.addLevel(1, 200);
				tempEntry.statPower.addLevel(0, 1);
				
				tempEntry.statSpecial.addLevel(0, 0);//Bonus downgradeable if 1, static if 0
				
				//}
				
				
				
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//Medals /////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//"gameClass" holds the class of the movieclip for the medal
			//"cost" is the amount required to unlock the medal
			//"power" is the strength of the granted bonus effect
			//"bodyStageBeforeGameClass" is the bonus descripton
			//"special" is the reward in BP
			
			tempEntry = addEntry("medalSpeed", "Gotta go fast!", TYPE_MEDAL, 3, getClass("src.shop.medals.Speed"));//{
				tempEntry.shopDescription.addLevel(0, "Fly faster than 10 mph, launch doesn't count!");
				tempEntry.shopDescription.addLevel(1, "Fly faster than 20 mph, launch doesn't count!");
				tempEntry.shopDescription.addLevel(2, "Fly faster than 35 mph, launch doesn't count!");
				tempEntry.shopDescription.addLevel(3, "Fly faster than 60 mph, launch doesn't count!");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+1.5% drag reduction + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+1.5% drag reduction + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+1.5% drag reduction + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "+1.5% drag reduction + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 10);
				tempEntry.statCost.addLevel(1, 20);
				tempEntry.statCost.addLevel(2, 35);
				tempEntry.statCost.addLevel(3, 60);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 0.985);
				tempEntry.statPower.addLevel(2, 0.97);
				tempEntry.statPower.addLevel(3, 0.955);
				tempEntry.statPower.addLevel(4, 0.94);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalAltitude", "Lemme get high...", TYPE_MEDAL, 3, getClass("src.shop.medals.Altitude"));//{
				tempEntry.shopDescription.addLevel(0, "Fly to an altitude of 5,000'");
				tempEntry.shopDescription.addLevel(1, "Fly to an altitude of 20,000'");
				tempEntry.shopDescription.addLevel(2, "Fly to an altitude of 80,000'");
				tempEntry.shopDescription.addLevel(3, "Fly to an altitude of 400,000'");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+2.5% stage power + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+2.5% stage power + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+2.5% stage power + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "+2.5% stage power + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 5000);
				tempEntry.statCost.addLevel(1, 20000);
				tempEntry.statCost.addLevel(2, 80000);
				tempEntry.statCost.addLevel(3, 400000);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.025);
				tempEntry.statPower.addLevel(2, 1.05);
				tempEntry.statPower.addLevel(3, 1.075);
				tempEntry.statPower.addLevel(4, 1.1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalFlightTime", "Flight Time", TYPE_MEDAL, 3, getClass("src.shop.medals.FlightTime"));//{
				tempEntry.shopDescription.addLevel(0, "Fly for a duration of 20 seconds");
				tempEntry.shopDescription.addLevel(1, "Fly for a duration of 60 seconds");
				tempEntry.shopDescription.addLevel(2, "Fly for a duration of 120 seconds");
				tempEntry.shopDescription.addLevel(3, "Fly for a duration of 200 seconds");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+1.5% stage fuel + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+1.5% stage fuel + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+1.5% stage fuel + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "+1.5% stage fuel + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 20);
				tempEntry.statCost.addLevel(1, 60);
				tempEntry.statCost.addLevel(2, 120);
				tempEntry.statCost.addLevel(3, 200);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.015);
				tempEntry.statPower.addLevel(2, 1.03);
				tempEntry.statPower.addLevel(3, 1.045);
				tempEntry.statPower.addLevel(4, 1.06);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalCash", "Savings", TYPE_MEDAL, 3, getClass("src.shop.medals.Cash"));//{
				tempEntry.shopDescription.addLevel(0, "Have $1,000 in your wallet'");
				tempEntry.shopDescription.addLevel(1, "Have $10,000 in your wallet'");
				tempEntry.shopDescription.addLevel(2, "Have $50,000 in your wallet'");
				tempEntry.shopDescription.addLevel(3, "Have $150,000 in your wallet'");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+2.5% extra earnings + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+2.5% extra earnings + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+2.5% extra earnings + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "+2.5% extra earnings + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 1000);
				tempEntry.statCost.addLevel(1, 10000);
				tempEntry.statCost.addLevel(2, 50000);
				tempEntry.statCost.addLevel(3, 150000);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.025);
				tempEntry.statPower.addLevel(2, 1.05);
				tempEntry.statPower.addLevel(3, 1.075);
				tempEntry.statPower.addLevel(4, 1.1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalHorizontalDistance", "The old way", TYPE_MEDAL, 3, getClass("src.shop.medals.HorizontalDistance"));//{
				tempEntry.shopDescription.addLevel(0, "Travel 10,000' left or right");
				tempEntry.shopDescription.addLevel(1, "Travel 25,000' left or right");
				tempEntry.shopDescription.addLevel(2, "Travel 50,000' left or right");
				tempEntry.shopDescription.addLevel(3, "Travel 100,000' left or right");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+1% boost power + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+1% boost power + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+1% boost power + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "+1% boost power + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 10000);
				tempEntry.statCost.addLevel(1, 25000);
				tempEntry.statCost.addLevel(2, 50000);
				tempEntry.statCost.addLevel(3, 100000);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.01);
				tempEntry.statPower.addLevel(2, 1.02);
				tempEntry.statPower.addLevel(3, 1.03);
				tempEntry.statPower.addLevel(4, 1.04);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalDays", "PLAY MOAR", TYPE_MEDAL, 3, getClass("src.shop.medals.Days"));//{
				tempEntry.shopDescription.addLevel(0, "Play for 10 in-game days");
				tempEntry.shopDescription.addLevel(1, "Play for 50 in-game days");
				tempEntry.shopDescription.addLevel(2, "Play for 100 in-game days");
				tempEntry.shopDescription.addLevel(3, "Play for 200 in-game days");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+2.5% launcher power + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+2.5% launcher power + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+2.5% launcher power + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "+2.5% launcher power + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 10);
				tempEntry.statCost.addLevel(1, 50);
				tempEntry.statCost.addLevel(2, 100);
				tempEntry.statCost.addLevel(3, 200);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.025);
				tempEntry.statPower.addLevel(2, 1.05);
				tempEntry.statPower.addLevel(3, 1.075);
				tempEntry.statPower.addLevel(4, 1.1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalItemUpgrades", "Gotta upgrade 'em all", TYPE_MEDAL, 3, getClass("src.shop.medals.ItemUpgrades"));//{
				tempEntry.shopDescription.addLevel(0, "Have an item to its maximum level");
				tempEntry.shopDescription.addLevel(1, "Have 4 items to their max level");
				tempEntry.shopDescription.addLevel(2, "Have 8 items to their max level");
				tempEntry.shopDescription.addLevel(3, "Have 10 items to +5 over-level");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+5% steering + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+5% steering + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+5% steering + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "+5% steering + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 1);
				tempEntry.statCost.addLevel(1, 4);
				tempEntry.statCost.addLevel(2, 8);
				tempEntry.statCost.addLevel(3, 10);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.05);
				tempEntry.statPower.addLevel(2, 1.1);
				tempEntry.statPower.addLevel(3, 1.15);
				tempEntry.statPower.addLevel(4, 1.2);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalFrequentBuyer", "Capitalism!", TYPE_MEDAL, 3, getClass("src.shop.medals.FrequentBuyer"));//{
				tempEntry.shopDescription.addLevel(0, "Purchase a total of 10 items");
				tempEntry.shopDescription.addLevel(1, "Purchase a total of 50 items");
				tempEntry.shopDescription.addLevel(2, "Purchase a total of 100 items");
				tempEntry.shopDescription.addLevel(3, "Purchase a total of 200 items");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+2.5% extra earnings + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+2.5% extra earnings + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+2.5% extra earnings + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "+2.5% extra earnings + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 10);
				tempEntry.statCost.addLevel(1, 50);
				tempEntry.statCost.addLevel(2, 100);
				tempEntry.statCost.addLevel(3, 200);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.025);
				tempEntry.statPower.addLevel(2, 1.05);
				tempEntry.statPower.addLevel(3, 1.075);
				tempEntry.statPower.addLevel(4, 1.1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalAltitudeTotal", "Total Altitude", TYPE_MEDAL, 3, getClass("src.shop.medals.AltitudeTotal"));//{
				tempEntry.shopDescription.addLevel(0, "Travel a total of 100,000' up");
				tempEntry.shopDescription.addLevel(1, "Travel a total of 500,000' up");
				tempEntry.shopDescription.addLevel(2, "Travel a total of 1,000,000' up");
				tempEntry.shopDescription.addLevel(3, "Travel a total of 20,000,000' up");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+2.5% boost power + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+2.5% boost power + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+2.5% boost power + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "+2.5% boost power + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 100000);
				tempEntry.statCost.addLevel(1, 500000);
				tempEntry.statCost.addLevel(2, 1000000);
				tempEntry.statCost.addLevel(3, 20000000);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.025);
				tempEntry.statPower.addLevel(2, 1.05);
				tempEntry.statPower.addLevel(3, 1.075);
				tempEntry.statPower.addLevel(4, 1.1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalFlightTimeTotal", "Time well spent", TYPE_MEDAL, 3, getClass("src.shop.medals.FlightTimeTotal"));//{
				tempEntry.shopDescription.addLevel(0, "Spend a total of 300 seconds flying");
				tempEntry.shopDescription.addLevel(1, "Spend a total of 800 seconds flying");
				tempEntry.shopDescription.addLevel(2, "Spend a total of 1400 seconds flying");
				tempEntry.shopDescription.addLevel(3, "Spend a total of 2500 seconds flying");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+2.5% boost fuel + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+2.5% boost fuel + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+2.5% boost fuel + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "+2.5% boost fuel + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 300);
				tempEntry.statCost.addLevel(1, 800);
				tempEntry.statCost.addLevel(2, 1400);
				tempEntry.statCost.addLevel(3, 2500);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.025);
				tempEntry.statPower.addLevel(2, 1.05);
				tempEntry.statPower.addLevel(3, 1.075);
				tempEntry.statPower.addLevel(4, 1.1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalCashTotal", "Long-term investment", TYPE_MEDAL, 3, getClass("src.shop.medals.CashTotal"));//{
				tempEntry.shopDescription.addLevel(0, "Earn a total of $10,000");
				tempEntry.shopDescription.addLevel(1, "Earn a total of 50,000");
				tempEntry.shopDescription.addLevel(2, "Earn a total of 250,000");
				tempEntry.shopDescription.addLevel(3, "Earn a total of 1,000,000");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+5 starting cash + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+5 starting cash + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+10 starting cash + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "+20 starting cash + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 10000);
				tempEntry.statCost.addLevel(1, 50000);
				tempEntry.statCost.addLevel(2, 250000);
				tempEntry.statCost.addLevel(3, 1000000);
				//tempEntry.statPower.addLevel(0, 1);
				//tempEntry.statPower.addLevel(1, 1.025);
				//tempEntry.statPower.addLevel(2, 1.05);
				//tempEntry.statPower.addLevel(3, 1.075);
				//tempEntry.statPower.addLevel(4, 1.1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalObstaclesHit", "It's just a scratch...", TYPE_MEDAL, 3, getClass("src.shop.medals.ObstaclesHit"));//{
				tempEntry.shopDescription.addLevel(0, "Hit a total of 10 obstacles");
				tempEntry.shopDescription.addLevel(1, "Hit a total of 25 obstacles");
				tempEntry.shopDescription.addLevel(2, "Hit a total of 100 obstacles");
				tempEntry.shopDescription.addLevel(3, "Hit a total of 250 obstacles");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+5% lighter obstacles + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+5% lighter obstacles + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+5% lighter obstacles + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "+5% lighter obstacles + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 10);
				tempEntry.statCost.addLevel(1, 25);
				tempEntry.statCost.addLevel(2, 100);
				tempEntry.statCost.addLevel(3, 250);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 0.95);
				tempEntry.statPower.addLevel(2, 0.9);
				tempEntry.statPower.addLevel(3, 0.85);
				tempEntry.statPower.addLevel(4, 0.8);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalStagesOnly", "Keepin' it simple", TYPE_MEDAL, 3, getClass("src.shop.medals.StagesOnly"));//{
				tempEntry.shopDescription.addLevel(0, "Reach an altitude of 10,000' without launchers or boosts");
				tempEntry.shopDescription.addLevel(1, "Reach an altitude of 25,000' without launchers or boosts");
				tempEntry.shopDescription.addLevel(2, "Reach an altitude of 100,000' without launchers or boosts");
				tempEntry.shopDescription.addLevel(3, "Reach an altitude of 200,000' without launchers or boosts");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+2.5% launcher power + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+2.5% launcher power + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+2.5% launcher power + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "+2.5% launcher power + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 10000);
				tempEntry.statCost.addLevel(1, 25000);
				tempEntry.statCost.addLevel(2, 100000);
				tempEntry.statCost.addLevel(3, 200000);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 1.025);
				tempEntry.statPower.addLevel(2, 1.05);
				tempEntry.statPower.addLevel(3, 1.075);
				tempEntry.statPower.addLevel(4, 1.1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalBasicBody", "Penguin in space", TYPE_MEDAL, 3, getClass("src.shop.medals.BasicBody"));//{
				tempEntry.shopDescription.addLevel(0, "Reach an altitude of 10,000' with the default body (empty)");
				tempEntry.shopDescription.addLevel(1, "Reach an altitude of 25,000' with the default body (empty)");
				tempEntry.shopDescription.addLevel(2, "Reach an altitude of 50,000' with the default body (empty)");
				tempEntry.shopDescription.addLevel(3, "Reach an altitude of 100,000' with the default body (empty)");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+1.5% drag reduction + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+1.5% drag reduction + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+1.5% drag reduction + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "Omega penguin body + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 10000);
				tempEntry.statCost.addLevel(1, 25000);
				tempEntry.statCost.addLevel(2, 50000);
				tempEntry.statCost.addLevel(3, 100000);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 0.985);
				tempEntry.statPower.addLevel(2, 0.97);
				tempEntry.statPower.addLevel(3, 0.955);
				tempEntry.statPower.addLevel(4, 0.955);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalPayload", "Payload Master", TYPE_MEDAL, 3, getClass("src.shop.medals.Payload"));//{
				tempEntry.shopDescription.addLevel(0, "Reach an altitude of 25,000' with a payload of 1");
				tempEntry.shopDescription.addLevel(1, "Reach an altitude of 50,000' with a payload of 15");
				tempEntry.shopDescription.addLevel(2, "Reach an altitude of 100,000' with a payload of 75");
				tempEntry.shopDescription.addLevel(3, "Reach an altitude of 200,000' with a payload of 150");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+2% weight reduction + " + Global.LEVEL_1_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, "+2% weight reduction + " + Global.LEVEL_2_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, "+2% weight reduction + " + Global.LEVEL_3_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, "+2% weight reduction + " + Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statPower.addLevel(1, 0.98);
				tempEntry.statPower.addLevel(2, 0.96);
				tempEntry.statPower.addLevel(3, 0.94);
				tempEntry.statPower.addLevel(4, 0.92);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_2_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_3_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalStoryMode", "Story Mode", TYPE_MEDAL, 3, getClass("src.shop.medals.GameMode1"));//{
				tempEntry.shopDescription.addLevel(0, "Complete the game on Story Mode");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+" + Global.LEVEL_5_MEDAL_REWARD + " Bonus Points");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_5_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalStoryMode2", "Story Mode 2", TYPE_MEDAL, 3, getClass("src.shop.medals.GameMode1b"));//{
				tempEntry.shopDescription.addLevel(0, "Complete the game on Story Mode at 500,000 altitude");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+" + Global.LEVEL_6_MEDAL_REWARD + " Bonus Points");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_6_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalStoryMode3", "Story Mode 3", TYPE_MEDAL, 3, getClass("src.shop.medals.GameMode1c"));//{
				tempEntry.shopDescription.addLevel(0, "Complete the game on Story Mode at 1,000,000 altitude");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+" + Global.LEVEL_7_MEDAL_REWARD + " Bonus Points");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_7_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalStoryMode4", "Story Mode 4", TYPE_MEDAL, 3, getClass("src.shop.medals.GameMode1d"));//{
				tempEntry.shopDescription.addLevel(0, "Complete the game on Story Mode at 4,000,000 altitude");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+" + Global.LEVEL_8_MEDAL_REWARD + " Bonus Points");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_8_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalFreeMode", "Payload Mode", TYPE_MEDAL, 3, getClass("src.shop.medals.GameMode2"));//{
				tempEntry.shopDescription.addLevel(0, "Complete every challenge on Payload Mode");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+" + Global.LEVEL_5_MEDAL_REWARD + " Bonus Points");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_5_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalClassicMode", "Classic Mode", TYPE_MEDAL, 3, getClass("src.shop.medals.GameMode3"));//{
				tempEntry.shopDescription.addLevel(0, "Complete the game on Classic Mode");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+" + Global.LEVEL_5_MEDAL_REWARD + " Bonus Points");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_5_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalSandboxMode", "Sandbox Mode", TYPE_MEDAL, 3, getClass("src.shop.medals.GameMode4"));//{
				tempEntry.shopDescription.addLevel(0, "Play 10 days on Sandbox Mode");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+" + Global.LEVEL_5_MEDAL_REWARD + " Bonus Points");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statPower.addLevel(0, 10);//Days
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_5_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalEasterEggs", "Easter eggs!", TYPE_MEDAL, 3, getClass("src.shop.medals.EasterEgg"));//{
				tempEntry.shopDescription.addLevel(0, "Have you found the 4 secret videos?");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+" + Global.LEVEL_4_MEDAL_REWARD + " Bonus Points");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			//tempEntry = addEntry("medalAroundTheWorld", "Around the world", TYPE_MEDAL, 3, getClass("src.shop.medals.AroundTheWorld"));//{
				//tempEntry.shopDescription.addLevel(0, "Do a full circle around the earth after leaving the atmosphere");
				//tempEntry.bodyStageBeforeGameClass.addLevel(0, "+500 Bonus Points");
				//tempEntry.statCost.addLevel(0, 0);
				//tempEntry.statPower.addLevel(0, 1);
				//tempEntry.statSpecial.addLevel(0, 500);
				////}
				
			tempEntry = addEntry("medalAllBonus", "Grab all the bonuses!", TYPE_MEDAL, 3, getClass("src.shop.medals.AllBonus"));//{
				tempEntry.shopDescription.addLevel(0, "Get every Bonus Shop item at level 1 or more");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+" + Global.LEVEL_5_MEDAL_REWARD + " Bonus Points");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_5_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalMoonBreaker", "Moon Breaker", TYPE_MEDAL, 3, getClass("src.shop.medals.MoonBreaker"));//{
				tempEntry.shopDescription.addLevel(0, "Destroy the moon to... prevent goku from transforming? Just go really fast...");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+" + Global.LEVEL_5_MEDAL_REWARD + " Bonus Points");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_5_MEDAL_REWARD);
				//}
				
				
				
				
				
			////Cards, for display only
			tempEntry = addEntry("bp1", "Bonus Point 1", TYPE_MEDAL, 1, null);//{
				tempEntry.shopDescription.addLevel(0, "A card worth 25 Bonus Points");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "");
				//}
				
			tempEntry = addEntry("bp2", "Bonus Point 2", TYPE_MEDAL, 1, null);//{
				tempEntry.shopDescription.addLevel(0, "A card worth 50 Bonus Points");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "");
				//}
				
			tempEntry = addEntry("bp3", "Bonus Point 3", TYPE_MEDAL, 1, null);//{
				tempEntry.shopDescription.addLevel(0, "A card worth 100 Bonus Points");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "");
				//}
				
			tempEntry = addEntry("bp4", "Bonus Point 4", TYPE_MEDAL, 1, null);//{
				tempEntry.shopDescription.addLevel(0, "A card worth 150 Bonus Points");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "");
				//}
				
			tempEntry = addEntry("bp5", "Bonus Point 5", TYPE_MEDAL, 1, null);//{
				tempEntry.shopDescription.addLevel(0, "A card worth 250 Bonus Points");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "");
				//}
				

				//
				//
				
			tempEntry = addEntry("medalChallengeStory1", "Story Challenge 1", TYPE_MEDAL, 3, getClass("src.shop.medals.ChallengeStory1"));//{
				tempEntry.shopDescription.addLevel(0, "Complete Story Mode in 10 days or less");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+" + Global.LEVEL_4_MEDAL_REWARD + " Bonus Points");
				tempEntry.statCost.addLevel(0, 10);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalChallengeStory4", "Story Challenge 2", TYPE_MEDAL, 3, getClass("src.shop.medals.ChallengeStory4"));//{
				tempEntry.shopDescription.addLevel(0, "Complete 4,000k Story Mode in 28 days or less");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+" + Global.LEVEL_5_MEDAL_REWARD + " Bonus Points");
				tempEntry.statCost.addLevel(0, 28);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_5_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalChallengePayload", "Payload Challenge", TYPE_MEDAL, 3, getClass("src.shop.medals.ChallengePayload"));//{
				tempEntry.shopDescription.addLevel(0, "Complete Payload Mode in 15 days or less");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+" + Global.LEVEL_4_MEDAL_REWARD + " Bonus Points");
				tempEntry.statCost.addLevel(0, 15);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalChallengeClassic", "Classic Challenge", TYPE_MEDAL, 3, getClass("src.shop.medals.ChallengeClassic"));//{
				tempEntry.shopDescription.addLevel(0, "Complete Classic Mode in 10 days or less");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "+" + Global.LEVEL_4_MEDAL_REWARD + " Bonus Points");
				tempEntry.statCost.addLevel(0, 10);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_4_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalCompletionist", "Completionist", TYPE_MEDAL, 3, getClass("src.shop.medals.Completionist"));//{
				tempEntry.shopDescription.addLevel(0, "Earn every other medal");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "Dodo body +" + (Global.LEVEL_8_MEDAL_REWARD * 2) + " Bonus Points");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(0, (Global.LEVEL_8_MEDAL_REWARD * 2));
				//}
				
			tempEntry = addEntry("medalCheater", "You cheater!", TYPE_MEDAL, 3, getClass("src.shop.medals.Cheater"));//{
				tempEntry.shopDescription.addLevel(0, "Medal of great shame for those who cheat in this game...");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, "Nothing! You LOSE! Good day sir!");
				tempEntry.statCost.addLevel(0, 0);
				tempEntry.statPower.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(0, 0);
				//}
				
				
			tempEntry = addEntry("medalComeBack", "Frequent Flyer", TYPE_MEDAL, 3, getClass("src.shop.medals.ComeBack"));//{
				tempEntry.shopDescription.addLevel(0, "Play the game on 2 different real life days");
				tempEntry.shopDescription.addLevel(1, "Play the game on 3 different real life days");
				tempEntry.shopDescription.addLevel(2, "Play the game on 4 different real life days");
				tempEntry.shopDescription.addLevel(3, "Play the game on 5 different real life days");
				tempEntry.statCost.addLevel(0, 2);
				tempEntry.statCost.addLevel(1, 3);
				tempEntry.statCost.addLevel(2, 4);
				tempEntry.statCost.addLevel(3, 5);
				tempEntry.bodyStageBeforeGameClass.addLevel(0, Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(1, Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(2, Global.LEVEL_4_MEDAL_REWARD + "BP");
				tempEntry.bodyStageBeforeGameClass.addLevel(3, Global.LEVEL_5_MEDAL_REWARD + "BP");
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_4_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(1, Global.LEVEL_4_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(2, Global.LEVEL_4_MEDAL_REWARD);
				tempEntry.statSpecial.addLevel(3, Global.LEVEL_5_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalInsaneAltitude", "To the infinity...", TYPE_MEDAL, 1, getClass("src.shop.medals.InsaneAltitude"));//{
				tempEntry.shopDescription.addLevel(0, "Fly to an altitude of 5,000,000'");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, Global.LEVEL_7_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 5000000);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_7_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalInsaneAltitude2", "...and beyond!", TYPE_MEDAL, 1, getClass("src.shop.medals.InsaneAltitude"));//{
				tempEntry.shopDescription.addLevel(0, "Fly to an altitude of 10,000,000'");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, Global.LEVEL_7_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 10000000);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_7_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalSpeedrunner", "Speedrunner 1", TYPE_MEDAL, 1, getClass("src.shop.medals.SpeedRun"));//{
				tempEntry.shopDescription.addLevel(0, "Complete Story Mode in 6 days or less");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, Global.LEVEL_7_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 6);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_7_MEDAL_REWARD);
				//}
				
			tempEntry = addEntry("medalSpeedrunner2", "Speedrunner 2", TYPE_MEDAL, 1, getClass("src.shop.medals.SpeedRun"));//{
				tempEntry.shopDescription.addLevel(0, "Complete 4,000k Story Mode in 13 days or less");
				tempEntry.bodyStageBeforeGameClass.addLevel(0, Global.LEVEL_7_MEDAL_REWARD + "BP");
				tempEntry.statCost.addLevel(0, 13);
				tempEntry.statSpecial.addLevel(0, Global.LEVEL_7_MEDAL_REWARD);
				//}
				
				
				
				////HERE - Determine goal for payload and classic speedrun
				
			//tempEntry = addEntry("medalSpeedrunner3", "Speedrunner 3", TYPE_MEDAL, 3, getClass("src.shop.medals.AltitudeChallenge"));//{
				//tempEntry.shopDescription.addLevel(0, "Complete Payload Mode in 13 days or less");
				//tempEntry.bodyStageBeforeGameClass.addLevel(0, Global.LEVEL_1_MEDAL_REWARD + "BP");
				//tempEntry.statCost.addLevel(0, 13);
				//tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				////}
				
			//tempEntry = addEntry("medalSpeedrunner4", "Speedrunner 4", TYPE_MEDAL, 3, getClass("src.shop.medals.AltitudeChallenge"));//{
				//tempEntry.shopDescription.addLevel(0, "Complete Classic Mode in 13 days or less");
				//tempEntry.bodyStageBeforeGameClass.addLevel(0, Global.LEVEL_1_MEDAL_REWARD + "BP");
				//tempEntry.statCost.addLevel(0, 13);
				//tempEntry.statSpecial.addLevel(0, Global.LEVEL_1_MEDAL_REWARD);
				////}
				
				
				
				
				
				
				
				
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//Huds /////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//"gameClass" holds the class of the movieclip for the medal
			//"cost" is the amount required to unlock the medal
			//"power" is the strength of the granted bonus effect
			//"bodyStageBeforeGameClass" is the bonus descripton
			//"special" is the reward in BP
				
			tempEntry = addEntry("blackSpeed", "High Tech Speed", TYPE_HUD, 3, BlackSpeed);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("digitalAltitude", "Digital Altitude", TYPE_HUD, 3, DigitalAltitude);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("digitalSpeed", "Digital Speed", TYPE_HUD, 3,DigitalSpeed);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("digitalDrag", "Digital Drag", TYPE_HUD, 3, DigitalDrag);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("digitalWind", "Digital Wind", TYPE_HUD, 3, DigitalWind);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("digitalDuration", "Digital Flight Time", TYPE_HUD, 3, DigitalDuration);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("digitalDistance", "Digital Distance", TYPE_HUD, 3, DigitalDistance);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("compactAltitude", "Compact Altitude", TYPE_HUD, 3, CompactAltitude);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("compactDrag", "Compact Drag", TYPE_HUD, 3, CompactDrag);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("compactDuration", "Compact Flight Time", TYPE_HUD, 3, CompactDuration);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("compactSpeed", "Compact Speed", TYPE_HUD, 3, CompactSpeed);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("compactWind", "Compact Wind", TYPE_HUD, 3, CompactWind);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("compactDistance", "Compact Distance", TYPE_HUD, 3, CompactDistance);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("dragNeedle", "Basic Drag Meter", TYPE_HUD, 3, DragNeedle);
				tempEntry.statCost.addLevel(0, 10);
				
			tempEntry = addEntry("altitudeNeedle", "Basic Altitude", TYPE_HUD, 3, AltitudeNeedleHud);
				tempEntry.statCost.addLevel(0, 10);
				
			tempEntry = addEntry("progressMeter", "Progress Meter", TYPE_HUD, 3, ProgressMeter);
				tempEntry.statCost.addLevel(0, 10);
				
			tempEntry = addEntry("speedNeedle", "Basic Speed Meter", TYPE_HUD, 3, SpeedNeedleHud);
				tempEntry.statCost.addLevel(0, 10);
				
			tempEntry = addEntry("speedNeedleWatch", "Speed Meter Watch", TYPE_HUD, 3, SpeedNeedleWatch);
				tempEntry.statCost.addLevel(0, 15);
				
			tempEntry = addEntry("speedWood", "Wood Speed Meter", TYPE_HUD, 3, SpeedHudWood);
				tempEntry.statCost.addLevel(0, 5);
				
			tempEntry = addEntry("timeWatch", "Flight Time Stopwatch", TYPE_HUD, 3, TimeWatch);
				tempEntry.statCost.addLevel(0, 15);
				
			tempEntry = addEntry("windNeedle", "Wind Meter", TYPE_HUD, 3, WindNeedle);
				tempEntry.statCost.addLevel(0, 15);
				
			tempEntry = addEntry("windNeedle2", "Wind Meter 2", TYPE_HUD, 3, WindNeedle2);
				tempEntry.statCost.addLevel(0, 15);
				
			tempEntry = addEntry("babySpeed", "Baby Speed", TYPE_HUD, 3, BabySpeed);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("babyAltitude", "Baby Altitude", TYPE_HUD, 3, BabyAltitude);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("babyDrag", "Baby Drag", TYPE_HUD, 3, BabyDrag);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("babyDuration", "Baby Flight Time", TYPE_HUD, 3, BabyDuration);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("babyDistance", "Baby Distance", TYPE_HUD, 3, BabyDistance);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("babyWind", "Baby Wind", TYPE_HUD, 3, BabyWind);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("rollingAltitude", "Rolling Altitude", TYPE_HUD, 3, RollingAltitude);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("rollingSpeed", "Rolling Speed", TYPE_HUD, 3, RollingSpeed);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("rollingDrag", "Rolling Drag", TYPE_HUD, 3, RollingDrag);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("rollingDuration", "Rolling Flight Time", TYPE_HUD, 3, RollingDuration);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("rollingDistance", "Rolling Distance", TYPE_HUD, 3, RollingDistance);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("hologramAltitude", "Hologram Altitude", TYPE_HUD, 3, HologramAltitude);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("hologramSpeed", "Hologram Speed", TYPE_HUD, 3,HologramSpeed);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("hologramDrag", "Hologram Drag", TYPE_HUD, 3, HologramDrag);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("hologramWind", "Hologram Wind", TYPE_HUD, 3, HologramWind);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("hologramDuration", "Hologram Flight Time", TYPE_HUD, 3, HologramDuration);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("hologramDistance", "Hologram Distance", TYPE_HUD, 3, HologramDistance);
				tempEntry.statCost.addLevel(0, 25);
				
			tempEntry = addEntry("smartWatch", "Smart Watch", TYPE_HUD, 3, SmartWatch);
				tempEntry.statCost.addLevel(0, 60);
				
				
				
				
				
				
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//Payloads /////////////////////////////////////////////////////////////////////////////////////////////////
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//"gameClass" holds the class of the movieclip for the medal
			//"cost" is the altitude for the milestone
			//"special" is the reward in BP
			tempEntry = addEntry("payload1", "", TYPE_PAYLOAD, 4, getClass("src.game.payloadmode.PayloadProgressIcon1"));
				//tempEntry.shopDescription.addLevel(0, "Destroy the moon to... prevent goku from transforming?");
				//tempEntry.bodyStageBeforeGameClass.addLevel(0, "+1000 Bonus Points");
				tempEntry.statWeight.addLevel(0, 1);
				
				tempEntry.statCost.addLevel(0, 10000);
				tempEntry.statCost.addLevel(1, 25000);
				tempEntry.statCost.addLevel(2, 50000);
				tempEntry.statCost.addLevel(3, 100000);
				tempEntry.statCost.addLevel(4, 200000);
				
				tempEntry.statSpecial.addLevel(0, 1);
				tempEntry.statSpecial.addLevel(1, 2);
				tempEntry.statSpecial.addLevel(2, 3);
				tempEntry.statSpecial.addLevel(3, 4);
				tempEntry.statSpecial.addLevel(4, 5);
				
			tempEntry = addEntry("payload2", "", TYPE_PAYLOAD, 4, getClass("src.game.payloadmode.PayloadProgressIcon2"));
				tempEntry.statWeight.addLevel(0, 15);
				
				tempEntry.statCost.addLevel(0, 10000);
				tempEntry.statCost.addLevel(1, 25000);
				tempEntry.statCost.addLevel(2, 50000);
				tempEntry.statCost.addLevel(3, 100000);
				tempEntry.statCost.addLevel(4, 200000);
				
				tempEntry.statSpecial.addLevel(0, 2);
				tempEntry.statSpecial.addLevel(1, 4);
				tempEntry.statSpecial.addLevel(2, 6);
				tempEntry.statSpecial.addLevel(3, 8);
				tempEntry.statSpecial.addLevel(4, 10);
				
			tempEntry = addEntry("payload3", "", TYPE_PAYLOAD, 4, getClass("src.game.payloadmode.PayloadProgressIcon3"));
				tempEntry.statWeight.addLevel(0, 75);
				
				tempEntry.statCost.addLevel(0, 10000);
				tempEntry.statCost.addLevel(1, 25000);
				tempEntry.statCost.addLevel(2, 50000);
				tempEntry.statCost.addLevel(3, 100000);
				tempEntry.statCost.addLevel(4, 200000);
				
				tempEntry.statSpecial.addLevel(0, 3);
				tempEntry.statSpecial.addLevel(1, 6);
				tempEntry.statSpecial.addLevel(2, 9);
				tempEntry.statSpecial.addLevel(3, 12);
				tempEntry.statSpecial.addLevel(4, 15);
				
			tempEntry = addEntry("payload4", "", TYPE_PAYLOAD, 4, getClass("src.game.payloadmode.PayloadProgressIcon4"));
				tempEntry.statWeight.addLevel(0, 150);
				
				tempEntry.statCost.addLevel(0, 10000);
				tempEntry.statCost.addLevel(1, 25000);
				tempEntry.statCost.addLevel(2, 50000);
				tempEntry.statCost.addLevel(3, 100000);
				tempEntry.statCost.addLevel(4, 200000);
				
				tempEntry.statSpecial.addLevel(0, 5);
				tempEntry.statSpecial.addLevel(1, 10);
				tempEntry.statSpecial.addLevel(2, 15);
				tempEntry.statSpecial.addLevel(3, 25);
				tempEntry.statSpecial.addLevel(4, 50);
				
				
			//Log.log("\\------------------------------/");
			//Log.log("Number of", TYPE_BODY, "items:", getEntriesOfType(TYPE_BODY).length);
			//Log.log("Number of", TYPE_BONUS, "items:", getEntriesOfType(TYPE_BONUS).length);
			//Log.log("Number of", TYPE_BOOST, "items:", getEntriesOfType(TYPE_BOOST).length);
			//Log.log("Number of", TYPE_HUD, "items:", getEntriesOfType(TYPE_HUD).length);
			//Log.log("Number of", TYPE_LAUNCHER, "items:", getEntriesOfType(TYPE_LAUNCHER).length);
			//Log.log("Number of", TYPE_MEDAL, "items:", getEntriesOfType(TYPE_MEDAL).length);
			//Log.log("Number of", TYPE_MISC, "items:", getEntriesOfType(TYPE_MISC).length);
			//Log.log("Number of", TYPE_PAYLOAD, "items:", getEntriesOfType(TYPE_PAYLOAD).length);
			//Log.log("Number of", TYPE_STAGE, "items:", getEntriesOfType(TYPE_STAGE).length);
			//Log.log("Registry stats:");
			//Log.log("/------------------------------\\");
		}
		
		static public function get dic():Dictionary 
		{
			return _dic;
		}
		
		
		
	}

}