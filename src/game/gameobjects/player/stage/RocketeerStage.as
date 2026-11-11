package src.game.gameobjects.player.stage 
{
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.game.DeltaMovieClipWrapper;
	import src.game.gameobjects.player.Player;
	import src.game.particles.Particles;;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class RocketeerStage extends SimpleStage 
	{
		protected var _smokeCounter:Number = 0;
		
		public function RocketeerStage(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			_thrustOffsetVec2.y = 0;
		}
		
		override public function startStage():void 
		{
			_hasStarted = true;
			_visual = new (_item.statVisualClass)();
			_wrapper = new DeltaMovieClipWrapper(_visual, "initStart");
			
			_player.getMovieClip().addChildAt(_visual, 0);//Add child BEHIND body
			_visual.x = _player.tBottom.x;
			_visual.y = _player.tBottom.y;
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (_wrapper.currentState == "active") {
				if (_smokeCounter <= 0) {
					_smokeCounter = 1;
					Particles.builder.jetPackSmoke(15 + NumberUtils.randomBoth(2), 10, 0.4, 0.7, 4 + Math.random() * 3, DisplayObjectUtil.globalRotationOf(_visual) + 90 + NumberUtils.randomBoth(10), _visual);
					Particles.builder.jetPackSmoke(-15 + NumberUtils.randomBoth(2), 10, 0.4, 0.7, 4 + Math.random() * 3, DisplayObjectUtil.globalRotationOf(_visual) + 90 + NumberUtils.randomBoth(10), _visual);
				}else {
					_smokeCounter -= 1;
				}
			}
			
		}
		
	}

}