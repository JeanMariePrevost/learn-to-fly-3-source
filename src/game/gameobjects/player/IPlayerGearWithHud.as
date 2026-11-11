package src.game.gameobjects.player 
{
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IPlayerGearWithHud extends IPlayerGear
	{
		function get hudSignal():Signal;
	}
	
}