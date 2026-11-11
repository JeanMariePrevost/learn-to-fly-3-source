package src.audio 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author 
	 */
	public interface ISound 
	{
		/** Dispatches when a sound gets destroyed, to warn the manager. (objectDestroyed:ISound) */
		function get signalDestroyed():Signal;
		
		/** Resume payback at position in ms, from current position if NaN */
		 function play(position:Number = NaN):void;
		 
		 /** Pause payback and maintain the current position */
		 function pause():void;
		 
		 /** Stops playback and reset the position to 0 */
		 function stop():void;
		 
		 //** Forces a volume refresh, use when changing master volumes */
		 function updateVolume():void;
		
		/** Play with fadeIn if enabled, from current position if NaN */
		 function fadeIn(position:Number = NaN):void;
		 
		/** Destroy after fadeout enabled, cannot call more than once to "restart" fading */
		 function fadeOut(duration:Number = NaN):void;
		 
		 /** Stops playback and destroy this object */
		 function destroy():void;
		 
		 /** The length of the sound in ms */
		 function get length():Number;
		 
		 /** Low-level access to the actual Sound */
		 function get sound():Sound;
		 
		 /** Low-level access to the actual SoundChannel */
		 function get channel():SoundChannel;
		 
		 /** If the sound is set to loop until stopped or to be destroyed after 1 playback */
		 function get loop():Boolean;
		 function set loop(value:Boolean):void;
		 
		 /** If the sound is currently being played */
		 function get isPlaying():Boolean;
		 
		 /** If the sound is muted, overrides all volume settings */
		 function get mute():Boolean;
		 function set mute(value:Boolean):void;
		 
		 /** Current position of the playhead */
		 function get position():Number;
		 function set position(value:Number):void;
		 
		 /** Sound volume, stacks multiplicatively with other volume settings */
		 function get volume():Number;
		 function set volume(value:Number):void;
		 
		 /** Second sound volume, used for manual fading */
		 function get volume2():Number;
		 function set volume2(value:Number):void;
		 
		 /** Handle to the object that requested this sound, used to retrieve sound w/o locally creating vars */
		 function get parent():Object;
		 function set parent(value:Object):void;
		 
		 /** Handle to the object that requested this sound, used to retrieve sound w/o locally creating vars */
		 function get soundClass():Class;
		 function set soundClass(value:Class):void;
	}
	
}