package lbg.anticheatengine 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author 
	 */
	public class CheatDetector
	{
		public static const eventDispatcher:EventDispatcher = new EventDispatcher();
		
		protected static var _cheatDetectedSignal:Signal = new Signal();
		
		public function CheatDetector(doNotInstantiate:CheatDetector) 
		{
		}
		
		static public function get cheatDetectedSignal():Signal 
		{
			return _cheatDetectedSignal;
		}
		
	}

}