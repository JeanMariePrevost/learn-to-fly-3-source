package src.gui 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import src.audio.Sfx;
	import src.system.GameState;
	/**
	 * ...
	 * @author 
	 */
	public class DeleteSaveDialog extends QuestionBox 
	{
		public var saveSlot:LoadGameMenuSlot;
		
		public function DeleteSaveDialog(title:String, message:String, gameState:GameState, yesFunction:Function=null, noFunction:Function=null, closingFunction:Function=null) 
		{
			super(title, message, yesFunction, noFunction, closingFunction);
			
			(btnYes as HoldToConfirmButton).framesToFill = 40;
			
			//saveSlot.enable = false;
			saveSlot.updateFromState(gameState);
			saveSlot.bounce.destroy();
			
		}
		
		override protected function clickYes(target:DisplayObject):void 
		{
			if (btnYes.currentFrame >= btnYes.totalFrames) {
				Sfx.playMediumClick();
				if (yesFunction != null) yesFunction(saveSlot.state);
				closeMenu();
			}
		}
		
		
		override public function destroy():void 
		{
			if (saveSlot) saveSlot.destroy();
			saveSlot = null;
			
			super.destroy();
		}
		
	}

}