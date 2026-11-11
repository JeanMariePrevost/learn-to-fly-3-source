package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Superman3 extends Superman 
	{
		
		public function Superman3(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new SupermanVisual3();
		}
		
	}

}