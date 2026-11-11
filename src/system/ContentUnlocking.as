package src.system 
{
	import lbg.anticheatengine.SafeString;
	import src.reg.Registry;
	import src.reg.RegistryEntry;
	/**
	 * This class will hold a few functions used to sort out items that have not been unlocked on the current profile state or game state
	 * @author 
	 */
	public class ContentUnlocking 
	{
		//On first playthrough, items will be locked until X-days pass or X-altitude is reached
		public static const KEY_NORMAL1:String = "normal1";
		public static const KEY_NORMAL2:String = "normal2";
		public static const KEY_NORMAL3:String = "normal3";
		
		
		
		public static function filterLockedItemsOut(list:Vector.<RegistryEntry>):Vector.<RegistryEntry> {
			var filteredList:Vector.<RegistryEntry> = new Vector.<RegistryEntry>();
			
			for each (var i:RegistryEntry in list) {
				if (isUnlocked(i)) {
					filteredList.push(i);
				}
			}
			
			return filteredList;
		}
		
		protected static function isUnlocked(entry:RegistryEntry):Boolean {
			if (entry.unlockKeys == null) {
				//Item is enabled by default
				return true;
			}else{
				for each(var key:String in entry.unlockKeys) {
					if (ProfileState.instance.hasItemUnlockKey(key)) {
						//Keys match, item is unlocked
						return true;
					}
				}
			}
			
			//Item has keys and none match profile keys, item is locked
			return false;
		}
		
		public static function IdIsUnlocked(id:String):Boolean {
			return isUnlocked(Registry.getEntry(id));
		}
	}

}