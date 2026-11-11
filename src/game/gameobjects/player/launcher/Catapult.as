package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import sound.CatapultCrank;
	import sound.CatapultRelease;
	import src.audio.Audio;
	import src.audio.ISound;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameCamera;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.game.GameToolTip;
	import src.game.StatHooks;
	import src.Main;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class Catapult extends AbstractLauncher 
	{
		protected const CRANK_TO_FULL_POWER:Number = 700;
		
		public var baby:MovieClip;
		public var tCatapult:MovieClip;
		
		protected var _babyWrapper:DeltaMovieClipWrapper;
		protected var _catapultWrapper:DeltaMovieClipWrapper;
		protected var _crankSpeed:Number = 0;
		protected var _catapultCrankTotal:Number = 0;
		protected var _tickFunction:Function;
		
		protected var _fireTweenDuration:Number = 20;
		protected var _fireTweenCount:Number = 0;
		
		protected var _initTimer:Timer = new Timer(1000, 1);//Used to prevent key press within set period. Prevents misfires
		
		protected var _crankSound:ISound;
		
		public function Catapult(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			
			_tickFunction = tickNull;
			
			_catapultWrapper = new DeltaMovieClipWrapper(this);
			_catapultWrapper.stop();
			
			_babyWrapper = new DeltaMovieClipWrapper(baby);
			_babyWrapper.stop();
			
			GameToolTip.show("catapult");
			
			_initTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onInitTimer);
			_initTimer.start();
			
			//trace("INIT gravMass:", _player.getBody().gravMass);
		}
		
		private function onInitTimer(e:TimerEvent):void 
		{
			_initTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onInitTimer);
			Input.instance.basicCommands.anyKeyOrMouse.signalCommandDown.add(onKeyPress);
		}
		
		protected function onKeyPress():void 
		{
			if (_crankSound == null) {
				_crankSound = Audio.playSoundLoop(CatapultCrank, this);
			}
			_tickFunction = tickCrank;
			_crankSpeed += 4;
		}
		
		override public function tick(delta:Number):void {
			//trace("gravMass:", _player.getBody().gravMass);
			_tickFunction(delta);
		}
		
		
		protected function tickNull(delta:Number):void {
			movePlayerOnTarget(tCatapult);
		}
		
		protected function tickCrank(delta:Number):void {
			_crankSpeed *= 0.9;
			if (_crankSpeed <= 0.05) {
				_crankSpeed = 0;
				GameToolTip.hide();
				Input.instance.basicCommands.anyKeyOrMouse.signalCommandDown.remove(onKeyPress);
				if (_crankSound) _crankSound.destroy();
				Audio.playSound(CatapultRelease);
				launchPlayer();
				finalizeTakeoff();
				_tickFunction = tickFire;
				//trace("FINAL gravMass:", _player.getBody().gravMass);
			}
			_babyWrapper.tick(_crankSpeed);
			
			_catapultCrankTotal += _crankSpeed;
			//trace(_catapultCrankTotal, (_catapultCrankTotal / CRANK_TO_FULL_POWER));
			_catapultWrapper.interpolateLabel("specialStart", _catapultCrankTotal / CRANK_TO_FULL_POWER);
			movePlayerOnTarget(tCatapult);
		}
		
		protected function launchPlayer():void {
			movePlayerOnTarget(tCatapult);
			var power:Number = launcherBasePower;
			var powerAtWeight:Number = powerAtCurrentWeight;
			var crankPowerMult:Number = NumberUtils.interpolate2(0.1, 1, 0, CRANK_TO_FULL_POWER, _catapultCrankTotal, 2, true);
			power *= crankPowerMult;
			
			_player.getMovieClip().visible = true;
			
			//trace("Catapult crank:", crankPowerMult, "Power:", power, "PowerAtWeight:", powerAtWeight);
			
			//_player.applyThrust(power * powerAtWeight);
			
			applyLauncherThrust(power * powerAtCurrentWeight, 0, true);
		}
		
		protected function tickFire(delta:Number):void {
			_fireTweenCount += delta;
			_fireTweenCount = Math.min(_fireTweenCount, _fireTweenDuration);
			_catapultWrapper.interpolateLabel("specialStart", Easing.easeOutBack(_fireTweenCount, 1, -1, _fireTweenDuration) * (_catapultCrankTotal / CRANK_TO_FULL_POWER));
			
			if (_fireTweenCount >= _fireTweenDuration) {
				//Anim completely over
				finalizeLauncher();
			}
		}
		
		
	}

}