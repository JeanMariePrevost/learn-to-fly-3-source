package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Rocketeer3 extends Rocketeer2 
	{
		
		public function Rocketeer3(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new RocketeerVisual3();
		}
		
	}

}