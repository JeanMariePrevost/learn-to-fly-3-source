package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class BigHotAirBalloon extends Obstacle 
	{
		protected var _time:Number = 0;
		
		protected var _minBurnTime:Number = 50;
		protected var _maxBurnTime:Number = 220;
		protected var _minWaitTime:Number = 50;
		protected var _maxWaitTime:Number = 350;
		
		protected var _burning:Boolean = true;
		
		protected var _burnGravMass:Number = -50;
		protected var _waitGravMass:Number = 35;
		protected var _massChangeSpeed:Number = 1;
		
		public function BigHotAirBalloon(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.BigHotAirBalloonVisual();
				visual.scaleX = visual.scaleY = 0.7;
				var shapeCoords:Array = getShapeCoords("bigHotAirBalloon", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			_impulsePower = 1;
			
			//Base stats
			setMass(45);
			_life = 800;
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			_time -= delta;
			
			if (_burning) {
				_body.gravMass = Math.max(_burnGravMass, _body.gravMass - _massChangeSpeed);
				
				if (_time <= 0) {
					endBurn();
					_time = NumberUtils.randomRange(_minWaitTime, _maxWaitTime);
				}
			}else {
				_body.gravMass = Math.min(_waitGravMass, _body.gravMass + _massChangeSpeed);
				
				if (_time <= 0) {
					startBurn();
					_time = NumberUtils.randomRange(_minBurnTime, _maxBurnTime);
				}
			}
		}
		
		protected function startBurn():void {
			_burning = true;
			_movieClip.gotoAndStop(2);
			//_body.gravMass = _burnGravMass;
		}
		
		protected function endBurn():void {
			_burning = false;
			_movieClip.gotoAndStop(1);
			//_body.gravMass = _waitGravMass;
		}
		
	}

}