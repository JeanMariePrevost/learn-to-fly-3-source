package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class TrashCan3 extends TrashCan 
	{
		
		public function TrashCan3(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new TrashCanVisual3();
		}
		
	}

}