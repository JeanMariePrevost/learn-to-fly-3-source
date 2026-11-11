package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Glider3 extends Glider 
	{
		
		public function Glider3(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new GliderVisual3();
		}
	}

}