package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import lbg.utils.Easing;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class Drone extends Obstacle 
	{
		protected var _swingAmount:Number = 25;
		protected var _swingCounter:Number = 0;
		protected var _swingCounterMax:Number = 100;
		protected var _swingingUp:Boolean = true;
		
		protected var _maxAngle:Number;
		protected var _minAngle:Number;
		
		
		public function Drone(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.DroneVisual();
				visual.scaleX = visual.scaleY = 0.4;
				var shapeCoords:Array = getShapeCoords("drone", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			
			_impulsePower = 10;
			
			//Base stats
			setMass(10);
			_life = 150;
			
			_targetRotation = -10 + Math.random() * 20;
			
			_minAngle = _targetRotation - _swingAmount;
			_maxAngle = _targetRotation + _swingAmount;
			
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (_swingingUp) {
				_swingCounter += delta;
				if (_swingCounter >= _swingCounterMax) {
					_swingCounter = _swingCounterMax;
					_swingingUp = false;
				}
			}else {
				_swingCounter -= delta;
				if (_swingCounter <= 0) {
					_swingCounter = 0;
					_swingingUp = true;
				}
			}
			
			_targetRotation = Easing.easeBothInOutQuad(_swingCounter, _minAngle, _maxAngle - _minAngle, _swingCounterMax);
			//trace(_swingCounter, _targetRotation);
			//rotation = _targetRotation;
		}
		
	}

}