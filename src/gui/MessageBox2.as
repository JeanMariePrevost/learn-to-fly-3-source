package src.gui 
{
	/**
	 * Same as regular MessageBox, but the button displays "Cancel" tather than "Ok"
	 * @author 
	 */
	public class MessageBox2 extends MessageBox 
	{
		
		public function MessageBox2(title:String, message:String, okFunction:Function=null, closingFunction:Function=null, tweenDuration:Number=20) 
		{
			super(title, message, okFunction, closingFunction, tweenDuration);
			
		}
		
	}

}