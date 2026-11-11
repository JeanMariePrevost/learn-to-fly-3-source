package src.gui.progress 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author 
	 */
	public class AbstractMainScreen extends MovieClip 
	{
		
		public function AbstractMainScreen() 
		{
			super();
			
		}
		
		public function destroy():void {
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}