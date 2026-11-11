package src.game.gameobjects.obstacles.obstacles {
	import flash.display.MovieClip;
	import nape.shape.ShapeList;
	
	/**
	 * ...
	 * @author 
	 */
	public class Kite extends PaperPlane 
	{
		
		public function Kite(visual:MovieClip = null, shapeCoords:Array = null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.KiteVisual();
				var shapeCoords:Array = getShapeCoords("kite", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			//_baseRotation = 10 + Math.random() * 20;
			//_dropRotation = _baseRotation + 60;
			_rotationCounterMax = 200 + Math.random() * 200;
			_rotationCounter = _rotationCounterMax;
		
			//Base stats
			setMass(0.6);
			_life = 25;
			
			_impulsePower = 5;
			_drag = 0.98;
			
			_rotationCorrectionIncreasePerTick = 0;
			
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			_body.angularVel *= 0.9;
		}
		
	}

}