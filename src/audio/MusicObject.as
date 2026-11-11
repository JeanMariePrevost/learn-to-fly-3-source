package src.audio 
{
	import flash.media.Sound;
	import lbg.utils.Tools;
	
	/**
	 * ...
	 * @author 
	 */
	public class MusicObject extends FadingSoundObject 
	{
		
		public function MusicObject(sound:Sound) 
		{
			super(sound);
			
		}
		
		override protected function calculateVolume():Number 
		{
			var v:Number = Tools.audioTaper(Audio.masterVolume * Audio.musicVolume * _volume * _volume2 * _mute * _fadeVolume, 2);
			if (v != 0) {
				//trace("Audio.masterVolume:", Audio.masterVolume);
				//trace("Audio.musicVolume:", Audio.musicVolume);
				//trace("_volume:", _volume);
				//trace("_volume2:", _volume2);
				//trace("_fadeVolume:", _fadeVolume);
				//trace("Sound volume:", v);
			}
			return v;
		}
		
	}

}