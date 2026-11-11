package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Crate extends SimpleBody 
	{
		
		public function Crate(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new CrateVisual1();
		}
	}

}