package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Spearhead extends SimpleBody 
	{
		
		public function Spearhead(gameState:GameState) 
		{
			visualClass = SpearheadVisual1;
			
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new SpearheadVisual1();
		}
		
	}

}