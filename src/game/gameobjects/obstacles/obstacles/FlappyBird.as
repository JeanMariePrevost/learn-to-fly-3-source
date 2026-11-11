package src.game.gameobjects.obstacles.obstacles {
	import flash.display.MovieClip;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import nape.shape.ShapeList;
	import src.game.gameobjects.ShapesData;
	import src.game.gameobjects.obstacles.Obstacle;
	/**
	 * ...
	 * @author 
	 */
	public class FlappyBird extends Obstacle 
	{
		protected var _waitMin:Number = 10;
		protected var _waitMax:Number = 30;
		
		protected var _angleTime:Number = 0;
		protected var _angleDuration:Number = 50;
		protected var _startAngle:Number = -70;
		protected var _endAngle:Number = 50;
		protected var _waitTime:Number = 0;
		protected var _impulseMax:Number = 25;
		protected var _impulseMin:Number = 19;
		
		
		public function FlappyBird(visual:MovieClip = null, shapeCoords:Array = null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.FlappyBirdVisual();
				visual.scaleX = visual.scaleY = 0.5;
				var shapeCoords:Array = getShapeCoords("flappyBird", visual.scaleX);
				super(visual, shapeCoords);
			}
			
			//Base stats
			setMass(5);
			_life = 200;
			
			_impulsePower = 15;
			_drag = 0.93;
			
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (_angleTime >= _angleDuration) {
				if (_waitTime <= 0) {
					//Reset
					_angleTime = 0;
					_body.rotation = _startAngle;
					_rotationCorrection = ROTATION_CORRECTION_AT_COLLISION;
					_waitTime = NumberUtils.randomRange(_waitMin, _waitMax);
				}else {
					_waitTime -= delta;
				}
			}else {
				_angleTime += delta;
				_angleTime = Math.min(_angleTime, _angleDuration);
			}
			
			rotation = Trig.toRadians(Easing.easeLinear(_angleTime, _startAngle, _endAngle - _startAngle, _angleDuration));
			if (_movieClip.scaleX < 0) rotation *= -1;
			_impulsePower = Easing.easeOutQuad(_angleTime, _impulseMax, _impulseMin - _waitMax, _angleDuration);
		}
		
	}

}