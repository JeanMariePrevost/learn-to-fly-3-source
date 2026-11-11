package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class RocketKit2 extends RocketKit 
	{
		
		public function RocketKit2(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new RocketKitVisual2();
		}
		
	}

}