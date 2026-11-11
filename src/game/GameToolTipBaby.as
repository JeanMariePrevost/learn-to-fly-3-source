package src.game 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameToolTipBaby extends MovieClip 
	{
		public var bubble:MovieClip;
		
		public function GameToolTipBaby() 
		{
			
		}
		
		public function destroy():void {
			while (numChildren > 0) removeChildAt(0);
			bubble = null;
			
			if (stage) parent.removeChild(this);
		}
		
	}

}