package src.shop 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author 
	 */
	public class ComputerOverlay extends MovieClip 
	{
		public var gradient:MovieClip;
		public var baby1:MovieClip;
		public var baby2:MovieClip;
		
		
		public function ComputerOverlay() 
		{
			gradient.mouseEnabled = false;
			baby1.mouseEnabled = false;
			baby2.mouseEnabled = false;
			baby1.mouseChildren = false;
			baby2.mouseChildren = false;
			mouseEnabled = false;
			//mouseChildren = false;
		}
		
		public function destroy():void {
			gradient = null;
			baby1 = null;
			baby2 = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (stage) parent.removeChild(this);
		}
		
	}

}