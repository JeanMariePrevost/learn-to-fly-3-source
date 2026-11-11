package src.spaceinvader 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import src.Main;
	import src.audio.Sfx;
	
	/**
	 * ...
	 * @author 
	 */
	public class BadGuy extends MovieClip 
	{
		public var row:Number = 0;
		public var col:Number = 0;
		
		public var timeToFire:Number = 0;
		public var bulletsFired:Number = 0;
		
		public function BadGuy(row:Number, col:Number) 
		{
			this.row = row;
			this.col = col;
			super();
			
			scaleX = scaleY = 0.8;
			
			var min:Number = NumberUtils.interpolate2(80, 2, 0, 8, GameScreen.instance.wavesCleared);
			var max:Number = NumberUtils.interpolate2(750, 80, 0, 8, GameScreen.instance.wavesCleared);
			timeToFire = NumberUtils.randomRange(min, max);
			
			Main.unsafeTickSignal.add(tick);
		}
		
		protected function tick(delta:Number):void {
			timeToFire -= 1;
			
			if (timeToFire <= 0) fire();
		}
		
		protected function fire():void {
			if (GameScreen.instance == null) {
				destroy();
				return;
			}
			
			var timeFromY:Number = NumberUtils.interpolate2(30, 2, 70, 280, y);
			var timeFromWave:Number = NumberUtils.interpolate2(300, -30, 0, 15, GameScreen.instance.wavesCleared);
			var timeFromBulletsFired:Number = NumberUtils.interpolate2(10, 0, 0, 5, bulletsFired) * NumberUtils.randomRange(0.3, 1);
			
			var b:Bullet = new Bullet();
			b.x = x;
			b.y = y;
			//b.scaleY = -1;
			GameScreen.instance.addChild(b);
			bulletsFired += 1;
			
			timeToFire = (timeFromY + timeFromWave+timeFromBulletsFired) * NumberUtils.randomRange(0.7, 1);
			timeToFire = Math.max(timeToFire, 4);
			
			Sfx.playInvaderEnemyFire();
		}
		
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}