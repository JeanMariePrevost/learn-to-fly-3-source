package src.game.gameobjects.player.body 
{
	import src.game.gameobjects.ShapesData;
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Jet2 extends Jet 
	{
		
		public function Jet2(gameState:GameState) 
		{
			super(gameState);
			
			createBody(ShapesData.getShapeListOf(item.statSpecialIds));//Different shapes for this upgrade
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new JetVisual2();
		}
	}

}