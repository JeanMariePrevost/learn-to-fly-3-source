package lbg.audio 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import lbg.utils.Easing;
	import lbg.utils.VectorUtils;
	/**
	 * ...
	 * @author 
	 */
	public class SoundManager 
	{
		protected var _list:Vector.<SoundObject> = new Vector.<SoundObject>();
		
		public function SoundManager() 
		{
			
		}
		
		public function playSound(sound:Sound, loop:Boolean = false, tag:String = "sfx"):void {
			var so:SoundObject = new SoundObject(sound, loop, tag);
			_list.push(so);
			so.soundFinishedSignal.addOnce(removeFromList);
		}
		
		public function setVolume(volume:Number = 1, onlyToTag:String = null):void {
			var taperedVolume:Number = Math.max(0, Math.min(1, Easing.easeInQuad(volume, 0, 1, 1)));
			var soundTransform:SoundTransform = new SoundTransform(taperedVolume);
			//trace(soundTransform.volume);
			
			for each(var s:SoundObject in _list) {
				if (onlyToTag == null) {
					s.channel.soundTransform = soundTransform;
				}else if (s.tag == onlyToTag) {
					s.channel.soundTransform = soundTransform;
				}
			}
		}
		
		public function stopAllSounds(tag:String = null):void {
			var deleteList:Vector.<SoundObject> = new Vector.<SoundObject>();
			
			for each(var s:SoundObject in _list) {
				if (tag == null) {
					deleteList.push(s);
					s.deleteSound();
				}else if (s.tag == tag) {
					deleteList.push(s);
					s.deleteSound();
				}
			}
			
			for each (s in deleteList) {
				removeFromList(s);
			}
		}
		
		protected function removeFromList(so:SoundObject):void 
		{
			_list.splice(_list.indexOf(so), 1);
			//trace(_list.length);
		}
		
		
	}

}