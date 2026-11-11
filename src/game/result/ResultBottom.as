package src.game.result 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author 
	 */
	public class ResultBottom extends MovieClip 
	{
		public var txtLabel:TextField;
		
		public function ResultBottom() 
		{
			super();
			
		}
		
		public function destroy():void {
			txtLabel = null;
			if (stage) parent.removeChild(this);
		}
		
	}

}