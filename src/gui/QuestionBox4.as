package src.gui 
{
	/**
	 * Online loading specific box with "retry" and "Start offline" buttons for yes/no
	 * @author 
	 */
	public class QuestionBox4 extends QuestionBox 
	{
		
		public function QuestionBox4(title:String, message:String, yesFunction:Function=null, noFunction:Function=null, closingFunction:Function=null) 
		{
			super(title, message, yesFunction, noFunction, closingFunction);
			
		}
		
		override protected function adjustSize():void 
		{
			//super.adjustSize();
		}
		
	}

}