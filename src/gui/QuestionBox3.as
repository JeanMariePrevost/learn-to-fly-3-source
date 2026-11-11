package src.gui 
{
	import flash.display.DisplayObject;
	/**
	 * Hold to confirm yes button
	 * @author 
	 */
	public class QuestionBox3 extends QuestionBox 
	{
		
		public function QuestionBox3(title:String, message:String, yesFunction:Function=null, noFunction:Function=null, closingFunction:Function=null) 
		{
			super(title, message, yesFunction, noFunction, closingFunction);
			
			(btnYes as HoldToConfirmButton).framesToFill = 130;
			
		}
		
		override protected function clickYes(target:DisplayObject):void 
		{
			if(btnYes.currentFrame>=btnYes.totalFrames) super.clickYes(target);
		}
		
	}

}