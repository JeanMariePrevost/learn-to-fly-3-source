package src.game.gameobjects.player.stage 
{
	import flash.geom.Point;
	import src.audio.Audio;
	import src.effects.LineTrail;
	import src.effects.smoketrail.SmokeTrail;
	import src.game.GameCamera;
	import src.game.gameobjects.player.Player;
	import src.game.particles.Particles;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class RPG extends SimpleStage 
	{
		protected var _trail:SmokeTrail;
		
		public function RPG(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override public function startStage():void 
		{
			super.startStage();
		}
		
		protected function createTrails():void {
			if (_trail == null) {
				_trail = SmokeTrail.newSmokeTrail();
				_trail.color = 0xFFFFFF;
				_trail.alpha = 1;
				_trail.fadeInLength = 12;
				_trail.fadeInAlpha = 0.1;
				_trail.fadeInPower = 0.7;
				_trail.fadeOutLegnth = 5;
				_trail.pushForce = 15;
				_trail.pushForceDrag = 0.96;
				_trail.spreadForce = 0.1;
				_trail.fadePerTick = 0.03;
				_trail.maxSegments = 70;
				_trail.lineWidth = 10;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trail.visual, _visual, -1);
			}
		}
		
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (_wrapper.currentState == "on" || _wrapper.currentState == "active") {
				createTrails();
				var pos:Point = GameCamera.getPositionOnCamera(_visual.tBottom);
				_trail.addSegment(pos.x, pos.y, _player.getMovieClip().rotation + 90);
			}else {
				_trail = null;
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