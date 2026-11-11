package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import sound.ExplosionFar;
	import src.audio.Audio;
	import src.compound.Mod;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameCamera;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.game.particles.AbstractParticle;
	import src.game.particles.Particles;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class NuclearReactor extends AbstractLauncher 
	{
		public var target:MovieClip;
		
		protected var _anim:MovieClip;
		protected var _wrapper:DeltaMovieClipWrapper;
		
		protected var _tickFunction:Function;
		protected var _cameraModY:Mod;
		
		public function NuclearReactor(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			var r:Number = Math.random();
			if (r <= 0.3) {
				_anim = new src.game.gameobjects.player.launcher.NuclearReactorAnim1();
			}else if (r <= 0.6) {
				_anim = new src.game.gameobjects.player.launcher.NuclearReactorAnim4();
			}else if (r <= 0.9) {
				_anim = new src.game.gameobjects.player.launcher.NuclearReactorAnim3();
			}else {
				_anim = new src.game.gameobjects.player.launcher.NuclearReactorAnim2();
			}
			_anim.gotoAndStop(1);
			GameCamera.instance.addChildToFixedLayer(_anim, 3);
			
			StatHooks.cameraZoomFloor = 2;
			_cameraModY = StatHooks.cameraYOffset.addMod2(-80);
			
			//scaleX = scaleY = 2.5;
			
			_player.getMovieClip().visible = false;
			
			_wrapper = new DeltaMovieClipWrapper(this);
			_wrapper.stop();
			
			_tickFunction = tickWaitForAnim;
			
		}
		
		override public function tick(delta:Number):void 
		{
			if (_anim.currentFrame < _anim.totalFrames) {
				_anim.nextFrame();
			}
			
			if (_anim.currentLabel == "deathStart" && _tickFunction == tickWaitForAnim) {
				_tickFunction = tickWindUp;
			}
			
			_tickFunction(delta);
			
		}
		
		protected function tickWaitForAnim(delta:Number):void {
			movePlayerOnTarget(target);
		}
		
		protected function tickWindUp(delta:Number):void {
			_wrapper.tick(delta);
			movePlayerOnTarget(target);
			if (_wrapper.currentLabel == "specialEnd") {
				//Do launch
				StatHooks.cameraYOffset.removeMod(_cameraModY);
				Audio.playSound(ExplosionFar);
				applyPower();
				StatHooks.cameraZoomFloor = 0;
				finalizeTakeoff();
				_player.getMovieClip().visible = true;
				_wrapper.setToDeath();
				spawnSmoke();
				_tickFunction = tickFinish;
			}
		}
		
		protected function spawnSmoke():void {
			var i:int;
			for (i = 0; i <= 10; i++) {
				var p:AbstractParticle = Particles.builder.smokeGrey(0, 0, 1.25, 2, 15 + Math.random() * 15, -90 + NumberUtils.randomBoth(30), target);
				p.vScale = 0.03;
				p.particleLife = 0;
				p.particleFadeLife = 100;
				p.baseAlpha = 0.6;
				p.drag = 0.01;
			}
			
			Particles.builder.explosiveSmoke(0, 0, 1, 1, 1 + Math.random() * 2, -90, target);
		}
		
		protected function applyPower():void {
			var power:Number = launcherBasePower;
			var powerAtWeight:Number = _item.getPowerAtWeightMult(_player.getBody().mass);
			
			trace("Applying launcher power:", power, "x", powerAtWeight);
			
			applyLauncherThrust(power * powerAtWeight);
		}
		
		protected function tickFinish(delta:Number):void {
			_wrapper.tick(delta);
			if (_wrapper.currentLabel == "deathEnd") {
				//completely finished
				finalizeLauncher();
			}
		}
		
		override protected function finalizeLauncher():void 
		{
			super.finalizeLauncher();
			
			if (_anim.stage) _anim.parent.removeChild(_anim);
			_anim = null;
			
			_wrapper.destroy();
			_wrapper = null;
			
			_tickFunction = null;
		}
		
		
	}

}