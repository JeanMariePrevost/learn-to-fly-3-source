package src.gui 
{
	import lbg.debug.Log;
	import org.osflash.signals.Signal;
	import src.Main;
	/**
	 * ...
	 * @author 
	 */
	public class GuiSettings 
	{
		
		protected static var _guiTickSignal:Signal = null;
		
		static public function get guiTickSignal():Signal 
		{
			if (_guiTickSignal == null) {
				Log.log("GuiSettings error - _guiTickSignal is null, no GUI element can work without it.");
				//throw new Error("GuiSettings error - _guiTickSignal is null, no GUI element can work without it.");
				_guiTickSignal = new Signal();
			}
			return _guiTickSignal;
		}
		
		/** Set a Singal(Number) as the default ticking event for GUI elements */
		static public function setGuiTickSignal(value:Signal):void 
		{
			_guiTickSignal = value;
		}
	}

}