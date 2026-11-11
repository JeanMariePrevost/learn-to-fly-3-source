package src.spaceinvader 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class Bullet extends MovieClip 
	{
		public var vy:Number = 0;
		public var isActive:Boolean = true;
		public function Bullet() 
		{
			super();
			
			vy = 8 + Math.min(GameScreen.instance.wavesCleared, 18);
			
			Main.unsafeTickSignal.add(tick);
		}
		
		public function tick(delta:Number):void {
			if (!stage) {
				destroy();
				return;
			}
			
			if (y <=-100 || y >= 650) {
				destroy();
			}else {
				GameScreen.instance.checkCollisions(this);
			}
			
			y += vy;
			
		}
		
		public function collidesWith(obj:DisplayObject):Boolean {
			return obj.hitTestPoint(x, y, true);
		}
		
		public function destroy():void {
			isActive = false;
			Main.unsafeTickSignal.remove(tick);
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}