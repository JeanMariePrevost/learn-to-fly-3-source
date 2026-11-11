package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import src.game.particles.AbstractParticle;
	import src.game.particles.Particles;
	
	/**
	 * ...
	 * @author 
	 */
	public class JetpackBaby extends Drone 
	{
		
		protected var _smokeTime:Number = 0;
		protected var _smokeDuration:Number = 3;
		
		public function JetpackBaby(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.JetpackBabyVisual();
				//visual.scaleX = visual.scaleY = 0.4;
				var shapeCoords:Array = getShapeCoords("jetpackBaby", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			//Base stats
			setMass(10);
			_life = 250;
			
			_impulsePower = 12;
			_targetRotation = -30 + Math.random() * 60;
			
			_swingAmount = 25 + Math.random() * 30;
			//_swingCounter = 0;
			_swingCounterMax = 30 + Math.random() * 60;
			//_swingingUp = true;
			
			_minAngle = _targetRotation - _swingAmount;
			_maxAngle = _targetRotation + _swingAmount;
			
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (_smokeTime >= _smokeDuration) {
				_smokeTime = 0;
				var angle:Number = (_movieClip.scaleX > 0) ? 180 + _movieClip.rotation:_movieClip.rotation;
				var p:AbstractParticle = Particles.builder.smokeGrey(0, 0, 0.6, 0.7, 4 + Math.random() * 2, angle, _movieClip);
				p.particleLife = 1;
			}else {
				_smokeTime += 1;
			}
		}
		
	}

}