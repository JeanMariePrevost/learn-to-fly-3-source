package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	
	/**
	 * ...
	 * @author 
	 */
	public class Comet2 extends Comet 
	{
		
		public function Comet2(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.Comet2Visual();
				visual.scaleX = visual.scaleY = NumberUtils.randomRange(0.5, 5);
				var shapeCoords:Array = getShapeCoords("comet2", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			//Base stats
			_life = 2000;
		}
		
	}

}