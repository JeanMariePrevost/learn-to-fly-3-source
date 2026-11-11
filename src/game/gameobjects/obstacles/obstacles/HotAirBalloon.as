package src.game.gameobjects.obstacles.obstacles {
	import flash.display.MovieClip;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class HotAirBalloon extends Obstacle 
	{
		
		public function HotAirBalloon(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.HotAirBalloonVisual();
				visual.scaleX = visual.scaleY = 1.2;
				var shapeCoords:Array = getShapeCoords("hotAirBalloon", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			//Base stats
			setMass(35);
			_life = 300;
			
			_impulsePower = Math.random() * 2;
			
		}
		
	}

}