package src.game.particles 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import src.Main;
	import src.audio.Audio;
	import src.audio.Sfx;
	import src.compound.TimedMod;
	import src.compound.TimedModInOut;
	import src.game.GameCamera;
	import src.game.StatHooks;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author 
	 */
	internal class ParticleBuilder 
	{
		public function ParticleBuilder() {
			
		}
		
		public function addParticle(particle:AbstractParticle, x:Number, y:Number,minScale:Number = 0.8, maxScale:Number = 1.2, depthOffset:int = -1, reference:DisplayObjectContainer = null):void {
			if (particle == null) {
				Log.log("addParticle error - particle is null");
				return;
			}
			
			GameCamera.instance.addChildToMovingLayer(particle, depthOffset);
			
			//Scale
			particle.scaleX = particle.scaleY = NumberUtils.interpolate(minScale, maxScale, Math.random());
			
			
			var pos:Point = new Point(x, y);
			
			if (reference) {
				pos = DisplayObjectUtil.localToLocal(pos, reference, GameCamera.instance.getMovingLayer(depthOffset));
			}
			
			particle.x = pos.x;
			particle.y = pos.y;
		}
		
		public function addAngleForcedParticle(particle:AbstractParticle, x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, depthOffset:Number = -1, reference:DisplayObjectContainer = null):void {
			if (force != 0) {
				particle.vx += Trig.vectorX(force, forceAngle);
				particle.vy += Trig.vectorY(force, forceAngle);
			}
			
			addParticle(particle, x, y, minScale, maxScale, depthOffset, reference);
		}
		
		public function smokeWhite(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):AbstractParticle {
			var p:AbstractParticle = new SmokeWhite();
			p.rotation = Math.random() * 360;
			
			addAngleForcedParticle(p, x, y, minScale, maxScale, force, forceAngle, -1, reference);
			return p;
		}
		
		public function smokeBlack(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):AbstractParticle {
			var p:AbstractParticle = new SmokeBlack();
			p.rotation = Math.random() * 360;
			
			addAngleForcedParticle(p, x, y, minScale, maxScale, force, forceAngle, -1, reference);
			return p;
		}
		
		public function smokeGrey(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):AbstractParticle {
			var p:AbstractParticle = new SmokeGrey();
			p.rotation = Math.random() * 360;
			
			addAngleForcedParticle(p, x, y, minScale, maxScale, force, forceAngle, -1, reference);
			return p;
		}
		
		public function smokeBalloon(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):AbstractParticle {
			var p:AbstractParticle = new SmokeWhite(8, 30);
			p.rotation = Math.random() * 360;
			p.vScale = 0.03;
			p.baseAlpha = 0.3;
			
			addAngleForcedParticle(p, x, y, minScale, maxScale, force, forceAngle, -1, reference);
			return p;
		}
		
		public function blackSpot(x:Number = 0, y:Number = 0, minScale:Number = 1, maxScale:Number = 1, life:Number = 50, fadeLife:Number = 50, reference:DisplayObjectContainer = null):AbstractParticle {
			var p:AbstractParticle = new BlackSpot();
			p.particleLife = life;
			p.particleFadeLife = fadeLife;
			
			addAngleForcedParticle(p, x, y, minScale, maxScale, 0, 0, -1, reference);
			return p;
		}
		
		public function smokeWhiteQuick(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):AbstractParticle {
			var p:AbstractParticle = new SmokeWhite(8, 33);
			p.vScale = 0.08;
			p.rotation = Math.random() * 360;
			
			addAngleForcedParticle(p, x, y, minScale, maxScale, force, forceAngle, -1, reference);
			return p;
		}
		
		public function impactSmoke(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null, impactStrength:Number = 0):AbstractParticle {
			if (ProfileState.instance.cheatMichaelBay) {
				var rand:Number = Math.random();
				
				if (rand <= 0.333) {
					var p:AbstractParticle = new CheatExplosion();
				}else if (rand <= 0.666) {
					var p:AbstractParticle = new CheatExplosion2();
				}else {
					var p:AbstractParticle = new CheatExplosion3();
				}
				
				if (rand <= 0.18) {
					Sfx.playExplosion1();
				}else if (rand <= 0.36) {
					Sfx.playExplosion2();
				}else if (rand <= 0.54) {
					Sfx.playExplosion3();
				}else if (rand <= 0.72) {
					Sfx.playExplosion4();
				}else if (rand <= 0.90) {
					Sfx.playExplosion5();
				}else {
					Sfx.playExplosion6();
				}
				
				//trace("impactStrength", impactStrength);
				var scaleMod:Number = NumberUtils.interpolate2(0.2, 3, 1, 50, impactStrength, 0.9);
				var timeWarpMult:Number = NumberUtils.interpolate2(0.9, 0.7, 0.2, 3, scaleMod, 0.8)
				var timeWarpDuration:Number = NumberUtils.interpolate2(20, 40, 0.2, 3, scaleMod, 0.8);
				var timeWarp:TimedModInOut = new TimedModInOut(0, 0, 1, timeWarpMult, timeWarpDuration, 0.25, Main.gameEngineTickSignal);
				timeWarp.fadePower = 0.5;
				timeWarp.fadePowerAfterMid = 2;
				StatHooks.deltaTimeMult.addMod(timeWarp);
				
				p.vScale = 0.045 * scaleMod;
				p.rotation = Math.random() * 360;
				p.drag = 0.02;
				
				addAngleForcedParticle(p, x, y, minScale * scaleMod, maxScale * scaleMod, force * 0.98, forceAngle, 3, reference);
				return p;
			}else {
				var p:AbstractParticle = new SmokeGrey(8, 33);
				p.vScale = 0.015;
				p.rotation = Math.random() * 360;
				
				addAngleForcedParticle(p, x, y, minScale, maxScale, force, forceAngle, 3, reference);
				return p;
			}
		}
		
		public function jetPackSmoke(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):AbstractParticle {
			var p:AbstractParticle = new SmokeGrey(8, 33);
			p.vScale = 0.06;
			p.rotation = Math.random() * 360;
			
			addAngleForcedParticle(p, x, y, minScale, maxScale, force, forceAngle, -1, reference);
			return p;
		}
		
		public function explosiveSmoke(x:Number = 0, y:Number = 0, minScale:Number = 0.8, maxScale:Number = 1.2, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):AbstractParticle {
			var p:AbstractParticle = new ExplosiveSmoke(8, 33);
			p.vScale = 0.5;
			p.rotation = Math.random() * 360;
			
			addAngleForcedParticle(p, x, y, minScale, maxScale, force, forceAngle, -1, reference);
			return p;
		}
		
		public function screenFlash(baseAlpha:Number = 1, life:Number = 0, fadeLife:Number = 20):AbstractParticle {
			var p:AbstractParticle = new ScreenFlash();
			p.baseAlpha = baseAlpha;
			p.particleLife = life;
			p.particleFadeLife = fadeLife;
			
			GameCamera.instance.addChildToFixedLayer(p, 3);
			return p;
		}
		
		/** SnowDebris use GameObjects to emulate physics */
		public function snowDebris(x:Number = 0, y:Number = 0, debrisScale:Number = 1, force:Number = 0, forceAngle:Number = 0, reference:DisplayObjectContainer = null):SnowDebris {
			var p:SnowDebris = new SnowDebris(debrisScale);
			
			var pos:Point = new Point(x, y);
			
			if (reference) {
				pos = DisplayObjectUtil.localToLocal(pos, reference, GameCamera.instance.getMovingLayer(0));
			}
			
			p.gameObject.setPosition(pos.x, pos.y);
			p.gameObject.applyAngleForce(force, forceAngle);
			return p;
		}
		
		
		
	}

}