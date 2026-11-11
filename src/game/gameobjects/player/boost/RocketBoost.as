package src.game.gameobjects.player.boost 
{
	import src.game.DeltaMovieClipWrapper;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class RocketBoost extends AuxiliaryRocket 
	{
		
		public function RocketBoost(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override protected function setupVisual():void 
		{
			leftVisual = new _item.statVisualClass();
			leftWrapper = new DeltaMovieClipWrapper(leftVisual, "idleStart");
			_player.getMovieClip().addChildAt(leftVisual, 0);//Add child BEHIND body
			//_player.getMovieClip().addChild(leftVisual);//Add child IN FRONT OF body

			rightVisual = new _item.statVisualClass();
			rightVisual.scaleY = -1;//Flip around
			rightWrapper = new DeltaMovieClipWrapper(rightVisual, "idleStart");
			_player.getMovieClip().addChildAt(rightVisual, 0);//Add child BEHIND body
			//_player.getMovieClip().addChild(rightVisual);//Add child IN FRONT OF body
		}
		
	}

}