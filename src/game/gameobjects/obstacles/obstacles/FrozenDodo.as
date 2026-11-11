package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	
	/**
	 * ...
	 * @author 
	 */
	public class FrozenDodo extends Comet 
	{
		
		public function FrozenDodo(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.FrozenDodoVisual();
				visual.scaleX = visual.scaleY = NumberUtils.randomRange(0.9, 1.3);
				var shapeCoords:Array = getShapeCoords("frozenDodo", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			
			//Base stats
			setMass(50 * Math.abs(_movieClip.scaleX));
			_life = 1000;
		}
		
	}

}