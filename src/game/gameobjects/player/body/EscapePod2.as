package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class EscapePod2 extends EscapePod 
	{
		
		public function EscapePod2(gameState:GameState) 
		{
			super(gameState);
			
			_flapSeparationForce = 5000;
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new EscapePodVisual2();
		}
	}

}