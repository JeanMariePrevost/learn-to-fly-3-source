package src.game.gameobjects.player.stage 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import src.audio.Audio;
	import src.audio.ISound;
	import src.game.gameobjects.player.Player;
	import src.game.particles.AbstractParticle;
	import src.game.particles.Particles;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TheDIY extends SimpleStage 
	{
		public var fire:MovieClip;
		
		protected var _baseFireScaleX:Number;
		protected var _baseFireScaleY:Number;
		
		
		protected const GOOD_DURATION:Number = 200;
		protected const WEAK_DURATION:Number = 80;
		protected const BAD_DURATION:Number = 40;
		
		protected const GOOD_MIN_POWER:Number = 0.95;
		protected const GOOD_MAX_POWER:Number = 1.05;
		protected const WEAK_MIN_POWER:Number = 0.25;
		protected const WEAK_MAX_POWER:Number = 0.6;
		
		
		protected var _smokeTime:Number = 0;
		protected var _phaseTime:Number = 0;
		protected var _goodPhases:Number = 0;
		protected var _weakPhases:Number = 0;
		protected var _badPhases:Number = 0;
		/** >0-1 power mult, 0 = forced turn off, <0 = missfire */
		protected var _currentPhase:Number = 0;
		
		protected var _badPhaseDirection:Number = 0;
		
		protected var _sound2:ISound;
		
		public function TheDIY(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override public function startStage():void 
		{
			super.startStage();
			
			fire = _visual.fire;
			_baseFireScaleX = fire.scaleX;
			_baseFireScaleY = fire.scaleY;
		}
		
		override public function tick(delta:Number):void 
		{
			if (fuel <= 0) {
				tickFire(0);
				stopSound();
				doDeath();
				return;
			}
			
			if (_phaseTime <= 0) {
				//Phase over
				pickNewPhase();
			}
			
			_phaseTime -= delta;
			if (_currentPhase >= GOOD_MIN_POWER) {
				//good	
				//trace("good");
				super.tick(delta * _currentPhase);
				if (fuel > 0 && Input.metaDown.isDown == false) {
					spawnGoodSmoke();
					tickFire(1);
				}else {
					tickFire(0);
				}
			}else if (_currentPhase >= 0) {
				//weak
				//trace("weak");
				playWeakSound();
				super.tick(delta * _currentPhase);
				if (fuel > 0 && Input.metaDown.isDown == false) {
					spawnWeakSmoke();
					tickFire(0.5);
				}else {
					tickFire(0);
				}
			}else {
				//bad
				//trace("bad");
				tickBadPhase(delta);
				playSteamSound();
				spawnBadSmoke();
				tickFire(0);
			}
		}
		
		protected function tickFire(legnthNorm:Number = 1):void {
			if (legnthNorm > 0) {
				fire.visible = true;
				fire.scaleX = _baseFireScaleX + NumberUtils.randomRange(-0.06, 0.06);
				fire.scaleY = (_baseFireScaleY + NumberUtils.randomRange(-0.1, 0.3)) * legnthNorm;
			}else {
				fire.visible = false;
			}
		}
		
		protected function playSteamSound(fadeInDuration:Number = NaN):void {
			if (_item == null) return;
			
			if (isNaN(fadeInDuration)) fadeInDuration = 30;
			
			if (_sound2 == null && _item.statSound3 != null) {
				//trace("New sound created!");
				_sound2 = Audio.playFadingSoundLoop(_item.statSound3, this, fadeInDuration);
				_sound2.volume = _item.statSound3Volume;
			}
		}
		
		protected function playWeakSound(fadeInDuration:Number = NaN):void {
			if (_item == null) return;
			
			if (isNaN(fadeInDuration)) fadeInDuration = 150;
			
			if (_sound2 == null && _item.statSound2 != null) {
				//trace("New sound created!");
				_sound2 = Audio.playFadingSoundLoop(_item.statSound2, this, fadeInDuration);
				_sound2.volume = _item.statSound2Volume;
			}
		}
		
		override protected function stopSound(fadeOutDuration:Number = NaN):void 
		{
			if (_sound2) {
				if (isNaN(fadeOutDuration)) fadeOutDuration = 300;
				//trace("Sound fading out!");
				_sound2.fadeOut(fadeOutDuration);
				_sound2 = null;
			}
			
			super.stopSound(fadeOutDuration);
		}
		
		protected function stopSound2(fadeOutDuration:Number = NaN):void {
			if (_sound2) {
				if (isNaN(fadeOutDuration)) fadeOutDuration = 300;
				_sound2.fadeOut(fadeOutDuration);
				_sound2 = null;
			}
		}
		
		protected function tickBadPhase(delta:Number):void {
			applyPower(delta * _currentPhase, _badPhaseDirection);
		}
		
		protected function spawnGoodSmoke():void {
			if (_smokeTime <= 0) {
				_smokeTime = 3;
				var smoke:AbstractParticle = Particles.builder.smokeGrey(NumberUtils.randomRange( -5, 5), 45, 0.6, 0.9, 14 + Math.random() * 10, _player.getMovieClip().rotation + 90 + NumberUtils.randomBoth(16), _visual);
				smoke.particleLife = 5;
				smoke.vScale = 0.14;
			}else {
				_smokeTime -= 1;
			}
		}
		
		protected function spawnWeakSmoke():void {
			if (_smokeTime <= 0) {
				_smokeTime = 6;
				var smoke:AbstractParticle = Particles.builder.smokeBlack(NumberUtils.randomRange( -5, 5), 45, 0.5, 0.8, 3 + Math.random() * 10, _player.getMovieClip().rotation + 90 + NumberUtils.randomBoth(16), _visual);
				smoke.particleLife = 5;
				smoke.vScale = 0.14;
			}else {
				_smokeTime -= 1;
			}
		}
		
		protected function spawnBadSmoke():void {
			if (_smokeTime <= 0) {
				_smokeTime = 1;
				var smoke:AbstractParticle = Particles.builder.smokeWhiteQuick(NumberUtils.randomRange( -5, 5), 45, 0.7, 0.9, 24 + Math.random() * 20, _player.getMovieClip().rotation + 90 + NumberUtils.randomBoth(32) - _badPhaseDirection, _visual);
				smoke.particleLife = 60;
				smoke.vScale = 0.04;
				smoke.drag = 0.06;
			}else {
				_smokeTime -= 1;
			}
		}
		
		
		
		protected function pickNewPhase():void {
			var previousPhase:Number = _currentPhase;
			
			var totalPhases:Number = _goodPhases + _weakPhases + _badPhases;
			
			var goodOdds:Number = NumberUtils.interpolate2(1, 0.3, 0, totalPhases / 3, _goodPhases);
			var weakOdds:Number = NumberUtils.interpolate2(1, 0.3, 0, totalPhases / 3, _weakPhases);
			var badOdds:Number = NumberUtils.interpolate2(1, 0.3, 0, totalPhases / 3, _badPhases);
			
			var rand:Number = Math.random() * (goodOdds + weakOdds + badOdds);
			
			if (rand <= goodOdds) {
				//Good
				_currentPhase = NumberUtils.randomRange(GOOD_MIN_POWER, GOOD_MAX_POWER);
				_goodPhases += 1;
				_phaseTime = GOOD_DURATION * NumberUtils.randomRange(0.5, 1.1);
				
			}else if (rand <= goodOdds + weakOdds) {
				//Weak
				_currentPhase = NumberUtils.randomRange(WEAK_MIN_POWER, WEAK_MAX_POWER);
				_weakPhases += 1;
				_phaseTime = WEAK_DURATION * NumberUtils.randomRange(0.3, 1);
				
			}else {
				//Bad
				_currentPhase = NumberUtils.randomRange(-0.8, -1);
				_badPhases += 1;
				_phaseTime = BAD_DURATION * NumberUtils.randomRange(0.2, 1);
				
				_badPhaseDirection = NumberUtils.randomRange( -180, 180);
				
			}
			
			if (_currentPhase >= GOOD_MIN_POWER) {
				//good	
				stopSound2();
			}else if (_currentPhase >= 0) {
				//weak
				if (previousPhase < 0) stopSound2();
			}else {
				//bad
				if (previousPhase >= 0) stopSound2();
			}
			
		}
	}

}