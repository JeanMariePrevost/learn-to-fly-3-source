package src.game.gameobjects.player.stage 
{
	import lbg.components.labelmovieclip.LabelMovieClip;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.game.gameobjects.player.Player;
	import src.game.particles.AbstractParticle;
	import src.game.particles.Particles;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class PotatoStage extends Balloon 
	{
		
		public function PotatoStage(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override public function tick(delta:Number):void 
		{
			if (fuel > 0) {
				//Stage working normally
				if(_wrapper.currentState != "init") _wrapper.setToOn();
				if (_wrapper.currentState == "active") {
					playSound();
					applyPower(delta);
					_wrapper.stop();
					substractFuel(delta);
					if (_smokeCounter <= 0) {
						_smokeCounter = 2;
						var p:AbstractParticle = Particles.builder.smokeBlack(0, 100, 0.55, 0.65, 5 + Math.random() * 2, DisplayObjectUtil.globalRotationOf(_visual) + 90 + NumberUtils.randomBoth(4), _visual);
						p.particleLife = 0;
						p.vScale = 0.09;
					}else {
						_smokeCounter -= 1;
					}
				}
			}else {
				//Out of fuel
				if (!_isFinished) {
					stopSound();
					doDeath();
					_wrapper.play();
				}else {
					//Nothing
				}
			}
		}
	}

}