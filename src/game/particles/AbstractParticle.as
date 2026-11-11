package src.game.particles 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import src.game.GameCamera;
	import src.game.GameEngine;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class AbstractParticle extends MovieClip 
	{
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var vr:Number = 0;
		public var vScale:Number = 0;
		public var drag:Number = 0;
		
		protected var _baseAlpha:Number = 1;
		
		protected var _particleLife:Number = 100;
		protected var _particleFadeLife:Number = 50;
		
		protected var _particleLifeMax:Number = _particleLife;
		protected var _particleFadeLifeMax:Number = _particleFadeLife;
		
		protected var _hasFlippedFromGround:Boolean = false;//If ground collision has happened
		
		public function AbstractParticle() 
		{
			Main.unsafeTickSignal.add(tick);
		}
		
		protected function tick(delta:Number):void {
			x += vx * delta;
			y += vy * delta;
			rotation += vr * delta;
			
			scaleX = scaleY = scaleX + vScale;
			
			vx *= 1 - (drag * delta);
			vy *= 1 - (drag * delta);
			vr *= 1 - (drag * delta);
			//vScale *= 1 - (drag * delta);
			
			//Collision with ground
			if (GameEngine.instance == null || GameEngine.instance.ground == null) {
				destroy();
				return;
			}else {
				if (_hasFlippedFromGround == false && y >= GameEngine.instance.ground.groundLevel) {
					_hasFlippedFromGround = true;
					
					if (vx <= 0.15 && vx >= -0.15) {
						//Nearly straight down trajectory, randomize it for better visual effect and not smoke going ONLY one way
						vx = NumberUtils.randomRange( -0.15, 0.15);
					}
					
					if (vx >= 0) {
						vx += Math.abs(vy) * 0.85;
					}else {
						vx -= Math.abs(vy) * 0.85;
					}
					
					vy *= NumberUtils.randomRange(-0.05, 0.05);
				}
			}
			
			if (_particleLife > 0) {
				//alive
				_particleLife -= delta;
				alpha = _baseAlpha;
			}else if (_particleFadeLife > 0) {
				//fading
				_particleFadeLife -= delta;
				doFade();
			}else {
				//dead
				destroy();
			}
		}
		
		protected function doFade():void {
			alpha = _baseAlpha * NumberUtils.constrain(_particleFadeLife / _particleFadeLifeMax);
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			while (numChildren >= 1) removeChildAt(0);
			if(stage) parent.removeChild(this);
		}
		
		public function get particleLife():Number 
		{
			return _particleLife;
		}
		
		public function set particleLife(value:Number):void 
		{
			_particleLife = value;
			_particleLifeMax = value;
		}
		
		public function get particleFadeLife():Number 
		{
			return _particleFadeLife;
		}
		
		public function set particleFadeLife(value:Number):void 
		{
			_particleFadeLife = value;
			_particleFadeLifeMax = value;
		}
		
		public function get baseAlpha():Number 
		{
			return _baseAlpha;
		}
		
		public function set baseAlpha(value:Number):void 
		{
			_baseAlpha = value;
			alpha = Math.min(alpha, _baseAlpha);
		}
	}

}