package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import sound.SlingshotWhoosh;
	import src.audio.Audio;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameCamera;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.game.GameToolTip;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class Slingshot extends AbstractLauncher 
	{
		public var band:MovieClip;
		
		protected var _wrapper:DeltaMovieClipWrapper;
		protected var _tickFunction:Function;
		
		protected var _pullNorm:Number = 0;
		protected const BEST_PULL_VALUE:Number = 0.75;
		protected const WORST_PULL_MULT:Number = 0.2;
		
		
		public function Slingshot(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			
			_wrapper = new DeltaMovieClipWrapper(this);
			_tickFunction = tickChangeDepth;
			
			Input.instance.basicCommands.anyKeyOrMouse.signalCommandDown.addOnce(keyDown);
			
			GameToolTip.show("slingshot");
		}
		
		protected function keyDown():void 
		{
			Input.instance.basicCommands.anyKeyOrMouse.signalCommandDown.remove(keyDown);
			Input.instance.basicCommands.anyKeyOrMouse.signalCommandUp.addOnce(keyUp);
			_tickFunction = tickPull;
		}
		
		protected function keyUp():void 
		{
			Input.instance.basicCommands.anyKeyOrMouse.signalCommandUp.remove(keyUp);
			_tickFunction = null;
			_wrapper.setToDeath();
			
			var pullMult:Number;
			if (_pullNorm <= BEST_PULL_VALUE) {
				pullMult = NumberUtils.interpolate2(WORST_PULL_MULT, 1, 0, BEST_PULL_VALUE, _pullNorm, 0.75);
			}else {
				pullMult = NumberUtils.interpolate2(1, WORST_PULL_MULT, BEST_PULL_VALUE, 1, _pullNorm, 1.25);
			}
			
			//trace("Boing at", pullMult, "power mult");
			
			GameToolTip.hide();
			movePlayerOnTarget(band);
			Audio.playSound(SlingshotWhoosh).volume = NumberUtils.interpolate2(0.3, 1, 0, 1, _pullNorm);
			applyPower(pullMult);
			finalizeTakeoff();
		}
		
		override public function tick(delta:Number):void 
		{
			if(_tickFunction) _tickFunction(delta);
		}
		
		protected function tickChangeDepth(delta:Number):void {
			parent.removeChild(this);
			GameCamera.instance.addChildToMovingLayer(this, 0);
			_tickFunction = tickWait;
		}
		
		protected function tickWait(delta:Number):void {
			movePlayerOnTarget(band);
		}
		
		protected function tickPull(delta:Number):void {
			_pullNorm += _item.statSpecial;
			_pullNorm = Math.min(1, _pullNorm);
			
			_wrapper.interpolateLabel("specialStart", _pullNorm);
			movePlayerOnTarget(band);
			
			if (_pullNorm >= 1) {
				//Max reached
				keyUp();
			}
		}
		
		protected function applyPower(mult:Number):void {
			var power:Number = launcherBasePower;
			var powerAtWeight:Number = _item.getPowerAtWeightMult(_player.getBody().mass);
			
			applyLauncherThrust(power * powerAtWeight * mult);
		}
	}

}