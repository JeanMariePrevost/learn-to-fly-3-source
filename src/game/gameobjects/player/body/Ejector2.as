package src.game.gameobjects.player.body 
{
	import flash.display.MovieClip;
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Ejector2 extends Ejector 
	{
		
		public function Ejector2(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		override protected function createFallingSeat():MovieClip 
		{
			return new EjectorSeatEmpty2();
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new EjectorVisual2();
		}
		
		
	}

}