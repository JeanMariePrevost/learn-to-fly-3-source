package src.game.gameobjects.player.boost 
{
	import flash.display.MovieClip;
	import src.game.DeltaMovieClipWrapper;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MultiRocketMCWrapper extends DeltaMovieClipWrapper 
	{
		
		public function MultiRocketMCWrapper(movieClip:MovieClip, startAtFrame:Object=1) 
		{
			super(movieClip, startAtFrame);
			
		}
		
		override protected function customActionsHook():void 
		{
			super.customActionsHook();
			
			setAction("offEnd", ACTION_STOP);
		}
		
		//FIX
		//override protected function checkAndSetLabel():Boolean 
		//{
			//if (_movieClip.currentLabel == "offEnd") {
				//return false;
			//}else {
				//return super.checkAndSetLabel();
			//}
		//}
		
	}

}