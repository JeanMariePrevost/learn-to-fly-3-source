package src.system 
{
	import com.hurlant.util.Base64;
	import flash.net.registerClassAlias;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.ByteArray;
	import lbg.anticheatengine.*;
	import lbg.debug.Log;
	import lbg.utils.Tools;
	import src.game.hud.HudComponentList;
	import lbg.utils.Serialize;
	import src.Main;
	import src.gui.MessageBox;
	import src.gui.ProfileStatsScreen;
	import src.gui.ScreenBlurEffect;
	import src.reg.RegistryCompressionDictionary;
	import src.reg.RegistryEntry;
	/**
	 * ...
	 * @author 
	 */
	public class SaveLoadModule 
	{
		private static const SAVE_FILE_NAME:String = "savedata.dat";
		private static const BACKUP_FILE_NAME:String = "savedata_backup.dat";

		
		public static function profileToString(profile:ProfileState):String {
			registerClassAlias("ProfileState", ProfileState);
			
			var ba:ByteArray = new ByteArray();
			ba.writeObject(profile);
			ba.deflate();
			var saveString:String = Base64.encodeByteArray(ba);
			
			//Log.log("profileToString() - Profile saveString length ->", saveString.length);
			
			return saveString;
		}
		
		public static function loadProfileFromString(saveString:String):ProfileState {
			var detectionWasEnabled:Boolean = Main.cheatDetectionEnabled;
			Main.cheatDetectionEnabled = false;
			try {
				registerClassAlias("ProfileState", ProfileState);
				var data:ByteArray = Base64.decodeToByteArray(saveString);
				data.inflate();
				data.position = 0;
				var profile:ProfileState = data.readObject() as ProfileState;
				if (profile != null) Main.mainLayer.stage.quality = profile.optionQuality;
				return profile;
			}catch (error:Error) {
				Log.log("Could not read the profile", error.message);
				return null;
			}finally {
				Main.cheatDetectionEnabled = detectionWasEnabled;
			}
		}
		
		/** Save profile to file, null filename will use the default one */
		public static function saveProfileToFile(profile:ProfileState, filename:String = null):Boolean {
			try {
				//Force update of quality property on ProfileState before saving
				profile.optionQuality = Main.mainLayer.stage.quality;
				

				
				var saveString:String = profileToString(profile);
				
				var ba:ByteArray = new ByteArray();
				ba.writeUTF(saveString);
				ba.deflate();
			}catch (e:Error) {
				Log.log("saveProfileToFile() ERROR -", e.name, e.message, e.errorID);
				return false;
			}

			if (filename == null || filename == "") filename = SAVE_FILE_NAME;

			if (writeLocalSave(ba, filename)) {
				Log.log("saveProfileToFile() success. Profile saved to local file. SaveString is", saveString.length, "bytes");
				return true;
			}else {
				Log.log("saveProfileToFile() failed.");
				return false;
			}
		}
		
		/** True on backup successfull */
		public static function performSaveBackup():Boolean {
			var profile:ProfileState = loadProfileFromSaveFile();
			
			if (profile == null) {
				Log.log("performSaveBackup() ERROR - Profile file could not be read.");
				return false;
			}
			
			var success:Boolean = saveProfileToFile(profile, BACKUP_FILE_NAME);
			
			if (success) {
				Log.log("performSaveBackup() Save file backup successful.");
				return true;
			}else {
				Log.log("performSaveBackup() ERROR - Save file backup could not be written.");
				return false;
			}
		}
		
		public static function loadProfileFromSaveFile():ProfileState {
			var profile:ProfileState = loadLocalProfile(SAVE_FILE_NAME);
			return profile != null ? profile : loadLocalProfile(BACKUP_FILE_NAME);
		}

		private static function loadLocalProfile(filename:String):ProfileState {
			var data:ByteArray = readLocalSave(filename);
			if (data == null) return null;
			try {
				data.inflate();
				return loadProfileFromString(data.readUTF());
			}catch (error:Error) {
				Log.log("Could not read the local save", filename, error.message);
				return null;
			}
		}

		private static function readLocalSave(filename:String):ByteArray {
			try {
				// The primary save and backup live in separate objects so either can be read on its own.
				var stored:ByteArray = SharedObject.getLocal("LearnToFly3_" + filename, "/").data.bytes as ByteArray;
				if (stored == null) return null;
				var copy:ByteArray = new ByteArray();
				copy.writeBytes(stored);
				copy.position = 0;
				return copy;
			}catch (error:Error) {
				Log.log("Could not open the local save", filename, error.message);
				return null;
			}
		}

		private static function writeLocalSave(data:ByteArray, filename:String):Boolean {
			var storage:SharedObject;
			var previous:ByteArray;
			try {
				storage = SharedObject.getLocal("LearnToFly3_" + filename, "/");
				previous = storage.data.bytes as ByteArray;
				storage.data.bytes = data;
				if (storage.flush() == SharedObjectFlushStatus.FLUSHED) return true;
			}catch (error:Error) {
				Log.log("Could not write the local save", filename, error.message);
			}
			if (storage != null) {
				if (previous != null) storage.data.bytes = previous;
				else delete storage.data.bytes;
			}
			return false;
		}

	}

}
