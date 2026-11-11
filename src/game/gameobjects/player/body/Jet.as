package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Jet extends SimpleBody 
	{
		
		public function Jet(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new JetVisual();
		}
		
	}

}