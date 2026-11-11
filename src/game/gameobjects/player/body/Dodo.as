package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Dodo extends SimpleBody 
	{
		
		public function Dodo(gameState:GameState) 
		{
			visualClass = DodoVisual1;
			
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new DodoVisual1();
		}
		
	}

}