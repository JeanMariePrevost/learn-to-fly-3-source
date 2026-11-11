package src.game.gameobjects.player.boost 
{
	import flash.display.MovieClip;
	import src.game.DeltaMovieClipWrapper;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MultiJumpMCWrapper extends DeltaMovieClipWrapper 
	{
		
		public function MultiJumpMCWrapper(movieClip:MovieClip, startAtFrame:Object=1) 
		{
			super(movieClip, startAtFrame);
			
		}
		
		override protected function customActionsHook():void 
		{
			super.customActionsHook();
			
			setAction("activeEnd", ACTION_STOP);
			setAction("initEnd", "offStart");
		}
		
		//FIX
		//override protected function checkAndSetLabel():Boolean 
		//{
			//switch(_movieClip.currentLabel) {
				//case "idle":
					////no animation
					//return false;
				//case "idleStart":
				//case "initStart":
				//case "onStart":
				//case "activeStart":
				//case "offStart":
				//case "deathStart":
				//case "specialStart":
					//return true;
				//case "idleEnd":
					//gotoLabel("idleStart");
					//return false;
				//case "activeEnd":
					////Has to be done manually, active lead to nothing
					//return false;
				//case "initEnd":
					//gotoLabel("offStart");//SPECIAL - init leads to off
					//return false;
				//case "onEnd":
					//gotoLabel("activeStart");
					//return false;
				//case "offEnd":
					//gotoLabel("idleStart");
					//return false;
				//case "deathEnd":
					////Death stops animation process
					////CLEARS REFERENCES
					//destroy();
					//return false;
				//case "specialEnd":
				//default:
					//return false;
			//}
		//}
		
		
		
	}

}