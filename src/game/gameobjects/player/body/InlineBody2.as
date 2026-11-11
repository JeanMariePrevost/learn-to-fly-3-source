package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class InlineBody2 extends InlineBody 
	{
		
		public function InlineBody2(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new InlineBodyVisual2();
		}
		
	}

}