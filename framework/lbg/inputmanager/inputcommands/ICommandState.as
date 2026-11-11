package lbg.inputmanager.inputcommands 
{
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author 
	 */
	public interface ICommandState 
	{
		function get isDown():Boolean;
		function get signalCommandDown():Signal 
		function get signalCommandUp():Signal 
		function destroy():void
	}
	
}