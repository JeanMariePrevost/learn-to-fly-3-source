package src.game.particles 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import src.game.GameEngine;
	import src.game.GameMediator;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class SmokeWhite extends AbstractParticle
	{
		
		public function SmokeWhite(life:Number = 50, fadeLife:Number = 50) 
		{
			super();
			
			//vx = NumberUtils.randomBoth(3);
			//vy = NumberUtils.randomBoth(3);
			vr = NumberUtils.randomBoth(12);
			vScale = 0.03;
			drag = 0.03;
			
			particleLife = life;
			particleFadeLife = fadeLife;
			
		}
		
		
	}

}