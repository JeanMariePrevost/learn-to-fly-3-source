package src.game.particles 
{
	/**
	 * ...
	 * @author 
	 */
	public class ExplosiveSmoke extends SmokeWhite 
	{
		
		public function ExplosiveSmoke(life:Number=50, fadeLife:Number=50) 
		{
			super(life, fadeLife);
			
		}
		
		
		override protected function tick(delta:Number):void 
		{
			vScale *= 0.97;
			super.tick(delta);
		}
	}

}