package src.game.gameobjects.player 
{
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IPlayerGear 
	{
		function tick(delta:Number):void;
		//function set item(value:GameStateItem):void;
		function get item():GameStateItem;
		//function get showOnHud():Boolean;
		function destroy():void;
	}
	
}