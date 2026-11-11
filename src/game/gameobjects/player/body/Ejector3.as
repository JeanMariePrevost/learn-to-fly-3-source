package src.game.gameobjects.player.body 
{
	import flash.display.MovieClip;
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Ejector3 extends Ejector 
	{
		
		public function Ejector3(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function createFallingSeat():MovieClip 
		{
			return new EjectorSeatEmpty3();
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new EjectorVisual3();
		}
		
		
	}

}