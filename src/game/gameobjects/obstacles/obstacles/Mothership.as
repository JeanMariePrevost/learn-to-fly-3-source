package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class Mothership extends Obstacle 
	{
		
		public function Mothership(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.MothershipVisual();
				visual.scaleX = visual.scaleY = NumberUtils.randomRange(1.4, 1.8);
				var shapeCoords:Array = getShapeCoords("mothership", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			
			//Base stats
			setMass(1100 * Math.abs(_movieClip.scaleX));
			_life = 5000;
			
			_impulsePower = 0.8 + Math.random() * 0.9;
			_rotationCorrectionIncreasePerTick = 0.0001;
			_drag = 0.995;
			
			
			
			//Skip acceleration
			for (var i:int = 0; i <= 50; i++) {
				applyObstacleForce(1);
			}
			
			
		}
		
	}

}