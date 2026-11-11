package src.gui 
{
	/**
	 * ...
	 * @author 
	 */
	public class QuestionBox5 extends QuestionBox 
	{
		
		public function QuestionBox5(title:String, message:String, yesFunction:Function=null, noFunction:Function=null, closingFunction:Function=null) 
		{
			super(title, message, yesFunction, noFunction, closingFunction);
			
			decoNo.scaleMod = 0.06;
			decoYes.scaleMod = 0.06;
			
		}
		
	}

}