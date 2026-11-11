package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import lbg.utils.Trig;
	import src.effects.LineTrail;
	import src.game.GameCamera;
	import src.game.gameobjects.obstacles.Obstacle;
	import src.game.particles.AbstractParticle;
	import src.game.particles.Particles;
	import src.system.Global;
	
	/**
	 * ...
	 * @author 
	 */
	public class titanFall extends Obstacle 
	{
		protected var _targetBehind:MovieClip;
		protected var _trail:LineTrail;
		
		protected var _smokeTime:Number = 0;
		protected var _smokeDuration:Number = 3;
		
		
		public function titanFall(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.TitanFallVisual();
				visual.scaleX = visual.scaleY = 1.4;
				var shapeCoords:Array = getShapeCoords("titanFall", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			//Base stats
			setMass(900);
			_life = 1500;
			
			_impulsePower = 40;
			
			_targetBehind = (_movieClip.tBehind as MovieClip);
			
			_movieClip.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		override protected function applyFlipChance(visual:MovieClip, shapeCoords:Array):void 
		{
			//Doesn't flip
		}
		
		private function added(e:Event):void 
		{
			_movieClip.removeEventListener(Event.ADDED_TO_STAGE, added);
			
			_trail = LineTrail.newLineTrail();
			_trail.color = 0xFF6600;
			_trail.baseAlpha = 1;
			_trail.fadeInPower = 0.5;
			_trail.fadeFromLength = 1;
			_trail.maxSegments = 40;
			_trail.lineWidth = 65;
			GameCamera.instance.addChildToMovingLayerRelativeTo(_trail.visual, _movieClip, -1);
			
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (_targetBehind) {
				var pos:Point = GameCamera.getPositionOnCamera(_targetBehind);
				_trail.addSegment(pos.x, pos.y);
				_trail.fadeLine();
				_trail.update();
				
				if (_smokeTime >= _smokeDuration) {
					_smokeTime = 0;
					var angle:Number = _movieClip.rotation + 90;
					var p:AbstractParticle = Particles.builder.smokeBlack(- 30 + Math.random() * 60, 0, 2, 3, 5 + Math.random() * 8, angle - 30 + Math.random() * 60, _targetBehind);
					p.particleLife = 10;
					p.particleFadeLife = 100;
					p.drag = 0.03;
				}else {
					_smokeTime += 1;
				}
			}
		}
		
		
		override protected function applyObstacleForce(delta:Number):void 
		{
			var angle:Number = Trig.toDegrees(_body.rotation);
			var power:Number = _impulsePower * Global.powerPerMassUnit * _body.mass;
			
			//Move downwards instead of right
			angle += 90;
			
			var vx:Number = Trig.vectorX(power, angle);
			var vy:Number = Trig.vectorY(power, angle);
			applyForce(vx, vy);
		}
		
	}

}