package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class InlineBody extends SimpleBody 
	{
		
		public function InlineBody(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new InlineBodyVisual();
		}
		
	}

}