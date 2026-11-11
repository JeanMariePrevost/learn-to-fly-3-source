package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import sound.Explode2;
	import sound.FuseBurning;
	import src.audio.Audio;
	import src.audio.ISound;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class Explosive extends AbstractLauncher 
	{
		public var target:MovieClip;
		protected var _anim:MovieClip;
		protected var _animWrapper:DeltaMovieClipWrapper;
		protected var _explosiveWrapper:DeltaMovieClipWrapper;
		protected var _tickFunction:Function;
		
		
		public function Explosive(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			
			startRandomAnimation();
			_explosiveWrapper = new DeltaMovieClipWrapper(this);
			_explosiveWrapper.stop();
			
			_tickFunction = tickAnim;
		}
		
		private function startRandomAnimation():void 
		{
			var r:Number = Math.random();
			if (r <= 0.8) {
				_anim = new (src.game.gameobjects.player.launcher.ExplosiveTrigger1)();
			}else if (r <= 0.9) {
				_anim = new (src.game.gameobjects.player.launcher.ExplosiveTrigger2)();
			}else if (r <= 1) {
				_anim = new (src.game.gameobjects.player.launcher.ExplosiveTrigger3)();
			}else {
				_anim = new (src.game.gameobjects.player.launcher.ExplosiveTrigger1)();
			}
			
			_animWrapper = new DeltaMovieClipWrapper(_anim);
			addChild(_anim);
		}
		
		override public function tick(delta:Number):void 
		{
			_tickFunction(delta);
			if (!_takeoffFinalized) movePlayerOnTarget(target);
		}
		
		protected function tickAnim(delta:Number):void {
			//trace(_animWrapper.currentLabel);
			if (_animWrapper.currentLabel == "deathEnd") {
				_tickFunction = tickExplode;
				_explosiveWrapper.setToSpecial();
				_explosiveWrapper.play();
			}
		}
		
		protected function tickExplode(delta:Number):void {
			if (_explosiveWrapper.currentLabel == "specialEnd") {
				explode();
				Audio.playSound(Explode2);
				launchPlayer();
				finalizeTakeoff();
			}
		}
		
		protected function explode():void {
			_explosiveWrapper.setToDeath();
		}
		
		protected function launchPlayer():void {
			var power:Number = launcherBasePower;
			var powerAtWeight:Number = _item.getPowerAtWeightMult(_player.getBody().mass);
			
			applyLauncherThrust(power * powerAtWeight);
		}
	}

}