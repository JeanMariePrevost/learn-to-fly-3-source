package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class Zeppelin extends Obstacle 
	{
		
		public function Zeppelin(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.ZeppelinVisual();
				visual.scaleX = visual.scaleY = 1.8;
				var shapeCoords:Array = getShapeCoords("zeppelin", visual.scaleX);
				if (Math.random() >= 0.75) {
					visual.gotoAndStop(2);
				}else {
					visual.gotoAndStop(1);
				}
			}
			
			super(visual, shapeCoords);
			
			//Base stats
			_life = 1500;
			setMass(155);
			
			_impulsePower = 3;			
			
			if (_movieClip.scaleX < 0) {
				if (visual.currentFrame >= 2) {
					_movieClip.scaleX = Math.abs(_movieClip.scaleX);
				}else {
					var txt:MovieClip = (_movieClip.txt as MovieClip);
					if(txt) txt.scaleX = -1;
				}
			}
			
		}
		
	}

}