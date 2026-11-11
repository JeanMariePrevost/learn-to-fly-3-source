package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class StudentDriver extends Obstacle 
	{
		
		public function StudentDriver(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.StudentDriverVisual();
				visual.scaleX = visual.scaleY = 1.4;
				var shapeCoords:Array = getShapeCoords("studentDriver", visual.scaleX);
			}
			super(visual, shapeCoords);
			
			//Base stats
			setMass(12);
			_life = 120;
			
			_impulsePower = 11;
			
			_targetRotation = -15 + Math.random() * 30;
			
		}
		
	}

}