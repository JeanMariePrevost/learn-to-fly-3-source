package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Shuttle3 extends Shuttle 
	{
		
		public function Shuttle3(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new ShuttleVisual3();
		}
		
	}

}