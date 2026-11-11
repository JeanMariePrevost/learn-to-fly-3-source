package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class NewsCopter extends Obstacle 
	{
		
		public function NewsCopter(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.NewsCopterVisual();
				//visual.scaleX = visual.scaleY = 0.4;
				var shapeCoords:Array = getShapeCoords("newsCopter", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			
			//Base stats
			setMass(15);
			_life = 500;
			
			_impulsePower = 8;
		}
		
	}

}