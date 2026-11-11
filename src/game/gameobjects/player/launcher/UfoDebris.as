package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author 
	 */
	public class UfoDebris extends MovieClip 
	{
		
		public var speedMult:Number;
		public var vy:Number = 0;
		public var dragUp:Number = 0.998;
		public var dragDown:Number = 0.99;
		
		public function UfoDebris() 
		{
			super();
			vy = 0;
			x = Math.random() * 720;
			y = Math.random() * 600 + 440;
			rotation = Math.random() * 360;
			gotoAndStop(Math.ceil(Math.random() * totalFrames));
			alpha = 0;
			speedMult = 0.6 + Math.random() * 0.5;
			scaleX = scaleY = speedMult;
		}
		
		public function tickUp(delta:Number):void {
			if (alpha < 1) {
				alpha += 0.02;
			}
			
			vy -= 0.02 * speedMult;
			vy *= dragUp;
			y += vy;
			
			if (y <= -30) {
				x = Math.random() * 720;
				y = Math.random() * 40 + 540;
				rotation = Math.random() * 360;
				gotoAndStop(Math.ceil(Math.random() * totalFrames));
				alpha = 0.5;
				speedMult = 0.6 + Math.random() * 0.5;
				scaleX = scaleY = speedMult;
			}
		}
		
		public function tickDown(delta:Number):void {
			vy += 0.2 * speedMult;
			vy *= dragDown;
			y += vy;
		}
		
		public function get isFinished():Boolean {
			return y >= 570;
		}
		
	}

}