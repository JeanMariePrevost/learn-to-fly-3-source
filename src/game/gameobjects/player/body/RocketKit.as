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
	public class RocketKit extends SimpleBody 
	{
		
		public function RocketKit(gameState:GameState) 
		{
			super(gameState);
			
			createBody(getShapeList(item.statSpecialIds));//Different shapes for each upgrade
			
			GameMediator.addStageAtRuntime.dispatch(GameStateItem.createFrom("rocketKitStage", item.level));
			
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new RocketKitVisual();
		}
		
	}

}