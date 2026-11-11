package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class OmegaBody extends EmptyBody 
	{
		
		public function OmegaBody(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new OmegaBodyVisual();
		}
		
	}

}