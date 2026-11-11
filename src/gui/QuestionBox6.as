package src.gui 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author 
	 */
	public class QuestionBox6 extends QuestionBox 
	{
		
		public function QuestionBox6(title:String, message:String, yesFunction:Function=null, noFunction:Function=null, closingFunction:Function=null) 
		{
			super(title, message, yesFunction, noFunction, closingFunction);
			
			(btnYes as HoldToConfirmButton2).framesToFill = 130;
			
			decoYes.scaleMod = 0.06;
			decoNo.scaleMod = 0.06;
			
		}
		
		
		override protected function clickYes(target:DisplayObject):void 
		{
			if(btnYes.currentFrame>=btnYes.totalFrames) super.clickYes(target);
		}
		
		
		
	}

}