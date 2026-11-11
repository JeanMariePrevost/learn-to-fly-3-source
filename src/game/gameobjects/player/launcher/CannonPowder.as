package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import lbg.components.labelmovieclip.LabelMovieClip;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import sound.*;
	import src.audio.Audio;
	import src.audio.ISound;
	import src.compound.Mod;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameCamera;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.game.GameToolTip;
	import src.game.particles.Particles;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * ...
	 * @author light_bringer777
	 */
	public class CannonPowder extends AbstractLauncher 
	{
		protected const POWDER_MAX:Number = 230;//Amount of powder required to achieve ~max launch power
		
		public var wick:CannonPowderWick;
		public var tCannon:MovieClip;
		public var cannon:MovieClip;
		public var bubble:MovieClip;
		public var powderBaby:CannonPowderBaby;
		
		protected var _wrapper:DeltaMovieClipWrapper;
		protected var _miniGameFinished:Boolean = false;
		protected var _babyFellIn:Boolean = false;
		protected var _cannonFired:Boolean = false;
		protected var _flow:Number = 0;
		
		protected var _powder:Number = 0;
		
		protected var _cameraMod:Mod;
		
		protected var _tickFunction:Function;
		
		protected var _wickLoop:ISound;
		
		public function CannonPowder(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			
			_wrapper = new DeltaMovieClipWrapper(this);
			_wrapper.setAction("badDeathStart", LabelMovieClip.ACTION_PLAY);
			_wrapper.setAction("badDeathEnd", LabelMovieClip.ACTION_STOP);
			_wrapper.useDeltaTime = false;
			_wrapper.stop();
			
			cannon.stop();
			
			bubble.mc.gotoAndStop(1);
			bubble.visible = false;
			
			_player.getMovieClip().visible = false;
			
			GameToolTip.show("cannonPowder");
			_cameraMod = StatHooks.cameraYOffset.addMod2(-50);
			
			wick.addEventListener(Event.COMPLETE, onWickBurned);
			
			_tickFunction = tickNotStarted;
		}
		
		private function onWickBurned(e:Event):void 
		{
			finishMiniGameGood();
		}
		
		protected function fireCannon():void {
			if(!_cannonFired){
				_cannonFired = true;
				_cameraMod.destroy();
				_cameraMod = null;
				launchPlayer();
				finalizeTakeoff();
			}
		}
		
		protected function launchPlayer():void {
			var power:Number = launcherBasePower;
			var powerAtWeight:Number = _item.getPowerAtWeightMult(_player.getBody().mass);
			var powderPowerMult:Number = NumberUtils.interpolate2(0.1, 1, 0, POWDER_MAX, _powder, 2, true);
			power *= powderPowerMult;
			
			if (powderPowerMult <= 0.25) {
				Audio.playSound(Explode1);
			}else if (powderPowerMult <= 0.7) {
				Audio.playSound(Explode6);
			}else {
				Audio.playSound(Explode2);
			}
			
			_player.getMovieClip().visible = true;
			
			for (var i = 0; i <= 8; i++) {
				Particles.builder.smokeWhite(_player.getPositionX(), _player.getPositionY(), 0.8, 1.2, 2 + Math.random() * 6, -90 + NumberUtils.randomBoth(90));
			}
			for (i = 0; i <= 6; i++) {
				Particles.builder.smokeWhite(_player.getPositionX(), _player.getPositionY(), 0.8, 1.2, 10 + Math.random() * 8, -90 + NumberUtils.randomBoth(15));
			}
			
			applyLauncherThrust(power * powerAtWeight);
		}

		override public function tick(delta:Number):void 
		{
			//trace("Player gravMass:", _player.getBody().gravMass);
			_tickFunction(delta);
			//movePlayerOnTarget();
			if (!_cannonFired) movePlayerOnTarget(cannon.tCannon);
		}
		
		
		///////////////////////////////////////////
		//Different states of minigame / controls
		
		protected function tickNotStarted(delta:Number):void {
			if (Input.instance.basicCommands.anyKeyOrMouse.isDown) {
				_wickLoop = Audio.playFadingSoundLoop(FuseBurning, this, 450);
				wick.igniteWick();
				bubble.visible = true;
				_wrapper.setToSpecial();
				_tickFunction = tickMiniGame;
			}
		}
		
		protected function tickMiniGame(delta:Number):void {
			updateFlow(Input.instance.basicCommands.anyKeyOrMouse.isDown);
			
			
			if (_flow < 0.5) {
				_powder += _flow;
				bubble.mc.gotoAndStop(1);
				powderBaby.wrapper.setToState("good");
			}else if (_flow < 0.75) {
				_powder += 1.05 - Math.abs(0.625 - _flow);
				bubble.mc.gotoAndStop(2);
				powderBaby.wrapper.setToState("safe");
			}else {
				_powder += 0.85;
				bubble.mc.gotoAndStop(3);
				powderBaby.wrapper.setToState("full");
			}
			
			
			if (_flow >= 1) {
				//Went too far, launch failed
				finishMiniGameBad();
			}
		}
		
		protected function updateFlow(buttonDown:Boolean):void {
			if (buttonDown) {
				_flow += 0.01;
			}else {
				_flow -= 0.015;
			}
			
			_flow = NumberUtils.constrain(_flow);
			
			if (_wrapper.currentState == "special") {
				_wrapper.interpolateLabel("specialStart", _flow);
			}
		}
		
		protected function finishMiniGameGood():void {
			if (!_miniGameFinished) {
				if (_wickLoop) _wickLoop.fadeOut(150);
				_miniGameFinished = true;
				//_wrapper.setToDeath();
				//_wrapper.play();
				bubble.visible = false;
				GameToolTip.hide();
				_tickFunction = tickAnimCannon;
			}
		}
		
		protected function finishMiniGameBad():void {
			if (!_miniGameFinished) {
				if (_wickLoop) _wickLoop.fadeOut(150);
				_babyFellIn = true;
				_miniGameFinished = true;
				_wrapper.setToState("badDeath");
				_wrapper.play();
				powderBaby.wrapper.setToState("worst");
				bubble.visible = false;
				GameToolTip.hide();
				_tickFunction = tickAnimFallingIn;
			}
		}
		
		protected function tickAnimFallingIn(delta:Number):void {
			if (_wrapper.currentLabel != "badDeathEnd") {
				//Still playing, wait
			}else {
				//Done falling in, fire cannon
				_tickFunction = tickAnimCannon;
			}
		}
		
		protected function tickAnimCannon(delta:Number):void {
			//Finished, either via failed attempt or out of time
			if (cannon.currentFrame < cannon.totalFrames) {
				updateFlow(false);
				cannon.nextFrame();
				if (!_cannonFired && cannon.currentLabel == "fire") {
					//Animation reached firing point
					fireCannon();
				}
			}else {
				finalizeLauncher();
			}
		}
		
	}

}