package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class BananaPlane extends Drone 
	{
		
		public function BananaPlane(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.BananaPlaneVisual();
				//visual.scaleX = visual.scaleY = 0.7;
				var shapeCoords:Array = getShapeCoords("bananaPlane", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			_swingAmount = 25;
			//_swingCounter = 0;
			_swingCounterMax = 100;
			//_swingingUp = true;
		
			_impulsePower = 7;
			
			//Base stats
			setMass(45);
			_life = 450;
			
			_targetRotation = 0;
			
			_minAngle = _targetRotation - _swingAmount;
			_maxAngle = _targetRotation + _swingAmount;
			
			
		}
		
	}

}