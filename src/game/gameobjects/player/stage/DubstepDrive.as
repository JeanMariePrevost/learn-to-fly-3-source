package src.game.gameobjects.player.stage 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import lbg.utils.Tools;
	import src.audio.Audio;
	import src.audio.Music;
	import src.audio.MusicObject;
	import src.compound.CompoundNumber;
	import src.effects.smoketrail.SmokeTrail;
	import src.game.GameCamera;
	import src.game.gameobjects.player.Player;
	import src.game.particles.AbstractParticle;
	import src.game.particles.Particles;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class DubstepDrive extends SimpleStage 
	{
		protected var _ba:ByteArray = new ByteArray();
		protected var _trail:SmokeTrail;
		
		protected var _flashCooldown:Number = 0;
		protected var _flashCooldownLength:Number = 30;
		
		protected var _dubstep:MusicObject;
		protected var _soundMap:Array = new Array(0.19,0.19,0.42,0.42,0.42,0.36,0.36,0.36,0.31,0.31,0.35,0.35,0.35,0.33,0.33,0.33,0.04,0.04,0.13,0.13,0.13,0.2,0.2,0.2,0.13,0.13,0.13,0.05,0.05,0.05,0.01,0.01,0.01,0.02,0.02,0.54,0.54,0.54,0.32,0.32,0.32,0.24,0.24,0.24,0.24,0.24,0.24,0.14,0.14,0.15,0.15,0.15,0.09,0.09,0.46,0.46,0.46,0.22,0.22,0.22,0.22,0.12,0.12,0.05,0.05,0.05,0.24,0.24,0.24,0.06,0.06,0.06,0.16,0.16,0.16,0.22,0.22,0.1,0.1,0.1,0.11,0.11,0.07,0.07,0.07,0.07,0.52,0.52,0.37,0.37,0.37,0.17,0.17,0.09,0.09,0.09,0.54,0.54,0.54,0.54,0.32,0.32,0.24,0.24,0.24,0.37,0.37,0.37,0.14,0.14,0.14,0.09,0.09,0.09,0.15,0.15,0.19,0.19,0.19,0.31,0.31,0.31,0.37,0.37,0.37,0.49,0.49,0.86,0.86,0.86,1,1,0.65,0.65,0.65,0.65,0.78,0.78,0.78,1,1,0.91,0.91,0.81,0.81,0.81,0.81,0.49,0.49,0.49,0.83,0.83,0.83,0.74,0.74,0.8,0.8,0.8,0.96,0.96,0.96,0.83,0.83,0.83,0.72,0.72,0.7,0.7,0.7,0.76,0.76,0.76,0.8,0.8,0.56,0.56,0.56,0.56,0.55,0.55,0.77,0.77,0.77,0.43,0.43,0.43,0.7,0.7,0.7,0.82,0.82,0.39,0.39,0.39,0.64,0.64,0.64,0.52,0.52,0.52,0.45,0.45,0.45,0.41,0.41,0.47,0.47,0.47,0.4,0.4,0.4,0.8,0.8,0.67,0.67,0.67,0.67,0.83,0.83,0.53,0.53,0.53,0.76,0.76,0.76,0.69,0.69,0.69,0.8,0.8,1,1,1,0.59,0.59,0.59,0.7,0.7,0.7,0.26,0.26,0.26,0.59,0.59,0.49,0.49,0.49,0.37,0.37,0.37,0.76,0.76,0.76,0.53,0.53,0.53,0.86,0.86,0.71,0.71,0.71,0.99,0.99,0.99,0.67,0.67,0.67,0.75,0.75,0.75,0.77,0.77,0.99,0.99,0.99,0.55,0.55,0.55,0.39,0.39,0.39,0.76,0.76,0.7,0.7,0.7,0.54,0.54,0.71,0.71,0.71,0.71,0.95,0.95,0.95,0.71,0.71,0.74,0.74,0.55,0.55,0.55,0.55,1,1,1,0.57,0.57,0.57,0.85,0.85,0.78,0.78,0.78,0.84,0.84,0.84,0.8,0.8,0.8,0.72,0.72,0.85,0.85,0.85,0.61,0.61,0.61,0.79,0.79,0.83,0.83,0.83,0.83,0.71,0.71,0.62,0.62,0.62,0.62,0.62,0.62,0.58,0.58,0.58,0.35,0.35,0.35,0.51,0.51,0.64,0.64,0.64,0.95,0.95,0.95,0.44,0.44,0.44,0.55,0.55,0.61,0.61,0.61,0.41,0.41,0.41,0.46,0.46,0.46,0.75,0.75,0.75,0.71,0.71,0.93,0.93,0.93,0.42,0.42,0.42,0.8,0.8,0.8,0.36,0.36,0.79,0.79,0.79,0.47,0.47,0.47,0.4,0.4,0.4,0.78,0.78,0.78,0.69,0.69,0.83,0.83,0.83,0.86,0.86,0.86,0.48,0.48,0.48,0.55,0.55,0.55,0.45,0.45,0.85,0.85,0.85,0.72,0.72,0.72,0.32,0.32,0.32,0.66,0.66,1,1,1,0.89,0.89,0.89,0.8,0.8,0.8,0.77,0.77,0.77,0.95,0.95,0.73,0.73,0.73,0.81,0.81,0.81,0.37,0.37,0.73,0.73,0.73,0.73,0.58,0.58,0.3,0.3,0.3,0.86,0.86,0.86,0.59,0.59,0.59,0.81,0.81,0.81,0.8,0.8,1,1,1,0.81,0.81,0.81,0.8,0.8,0.8,0.78,0.78,0.52,0.52,0.52,0.94,0.94,0.94,0.92,0.92,0.92,0.76,0.76,0.76,0.38,0.38,0.51,0.51,0.51,0.51,0.51,0.51,0.68,0.68,0.68,0.91,0.91,0.91,0.61,0.61,0.31,0.31,0.45,0.45,0.45,1,1,1,1,0.3,0.3,0.4,0.4,0.4,0.51,0.51,0.51,0.49,0.49,0.49,0.35,0.35,0.35,0.4,0.4,0.83,0.83,0.83,0.44,0.44,0.44,0.74,0.74,0.74,0.49,0.49,0.49,0.82,0.82,0.7,0.7,0.7,0.27,0.27,0.27,0.91,0.91,0.91,0.85,0.85,0.55,0.55,0.55,0.89,0.89,0.89,0.54,0.54,0.68,0.68,0.68,0.68,0.74,0.74,0.88,0.88,0.88,0.75,0.75,0.75,0.56,0.56,0.56,0.65,0.65,0.54,0.54,0.54,0.88,0.88,0.88,0.44,0.44,0.44,0.72,0.72,0.72,0.61,0.61,0.45,0.45,0.45,0.36,0.36,0.36,0.44,0.44,0.44,0.77,0.77,0.77,0.57,0.57,0.54,0.54,0.54,0.67,0.67,0.67,0.79,0.79,0.79,0.68,0.68,0.6,0.6,0.6,0.51,0.51,0.51,0.86,0.86,0.86,0.69,0.69,1,1,1,0.76,0.76,0.76,0.76,0.76,0.76,0.42,0.42,0.42,0.65,0.65,0.65,0.72,0.72,0.59,0.59,0.59,0.87,0.87,0.87,0.83,0.83,0.83,0.57,0.57,0.57,0.7,0.7,0.65,0.65,0.65,0.89,0.89,0.89,0.72,0.72,0.72,0.52,0.52,0.66,0.66,0.66,0.95,0.95,0.95,0.75,0.75,0.75,0.36,0.36,0.36,0.56,0.56,0.46,0.46,0.46,0.55,0.55,0.55,0.68,0.68,0.68,0.58,0.58,0.58,0.71,0.71,0.72,0.72,0.72,0.85,0.85,0.85,0.76,0.76,0.76,0.76,0.76,0.87,0.87,0.87,0.71,0.71,0.71,0.69,0.69,0.69,0.76,0.76,0.76,0.47,0.47,0.72,0.72,0.72,0.84,0.84,0.84,0.63,0.63,0.63,0.86,0.86,1,1,1,0.67,0.67,0.67,0.66,0.66,0.66,0.67,0.67,0.67,0.77,0.77,0.61,0.61,0.61,0.68,0.68,0.68,0.87,0.87,0.87,0.72,0.72,0.72,0.87,0.87,0.27,0.27,0.27,0.36,0.36,0.36,0.35,0.35,0.35,0.64,0.64,0.64,0.49,0.49,0.57,0.57,0.57,0.58,0.58,0.58,0.87,0.87,0.87,0.88,0.88,0.88,0.88,0.88,0.41,0.41,0.41,0.9,0.9,0.9,0.78,0.78,0.78,0.56,0.56,0.37,0.37,0.37,0.01,0.01,0.01,0.01,0.01,0.01);
		protected var _powerFromMaxFuel:Number = 1;//Used to replace increased fuel with power
		
		public function DubstepDrive(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			maxFuel = _item.statFuel;
			fuel = maxFuel;
		}
		
		override protected function refreshMaxFuel(stageFuelMult:CompoundNumber):void {
			if (_item && stageFuelMult) {
				var fuelRatio:Number = fuel / maxFuel;
				_powerFromMaxFuel = NumberUtils.interpolate2(1, 2, 1, 3, fuelRatio, 1.5, true);
				
				maxFuel = _item.statFuel;
				fuel = maxFuel * fuelRatio;
			}
			
		}
		
		override public function startStage():void 
		{
			super.startStage();
			_visual.wave1.gotoAndStop(7);
			_visual.wave2.gotoAndStop(7);
			
			if (_trail == null) {
				_trail = SmokeTrail.newSmokeTrail();
				_trail.color = 0xFFFFAA;
				_trail.alpha = 1;
				_trail.fadeInLength = 5;
				_trail.fadeInAlpha = 0.5;
				_trail.fadeInPower = 0.7;
				_trail.fadeOutLegnth = 25;
				_trail.pushForce = 30;
				_trail.pushForceDrag = 0.96;
				_trail.spreadForce = 3;
				_trail.spreadForceDrag = 0.94;
				_trail.fadePerTick = 0.03;
				_trail.maxSegments = 70;
				_trail.lineWidth = 50;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trail.visual, _visual, -1);
			}
		}
		
		override public function tick(delta:Number):void 
		{
			_isStoppedByPlayer = false;
			_flashCooldown -= delta;
			
			if (fuel > 0) {
				//Stage working normally
				playSound();
				if(_wrapper.currentState != "init") _wrapper.setToOn();
				if (_wrapper.currentState == "on" || _wrapper.currentState == "active") {
					var pos:Point = GameCamera.getPositionOnCamera(_visual.tBottom);
					_trail.addSegment(pos.x, pos.y, _player.getMovieClip().rotation + 90);
					
					applyPower(delta * _powerFromMaxFuel);
					substractFuel(delta);
				}
			}else {
				//Out of fuel
				if (!_isFinished) {
					_visual.wave1.gotoAndStop(7);
					_visual.wave2.gotoAndStop(7);
					stopSound();
					doDeath();
				}else {
					//Nothing
				}
			}
			
		}
		
		override protected function playSound(fadeInDuration:Number = NaN):void 
		{
			if (_item != null && _dubstep == null) {
				Music.fadeOutAll();
			}
			if (_item == null) return;
			
			if (isNaN(fadeInDuration)) fadeInDuration = 300;
			
			if (_dubstep == null && _item.statSound1 != null) {
				//trace("New sound created!");
				_dubstep = Audio.playMusic(_item.statSound1, fadeInDuration);
				_dubstep.loop = false;
				_dubstep.volume = _item.statSound1Volume;
			}
		}
		
		override protected function stopSound(fadeOutDuration:Number = NaN):void 
		{
			if (_item && _dubstep) {
				Music.playGameMusic();
			}
			if (_dubstep) {
				if (isNaN(fadeOutDuration)) fadeOutDuration = 300;
				//trace("Sound fading out!");
				_dubstep.fadeOut(fadeOutDuration);
				_dubstep = null;
			}
		}
		
		override protected function applyPower(delta:Number, forceThrustRelativeAngle:Number = NaN):void 
		{
			super.applyPower(delta * readSpectrum());
		}
		
		protected function readSpectrum():Number {
			//SoundMixer.computeSpectrum(_ba, false, 0);
			//
			//var totalSound:Number = 0;
			//var currentFloat:Number = 0;
			//
			//for (var i = 0; i < 256; i += 8) {
				//currentFloat = _ba.readFloat();
				//totalSound += Math.abs(currentFloat);
			//}
			//
			//var spectrumNorm:Number = NumberUtils.interpolate2(0, 1, 0, 7, totalSound, 1);
			//
			//trace(totalSound, "->", spectrumNorm);
			//
			//a.push(NumberUtils.setPrecison(spectrumNorm, 2));
			
			//var pos:Number = (NumberUtils.interpolate2(1, _soundMap.length - 1, 0, _dubstep.length, _dubstep.position));
			var pos:Number = (NumberUtils.interpolate2(1, _soundMap.length - 1, maxFuel, 0, fuel));
			var val1:Number = _soundMap[Math.floor(pos)];
			var val2:Number = _soundMap[Math.ceil(pos)];
			
			var spectrumNorm:Number = NumberUtils.interpolate2(val1, val2, Math.floor(pos), Math.ceil(pos), pos);
			
			trace(_soundMap[Math.round(pos)], "->", spectrumNorm);
			
			if (spectrumNorm >= 0.4) {
				if (_flashCooldown <= 0) {
					_flashCooldown = _flashCooldownLength;
					var p:AbstractParticle = Particles.builder.screenFlash(0.5 + Math.random() * 0.5, 0, NumberUtils.randomRange(20, 60));
					var rndColor:uint = Tools.rgbToColor(Math.random() * 155 + 100, Math.random() * 155 + 100, Math.random() * 155 + 100);
					DisplayObjectUtil.setObjectTint(p, rndColor , 1);
					_trail.color = rndColor;
				}
			}
			
			_trail.alpha = NumberUtils.interpolate(0.3, 1, spectrumNorm)
			_trail.lineWidth = NumberUtils.interpolate(1, 60, spectrumNorm)
			_trail.pushForce = NumberUtils.interpolate(1, 15, spectrumNorm)
			_trail.spreadForce = NumberUtils.interpolate(0, 40, spectrumNorm)
			
			_visual.scaleX = NumberUtils.interpolate(1, 1.15, spectrumNorm);
			_visual.scaleY = NumberUtils.interpolate(1, 1.3, spectrumNorm);
			
			var waveFrame:Number = Math.round(NumberUtils.interpolate2(7, 1, 0, 1, spectrumNorm, 1));
			_visual.wave1.gotoAndStop(waveFrame);
			_visual.wave2.gotoAndStop(waveFrame);
			
			return spectrumNorm;
		}
		
	}

}