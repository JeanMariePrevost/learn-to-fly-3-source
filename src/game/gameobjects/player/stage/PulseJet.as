package src.game.gameobjects.player.stage 
{
	import flash.geom.Point;
	import src.effects.LineTrail;
	import src.effects.smoketrail.SmokeTrail;
	import src.game.GameCamera;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class PulseJet extends RamJet 
	{
		
		public function PulseJet(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override protected function addToDisplay():void 
		{
			super.addToDisplay();
			
			createTrails();
		}
		
		override protected function createTrails():void 
		{
			if (_trailLeft == null) {
				_trailLeft = SmokeTrail.newSmokeTrail();
				_trailLeft.color = 0xFFD24A;
				_trailLeft.alpha = 1;
				_trailLeft.fadeInLength = 12;
				_trailLeft.fadeInAlpha = 0.1;
				_trailLeft.fadeInPower = 0.7;
				_trailLeft.fadeOutLegnth = 5;
				_trailLeft.pushForce = 25;
				_trailLeft.pushForceDrag = 0.96;
				_trailLeft.spreadForce = 0.5;
				_trailLeft.fadePerTick = 0.03;
				_trailLeft.maxSegments = 70;
				_trailLeft.lineWidth = 10;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trailLeft.visual, _visualLeft, -1);
			}
			
			if (_trailRight == null) {
				_trailRight = SmokeTrail.newSmokeTrail();
				_trailRight.color = 0xFFD24A;
				_trailRight.alpha = 1;
				_trailRight.fadeInLength = 12;
				_trailRight.fadeInAlpha = 0.1;
				_trailRight.fadeInPower = 0.7;
				_trailRight.fadeOutLegnth = 5;
				_trailRight.pushForce = 25;
				_trailRight.pushForceDrag = 0.96;
				_trailRight.spreadForce = 0.5;
				_trailRight.fadePerTick = 0.03;
				_trailRight.maxSegments = 70;
				_trailRight.lineWidth = 10;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trailRight.visual, _visualRight, -1);
			}
		}
		
		
		
	}

}