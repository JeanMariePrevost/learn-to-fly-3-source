package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author 
	 */
	public class PotatoGlados extends SpaceCore 
	{
		
		public function PotatoGlados(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.PotatoGladosVisual();
				visual.scaleX = visual.scaleY = 0.7;
				var shapeCoords:Array = getShapeCoords("potatoGlados", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			//Base stats
			_life = 4000;
		}
		
	}

}