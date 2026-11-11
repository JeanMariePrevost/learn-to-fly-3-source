package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Hedgehog2 extends Hedgehog 
	{
		
		public function Hedgehog2(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new HedgehogVisual2();
		}
	}

}