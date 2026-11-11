package src.gui 
{
	/**
	 * Same as QuestionBox, but the buttons read "OK", and "Cancel" instead of yes/no
	 * @author 
	 */
	public class QuestionBox2 extends QuestionBox 
	{
		
		public function QuestionBox2(title:String, message:String, yesFunction:Function=null, noFunction:Function=null, closingFunction:Function=null) 
		{
			super(title, message, yesFunction, noFunction, closingFunction);
			
		}
		
	}

}