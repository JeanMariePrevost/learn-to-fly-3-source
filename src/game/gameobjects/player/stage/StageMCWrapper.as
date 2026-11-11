package src.game.gameobjects.player.stage 
{
	import flash.display.MovieClip;
	import src.game.DeltaMovieClipWrapper;
	
	/**
	 * Specially for stages, init goes into on directly
	 */
	public class StageMCWrapper extends DeltaMovieClipWrapper 
	{
		
		public function StageMCWrapper(movieClip:MovieClip, startAtFrame:Object=1) 
		{
			super(movieClip, startAtFrame);
			
		}
		
		override protected function checkAndSetLabel():Boolean 
		{
			if (_movieClip.currentLabel == "initEnd") {
				setToOn();
				return false;
			}else {
				return super.checkAndSetLabel();
			}
		}
		
	}

}