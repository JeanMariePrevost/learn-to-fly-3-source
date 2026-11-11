package src.game.gameobjects.player.body 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 
	 */
	public class EjectorVisual extends BodyVisual 
	{
		public var seat:MovieClip;
		
		public function EjectorVisual() 
		{
			super();
			
			seat.gotoAndStop(1);
		}
		
	}

}