package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class MilitaryCopter extends Obstacle 
	{
		
		public function MilitaryCopter(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.MilitaryCopterVisual();
				//visual.scaleX = visual.scaleY = 0.4;
				var shapeCoords:Array = getShapeCoords("militaryCopter", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			_impulsePower = 4;
			
			//Base stats
			setMass(35);
			_life = 1500;
			
		}
		
	}

}