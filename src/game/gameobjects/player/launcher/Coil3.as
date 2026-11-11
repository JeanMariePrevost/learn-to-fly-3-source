package src.game.gameobjects.player.launcher 
{
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class Coil3 extends Coil 
	{
		
		public function Coil3(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			
			scaleX = scaleY = 0.8;
		}
		
	}

}