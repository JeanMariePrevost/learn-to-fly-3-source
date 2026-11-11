package src.game.gameobjects.player.boost 
{
	import lbg.utils.Tools;
	import src.effects.smoketrail.SmokeTrail;
	import src.game.GameCamera;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class OmegaBoosters extends BellNozzle 
	{
		
		public function OmegaBoosters(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override protected function createTrails():void 
		{
			if (_trailLeft == null) {
				_trailLeft = SmokeTrail.newSmokeTrail();
				_trailLeft.color = Tools.rgbToColor(122, 231, 0);
				_trailLeft.alpha = 1;
				_trailLeft.fadeInLength = 10;
				_trailLeft.fadeInAlpha = 0.2;
				_trailLeft.fadeInPower = 0.7;
				_trailLeft.fadeOutLegnth = 20;
				_trailLeft.pushForce = 35;
				_trailLeft.pushForceDrag = 0.85;
				_trailLeft.spreadForce = 2;
				_trailLeft.spreadForceDrag = 0.95;
				_trailLeft.fadePerTick = 0.01;
				_trailLeft.maxSegments = 50;
				_trailLeft.lineWidth = 55;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trailLeft.visual, leftVisual, -1);
			}
			
			if (_trailRight == null) {
				_trailRight = SmokeTrail.newSmokeTrail();
				_trailRight.color = Tools.rgbToColor(122, 231, 0);
				_trailRight.alpha = 1;
				_trailRight.fadeInLength = 10;
				_trailRight.fadeInAlpha = 0.2;
				_trailRight.fadeInPower = 0.7;
				_trailRight.fadeOutLegnth = 20;
				_trailRight.pushForce = 35;
				_trailRight.pushForceDrag = 0.85;
				_trailRight.spreadForce = 2;
				_trailRight.spreadForceDrag = 0.95;
				_trailRight.fadePerTick = 0.01;
				_trailRight.maxSegments = 50;
				_trailRight.lineWidth = 55;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trailRight.visual, rightVisual, -1);
			}
		}
		
	}

}