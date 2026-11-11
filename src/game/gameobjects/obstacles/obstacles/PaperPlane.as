package src.game.gameobjects.obstacles.obstacles {
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import nape.shape.ShapeList;
	import src.game.gameobjects.ShapesData;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class PaperPlane extends Obstacle 
	{
		protected var _baseRotation:Number = -10 + Math.random() * 20;
		protected var _dropRotation:Number = _baseRotation + 60;
		protected var _rotationCounterMax:Number = 100 + Math.random() * 150;
		protected var _rotationCounter:Number = _rotationCounterMax;
		protected var _straightTime:Number = 10 + Math.random() * 70;
		
		public function PaperPlane(visual:MovieClip = null, shapeCoords:Array = null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.PaperPlaneVisual();
				var shapeCoords:Array = getShapeCoords("paperPlane");
			}
			
			super(visual, shapeCoords);
			
			if (_movieClip.scaleX < 0) {
				_dropRotation *= -1;
			}
			
			
			//Base stats
			_life = 15;
			setMass(0.2);
			_impulsePower = 12;
			
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			
			if (_straightTime >= 0) {
				_straightTime -=  delta;
			}else {
				_rotationCounter -= delta;
			}
			
			_targetRotation = NumberUtils.interpolate2(_baseRotation, _dropRotation, _rotationCounterMax, 0, _rotationCounter, 1.6, true);
		}
		
	}

}