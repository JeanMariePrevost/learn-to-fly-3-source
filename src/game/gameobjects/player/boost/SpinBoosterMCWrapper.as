package src.game.gameobjects.player.boost 
{
	import flash.display.MovieClip;
	import src.game.DeltaMovieClipWrapper;
	
	/**
	 * ...
	 * @author 
	 */
	public class SpinBoosterMCWrapper extends DeltaMovieClipWrapper 
	{
		
		public function SpinBoosterMCWrapper(movieClip:MovieClip, startAtFrame:Object=1) 
		{
			super(movieClip, startAtFrame);
			
		}
		
		
		override protected function customActionsHook():void 
		{
			super.customActionsHook();
			
			setAction("onEnd", "onStart");
			setAction("offEnd", "offStart");
		}
		
		//FIX
		//override protected function checkAndSetLabel():Boolean 
		//{
			//if (_movieClip.currentLabel == "onEnd") {
				//gotoLabel("onStart");
				//return false;
			//}else if (_movieClip.currentLabel == "offEnd") {
				//gotoLabel("offStart");
				//return false;
			//}else {
				//return super.checkAndSetLabel();
			//}
		//}
		
	}

}