package src.audio 
{
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.utils.Timer;
	import lbg.utils.NumberUtils;
	import lbg.utils.Tools;
	
	/**
	 * Same as SoundObject, but both play and stop fade instead of being immediate
	 * @author 
	 */
	public class FadingSoundObject extends SoundObject 
	{
		protected const FADE_INTERVAL:uint = 30;
		
		public var fadeInDuration:Number = 200;
		/** Starting volume of the fade-in, default 0 */
		public var fadeInVolume:Number = 0;
		public var fadeOutDuration:Number = 300;
		/** Final volume of the fade-out, default 0 */
		public var fadeOutVolume:Number = 0;
		
		protected var _fadeVolume:Number = 1;
		protected var _fadeTime:Number = 0;
		/** To fade from current volume instead of fading from 1->0 */
		protected var _fadeOutStartVolume:Number = 1;
		
		protected var _fadeTimer:Timer = new Timer(FADE_INTERVAL, 0);
		
		protected var _fadingIn:Boolean = false;
		protected var _fadingOut:Boolean = false;
		
		
		
		public function FadingSoundObject(sound:Sound) 
		{
			super(sound);
			
		}
		
		override protected function calculateVolume():Number 
		{
			return Tools.audioTaper(Audio.masterVolume * Audio.soundVolume * _volume * _volume2 * _mute * _fadeVolume, 2);
		}
		
		/** Plays the sound while applying the fadein effect */
		override public function fadeIn(position:Number = NaN):void {
			if (_fadingIn == false) {
				_fadingIn = true;
				_fadeVolume = fadeInVolume;
				_fadeTime = 0;
				updateVolume();
				play(position);
				
				_fadeTimer.reset();
				_fadeTimer.addEventListener(TimerEvent.TIMER, onFadeInTimer);
				_fadeTimer.start();
			}
		}
		
		/** Destroys the sound after applying the fadeout effect */
		override public function fadeOut(duration:Number = NaN):void {
			if (!isNaN(duration)) {
				fadeOutDuration = duration;
			}
			
			if (_fadingOut == false) {
				_fadingOut = true;
				
				if (_fadeTimer) {
					//_fadeVolume = 1;
					_fadeOutStartVolume = _fadeVolume;
					_fadeTime = 0;
					_fadeTimer.reset();
					_fadeTimer.removeEventListener(TimerEvent.TIMER, onFadeInTimer);
					_fadeTimer.addEventListener(TimerEvent.TIMER, onFadeOutTimer);
					_fadeTimer.start();
				}else {
					//Was probably destroyed
					destroy();
				}
			}
		}
		
		private function onFadeInTimer(e:TimerEvent):void 
		{
			_fadeTime += FADE_INTERVAL;
			_fadeVolume = NumberUtils.interpolate2(fadeInVolume, 1, 0, fadeInDuration, _fadeTime);
			
			//trace("Fade in volume:", _fadeVolume);
			
			if (_fadeTime >= fadeInDuration) {
				_fadingIn = false;
				_fadeVolume = 1;
				_fadeTimer.removeEventListener(TimerEvent.TIMER, onFadeInTimer);
				_fadeTimer.stop();
				_fadeTimer.reset();
			}
			
			updateVolume();
		}
		
		private function onFadeOutTimer(e:TimerEvent):void 
		{
			_fadeTime += FADE_INTERVAL;
			_fadeVolume = NumberUtils.interpolate2(_fadeOutStartVolume, fadeOutVolume, 0, fadeOutDuration, _fadeTime);
			
			updateVolume();
			
			if (_fadeTime >= fadeOutDuration) {
				_fadingOut = false;
				_fadeVolume = 0;
				_fadeTimer.removeEventListener(TimerEvent.TIMER, onFadeOutTimer);
				_fadeTimer.stop();
				_fadeTimer.reset();
				destroy();
			}
		}
		
		override public function destroy():void 
		{
			if (_fadeTimer) {
				_fadeTimer.stop();
				_fadeTimer.reset();
				_fadeTimer.removeEventListener(TimerEvent.TIMER, onFadeInTimer);
				_fadeTimer.removeEventListener(TimerEvent.TIMER, onFadeInTimer);
			}
			_fadeTimer = null;
			
			super.destroy();
		}
	}

}