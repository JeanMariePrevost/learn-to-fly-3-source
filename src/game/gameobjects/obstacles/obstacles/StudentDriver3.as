package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author 
	 */
	public class StudentDriver3 extends StudentDriver 
	{
		
		public function StudentDriver3(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.StudentDriver3Visual();
				visual.scaleX = visual.scaleY = 1.3;
				var shapeCoords:Array = getShapeCoords("studentDriver3", visual.scaleX);
			}
			super(visual, shapeCoords);
			
			//Base stats
			_life = 90;
		}
		
	}

}