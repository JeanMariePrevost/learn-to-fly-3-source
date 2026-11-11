package src.game.gameobjects.player.stage 
{
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.game.gameobjects.player.Player;
	import src.game.particles.AbstractParticle;
	import src.game.particles.Particles;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class EscapePodStage extends SimpleStage 
	{
		
		protected var _smokeCounter:Number = 0;
		
		public function EscapePodStage(player:Player, item:GameStateItem) 
		{
			super(player, item);
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			if (_wrapper.currentState == "on" || _wrapper.currentState == "active") {
				if (_smokeCounter <= 0) {
					_smokeCounter = 3;
					var p:AbstractParticle = Particles.builder.smokeWhiteQuick(0, 60, 0.8, 1.2, 7 + Math.random() * 3, DisplayObjectUtil.globalRotationOf(_visual) + 90 + NumberUtils.randomBoth(4), _visual);
					p.vScale = 0.04;
				}else {
					_smokeCounter -= 1;
				}
			}
		}
	}

}