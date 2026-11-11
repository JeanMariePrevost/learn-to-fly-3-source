package src.game.particles 
{
	import src.Main;
	/**
	 * ...
	 * @author ...
	 */
	public class NullParticle extends AbstractParticle 
	{
		
		public function NullParticle() 
		{
			super();
		}
		
		override protected function tick(delta:Number):void {
			destroy();
		}
		
		override protected function doFade():void {
		}
		
	}

}