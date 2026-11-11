package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BigBird extends RocketKit 
	{
		
		public function BigBird(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new BigBirdVisual();
		}
		
	}

}