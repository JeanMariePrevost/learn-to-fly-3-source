package src.game.gameobjects.player.boost 
{
	import flash.geom.Point;
	import lbg.utils.NumberUtils;
	import lbg.utils.Tools;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameCamera;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	import src.effects.smoketrail.SmokeTrail;
	
	/**
	 * ...
	 * @author 
	 */
	public class BellNozzle extends AuxiliaryRocket 
	{
		
		//Used to maintain IDE fire scaling
		protected var _baseScaleX:Number;
		protected var _baseScaleY:Number;
		
		public function BellNozzle(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override protected function createTrails():void 
		{
			if (_trailLeft == null) {
				_trailLeft = SmokeTrail.newSmokeTrail();
				_trailLeft.color = Tools.rgbToColor(50, 205, 255);
				_trailLeft.alpha = 1;
				_trailLeft.fadeInLength = 10;
				_trailLeft.fadeInAlpha = 0.2;
				_trailLeft.fadeInPower = 0.7;
				_trailLeft.fadeOutLegnth = 20;
				_trailLeft.pushForce = 25;
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
				_trailRight.color = Tools.rgbToColor(50, 205, 255);
				_trailRight.alpha = 1;
				_trailRight.fadeInLength = 10;
				_trailRight.fadeInAlpha = 0.2;
				_trailRight.fadeInPower = 0.7;
				_trailRight.fadeOutLegnth = 20;
				_trailRight.pushForce = 25;
				_trailRight.pushForceDrag = 0.85;
				_trailRight.spreadForce = 2;
				_trailRight.spreadForceDrag = 0.95;
				_trailRight.fadePerTick = 0.01;
				_trailRight.maxSegments = 50;
				_trailRight.lineWidth = 55;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trailRight.visual, rightVisual, -1);
			}
		}
		
		override protected function setupVisual():void 
		{
			super.setupVisual();
			
			leftVisual.fire.visible = false;
			rightVisual.fire.visible = false;
			
			_baseScaleX = leftVisual.fire.scaleX;
			_baseScaleY = leftVisual.fire.scaleY;
		}
		
		override protected function applyThrust(delta:Number):void 
		{
			if (leftVisual.currentLabel == "activeStart" || leftVisual.currentLabel == "activeEnd") {
				super.applyThrust(delta);
			}
		}
		
		override protected function tickTrails(delta:Number):void 
		{
			if (fuel.value >0 && leftVisual.currentLabel == "activeStart" || leftVisual.currentLabel == "activeEnd") {
				createTrails();
				
				var p:Point = GameCamera.getPositionOnCamera(leftVisual.tBottom);
				_trailLeft.addSegment(p.x, p.y, _player.getMovieClip().rotation + 90 + 15);
				
				var p:Point = GameCamera.getPositionOnCamera(rightVisual.tBottom);
				_trailRight.addSegment(p.x, p.y, _player.getMovieClip().rotation + 90 - 15);
				
				leftVisual.fire.visible = true;
				rightVisual.fire.visible = true;
				var xScale:Number = _baseScaleX * NumberUtils.randomRange(0.97, 1.03);
				var yScale:Number = _baseScaleY * NumberUtils.randomRange(0.95, 1.05);
				leftVisual.fire.scaleX = xScale;
				leftVisual.fire.scaleY = yScale;
				rightVisual.fire.scaleX = xScale;
				rightVisual.fire.scaleY = yScale;
			}else {
				leftVisual.fire.visible = false;
				rightVisual.fire.visible = false;
				_trailLeft = null;
				_trailRight = null;
			}
		}
		
		override protected function playSound(fadeInDuration:Number = NaN):void 
		{
			if (leftWrapper.currentState == "active") {
				if (isNaN(fadeInDuration)) fadeInDuration = 50;
				super.playSound(fadeInDuration);
			}
		}
		
	}

}