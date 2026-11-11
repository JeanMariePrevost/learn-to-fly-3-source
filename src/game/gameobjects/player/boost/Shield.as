package src.game.gameobjects.player.boost 
{
	import src.compound.Mod;
	import src.game.DeltaMovieClipWrapper;
	import src.game.gameobjects.player.Player;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class Shield extends Brick 
	{
		protected var _impactMod:Mod;
		
		public function Shield(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			_impactMod = StatHooks.obstacleMassMult.addMod2(0, _item.statPower);
		}
		
		override protected function setupVisual():void {
			leftVisual = new _item.statVisualClass();
			leftWrapper = new DeltaMovieClipWrapper(leftVisual);
			_player.getMovieClip().addChildAt(leftVisual, 0);//Add child BEHIND body
			//_player.getMovieClip().addChild(leftVisual);//Add child IN FRONT OF body

			rightVisual = new _item.statVisualClass();
			rightVisual.scaleY = -1;//Flip around
			rightWrapper = new DeltaMovieClipWrapper(rightVisual);
			_player.getMovieClip().addChildAt(rightVisual, 0);//Add child BEHIND body
			//_player.getMovieClip().addChild(rightVisual);//Add child IN FRONT OF body
		}
		
	}

}