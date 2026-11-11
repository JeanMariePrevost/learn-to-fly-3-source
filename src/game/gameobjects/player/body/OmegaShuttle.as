package src.game.gameobjects.player.body 
{
	import src.game.gameobjects.player.body.BodyVisual;
	import src.game.gameobjects.player.body.SimpleBody;
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class OmegaShuttle extends SimpleBody 
	{
		
		public function OmegaShuttle(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new OmegaShuttleVisual();
		}
		
	}

}