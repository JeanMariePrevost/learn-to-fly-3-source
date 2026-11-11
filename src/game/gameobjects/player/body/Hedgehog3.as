package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Hedgehog3 extends Hedgehog 
	{
		
		public function Hedgehog3(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new HedgehogVisual3();
		}
		
	}

}