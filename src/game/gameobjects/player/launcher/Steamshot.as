package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import sound.SteamEngine;
	import sound.SteamHit;
	import sound.SteamRelease;
	import sound.SteamWhistle;
	import src.audio.Audio;
	import src.audio.ISound;
	import src.compound.Mod;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.game.GameToolTip;
	import src.game.particles.AbstractParticle;
	import src.game.particles.Particles;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class Steamshot extends AbstractLauncher 
	{
		public var meter:MovieClip;
		public var pump:MovieClip;
		
		public var targetLeft:MovieClip;
		public var targetRight:MovieClip;
		public var targetCenter:MovieClip;
		public var targetPumpLeft:MovieClip;
		public var targetPumpRight:MovieClip;
		
		protected var _meterWrapper:DeltaMovieClipWrapper;
		protected var _pumpWrapper:DeltaMovieClipWrapper;
		protected var _wrapper:DeltaMovieClipWrapper;
		
		protected var _pumpWrapperSpeed:Number = 0;//Used to animate the pump
		
		
		protected const NUMBER_OF_CLICKS:uint = 3;//Max number of tries
		protected var _clickCount:Number = 0;//Current number of tries
		protected var _crankSmoothing:Number = 0;//Used to animate the crank moving down
		
		protected var _pumpPressure:Number = 0;//Pressure of current try
		protected var _totalPressure:Number = 0;//Built up pressure
		
		protected var _preLaunchTime:Number = 0;
		protected var _preLaunchDuration:Number = 110;
		protected var _preLaunchSmokeTime:Number = 0;
		protected var _preLaunchSmokeDuration:Number = 7;
		
		//Launch tween is the crank moving up
		protected var _launchTweenTime:Number = 0;
		protected var _launchTweenDuration:Number = 40;
		protected var _launchTweenStartNorm:Number = 0;
		
		protected var _tickFunction:Function;
		
		protected var cameraModY:Mod;
		
		protected var _soundLoop:ISound;
		
		
		public function Steamshot(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			
			scaleX = scaleY = 2;
			
			_wrapper = new DeltaMovieClipWrapper(this);
			_meterWrapper = new DeltaMovieClipWrapper(meter);
			_pumpWrapper = new DeltaMovieClipWrapper(pump);
			
			cameraModY = StatHooks.cameraYOffset.addMod2(-100);
			
			_wrapper.stop();
			_meterWrapper.stop();
			_pumpWrapper.stop();
			
			_tickFunction = tickBuildPressure;
			
			_soundLoop = Audio.playFadingSoundLoop(SteamEngine, this, 700);
			
			GameToolTip.show("steamLauncher");
			
			Input.instance.basicCommands.anyKeyOrMouse.signalCommandDown.add(onKeyDown);
		}
		
		override public function tick(delta:Number):void 
		{
			_tickFunction(delta);
			
		}
		
		protected function onKeyDown():void 
		{
			_clickCount += 1;
			var pressure:Number = Easing.easeInQuart(_pumpPressure, 0, 1, 1);
			_totalPressure+= pressure / NUMBER_OF_CLICKS;
			
			//trace(pressure, "->", _totalPressure);
			
			if (_tickFunction == tickBuildPressure) {
				Audio.playSound(SteamRelease).volume = 0.7;
				_tickFunction = tickReleasePressure;
				expelVapor();
			}
			
			if (_clickCount >= NUMBER_OF_CLICKS) {
				Input.instance.basicCommands.anyKeyOrMouse.signalCommandDown.remove(onKeyDown);
				//_tickFunction = tickLaunch;
			}
		}
		
		protected function tickBuildPressure(delta:Number):void {
			_pumpWrapperSpeed += (2.5 - _pumpWrapperSpeed) * 0.15;
			_pumpWrapper.tick(_pumpWrapperSpeed);
			
			movePlayerOnTarget(targetCenter);			
			if (_pumpPressure >= 1) {
				_tickFunction = tickReleasePressure;
				expelVapor();
			}else {
				_pumpPressure += 0.01;
				_pumpPressure = Math.min(_pumpPressure, 1);
				var pressureEase:Number = Easing.easeInQuart(_pumpPressure, 0, 1, 1);
				_meterWrapper.interpolateLabel("specialStart", pressureEase);
			}
			
			tweenPlate(delta);
		}
		
		protected function tweenPlate(delta:Number):void {
			if (_crankSmoothing != _totalPressure) {
				_crankSmoothing += (_totalPressure - _crankSmoothing) * 0.05;
				if (Math.abs(_crankSmoothing - _totalPressure) <= 0.025) {
					_crankSmoothing = _totalPressure;
				}
				_wrapper.interpolateLabel("specialStart", _crankSmoothing);
				movePlayerOnTarget(targetCenter);
			}
		}
		
		protected function tickReleasePressure(delta:Number):void {
			_pumpWrapperSpeed *= 0.92;
			_pumpWrapper.tick(_pumpWrapperSpeed);
			
			movePlayerOnTarget(targetCenter);			
			_pumpPressure -= 0.025;
			_pumpPressure = Math.max(_pumpPressure, 0);
			var pressureEase:Number = Easing.easeOutQuad(1 - _pumpPressure, 1, -1, 1);
			_meterWrapper.interpolateLabel("specialStart", pressureEase);
			
			if (_pumpPressure <= 0) {
				if (_clickCount >= NUMBER_OF_CLICKS) {
					Audio.playSound(SteamWhistle).volume = 0.7;
					_soundLoop.fadeOut(300);
					_tickFunction = tickPreLaunch;
					GameToolTip.hide();
				}else {
					_tickFunction = tickBuildPressure;
				}
			}
			
			tweenPlate(delta);
		}
		
		protected function tickPreLaunch(delta:Number):void {
			_preLaunchTime += delta;
			_preLaunchTime = Math.min(_preLaunchTime, _preLaunchDuration);
			
			_pumpWrapperSpeed += (6.5 - _pumpWrapperSpeed) * 0.05;
			_pumpWrapper.tick(_pumpWrapperSpeed);
			var f:Array = [new GlowFilter(0x000000, 1, 5, 5, 5, 1), new BlurFilter(0, _pumpWrapperSpeed * 3, 1)];
			pump.filters = f;
			
			_preLaunchSmokeTime += 1;
			if (_preLaunchSmokeTime >= _preLaunchSmokeDuration) {
				Particles.builder.smokeWhiteQuick(0, 0, 1.3, 1.5, 5 + Math.random() * 2, -165, targetLeft);
				Particles.builder.smokeWhiteQuick(0, 0, 1.3, 1.5, 5 + Math.random() * 2, -15, targetRight);
				_preLaunchSmokeTime = 0;
			}
			
			if (_preLaunchTime >= _preLaunchDuration) {
				Audio.playSound(SteamHit);
				doLaunch();
			}else {
				movePlayerOnTarget(targetCenter);
			}
		}
		
		protected function tickLaunch(delta:Number):void {
			_launchTweenTime += delta;
			_launchTweenTime = Math.min(_launchTweenTime, _launchTweenDuration);
			var norm:Number = Easing.easeOutQuart(_launchTweenTime, _launchTweenStartNorm, -_launchTweenStartNorm, _launchTweenDuration);
			//trace("Norm:", norm, "Time:", _launchTweenTime);
			_wrapper.interpolateLabel("specialStart", norm);
		}
		
		protected function doLaunch():void {
			_launchTweenStartNorm = _wrapper.currentStateNorm;
			_launchTweenTime = 0;
			_tickFunction = tickLaunch;
			
			tickLaunch(1);//call once for better matching visuals
			launchPlayer();
			finalizeTakeoff();
			
			StatHooks.cameraYOffset.removeMod(cameraModY);
		}
		
		protected function launchPlayer():void {
			var power:Number = launcherBasePower;
			var powerAtWeight:Number = _item.getPowerAtWeightMult(_player.getBody().mass);
			var crankPowerMult:Number = NumberUtils.interpolate2(0.15, 1, 0, 1, _totalPressure, 2, true);
			power *= crankPowerMult;
			
			_player.getMovieClip().visible = true;
			
			applyLauncherThrust(power * powerAtWeight);
		}
		
		protected function expelVapor():void {
			for (var i:int = 0; i < 3; i++) {
				var p:AbstractParticle;
				p = Particles.builder.smokeBalloon(0, 0, 0.6, 1.0, Math.random() * 3, -155 + NumberUtils.randomBoth(45), targetPumpLeft);
				p.baseAlpha = 0.8;
				p.particleFadeLife = 70;
				p = Particles.builder.smokeBalloon(0, 0, 0.6, 1.0, Math.random() * 3, -25 + NumberUtils.randomBoth(45), targetPumpRight);
				p.baseAlpha = 0.8;
				p.particleFadeLife = 70;
			}
		}
		
	}

}