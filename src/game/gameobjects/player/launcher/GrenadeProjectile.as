package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	import src.game.particles.Particles;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class GrenadeProjectile extends MovieClip 
	{
		public var detonationSignal:Signal = new Signal();
		
		protected var _vx:Number;
		protected var _vy:Number;
		protected var _vr:Number;
		
		public function GrenadeProjectile(target:MovieClip, vx:Number, vy:Number) 
		{
			target.parent.addChild(this);
			x = target.x;
			y = target.y;
			
			_vx = vx;
			_vy = vy;
			_vr = -Math.random() * 10 - 4;
			
			Main.unsafeTickSignal.add(tick);
		}
		
		protected function tick(delta:Number):void 
		{
			_vy += delta * 0.2;
			_vy *= 0.992;
			_vx *= 0.992;
			
			x += _vx;
			y += _vy;
			rotation += _vr;
			
			y = Math.min(y, 0);
			
			if (y >= 0) {
				//Bounce
				_vy *= -0.3;
				_vx *= 0.8;
				_vr *= 0.6;
			}
			
			if (Math.abs(_vx) <= 0.01 && _vy >= -1) {
				//trace("Finished!");
				Main.unsafeTickSignal.remove(tick);
				Main.unsafeTickSignal.add(tickBoom);
				
			}
			
			
		}
		
		protected function tickBoom(delta:Number):void {
			var i:int;
			
			for (i = 0; i <= 15; i++) {
				Particles.builder.smokeWhiteQuick(0, 0, 0.5, 1, 5 + Math.random() * 10, -90 + NumberUtils.randomBoth(180), this);
			}
			for (i = 0; i <= 8; i++) {
				Particles.builder.smokeWhiteQuick(0, 0, 0.5, 1, 7 + Math.random() * 15, -90 + NumberUtils.randomBoth(90), this);
			}
			for (i = 0; i <= 7; i++) {
				Particles.builder.smokeWhiteQuick(0, 0, 0.5, 1, 10 + Math.random() * 20, -90 + NumberUtils.randomBoth(40), this);
			}
			for (i = 0; i <= 25; i++) {
				Particles.builder.snowDebris(NumberUtils.randomBoth(30), NumberUtils.randomBoth(30), 1, 100 + Math.random() * 1000, Math.random() * 360, this);
			}
			
			Particles.builder.explosiveSmoke(0, 0, 1, 1, 1 + Math.random() * 2, -90, this);
			
			detonationSignal.dispatch();
			
			Main.unsafeTickSignal.remove(tickBoom);
		}
		
	}

}