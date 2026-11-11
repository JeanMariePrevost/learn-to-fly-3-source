package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class TrashCan2 extends TrashCan 
	{
		
		public function TrashCan2(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new TrashCanVisual2();
		}
		
	}

}