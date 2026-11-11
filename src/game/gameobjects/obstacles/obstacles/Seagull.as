package src.game.gameobjects.obstacles.obstacles {
	import flash.display.MovieClip;
	import nape.shape.ShapeList;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class Seagull extends Obstacle 
	{
		
		public function Seagull(visual:MovieClip = null, shapeCoords:Array = null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.SeagullVisual();
				visual.scaleX = visual.scaleY = 1.8;
				var shapeCoords:Array = getShapeCoords("seagull", visual.scaleX);
			}
			super(visual, shapeCoords);
			
			//Base stats
			setMass(2);
			_life = 40;
			
			_impulsePower = 6;
			
			_rotationCorrectionIncreasePerTick = 0.0025;
			
		}
		
	}

}