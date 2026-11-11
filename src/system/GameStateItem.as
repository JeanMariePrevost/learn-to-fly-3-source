package src.system 
{
	import lbg.anticheatengine.SafeNumber;
	import lbg.debug.Log;
	import src.reg.Registry;
	import src.reg.RegistryCompressionDictionary;
	import src.reg.RegistryEntry;
	/**
	 * ...
	 * @author 
	 */
	public class GameStateItem extends Object 
	{
		protected var _id:String;
		protected var _level:SafeNumber = new SafeNumber();
		protected var _bonusUnlockedLevel:SafeNumber = new SafeNumber();//Used when downgrading bonus items, allow buying back w/o BPs
		public var locked:Boolean = false;//Used to filter out owned items that are in locked slots
		
		protected var _entry:RegistryEntry;
		
		
		public function GameStateItem() 
		{
			
		}
		
		public static function createFrom(id:String, level:uint):GameStateItem {
			var item:GameStateItem = new GameStateItem();
			item.changeID(id);
			item.level = level;
			return item;
		}
		
		public function changeItemTo(entry:RegistryEntry):void {
			_id = entry.id;
			level = 0;
			_entry = entry;
		}
		
		
		public function getCostAt(levelOffset:int = 0):Number {
			var lvl:Number = Math.max(0, level + levelOffset);
			return _entry.statCost.valueAt(lvl);
		}
		
		public function get totalCostAtCurrentLevel():Number {
			var cost:Number = 0;
			for (var i:int = 0; i <= level; i++) {
				cost += _entry.statCost.valueAt(i);
			}
			return cost;
		}
		
		
		public function getPowerAtWeightMult(weight:Number):Number {
			return _entry.statPowerAtWeightMult.powerRatioAt(level, weight);
		}
		
		public function getStageSlotsAt(level:uint):Number {
			return _entry.statStageSlots.valueAt(level);
		}
		
		public function getBoostSlotsAt(level:uint):Number {
			return _entry.statBoostSlots.valueAt(level);
		}
		
		/** Returns true is level = max OR is lvl = max+ OVER_LEVELS if they are enabled */
		public function get isMaxed():Boolean {
			return level >= maxLevel + overLevelsAvailable;
		}
		
		
		
		//Stats pass-through/////////////////////////////////////////////////////////
		public function get statGameClass():Class {
			return _entry.gameClass.valueAt(level);
		}
		
		
		public function get statBodyStageBefore():String {
			return _entry.bodyStageBeforeGameClass.valueAt(level);
		}
		
		public function get statBodyStageAfter():String {
			return _entry.bodyStageAfterGameClass.valueAt(level);
		}
		
		
		public function get statSpecialIds():String {
			return _entry.specialIds.valueAt(level);
		}
		
		public function get statShopDescription():String {
			return _entry.shopDescription.valueAt(level);
		}
		
		public function get statFuel():Number {
			return _entry.statFuel.valueAt(level);
		}
		
		public function get statPower():Number {
			return _entry.statPower.valueAt(level);
		}
		
		public function get statTopSpeed():Number {
			return _entry.statTopSpeed.valueAt(level);
		}
		
		public function get statWeight():Number {
			return _entry.statWeight.valueAt(level);
		}
		
		public function get statTorque():Number {
			return _entry.statTorque.valueAt(level);
		}
		
		public function get statStageSlots():Number {
			return _entry.statStageSlots.valueAt(level);
		}
		
		public function get statBoostSlots():Number {
			return _entry.statBoostSlots.valueAt(level);
		}
		
		public function get statCost():Number {
			return _entry.statCost.valueAt(level);
		}
		
		public function get statSpecial():Number {
			return _entry.statSpecial.valueAt(level);
		}
		
		public function getZoomAtSpeed(speed:Number):Number {
			return _entry.statZoomAtSpeed.zoomAtSpeed(level, speed);
		}
		
		public function get statZoomFloor():Number {
			return _entry.statZoomFloor.valueAt(level);
		}
		
		public function get statVisualClass():Class {
			return _entry.statVisualClass.valueAt(level);
		}
		
		public function get statVisualClass2():Class {
			return _entry.statVisualClass2.valueAt(level);
		}
		
		public function get statVisualClass3():Class {
			return _entry.statVisualClass3.valueAt(level);
		}
		
		public function get statSound1():Class {
			return _entry.statSound1.valueAt(level);
		}
		
		public function get statSound2():Class {
			return _entry.statSound2.valueAt(level);
		}
		
		public function get statSound3():Class {
			return _entry.statSound3.valueAt(level);
		}
		
		public function get statSound1Volume():Number {
			return _entry.statSound1Volume.valueAt(level);
		}
		
		public function get statSound2Volume():Number {
			return _entry.statSound2Volume.valueAt(level);
		}
		
		public function get statSound3Volume():Number {
			return _entry.statSound3Volume.valueAt(level);
		}
		
		/** Maximum level w/o over levels */
		public function get maxLevel():int {
			return _entry.maxLevel;
		}
		
		/** E.g. "body", "launcher", "stage", "boost", "misc"... */
		public function get type():String {
			return _entry.type;
		}
		
		public function get name():String {
			return _entry.name;
		}
		
		public function get entry():RegistryEntry {
			return _entry;
		}
		
		public function get overLevelEnabled():Boolean {
			if (type == Registry.TYPE_BODY || type == Registry.TYPE_LAUNCHER) {
				return ProfileState.instance.bonusItems.bonusOverBodiesAndLaunchers.level > 0;
			}else if (type == Registry.TYPE_STAGE) {
				return ProfileState.instance.bonusItems.bonusOverStages.level > 0;
			}else if (type == Registry.TYPE_BOOST) {
				return ProfileState.instance.bonusItems.bonusOverBoosts.level > 0;
			}else if (type == Registry.TYPE_BONUS) {
				return ProfileState.instance.bonusItems.bonusOver.level > 0;
			}else {
				//Unkown item type trying to over-level?
				Log.log("overLevelEnabled Error - Item [", id, "] trying to over-level, but type is incorrect");
				return false;
			}
		}
		
		public function get overLevelsAvailable():Number {
			if (id == "bonusOverBodiesAndLaunchers" || id == "bonusOverStages" || id == "bonusOverBoosts" || id == "bonusOver") {
				return 0;
			}else if (type == Registry.TYPE_BODY || type == Registry.TYPE_LAUNCHER) {
				return ProfileState.instance.bonusItems.bonusOverBodiesAndLaunchers.statPower;
			}else if (type == Registry.TYPE_STAGE) {
				return ProfileState.instance.bonusItems.bonusOverStages.statPower;
			}else if (type == Registry.TYPE_BOOST) {
				return ProfileState.instance.bonusItems.bonusOverBoosts.statPower;
			}else if (type == Registry.TYPE_BONUS) {
				return ProfileState.instance.bonusItems.bonusOver.statPower;
			}else {
				//Unkown item type trying to over-level?
				Log.log("overLevelsAvailable Error - Item [", id, "] trying to over-level, but type is incorrect");
				return 0;
			}
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public function changeID(id:String):void {
			_id = id;
			_entry = Registry.getEntry(_id);
		}
		
		public function get shortID():String {
			return RegistryCompressionDictionary.getGodeOfID(_id);
		}
		
		public function set shortID(value:String):void {
			//set regular id from shortID, then update the entry from that
			_id = RegistryCompressionDictionary.getIdFromCode(value);
			_entry = Registry.getEntry(_id);
		}
		
		public function get level():uint 
		{
			return uint(_level.value);
		}
		
		public function set level(value:uint):void 
		{
			_level.value = value;
		}
		
		public function get bonusUnlockedLevel():uint 
		{
			return uint(_bonusUnlockedLevel.value);
		}
		
		public function set bonusUnlockedLevel(value:uint):void 
		{
			_bonusUnlockedLevel.value = value;
		}
		
		public function destroy():void {
			//if (_level) _level.destroy();
			//if (_bonusUnlockedLevel)_bonusUnlockedLevel.destroy();
			//
			//_level = null;
			//_bonusUnlockedLevel = null;
		}
	}

}