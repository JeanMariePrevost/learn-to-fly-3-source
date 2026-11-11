package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class BigBird2 extends BigBird 
	{
		
		public function BigBird2(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new BigBirdVisual2();
		}
		
	}

}