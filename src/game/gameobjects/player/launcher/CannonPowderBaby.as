package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import lbg.components.labelmovieclip.LabelMovieClip;
	import src.game.DeltaMovieClipWrapper;
	
	/**
	 * ...
	 * @author 
	 */
	public class CannonPowderBaby extends MovieClip 
	{
		public var wrapper:DeltaMovieClipWrapper;
		
		public function CannonPowderBaby() 
		{
			super();
			
			wrapper = new DeltaMovieClipWrapper(this);
			wrapper.setAction("goodStart", LabelMovieClip.ACTION_PLAY);
			wrapper.setAction("safeStart", LabelMovieClip.ACTION_PLAY);
			wrapper.setAction("fullStart", LabelMovieClip.ACTION_PLAY);
			wrapper.setAction("dangerStart", LabelMovieClip.ACTION_PLAY);
			wrapper.setAction("worstStart", LabelMovieClip.ACTION_PLAY);
			
			wrapper.setAction("goodEnd", "goodStart");
			wrapper.setAction("safeEnd", "safeStart");
			wrapper.setAction("fullEnd", "fullStart");
			wrapper.setAction("dangerEnd", "dangerStart");
			wrapper.setAction("worstEnd", LabelMovieClip.ACTION_STOP);
			
			wrapper.useDeltaTime = false;
			
		}
		
	}

}