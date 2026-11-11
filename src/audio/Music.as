package src.audio 
{
	import flash.utils.getDefinitionByName;
	import lbg.components.NumberBuffer;
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	import src.game.GameMediator;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author 
	 */
	public class Music 
	{
		protected static const ZONE1_END:Number = 10;//Start of track 2
		protected static const ZONE2_START:Number = 15;//End of track 1
		protected static const ZONE2_END:Number = 25;//Start of track 3
		protected static const ZONE3_START:Number = 30;//End of track 2
		
		protected static var _track1:MusicObject;
		protected static var _track2:MusicObject;
		protected static var _track3:MusicObject;
		
		protected static var _bufferedSpeed:NumberBuffer = new NumberBuffer(80, 0);
		
		public static function fadeOutAll():void {
			if (_track1) _track1.fadeOut();
			if (_track2) _track2.fadeOut();
			if (_track3) _track3.fadeOut();
		}
		
		public static function destroyAll():void {
			if (_track1) _track1.destroy();
			if (_track2) _track2.destroy();
			if (_track3) _track3.destroy();
			
			_track1 = null;
			_track2 = null;
			_track3 = null;
		}
		
		public static function playMenuMusic():void {
			destroyAll();
			_track1 = Audio.playMusic(MusicHype1, 500);
			//_track1.fadeInDuration = 100;
			//_track1.fadeOutDuration = 300;
		}
		
		public static function playResultsMusic():void {
			destroyAll();
			_track1 = Audio.playMusic(MusicResults);
			_track1.loop = false;
			//_track1.fadeInDuration = 100;
			//_track1.fadeOutDuration = 300;
		}
		
		public static function playShopMusic():void {
			destroyAll();
			_track1 = Audio.playMusic(MusicList.getClassOf(ProfileState.instance.musicShop));
			//_track1.fadeInDuration = 100;
			//_track1.fadeOutDuration = 300;
		}
		
		public static function playBonusShopMusic():void {
			destroyAll();
			_track1 = Audio.playMusic(MusicList.getClassOf(ProfileState.instance.musicBonusShop));
			//_track1.fadeInDuration = 100;
			//_track1.fadeOutDuration = 300;
		}
		
		public static function playInvaderIntro():void {
			destroyAll();
			_track1 = Audio.playMusic(MusicInvaderIntro);
		}
		
		public static function playInvaderTitle():void {
			destroyAll();
			_track1 = Audio.playMusic(MusicInvaderTitle);
			_track1.volume = 1.2;
		}
		
		public static function playInvaderGame():void {
			destroyAll();
			_track1 = Audio.playMusic(MusicInvaderGame);
		}
		
		public static function playGameMusic():void {
			destroyAll();
			
			_track1 = Audio.playMusic(MusicList.getClassOf(ProfileState.instance.musicGame1));
			//_track1.fadeInDuration = 0;
			//_track1.fadeOutDuration = 0;
			_track1.volume = 1;
			
			var t2:String = ProfileState.instance.musicGame2;
			if (t2 == "null") t2 = ProfileState.instance.musicGame1;
			_track2 = Audio.playMusic(MusicList.getClassOf(t2));
			//_track2.fadeInDuration = 0;
			//_track2.fadeOutDuration = 0;
			_track2.volume = 0;
			var t3:String = ProfileState.instance.musicGame3;
			if (t3 == "null") t3 = t2;
			_track3 = Audio.playMusic(MusicList.getClassOf(t3));
			//_track3.fadeInDuration = 0;
			//_track3.fadeOutDuration = 0;
			_track3.volume = 0;
			
			GameMediator.updatePlayerSpeed.add(onPlayerSpeed);
		}
		
		public static function onPlayerSpeed(speed:Number, angleInDegrees:Number):void {
			var volume1:Number;
			var volume2:Number;
			var volume3:Number;
			
			_bufferedSpeed.add(speed);
			
			var avgSpeed:Number = _bufferedSpeed.value;
			
			volume1 = NumberUtils.interpolate2(1, 0, ZONE1_END, ZONE2_START, avgSpeed, 4);
			if (avgSpeed <= 20) {
				volume2 = NumberUtils.interpolate2(0, 1, ZONE1_END, ZONE2_START, avgSpeed, 0.25);
			}else {
				volume2 = NumberUtils.interpolate2(1, 0, ZONE2_END, ZONE3_START, avgSpeed, 4);
			}
			var volume3:Number = NumberUtils.interpolate2(0, 1, ZONE2_END, ZONE3_START, avgSpeed, 0.25);
			
			if(_track1) _track1.volume = volume1;
			if(_track2) _track2.volume = volume2;
			if (_track3) _track3.volume = volume3;
			
			//trace("Speed for music:", avgSpeed, "Volumes:", volume1, volume2, volume3);
		}
		
		/** Used to fade the music as the day end draws near, dependent on onPlayerSpeed happening each tick*/
		public static function fadeGameMusic(volumeMult:Number = 1):void {
			if(_track1) _track1.volume2 = volumeMult;
			if(_track2) _track2.volume2 = volumeMult;
			if (_track3) _track3.volume2 = volumeMult;
		}
		
		public static function debugPlayerSpeed(speed:Number):void {
			onPlayerSpeed(speed, 0);
		}
		
		
		
	}

}