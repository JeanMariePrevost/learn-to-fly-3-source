package src.shop 
{
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author ...
	 */
	public class ShopMediator 
	{
		public static var slotOverSignal:Signal = new Signal(Slot);
		public static var slotOutSignal:Signal = new Signal(Slot);
		
		public static function clearAllSignals():void {
			slotOverSignal.removeAll();
			slotOutSignal.removeAll();
		}
		
	}

}