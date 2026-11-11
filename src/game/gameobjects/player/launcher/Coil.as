package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameCamera;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.game.StatHooks;
	import src.Main;
	import src.system.GameStateItem;
	import src.system.InvisibleTarget;
	
	/**
	 * ...
	 * @author 
	 */
	public class Coil extends AbstractLauncher 
	{
		public var tracer:InvisibleTarget;
		
		protected var _launched:Boolean = false;
		
		
		public function Coil(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			scaleX = scaleY = 0.4;
			
		}
		
		override public function tick(delta:Number):void {
			if (_player == null) return;
			
			if (currentFrame < totalFrames) nextFrame();
			
			if (_player && currentLabel == "deathEnd") {
				finalizeLauncher();
			}
			
			if (!_launched) {
				movePlayerOnTarget(tracer);
				
				if (currentLabel == "deathStart") {
					_launched = true;
					applyPower();
					playSoundEffect();
					finalizeTakeoff();
				}
			}
		}
		
		protected function applyPower():void {
			var power:Number = launcherBasePower;
			var powerAtWeight:Number = powerAtCurrentWeight;
			
			//trace("Applying launcher power:", power, "x", powerAtWeight);
			
			applyLauncherThrust(power * powerAtWeight, NumberUtils.randomBoth(3));
			//_player.applyThrust(power * powerAtWeight);
		}
		
	}

}