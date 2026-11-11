package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	
	/**
	 * ...
	 * @author 
	 */
	public class SpaceWaste2 extends SpaceWaste 
	{
		
		public function SpaceWaste2(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.SpaceWaste2Visual();
				visual.scaleX = visual.scaleY = NumberUtils.randomRange(1, 2);
				var shapeCoords:Array = getShapeCoords("spaceWaste2", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			//Base stats
			setMass(120 * Math.abs(_movieClip.scaleX));
			_life = 2000;
		}
		
	}

}