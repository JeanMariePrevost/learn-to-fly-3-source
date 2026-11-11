package src.game.gameobjects.player.boost 
{
	import flash.geom.Point;
	import src.effects.smoketrail.SmokeTrail;
	import src.game.GameCamera;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class AuxiliaryRocket extends SimpleBoost 
	{
		protected var _trailLeft:SmokeTrail;
		protected var _trailRight:SmokeTrail;
		
		public function AuxiliaryRocket(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		protected function createTrails():void 
		{
			if (_trailLeft == null) {
				_trailLeft = SmokeTrail.newSmokeTrail();
				_trailLeft.color = 0xFFFFFF;
				_trailLeft.alpha = 0.5;
				_trailLeft.fadeInLength = 6;
				_trailLeft.fadeInAlpha = 0.1;
				_trailLeft.fadeInPower = 0.7;
				_trailLeft.fadeOutLegnth = 20;
				_trailLeft.pushForce = 25;
				_trailLeft.pushForceDrag = 0.85;
				_trailLeft.spreadForce = 1;
				_trailLeft.spreadForceDrag = 0.95;
				_trailLeft.fadePerTick = 0.01;
				_trailLeft.maxSegments = 50;
				_trailLeft.lineWidth = 6;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trailLeft.visual, leftVisual, -1);
			}
			
			if (_trailRight == null) {
				_trailRight = SmokeTrail.newSmokeTrail();
				_trailRight.color = 0xFFFFFF;
				_trailRight.alpha = 0.5;
				_trailRight.fadeInLength = 6;
				_trailRight.fadeInAlpha = 0.1;
				_trailRight.fadeInPower = 0.7;
				_trailRight.fadeOutLegnth = 20;
				_trailRight.pushForce = 25;
				_trailRight.pushForceDrag = 0.85;
				_trailRight.spreadForce = 1;
				_trailRight.spreadForceDrag = 0.95;
				_trailRight.fadePerTick = 0.01;
				_trailRight.maxSegments = 50;
				_trailRight.lineWidth = 6;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trailRight.visual, rightVisual, -1);
			}
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			tickTrails(delta);
			
		}
		
		protected function tickTrails(delta:Number):void {
			if (fuel.value <= 0) return;
			
			if (leftWrapper.currentState == "on" || leftWrapper.currentState == "active") {
				createTrails();
				
				var p:Point = GameCamera.getPositionOnCamera(leftVisual.tBottom);
				_trailLeft.addSegment(p.x, p.y, _player.getMovieClip().rotation + 90 + 15);
				
				var p:Point = GameCamera.getPositionOnCamera(rightVisual.tBottom);
				_trailRight.addSegment(p.x, p.y, _player.getMovieClip().rotation + 90 - 15);
				
			}else {
				_trailLeft = null;
				_trailRight = null;
			}
		}
	}

}