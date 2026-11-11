package src.reg 
{
	import com.adobe.crypto.MD5;
	import flash.utils.Dictionary;
	import lbg.debug.Log;
	import src.system.Global;
	/**
	 * ...
	 * @author 
	 */
	public class RegistryCompressionDictionary 
	{
		protected static const MINIMUM_SHORTID_LENGTH:int = 5;
		protected static const BYPASS_COMPRESSION:Boolean = true;
		
		/** Keys are ids, data is compress code */
		protected static var _dic:Dictionary;
		
		/** Keys are compress codes, data is ids */
		protected static var _dicReverse:Dictionary;
		
		public static function getGodeOfID(id:String):String {
			var code:String = _dic[id];
			if (code == null) {
				Log.log("getGodeOfID -> id [" +  id +  "] not present in dictionary");
				//throw new Error("getGodeOfID -> id [" +  id +  "] not present in dictionary");
			}
			
			return code;
		}
		
		public static function getIdFromCode(code:String):String {
			var id:String = _dicReverse[code];
			if (id == null) {
				throw new Error("getIdFromCode -> code [" +  code + "] not present in dictionary");
			}
			
			return id;
		}
		
		/** Takes an ID and a "shortID", then adds the shortest unique length of that short ID as identifier */
		protected static function addPair(id:String, shortID:String):void {
			if (id == "" || shortID == "") {
				throw new Error("arrPair -> empty params");
			}			
			
			var shortened:String;
			var shortestUnique:String;
			for (var i:int = MINIMUM_SHORTID_LENGTH; i < shortID.length; i++) {
				shortened = shortID.substr(0, i);
				if (!_dicReverse.hasOwnProperty(shortened)) {
					//Id is shortest unique
					shortestUnique = shortened;
					break;
				}
			}
			
			if (shortestUnique == null) {
				throw new Error("arrPair -> No unique ID to be made from [" +  shortID +  "] for id [" +  id + "]");
			}else if (_dic.hasOwnProperty(shortestUnique)) {
				throw new Error("arrPair -> Duplicated shortID [" +  shortID +  "] for id [" +  id + "]");
			} 
			
			if (BYPASS_COMPRESSION) {
				shortestUnique = id;
			}
			
			_dic[id] = shortestUnique;
			_dicReverse[shortestUnique] = id;
		}
		
		public static function buildDictionary(registryDic:Dictionary):void {
			if (_dic != null) {
				//already created
				throw new Error("RegistryCompressionDictionary being built more than once.");
				return;
			}
			
			_dic = new Dictionary();
			_dicReverse = new Dictionary();
			
			trace("Sorting registry entries for RegistryCompressionDictionary...");
			
			//Sort entries first to prevent mix-up that happens with dictionaries alone
			var sortVector:Vector.<RegistryEntry> = new Vector.<RegistryEntry>();
			for each(var o:RegistryEntry in registryDic) {
				sortVector.push(o);
			}
			
			sortVector = sortVector.sort(sortFunction);
			
			for (var i:int = 0; i < sortVector.length; i++) {
				var shortID:String = MD5.hash(sortVector[i].id);
				addPair(sortVector[i].id, shortID);
			}
			
			trace("Dic built,", sortVector.length, "items present.");
			trace("Starting dic verification...");
			
			var entryCount:Number = 0;
			
			for each(var e:RegistryEntry in registryDic) {
				if (e.id != _dicReverse[_dic[e.id]]) {
					Log.log("RegistryCompressionDictionary error - dictionaries verification did not match for [", e.id, "] -> ", _dic[e.id], "=", _dicReverse[_dic[e.id]]);
				}else {
					if(Global.traceDictionaryVerification) trace(_dic[e.id], "->", e.id);
				}
				entryCount++;
			}
			
			trace(sortVector.length, "entries in,", entryCount, "verified.");
			trace("Dic verification complete.");
		}
		
		public static function  sortFunction(itemA:RegistryEntry, itemB:RegistryEntry):Number {
			if (itemA.id < itemB.id) return -1; //ITEM A is before ITEM B
			else if (itemA.id > itemB.id) return 1; //ITEM A is after ITEM B
			else return 0; //ITEM A and ITEM B have same date
		}		
		
		static public function get dic():Dictionary 
		{
			return _dic;
		}
		
		static public function get dicReverse():Dictionary 
		{
			return _dicReverse;
		}
		
	}

}