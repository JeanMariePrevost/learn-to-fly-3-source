package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class RescueCopter extends Obstacle 
	{
		
		public function RescueCopter(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.RescueCopterVisual();
				//visual.scaleX = visual.scaleY = 0.4;
				var shapeCoords:Array = getShapeCoords("rescueCopter", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			_impulsePower = 6;
			
			//Base stats
			setMass(20);
			_life = 600;
		}
		
	}

}