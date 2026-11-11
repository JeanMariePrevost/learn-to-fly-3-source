package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class CaptainSupporter extends Superman 
	{
		
		public function CaptainSupporter(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new CaptainSupporterVisual();
		}
	}

}