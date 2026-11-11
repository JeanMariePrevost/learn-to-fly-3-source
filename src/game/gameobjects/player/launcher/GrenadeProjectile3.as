package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.effects.LineTrail;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class GrenadeProjectile3 extends GrenadeProjectile 
	{
		protected var _tintCounterMax:Number = 40;
		protected var _tintCounter:Number = _tintCounterMax;
		
		protected var _trail:LineTrail;
		
		public function GrenadeProjectile3(target:MovieClip, vx:Number, vy:Number) 
		{
			super(target, vx, vy);
			
			_trail = LineTrail.newLineTrail();
			_trail.color = 0x3DC5FF;
			_trail.baseAlpha = 1;
			_trail.fadeFromLength = 1;
			_trail.maxSegments = 60;
			_trail.lineWidth = 5;
			parent.addChild(_trail.visual);
	}
		
		override protected function tick(delta:Number):void 
		{
			super.tick(delta);
			
			_trail.addSegment(x, y);
			_trail.fadeLine();
			_trail.update();
		}
		
		override protected function tickBoom(delta:Number):void 
		{
			if (_tintCounter > 0) {
				//DisplayObjectUtil.setObjectTint(this, 0xCCFFFF, NumberUtils.interpolate2(0, 1, _tintCounterMax, 0, _tintCounter));
				var blur:Number = NumberUtils.interpolate2(2, 60, _tintCounterMax, 0, _tintCounter, 4);
				var blurStrength:Number = NumberUtils.interpolate2(1, 10, _tintCounterMax, 0, _tintCounter, 4);
				var glow1:GlowFilter = new GlowFilter(0xA2F6FA, 1, blur * 0.2, blur * 0.2, blurStrength, 2, true);
				var glow2:GlowFilter = new GlowFilter(0x3FF3FC, 1, blur * 2.5, 1 + blur * 0.1, blurStrength, 2);
				filters = [glow1, glow2];
				_tintCounter -= 1;
			}else {
				super.tickBoom(delta);
			}
		}
		
	}

}