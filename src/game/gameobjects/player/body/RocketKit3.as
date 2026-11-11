package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class RocketKit3 extends RocketKit 
	{
		
		public function RocketKit3(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new RocketKitVisual3();
		}
		
	}

}