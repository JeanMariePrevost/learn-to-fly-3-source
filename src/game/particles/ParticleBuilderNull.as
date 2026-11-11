package src.game.particles 
{
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author ...
	 */
	public class ParticleBuilderNull extends ParticleBuilder 
	{
		
		public function ParticleBuilderNull() 
		{
			super();
			
		}
		
		override public function addParticle(particle:AbstractParticle, x:Number, y:Number,minScale:Number = 0.8, maxScale:Number = 1.2, depthOffset:int = -1, reference:DisplayObjectContainer = null):void {
		}
		
		override public function addAngleForcedParticle(particle:AbstractParticle, x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, depthOffset:Number = -1, reference:DisplayObjectContainer = null):void {
		}
		
		override public function smokeWhite(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):AbstractParticle {
			return new NullParticle();
		}
		
		override public function smokeBlack(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):AbstractParticle {
			return new NullParticle();
		}
		
		override public function smokeGrey(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):AbstractParticle {
			return new NullParticle();
		}
		
		override public function smokeBalloon(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):AbstractParticle {
			return new NullParticle();
		}
		
		override public function blackSpot(x:Number = 0, y:Number = 0, minScale:Number = 1, maxScale:Number = 1, life:Number = 50, fadeLife:Number = 50, reference:DisplayObjectContainer = null):AbstractParticle {
			return new NullParticle();
		}
		
		override public function smokeWhiteQuick(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):AbstractParticle {
			return new NullParticle();
		}
		
		override public function jetPackSmoke(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):AbstractParticle {
			return new NullParticle();
		}
		
		override public function explosiveSmoke(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):AbstractParticle {
			return new NullParticle();
		}
		
		override public function screenFlash(baseAlpha:Number = 1, life:Number = 0, fadeLife:Number = 20):AbstractParticle {
			return new NullParticle();
		}
		
		//Not overriden because it cannot be replaced by a NullParticle
		//override public function snowDebris(x:Number = 0, y:Number = 0, debrisScale:Number = 1, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):SnowDebris {
			//return null;
		//}
	}

}