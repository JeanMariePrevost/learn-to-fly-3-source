package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	/**
	 * ...
	 * @author 
	 */
	public class Crate3 extends Crate 
	{
		
		public function Crate3(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new CrateVisual3();
		}
		
	}

}