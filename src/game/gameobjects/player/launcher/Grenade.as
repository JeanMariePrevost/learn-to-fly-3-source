package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import sound.Explode1;
	import sound.Explode4;
	import sound.GrenadePin;
	import src.audio.Audio;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.game.GameToolTip;
	import src.game.particles.AbstractParticle;
	import src.game.particles.Particles;
	import src.game.particles.SmokeWhite;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class Grenade extends AbstractLauncher 
	{
		public var meter:MovieClip;
		public var target:MovieClip;
		
		protected var _wrapper:DeltaMovieClipWrapper;
		protected var _meterWrapper:DeltaMovieClipWrapper;
		protected var _grenade:GrenadeProjectile;
		protected var _greatTxt:MovieClip;
		protected var _minigameScore:Number;
		
		protected var _tickFunction:Function;
		
		protected var _smokeCounter:Number = 0;
		protected var _smokeDelay:Number = 3;
		protected var _smokeAmount:Number = 15;
		
		public function Grenade(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			
			_wrapper = new DeltaMovieClipWrapper(this);
			_wrapper.stop();
			_wrapper.setToIdle();
			
			_meterWrapper = new DeltaMovieClipWrapper(meter);
			_meterWrapper.stop();
			
			_tickFunction = tickWaitForKey;
			
			GameToolTip.show("grenade");
			
		}
		
		override public function tick(delta:Number):void 
		{
			_tickFunction(delta);
		}
		
		
		//protected function tickNull(delta:Number):void {
			////Nothing
		//}
		
		protected function tickWaitForKey(delta:Number):void {
			if (Input.instance.basicCommands.anyKeyOrMouse.isDown) {
				//Pull pin on grenade, start minigame
				Audio.playSound(GrenadePin);
				_wrapper.setToOn();
				_tickFunction = tickMiniGame;
			}
		}
		
		protected function tickMiniGame(delta:Number):void {
			_wrapper.tick(delta);
			
			if (_wrapper.currentState == "active") {
				if (Input.instance.basicCommands.anyKeyOrMouse.isDown) {
					//Throw
					_tickFunction = tickThrow;
					throwGrenade();
					_wrapper.setToDeath();
				}else {
					_meterWrapper.interpolateLabel("activeStart", _wrapper.currentStateNorm);
				}
			}
		}
		
		protected function throwGrenade():void {
			GameToolTip.hide();
			var norm:Number = _meterWrapper.currentStateNorm * 2;//x2 because the anim goes back and forth, going 0->1->0 in one state loop
			if (norm > 1) norm = 1 - (norm - 1);//Mirrored when passed half of the anim
			_minigameScore = norm;
			
			if (norm >= 0.48 && norm <= 0.52) {
				//Great!
				_greatTxt = new src.game.gameobjects.player.launcher.GrenadeGreat();
				addChildAt(_greatTxt, 0);
				_greatTxt.x = meter.x;
				_greatTxt.y = meter.y;
			}
			
			var vx:Number = NumberUtils.interpolate( -14, -1.5, norm, 0.6);
			var vy:Number = NumberUtils.interpolate( -2, -12, norm, 1.45);
			
			createGrenade(target, vx, vy);
		}
		
		protected function createGrenade(target, vx, vy):void {
			_grenade = new _item.statVisualClass(target, vx, vy);
			_grenade.detonationSignal.addOnce(launchPlayer);
		}
		
		protected function tickThrow(delta:Number):void {
			_wrapper.tick(delta);
		}
		
		protected function launchPlayer():void {
			if (_item.level >= 8) {
				//Hard-coded item level check for different sound
				Audio.playSound(Explode4);
			}else {
				Audio.playSound(Explode1);
			}
			
			var power:Number = launcherBasePower;
			var powerAtWeight:Number = _item.getPowerAtWeightMult(_player.getBody().mass);
			
			//Grenade power and angle//
			//based on _minigameScore, adjust pwer and launching angle
			//<0.5 is grenade too far right
			//0.5 is grenade dead center
			//>0.5 is grenade too far left
			
			var grenadePower:Number;
			var grenadeAngle:Number;
			
			if (_minigameScore <= 0.485) {
				//Grenade left of player
				grenadePower = NumberUtils.interpolate2(0.5, 1, 0, 0.475, _minigameScore, 1);
				grenadeAngle = NumberUtils.interpolate2(60, 1, 0, 0.475, _minigameScore, 1);
			}else if (_minigameScore >= 0.515) {
				//Grenade right of player
				grenadePower = NumberUtils.interpolate2(0.5, 1, 0, 0.475, _minigameScore, 1);
				grenadeAngle = NumberUtils.interpolate2(-1, -60, 0.525, 1, _minigameScore, 1);
			}else {
				//Grenade dead center!
				grenadePower = 1.15;//Bonus power
				grenadeAngle = 0;
			}
			
			//trace("Grenade takeoff. Power:", grenadePower, ", angle:", grenadeAngle, ", norm:", _minigameScore);
			
			applyLauncherThrust(power * powerAtWeight * grenadePower, grenadeAngle);
			_player.rotation = Trig.toRadians(grenadeAngle);
			
			finalizeTakeoff();
			_tickFunction = tickFinalize;
		}
		
		protected function tickFinalize(delta:Number):void {
			if (_smokeCounter <= 0) {
				_smokeCounter = _smokeDelay;
				if (_smokeAmount >= 1) {
					var s:AbstractParticle = Particles.builder.smokeWhite(0, 0, 0.8, 1.2, 0, 0, _player.getMovieClip());
					s.baseAlpha = NumberUtils.interpolate2(1, 0.1, 15, 1, _smokeAmount);
					_smokeAmount --;
				}else {
					//Smoking finished
					finalizeLauncher();
				}
			}else {
				_smokeCounter --;
			}
			
		}
		
		
		
	}

}