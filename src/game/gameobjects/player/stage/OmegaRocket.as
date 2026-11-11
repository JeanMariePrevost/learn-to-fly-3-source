package src.game.gameobjects.player.stage 
{
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
	public class OmegaRocket extends Rocket 
	{
		
		public function OmegaRocket(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			if (_wrapper.currentState == "on" || _wrapper.currentState == "active") {
				if (_smokeCounter <= 0) {
					_smokeCounter = 4;
					var p:AbstractParticle = Particles.builder.smokeWhiteQuick(0, 190, 1.3, 1.65, 10 + Math.random() * 4, DisplayObjectUtil.globalRotationOf(_visual) + 90 + NumberUtils.randomBoth(4), _visual);
					p.vScale = 0.12;
				}else {
					_smokeCounter -= 1;
				}
			}
		}
	}

}