package src.game.gameobjects.obstacles.obstacles {
	import flash.display.MovieClip;
	import nape.shape.ShapeList;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class RCPlane extends Obstacle 
	{
		
		public function RCPlane(visual:MovieClip=null, shapeCoords:Array = null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.RCPlaneVisual();
				visual.scaleX = visual.scaleY = 0.3;
				var shapeCoords:Array = getShapeCoords("rcPlane", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
		
			//Base stats
			setMass(3);
			_life = 40;
			
			_impulsePower = 12;
			_targetRotation = -20 + Math.random() * 40;
		}
		
	}

}