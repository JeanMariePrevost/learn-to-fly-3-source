package src.game.particles 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class CheatExplosion extends AbstractParticle 
	{
		
		public function CheatExplosion() 
		{
			super();
			
			_particleLife = 200;
			
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void 
		{
			if (currentFrame >= totalFrames) {
				stop();
				destroy();
			}
		}
		
		override public function destroy():void 
		{
			removeEventListener(Event.ENTER_FRAME, onFrame);
			super.destroy();
		}
		
	}

}