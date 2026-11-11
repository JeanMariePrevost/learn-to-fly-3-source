package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Thunderbird1 extends SimpleBody 
	{
		
		public function Thunderbird1(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new Thunderbird1Visual();
		}
	}

}