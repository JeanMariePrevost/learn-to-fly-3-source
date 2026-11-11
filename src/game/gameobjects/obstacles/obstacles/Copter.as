package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class Copter extends Obstacle 
	{
		
		public function Copter(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.CopterVisual();
				//visual.scaleX = visual.scaleY = 0.4;
				var shapeCoords:Array = getShapeCoords("copter", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			
			_impulsePower = 10;
			
			//Base stats
			setMass(15);
			_life = 600;
		}
		
	}

}