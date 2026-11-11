package src.game.gameobjects.player.stage 
{
	import lbg.utils.NumberUtils;
	import src.game.gameobjects.player.Player;
	import src.game.particles.AbstractParticle;
	import src.game.particles.Particles;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BigBirdStage extends RocketKitStage 
	{
		//This stage's power slowly fades in at first for a more dramatic liftoff
		protected var _powerFadeIn:Number = 0;
		protected var _maxPowerAt:Number = 100;
		
		public function BigBirdStage(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			_smokeDuration = 2;
		}
		
		override protected function applyPower(delta:Number, forceThrustRelativeAngle:Number = NaN):void 
		{
			_powerFadeIn += delta;
			var powerMult:Number = NumberUtils.interpolate2(0.05, 1, 0, _maxPowerAt, _powerFadeIn, 1.5);
			super.applyPower(delta * powerMult);
			
			if (_smokeTime >= _smokeDuration) {
				_smokeTime = 0;
				var smoke:AbstractParticle = Particles.builder.smokeWhiteQuick(NumberUtils.randomRange( -5, 5), 140, 2, 3, 12 + Math.random() * 10, _player.getMovieClip().rotation + 90 + NumberUtils.randomBoth(16), _visual);
				smoke.vScale = 0.14;
			}else {
				_smokeTime += 1;
			}
			
		}
		
	}

}