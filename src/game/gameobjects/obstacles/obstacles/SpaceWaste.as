package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	
	/**
	 * ...
	 * @author 
	 */
	public class SpaceWaste extends Comet 
	{
		
		public function SpaceWaste(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.SpaceWasteVisual();
				visual.scaleX = visual.scaleY = NumberUtils.randomRange(0.6, 1.5);
				var shapeCoords:Array = getShapeCoords("spaceWaste", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			//Base stats
			setMass(20 * Math.abs(_movieClip.scaleX));
			_life = 2000;
		}
		
	}

}