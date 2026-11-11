package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Shuttle2 extends Shuttle 
	{
		
		public function Shuttle2(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new ShuttleVisual2();
		}
		
		
	}

}