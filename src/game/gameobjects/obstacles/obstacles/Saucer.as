package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import src.game.gameobjects.obstacles.Obstacle;
	import src.system.Global;
	
	/**
	 * ...
	 * @author 
	 */
	public class Saucer extends Obstacle 
	{
		
		protected var _waveTime:Number = 0;
		protected var _waveDuration:Number = 30 + Math.random() * 30;
		protected var _wavePowerMult:Number = 0.8 + Math.random() * 0.2;
		
		protected var _waveFunction:Function = waveUp;
		
		public function Saucer(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if (visual == null) {
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.SpaceSaucerVisual();
				visual.scaleX = visual.scaleY = NumberUtils.randomRange(0.9, 2);
				var shapeCoords:Array = getShapeCoords("ufo", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			
			//Base stats
			setMass(40 * Math.abs(_movieClip.scaleX));
			_life = 500;
			
			_impulsePower = 11 + Math.random() * 6;
			_rotationCorrectionIncreasePerTick = 0.001;
			
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			_waveFunction(delta);
		}
		
		protected function waveUp(delta:Number):void {
			_waveTime += delta;
			_waveTime = Math.min(_waveTime, _waveDuration);
			
			applyWaveMovement(delta);
			
			if (_waveTime >= _waveDuration) {
				_waveFunction = waveDown;
			}
		}
		
		protected function waveDown(delta:Number):void {
			_waveTime -= delta;
			_waveTime = Math.max(_waveTime, 0);
			
			applyWaveMovement(delta);
			
			if (_waveTime <= 0) {
				_waveFunction = waveUp;
			}
		}
		
		protected function applyWaveMovement(delta:Number):void {
			var angle:Number = Trig.toDegrees(_body.rotation);
			
			var waveSmoothing:Number;
			
			if (_waveFunction == waveUp) {
				angle += 90;
				waveSmoothing = NumberUtils.interpolate2(0, 1, 0, _waveDuration, _waveTime, 1);
			}else {
				angle -= 90;
				waveSmoothing = NumberUtils.interpolate2(0, 1, _waveDuration, 0, _waveTime, 1);
			}
			
			if (_movieClip.scaleX < 0) {
				angle -= 180;
			}
			
			var power:Number = _impulsePower * Global.powerPerMassUnit * _body.mass * _wavePowerMult * waveSmoothing;
			
			var vx:Number = Trig.vectorX(power, angle);
			var vy:Number = Trig.vectorY(power, angle);
			applyForce(vx, vy);
		}
		
	}

}