package src.shop 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	
	/**
	 * ...
	 * @author 
	 */
	public class TvSweepEffect extends MovieClip 
	{
		
		public function TvSweepEffect() 
		{
			super();
			
			
			gotoAndPlay(Math.round(NumberUtils.randomRange(1, totalFrames)));
		}
		
	}

}