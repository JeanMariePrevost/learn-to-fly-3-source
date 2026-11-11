package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Glider extends SimpleBody 
	{
		
		public function Glider(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new GliderVisual();
		}
	}

}