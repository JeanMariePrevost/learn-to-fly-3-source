package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Rocketeer extends SimpleBody 
	{
		
		public function Rocketeer(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new RocketeerVisual();
		}
		
	}

}