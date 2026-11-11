package src.game.gameobjects.obstacles.obstacles {
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author 
	 */
	public class Albatross extends Seagull 
	{
		
		public function Albatross(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.AlbatrossVisual();
				visual.scaleX = visual.scaleY = 1.5;
				var shapeCoords:Array = getShapeCoords("albatross", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			//Base stats
			setMass(20);
			_life = 140;
		}
		
	}

}