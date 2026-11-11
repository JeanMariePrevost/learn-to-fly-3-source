package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class InlineBody3 extends InlineBody 
	{
		
		public function InlineBody3(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new InlineBodyVisual3();
		}
		
	}

}