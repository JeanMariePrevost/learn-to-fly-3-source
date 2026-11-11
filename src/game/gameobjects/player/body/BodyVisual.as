package src.game.gameobjects.player.body 
{
	import flash.display.MovieClip;
	import src.Penguin;
	/**
	 * ...
	 * @author 
	 */
	public class BodyVisual extends MovieClip
	{
		public var penguin:Penguin;
		public var tTop:MovieClip;
		public var tCenter:MovieClip;
		public var tBottom:MovieClip;
		public var tLeft1:MovieClip;
		public var tLeft2:MovieClip;
		public var tLeft3:MovieClip;
		public var tLeft4:MovieClip;
		
		public var tOffTop:MovieClip;
		public var tOffCenter:MovieClip;
		public var tOffBottom:MovieClip;
		//public var tLeft:MovieClip;
		//public var tRight:MovieClip;
		
		public function BodyVisual() 
		{
			
		}
		
		/* INTERFACE src.game.gameobjects.player.body.IAnchoredBody */
		
		public function tick(delta:Number):void 
		{
			
		}
		
	}

}