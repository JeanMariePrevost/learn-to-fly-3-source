package src.game.gameobjects.player.body 
{
	import src.game.GameMediator;
	import src.game.gameobjects.ShapesData;
	import src.system.GameState;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class BeerKeg extends SimpleBody 
	{
		
		public function BeerKeg(gameState:GameState) 
		{
			super(gameState);
			
			createBody(ShapesData.getShapeListOf(item.statSpecialIds));//Different shapes for each upgrade
			
			GameMediator.addStageAtRuntime.dispatch(GameStateItem.createFrom("beerKegStage", item.level));
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new BeerKegVisual();
		}
		
		
	}

}