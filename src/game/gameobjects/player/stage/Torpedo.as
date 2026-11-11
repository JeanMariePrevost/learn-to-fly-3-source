package src.game.gameobjects.player.stage 
{
	import lbg.utils.DisplayObjectUtil;
	import src.game.gameobjects.player.Player;
	import src.game.particles.Particles;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Torpedo extends SimpleStage 
	{
		protected var _smokeTime:Number = 0;
		protected var _smokeDuration:Number = 1;
		
		public function Torpedo(player:Player, item:GameStateItem) 
		{
			super(player, item);
			_thrustOffsetVec2.y = -1;
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (_wrapper.currentState == "active" || _wrapper.currentState == "on") {
				if (_smokeTime >= _smokeDuration) {
					_smokeTime = 0;
					Particles.builder.smokeWhiteQuick(0, 0, 0.8, 1.2, 15 + Math.random() * 10, DisplayObjectUtil.globalRotationOf(_visual) + 90, _visual.tBottom);
				}else {
					_smokeTime += 1;
				}
			}
		}
		
	}

}