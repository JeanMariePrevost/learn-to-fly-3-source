package src.game.result 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ResultTop extends MovieClip 
	{
		public var txtLabel:TextField;
		
		public function ResultTop() 
		{
			super();
			
		}
		
		public function destroy():void {
			txtLabel = null;
			if (stage) parent.removeChild(this);
		}
		
	}

}