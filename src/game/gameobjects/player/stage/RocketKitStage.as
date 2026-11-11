package src.game.gameobjects.player.stage 
{
	import lbg.utils.NumberUtils;
	import src.game.gameobjects.player.Player;
	import src.game.particles.Particles;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class RocketKitStage extends SimpleStage 
	{
		protected var _smokeTime:Number = 0;
		protected var _smokeDuration:Number = 1;
		
		public function RocketKitStage(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override protected function applyPower(delta:Number, forceThrustRelativeAngle:Number = NaN):void 
		{
			super.applyPower(delta);
			
			if (_smokeTime >= _smokeDuration) {
				_smokeTime = 0;
				Particles.builder.smokeWhiteQuick(0, 10, 0.8, 1.2, 12 + Math.random() * 10, _player.getMovieClip().rotation + 90 + NumberUtils.randomBoth(8), _visual);
			}else {
				_smokeTime += 1;
			}
			
		}
		
	}

}