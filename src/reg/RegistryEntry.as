package src.reg 
{
	import com.adobe.crypto.HMAC;
	import com.adobe.crypto.MD5;
	import com.adobe.crypto.SHA1;
	import com.adobe.crypto.SHA224;
	import com.adobe.crypto.SHA256;
	import flash.net.registerClassAlias;
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	import src.reg.Stat;
	import src.system.GameStateItem;
	/**
	 * ...
	 * @author 
	 */
	public class RegistryEntry extends Object 
	{
		public var unlockKeys:Vector.<String>;//If empty, item is unlocked by default, otherwise its keys will be compared to profile keys and item will unlock if any keys match
		
		public var id:String;
		public var type:String;//e.g. "body", "stage", "misc"...
		public var name:String;
		public var index:int;
		//public var shopDescription:String = "";
		public var maxLevel:int;//Level above which we enter over-upgrades
		
		public var gameClass:StatClass = new StatClass();
		public var specialIds:StatString = new StatString();//Stores extra IDs that are used dor icons and ads to change as level goes up
		public var shopDescription:StatString = new StatString();//Can vary description by level
		
		public var statFuel:Stat = new Stat();
		public var statPower:Stat = new Stat();
		public var statPowerAtWeightMult:StatPowerAtWeight = new StatPowerAtWeight();//Normalized values used to mult power depending on weight, "level" here is used as weight reference, not actual level
		public var statTopSpeed:Stat = new Stat();
		public var statWeight:Stat = new Stat(0);
		public var statTorque:Stat = new Stat();
		public var statStageSlots:Stat = new StatFlat();
		public var statBoostSlots:Stat = new StatFlat();
		public var statCost:Stat = new StatNice();
		public var statSpecial:Stat = new Stat();//Used for unique items that have special effects
		public var statZoomAtSpeed:StatCameraZoom = new StatCameraZoom();//Body-only, specifies camera zoom depending on player speed
		public var statZoomFloor:Stat = new Stat(0);
		
		public var statVisualClass:StatClass = new StatClass();
		public var statVisualClass2:StatClass = new StatClass();
		public var statVisualClass3:StatClass = new StatClass();
		
		public var statSound1:StatClass = new StatClass();
		public var statSound2:StatClass = new StatClass();
		public var statSound3:StatClass = new StatClass();
		
		public var statSound1Volume:StatFlat = new StatFlat(1);
		public var statSound2Volume:StatFlat = new StatFlat(1);
		public var statSound3Volume:StatFlat = new StatFlat(1);
		
		//Body stage hooks
		public var bodyStageBeforeGameClass:StatString = new StatString();
		public var bodyStageAfterGameClass:StatString = new StatString();
		
		
		//Shop display stats
		//displayStatName is the label for the displayed stat
		protected var _displayStatName1:String = "";
		protected var _displayStatName2:String = "";
		protected var _displayStatName3:String = "";
		protected var _displayStatName4:String = "";
		protected var _displayStatName5:String = "";
		//displayStat holds a REFERENCE to the stats you wish to display
		protected var _displayStat1:IStat;
		protected var _displayStat2:IStat;
		protected var _displayStat3:IStat;
		protected var _displayStat4:IStat;
		protected var _displayStat5:IStat;
		
		protected var _displayStat1Decimals:Number;
		protected var _displayStat2Decimals:Number;
		protected var _displayStat3Decimals:Number;
		protected var _displayStat4Decimals:Number;
		protected var _displayStat5Decimals:Number;
		
		
		public function RegistryEntry() 
		{
			//registerClassAlias("Vector", Vector);
			//registerClassAlias("String", String);
			//registerClassAlias("StatClass", StatClass);
			//registerClassAlias("StatString", StatString);
			//registerClassAlias("Stat", Stat);
			//registerClassAlias("StatPowerAtWeight", StatPowerAtWeight);
			//registerClassAlias("StatFlat", StatFlat);
			//registerClassAlias("StatNice", StatNice);
			//registerClassAlias("StatCameraZoom", StatCameraZoom);
			//registerClassAlias("StatCameraZoom", StatCameraZoom);
		}
		
		
		public function setUnlockKeys(... keys):void {
			unlockKeys = new Vector.<String>();
			
			for (var i:int = 0; i < keys.length; i++) {
				if (keys[i] is String) {
					unlockKeys.push(keys[i]);
				}else {
					Log.log("RegistryEntry setUunlockKeys() error - Key is not a String");
				}
			}
			
			if (unlockKeys.length <= 0) {
				//No keys were added, destroy the vector
				unlockKeys = null;
			}
		}
		
		/**
		 * Used to set a stat as a display stat in the shop
		 * @param	index Index, from 1 to 4, of the stat in the display
		 * @param	displayName Stat label
		 * @param	stat Stat object to display
		 */
		public function setDisplayStat(index:uint, displayName:String, stat:IStat, decimals:Number = NaN):void {
			switch(index) {
				case 1:
					_displayStatName1 = displayName;
					_displayStat1 = stat;
					_displayStat1Decimals = decimals;
					break;
				case 2:
					_displayStatName2 = displayName;
					_displayStat2 = stat;
					_displayStat2Decimals = decimals;
					break;
				case 3:
					_displayStatName3 = displayName;
					_displayStat3 = stat;
					_displayStat3Decimals = decimals;
					break;
				case 4:
					_displayStatName4 = displayName;
					_displayStat4 = stat;
					_displayStat4Decimals = decimals;
					break;
				case 5:
					_displayStatName5 = displayName;
					_displayStat5 = stat;
					_displayStat5Decimals = decimals;
					break;
				default:
					throw new Error ("Invalid DisplayStat index. Stat name:" + displayName);
					break;
			}
		}
		
		
		public function getDisplayStatName1():String {	return _displayStatName1 };
		public function getDisplayStatName2():String {	return _displayStatName2 };
		public function getDisplayStatName3():String {	return _displayStatName3 };
		public function getDisplayStatName4():String {	return _displayStatName4 };
		public function getDisplayStatName5():String {	return _displayStatName5 };
		
		public function getDisplayStatString(index:uint, level:uint):String 
		{
			var stat:IStat;
			var decimals:Number;
			
			if (index == 1) {
				stat = _displayStat1;
				decimals = _displayStat1Decimals;
			}else if (index == 2) {
				stat = _displayStat2;
				decimals = _displayStat2Decimals;
			}else if (index == 3) {
				stat = _displayStat3;
				decimals = _displayStat3Decimals;
			}else if (index == 4) {
				stat = _displayStat4;
				decimals = _displayStat4Decimals;
			}else if (index == 5) {
				stat = _displayStat5;
				decimals = _displayStat5Decimals;
			}else {
				throw new Error("Invalid DisplayStatString index");
				return "";
			}
			
			if (stat == null) {
				return "";
			}
			
			var value:Number = stat.valueAt(level);
			
			if (isNaN(decimals)) {
				if (value >= 100) {
					return NumberUtils.setPrecison(value, 0).toString();
				}else if (value >= 10) {
					return NumberUtils.setPrecison(value, 1).toString();
				}else {
					return NumberUtils.setPrecison(value, 2).toString();
				}
			}else {
				return NumberUtils.setPrecison(value, decimals).toString();
			}
		}
		
		
	}

}