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
	public class Banshee2 extends Banshee 
	{
		protected var _trailLeft:SmokeTrail;
		protected var _trailRight:SmokeTrail;
		
		public function Banshee2(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		private function createTrails():void 
		{
			if (_trailLeft == null) {
				_trailLeft = SmokeTrail.newSmokeTrail();
				_trailLeft.color = 0xFFFFFF;
				_trailLeft.alpha = 1;
				_trailLeft.fadeInLength = 12;
				_trailLeft.fadeInAlpha = 0.1;
				_trailLeft.fadeInPower = 0.7;
				_trailLeft.fadeOutLegnth = 20;
				_trailLeft.pushForce = 25;
				_trailLeft.pushForceDrag = 0.95;
				_trailLeft.spreadForce = 0.9;
				_trailLeft.fadePerTick = 0.03;
				_trailLeft.maxSegments = 50;
				_trailLeft.lineWidth = 40;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trailLeft.visual, _visualLeft, -1);
			}
			
			if (_trailRight == null) {
				_trailRight = SmokeTrail.newSmokeTrail();
				_trailRight.color = 0xFFFFFF;
				_trailRight.alpha = 1;
				_trailRight.fadeInLength = 12;
				_trailRight.fadeInAlpha = 0.1;
				_trailRight.fadeInPower = 0.7;
				_trailRight.fadeOutLegnth = 20;
				_trailRight.pushForce = 25;
				_trailRight.pushForceDrag = 0.95;
				_trailRight.spreadForce = 0.9;
				_trailRight.fadePerTick = 0.03;
				_trailRight.maxSegments = 50;
				_trailRight.lineWidth = 40;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trailRight.visual, _visualRight, -1);
			}
		}
		
		override public function tick(delta:Number):void 
		{
			try {
				super.tick(delta);
				
				if (_isFinished) return;
				
				if (_wrapperLeft.currentState == "on" || _wrapperLeft.currentState == "active") {
					createTrails();
					
					var p:Point = GameCamera.getPositionOnCamera(_visualLeft.tBottom);
					_trailLeft.addSegment(p.x, p.y, _player.getMovieClip().rotation + 90);
					
					var p:Point = GameCamera.getPositionOnCamera(_visualRight.tBottom);
					_trailRight.addSegment(p.x, p.y, _player.getMovieClip().rotation + 90);
				}else {
					_trailLeft = null;
					_trailRight = null;
				}
				
			}catch (e:Error) {
				//trace(e);
			}
		}
		
	}

}