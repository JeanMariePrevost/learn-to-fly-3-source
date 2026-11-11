package lbg.audio 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author 
	 */
	internal class SoundObject 
	{
		public const LOOP_BUFFER:uint = 20;//Milliseconds to start playback to when looping
		public var sound:Sound
		public var tag:String
		protected var _channel:SoundChannel;
		protected var _loop:Boolean;
		protected var _soundFinishedSignal:Signal = new Signal(SoundObject);
		
		public function SoundObject(sound:Sound, loop:Boolean, tag:String) 
		{
			this.sound = sound;
			this.tag = tag;
			_loop = loop;
			playSound();
		}
		
		public function deleteSound():void {
			_channel.removeEventListener(Event.SOUND_COMPLETE, soundFinished);
			_channel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
			
			_channel.stop();
			sound = null;
			_channel = null;
		}
		
		protected function playSound():void {
			if (_loop) {
				_channel = sound.play(0, int.MAX_VALUE);
				_channel.addEventListener(Event.SOUND_COMPLETE, loopSound);
			}else {
				_channel = sound.play(0);
				_channel.addEventListener(Event.SOUND_COMPLETE, soundFinished);
			}
		}
		
		protected function loopSound(e:Event):void 
		{
			_channel.removeEventListener(Event.SOUND_COMPLETE, loopSound);
			_channel = sound.play(LOOP_BUFFER);
			_channel.addEventListener(Event.SOUND_COMPLETE, loopSound);
		}
		
		protected function soundFinished(e:Event):void 
		{
			deleteSound();
			_soundFinishedSignal.dispatch(this);
			_soundFinishedSignal = null;
		}
		
		public function get channel():SoundChannel 
		{
			return _channel;
		}
		
		public function get loop():Boolean 
		{
			return _loop;
		}
		
		public function get soundFinishedSignal():Signal 
		{
			return _soundFinishedSignal;
		}
		
		
	}

}