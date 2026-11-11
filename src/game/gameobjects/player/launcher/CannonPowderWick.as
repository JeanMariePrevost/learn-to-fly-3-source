package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class CannonPowderWick extends MovieClip 
	{
		
		public function CannonPowderWick() 
		{
			super();
			stop();
			
		}
		
		public function igniteWick():void {
			Main.unsafeTickSignal.add(tick)
		}
		
		private function tick(delta:Number):void 
		{
			if (currentFrame >= totalFrames) {
				Main.unsafeTickSignal.remove(tick)
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			nextFrame();
		}
		
	}

}