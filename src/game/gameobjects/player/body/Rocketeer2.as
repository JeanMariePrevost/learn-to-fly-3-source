package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Rocketeer2 extends Rocketeer 
	{
		
		public function Rocketeer2(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new RocketeerVisual2()
		}
		
	}

}