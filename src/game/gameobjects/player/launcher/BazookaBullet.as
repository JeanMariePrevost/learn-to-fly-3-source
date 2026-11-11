package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import lbg.utils.Trig;
	import org.osflash.signals.Signal;
	import src.game.particles.Particles;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class BazookaBullet extends MovieClip 
	{
		public const POWER:Number = 20;
		public const GROUND_OFFSET:Number = 12;
		public var vx:Number;
		public var vy:Number;
		public var crater:MovieClip;
		public var explosionSignal:Signal = new Signal(BazookaBullet);
		
		public function BazookaBullet(bazookaMC:MovieClip) 
		{
			super();
			
			x = bazookaMC.x;
			y = bazookaMC.y;
			
			vx = Trig.vectorX(POWER, bazookaMC.rotation - 180);
			vy = Trig.vectorY(POWER, bazookaMC.rotation - 180);
			
			updateRotation();
			
			Main.unsafeTickSignal.add(tick);
			
		}
		
		private function tick(delta:Number):void 
		{
			x += vx;
			y += vy;
			
			vx *= 0.97;
			vy += 0.3;
			vy *= 0.97;
			
			updateRotation();
			
			if (y >= GROUND_OFFSET) {
				doExplosion();
				Main.unsafeTickSignal.remove(tick);
				Main.unsafeTickSignal.add(tickFinish);
			}
			
		}
		
		private function tickFinish(delta:Number):void 
		{
			crater.alpha -= 0.002;
			if (crater.alpha <= 0) {
				destroy();
			}
		}
		
		protected function doExplosion():void {
			crater = new src.game.gameobjects.player.launcher.BazookaCrater();
			crater.alpha = 1.2;
			crater.x = x;
			crater.y = y;
			parent.addChild(crater);
			
			Particles.builder.explosiveSmoke(0, 0, 0.8, 1.2, 0, 0, crater);
			Particles.builder.explosiveSmoke(0, 0, 0.4, 0.4, 0, 0, crater).vScale = 0.4;
			for (var i:int = 0; i <= 13; i++) {
				Particles.builder.snowDebris( -50 + Math.random() * 100, -50 + Math.random() * 50, 1, 75 + Math.random() * 300, -170 + Math.random() * 160, crater);
				Particles.builder.snowDebris( -50 + Math.random() * 100, -100 + Math.random() * 50, 1, 100 + Math.random() * 400, -135 + Math.random() * 90, crater);
			}
			explosionSignal.dispatch(this);
			
			parent.removeChild(this);
		}
		
		protected function updateRotation():void {
			rotation = Trig.angleFromDisplacement(vx, vy);
		}
		
		
		public function destroy():void {
			if (stage) parent.removeChild(this);
			if (crater) {
				if (crater.stage) crater.parent.removeChild(crater);
				crater = null;
			}
			if(explosionSignal) explosionSignal.removeAll();
			explosionSignal = null;
			Main.unsafeTickSignal.remove(tick);
			Main.unsafeTickSignal.remove(tickFinish);
		}
	}

}