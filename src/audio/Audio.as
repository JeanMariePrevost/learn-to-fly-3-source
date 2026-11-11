package src.audio 
{
	import flash.media.Sound;
	import lbg.debug.Log;
	import lbg.utils.VectorUtils;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author 
	 */
	public class Audio 
	{
		//Manager volumes are untapered, the audio tapering takes place inside the SoundObject class
		protected static var _masterVolume:Number = 1.1;
		protected static var _soundVolume:Number = 0.75;
		protected static var _musicVolume:Number = 0.75;
		
		/** Holds EVERY sound and music, anything audio goes here */
		protected static var _sounds:Vector.<ISound> = new Vector.<ISound>();
		
		public function Audio(staticClass:Enforcer) 
		{
			
		}
		
		public static function playSound(soundClass:Class, parent:Object = null):ISound {
			var soundObject:ISound = getNewSoundObject(soundClass, parent);
			soundObject.play(0);
			return soundObject;
		}
		
		public static function playSoundLoop(soundClass:Class, parent:Object = null):ISound {
			var soundObject:ISound = getNewSoundObject(soundClass, parent);
			soundObject.loop = true;
			soundObject.play(0);
			return soundObject;
		}
		
		public static function playFadingSound(soundClass:Class, parent:Object = null, fadeInDuration:Number = NaN):FadingSoundObject {
			var soundObject:FadingSoundObject = getNewFadingSoundObject(soundClass, parent);
			soundObject.fadeIn(fadeInDuration);
			return soundObject;
		}
		
		public static function playFadingSoundLoop(soundClass:Class, parent:Object = null, fadeInDuration:Number = NaN):FadingSoundObject {
			var soundObject:FadingSoundObject = getNewFadingSoundObject(soundClass, parent);
			soundObject.loop = true;
			if (fadeInDuration) {
				soundObject.fadeInDuration = fadeInDuration;
			}
			soundObject.fadeIn(0);
			return soundObject;
		}
		
		public static function playMusic(soundClass:Class, fadeIn:Number = 0):MusicObject {
			var soundObject:MusicObject = getNewMusicObject(soundClass, null);
			soundObject.loop = true;
			soundObject.fadeInDuration = fadeIn;
			if (fadeIn == 0) {
				soundObject.play(0);
			}else {
				soundObject.fadeIn(0);
			}
			return soundObject;
		}
		
		public static function destroyAllAudio():void {
			if (_sounds) {
				for each(var s:ISound in _sounds) {
					s.stop();
					s.destroy();
				}
			}
		}
		
		public static function pauseAllAudio(exceptMusic:Boolean = false):void {
			if (_sounds) {
				for each(var s:ISound in _sounds) {
					if (exceptMusic && (s is MusicObject)) continue;
					s.pause();
				}
			}
		}
		
		public static function resumeAllAudio():void {
			if (_sounds) {
				for each(var s:ISound in _sounds) {
					s.play();
				}
			}
		}
		
		/** Fade out what can be faded, destroy the rest */
		public static function fadeAllAudio():void {
			if (_sounds) {
				for each(var s:ISound in _sounds) {
					s.fadeOut();
				}
			}
		}
		
		/** Master volume mult for all audio, untapered */
		static public function get masterVolume():Number 
		{
			return _masterVolume;
		}
		
		static public function set masterVolume(value:Number):void 
		{
			_masterVolume = value;
			refreshVolumes();
		}
		
		/** Master volume mult for all sound effects, untapered */
		static public function get soundVolume():Number 
		{
			return _soundVolume;
		}
		
		static public function set soundVolume(value:Number):void 
		{
			_soundVolume = value;
			refreshVolumes();
		}
		
		/** Master volume mult for all music, untapered */
		static public function get musicVolume():Number 
		{
			return _musicVolume;
		}
		
		static public function set musicVolume(value:Number):void 
		{
			_musicVolume = value;
			refreshVolumes();
		}
		
		static public function get mute():Boolean {
			return ProfileState.instance.mute == 0;
		}
		
		static public function set mute(value:Boolean):void {
			if (value) {
				ProfileState.instance.mute == 0;
			}else {
				ProfileState.instance.mute == 1;
			}
			
			for each(var s:ISound in _sounds) {
				s.mute = value;
			}
		}
		
		protected static function refreshVolumes():void {
			for each(var s:ISound in _sounds) {
				s.updateVolume();
			}
		}
		
		protected static function getNewSoundObject(soundClass:Class, parent:Object = null):ISound {
			var sound:Sound = new soundClass();
			var so:SoundObject = new SoundObject(sound);
			so.parent = parent;
			so.soundClass = soundClass;
			_sounds.push(so);
			so.signalDestroyed.addOnce(soundDestroyed);
			
			return so;
		}
		
		protected static function getNewFadingSoundObject(soundClass:Class, parent:Object = null):FadingSoundObject {
			var sound:Sound = new soundClass();
			var so:FadingSoundObject = new FadingSoundObject(sound);
			so.parent = parent;
			so.soundClass = soundClass;
			_sounds.push(so);
			so.signalDestroyed.addOnce(soundDestroyed);
			
			return so;
		}
		
		protected static function getNewMusicObject(soundClass:Class, parent:Object = null):MusicObject {
			var sound:Sound = new soundClass();
			var so:MusicObject = new MusicObject(sound);
			so.parent = parent;
			so.soundClass = soundClass;
			_sounds.push(so);
			so.signalDestroyed.addOnce(soundDestroyed);
			
			return so;
		}
		
		public static function getISoundRef(soundClass:Class, parent:Object):ISound {
			for each(var s:ISound in _sounds) {
				if (s.soundClass == soundClass && s.parent == parent) {
					return s;
				}
			}
			
			Log.log("getISoundRef() warning -", parent, "tried requesting a sound for soundClass", soundClass, "but it's not in the list.");
			return null;
		}
		
		protected static function soundDestroyed(sound:ISound):void {
			VectorUtils.removeFromVector(_sounds, sound);
		}
		
		
	}

}

class Enforcer { }
