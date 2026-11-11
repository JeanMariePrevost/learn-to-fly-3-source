package src.game.gameobjects.player.stage 
{
	import flash.geom.Point;
	import src.audio.Audio;
	import src.effects.smoketrail.SmokeTrail;
	import src.game.GameCamera;
	import src.game.gameobjects.player.Player;
	import src.game.particles.Particles;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class Firework extends Banshee 
	{
		protected var _trailLeft:SmokeTrail;
		protected var _trailRight:SmokeTrail;
		
		public function Firework(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		
		override protected function addToDisplay():void 
		{
			_player.getMovieClip().addChild(_visualLeft);
			_player.getMovieClip().addChild(_visualRight);
			
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
				_trailLeft.pushForce = 12;
				_trailLeft.pushForceDrag = 0.96;
				_trailLeft.spreadForce = 0.1;
				_trailLeft.fadePerTick = 0.04;
				_trailLeft.maxSegments = 50;
				_trailLeft.lineWidth = 5;
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
				_trailRight.pushForce = 12;
				_trailRight.pushForceDrag = 0.96;
				_trailRight.spreadForce = 0.1;
				_trailRight.fadePerTick = 0.04;
				_trailRight.maxSegments = 50;
				_trailRight.lineWidth = 5;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trailRight.visual, _visualRight, -1);
			}
		}
		
		override public function tick(delta:Number):void 
		{
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
		}
		
		override protected function doDeath():void 
		{
			_player.applyThrust(_item.statSpecial, 0);
			Particles.builder.screenFlash(1, 0, 20);
			
			Audio.playSound(_item.statSound2, this).volume = _item.statSound2Volume;
			
			super.doDeath();
		}
		
	}

}