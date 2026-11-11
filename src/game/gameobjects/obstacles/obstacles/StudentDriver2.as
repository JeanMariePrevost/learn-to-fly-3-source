package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author 
	 */
	public class StudentDriver2 extends StudentDriver 
	{
		
		public function StudentDriver2(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.StudentDriver2Visual();
				visual.scaleX = visual.scaleY = 1.2;
				var shapeCoords:Array = getShapeCoords("studentDriver2", visual.scaleX);
			}
			super(visual, shapeCoords);
			
			_targetRotation = -30 + Math.random() * 25;
			
			if (_movieClip.scaleX < 0) {
				_targetRotation *= -1;
			}
			
			//Base stats
			_life = 150;
		}
		
	}

}