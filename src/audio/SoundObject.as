package src.audio 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import lbg.debug.Log;
	import lbg.utils.Tools;
	import org.osflash.signals.Signal;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author 
	 */
	public class SoundObject implements ISound
	{
		protected const LOOP_BUFFER:uint = 0;//Position to start playback at when looping
		
		protected var _signalDestroyed:Signal = new Signal(ISound);
		protected var _parent:Object;//No behavior, only used to lookup sounds
		protected var _soundClass:Class;//No behavior, only used to lookup sounds
		protected var _sound:Sound
		protected var _channel:SoundChannel;
		protected var _loop:Boolean = false;
		protected var _isPlaying:Boolean = false;
		protected var _position:Number = 0;//Stores position when not playing, otherwise use _channel.position
		protected var _transform:SoundTransform = new SoundTransform();
		protected var _volume:Number = 1;
		protected var _volume2:Number = 1;
		protected var _mute:Number = 1;
		
		public function SoundObject(sound:Sound) 
		{
			_sound = sound;
			
			if (_sound == null) {
				Log.log("SoundObject warning - created with a null sound.");
				destroy();
				return;
			}
			
			_mute = (ProfileState.instance.mute == 0) ? 0:1;
			
			updateVolume();
		}
		
		protected function calculateVolume():Number {
			var v:Number = Tools.audioTaper(Audio.masterVolume * Audio.soundVolume * _volume * _volume2 * _mute, 2);
			//trace("Sound volume:", v);
			return v;
		}
		
		public function updateVolume():void {
			_transform.volume = calculateVolume();
			
			//trace("Updated volume:", _transform.volume);
			
			//if (_isPlaying) {
				//var pos:Number = _channel.position;
				//_channel.stop();
				//play(pos);
			//}
			if (_isPlaying) {
				_channel.soundTransform = _transform;
			}
		}
		
		public function play(position:Number = NaN):void 
		{
			if (!_sound) destroy();
			
			if (isNaN(position)) {
				position = this.position;
			}else {
				position = Math.max(position, 0);
			}
			
			if (loop) {
				if (position > 0) {
					//1st loop will be from sound complete to reset the position
					_channel = _sound.play(position, 0, _transform);
				}else {
					_channel = _sound.play(position, int.MAX_VALUE, _transform);
				}
				_channel.addEventListener(Event.SOUND_COMPLETE, loopSound);
			}else {
				_channel = _sound.play(position, 0, _transform);
				//trace("Channel volume:", _channel.soundTransform.volume);
				_channel.addEventListener(Event.SOUND_COMPLETE, soundFinished);
			}
			
			_isPlaying = true;
		}
		
		protected function loopSound(e:Event):void 
		{
			//trace("Code looping");
			_channel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
			_channel = _sound.play(LOOP_BUFFER, int.MAX_VALUE, _transform);
			_channel.addEventListener(Event.SOUND_COMPLETE, loopSound);
		}
		
		protected function soundFinished(e:Event):void 
		{
			if (loop) {
				loopSound(e);
			}else {
				destroy();
			}
		}
		
		public function get channel():SoundChannel 
		{
			return _channel;
		}
		
		public function pause():void 
		{
			if (_isPlaying) {
				//trace("Sound position:", _channel.position);
				//trace("Sound legnth:", _sound.length);
				
				_position = _channel.position % _sound.length;
				_channel.stop();
				_isPlaying = false;
			}
		}
		
		public function stop():void 
		{
			if (_isPlaying) {
				_position = 0;
				_channel.stop();
				_isPlaying = false;
			}
		}
		
		public function get position():Number 
		{
			if (isPlaying) {
				return _channel.position;
			}else {
				return _position;
			}
		}
		
		public function set position(value:Number):void 
		{
			_position = value;
			if (_isPlaying) {
				play(value);
			}
		}
		
		public function get length():Number 
		{
			return _sound.length;
		}
		
		public function get sound():Sound 
		{
			return _sound;
		}
		
		public function get loop():Boolean 
		{
			return _loop;
		}
		
		public function set loop(value:Boolean):void 
		{
			if (_loop != value) {
				if (isPlaying) {
					_loop = value;
					var pos:Number = _channel.position;
					stop();
					play(pos);
				}
			}
			_loop = value;
		}
		
		public function get isPlaying():Boolean 
		{
			return _isPlaying;
		}
		
		public function get mute():Boolean 
		{
			return _mute == 0;
		}
		
		public function set mute(value:Boolean):void 
		{
			_mute = value ? 0:1;
			updateVolume();
		}
		
		public function get volume():Number 
		{
			return _volume;
		}
		
		public function set volume(value:Number):void 
		{
			_volume = value;
			//trace("Changed volume to:", _volume);
			updateVolume();
		}
		
		public function get volume2():Number 
		{
			return _volume2;
		}
		
		public function set volume2(value:Number):void 
		{
			_volume2 = value;
		}
		
		public function fadeIn(position:Number = NaN):void 
		{
			play(position);
		}
		
		public function fadeOut(duration:Number = NaN):void 
		{
			destroy();
		}
		
		public function get parent():Object 
		{
			return _parent;
		}
		
		public function set parent(value:Object):void 
		{
			_parent = value;
		}
		
		public function get soundClass():Class 
		{
			return _soundClass;
		}
		
		public function set soundClass(value:Class):void 
		{
			_soundClass = value;
		}
		
		public function get signalDestroyed():Signal 
		{
			return _signalDestroyed;
		}
		
		public function destroy():void 
		{
			if (_channel) {
				_channel.removeEventListener(Event.SOUND_COMPLETE, soundFinished);
				_channel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
				_channel.stop();
			}
			
			_isPlaying = false;
			_sound = null;
			_channel = null;
			
			if (_signalDestroyed) {
				_signalDestroyed.dispatch(this);
				_signalDestroyed.removeAll();
				_signalDestroyed = null;
			}
		}
		
	}

}