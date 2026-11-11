package src.game.gameobjects.player.stage 
{
	import lbg.components.labelmovieclip.LabelMovieClip;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.game.gameobjects.player.Player;
	import src.game.particles.Particles;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class BalloonArray extends Balloon 
	{
		protected var _currentBalloon:Number = 0;//Used for particles
		
		public function BalloonArray(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override public function tick(delta:Number):void 
		{
			if (fuel > 0) {
				//Stage working normally
				if(_wrapper.currentState != "init") _wrapper.setToOn();
				if (_wrapper.currentState == "active") {
					playSound(100);
					applyPower(delta);
					_wrapper.stop();
					substractFuel(delta);
					if (_smokeCounter <= 0) {
						_smokeCounter = 1;
						if (_currentBalloon <= 0) {
							_currentBalloon = 1;
							Particles.builder.smokeBalloon(-100, _visual.smokeTarget.y, 0.15, 0.25, 3 + Math.random() * 2, DisplayObjectUtil.globalRotationOf(_visual) + 90 + NumberUtils.randomBoth(4), _visual);
						}else if (_currentBalloon == 1) {
							_currentBalloon = 2;
							Particles.builder.smokeBalloon(0, _visual.smokeTarget.y, 0.15, 0.25, 3 + Math.random() * 2, DisplayObjectUtil.globalRotationOf(_visual) + 90 + NumberUtils.randomBoth(4), _visual);
						}else {
							_currentBalloon = 0;
							Particles.builder.smokeBalloon(100, _visual.smokeTarget.y, 0.15, 0.25, 3 + Math.random() * 2, DisplayObjectUtil.globalRotationOf(_visual) + 90 + NumberUtils.randomBoth(4), _visual);
						}
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