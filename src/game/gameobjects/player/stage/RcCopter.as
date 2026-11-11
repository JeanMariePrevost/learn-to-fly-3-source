package src.game.gameobjects.player.stage 
{
	import nape.geom.Vec2;
	import src.game.DeltaMovieClipWrapper;
	import src.game.gameobjects.player.Player;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class RcCopter extends SimpleStage 
	{
		
		public function RcCopter(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			_thrustOffsetVec2.y = 8;
		}
		
		override public function startStage():void 
		{
			_hasStarted = true;
			_visual = new (_item.statVisualClass)();
			_wrapper = new DeltaMovieClipWrapper(_visual, "initStart");
			
			_player.getMovieClip().addChildAt(_visual, 0);//Add child BEHIND body
			_visual.x = _player.tTop.x;
			_visual.y = _player.tTop.y;
		}
		
		override protected function playSound(fadeInDuration:Number = NaN):void 
		{
			if (isNaN(fadeInDuration)) fadeInDuration = 700;
			super.playSound(fadeInDuration);
		}
		
		override protected function stopSound(fadeOutDuration:Number = NaN):void 
		{
			if (isNaN(fadeOutDuration)) fadeOutDuration = 500;
			super.stopSound(fadeOutDuration);
		}
		
	}

}