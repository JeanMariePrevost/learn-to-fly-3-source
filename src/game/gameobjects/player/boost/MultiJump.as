package src.game.gameobjects.player.boost 
{
	import flash.display.MovieClip;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import src.audio.Audio;
	import src.game.GameCamera;
	import src.game.gameobjects.FallingObject;
	import src.game.gameobjects.IFallingObject;
	import src.game.gameobjects.player.Player;
	import src.game.PhysicsEngine;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * MultiJump uses a SPECIAL version of the MCWrapper that has different labels flow
	 */
	public class MultiJump extends SimpleBoost 
	{
		protected const BURST_MULT:Number = 1;//Effect will be multiplied for a few frames
		protected var _burstTime:Number = 0;
		
		public function MultiJump(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			_burstTime = _item.statSpecial;
		}
		
		override public function tick(delta:Number):void 
		{
			//super.tick(delta);
			
			if (fuel.value <= 0) {
				if (leftVisual.currentLabel == "activeEnd") {
					dropPods();
					leftWrapper.gotoLabel("deathStart");
					rightWrapper.gotoLabel("deathStart");
				}
				//if (leftVisual.currentLabel == "offStart" || leftVisual.currentLabel == "offEnd" || leftVisual.currentLabel == "idleStart" || leftVisual.currentLabel == "idleEnd")) {
					//leftWrapper.gotoLabel("deathStart");
					//rightWrapper.gotoLabel("deathStart");
				//}
			}else {
				if (leftVisual.currentLabel == "activeEnd") {
					dropPods();
					leftWrapper.gotoLabel("offStart");
					rightWrapper.gotoLabel("offStart");
				}
			}
			
			if ((Input.metaBoost.isDown || singleBoostInputIsDown)) {
				if (leftVisual.currentLabel == "idleStart" || leftVisual.currentLabel == "idleEnd") {
					//Shot is ready
					playSound(30);
					leftWrapper.gotoLabel("activeStart");
					rightWrapper.gotoLabel("activeStart");
					_burstTime = 0;
					fuel.value -= 1;
					//trace("Fuel =", fuel);
					_hudSignal.dispatch(fuel.value / maxFuel);
				}
			}
			
			if (_burstTime < _item.statSpecial) {
				//Currently boosting
				applyThrust(delta);
				_burstTime += delta;
				_preventDayEnd = true;
			}else {
				_preventDayEnd = false;
			}
		}
		
		protected function dropPods():void {
			//centralWrapper.destroy();
			var leftMc:MovieClip = leftVisual.pod;
			var rightMc:MovieClip = rightVisual.pod;
			
			//leftMc.visible = rightMc.visible = true;
			
			DisplayObjectUtil.changeContainer(leftMc, GameCamera.instance.getMovingLayer(1));
			DisplayObjectUtil.changeContainer(rightMc, GameCamera.instance.getMovingLayer(1));
			
			var fallingObjLeft:IFallingObject = FallingObject.getNewFallingObject(leftMc);
			var fallingObjRight:IFallingObject = FallingObject.getNewFallingObject(rightMc);
			fallingObjLeft.setPhysicsEngine(PhysicsEngine.instance);
			fallingObjRight.setPhysicsEngine(PhysicsEngine.instance);
			
			fallingObjLeft.mimicBodyMomentum(_player.getBody(), 0.6, 3.5);
			fallingObjRight.mimicBodyMomentum(_player.getBody(), 0.6, 3.5);
			
			fallingObjLeft.applyRelativeAngleForce(800, 30);
			fallingObjRight.applyRelativeAngleForce( -800, -30);
			
			fallingObjLeft.applyRotation(-Math.random() * 5);
			fallingObjRight.applyRotation(Math.random() * 5);
		}

		
		override protected function applyThrust(delta:Number):void 
		{
			var mult:Number = Easing.easeOutQuad(_burstTime, BURST_MULT, -BURST_MULT, _item.statSpecial);
			var thrust:Number = power * StatHooks.boostPowerMult.value * delta * _item.getPowerAtWeightMult(_player.getBody().mass)
			_player.applyThrust(thrust * mult);
		}
		
		override protected function setupVisual():void 
		{
			leftVisual = new _item.statVisualClass();
			leftWrapper = new MultiJumpMCWrapper(leftVisual, "initStart");
			_player.getMovieClip().addChildAt(leftVisual, 0);//Add child BEHIND body

			rightVisual = new _item.statVisualClass();
			rightVisual.scaleY = -1;//Flip around
			rightWrapper = new MultiJumpMCWrapper(rightVisual, "initStart");
			_player.getMovieClip().addChildAt(rightVisual, 0);//Add child BEHIND body
		}
		
		override protected function playSound(fadeInDuration:Number = NaN):void 
		{
			//trace("playSound");
			if (_item == null) return;
			
			if (isNaN(fadeInDuration)) fadeInDuration = 300;
			
			if (_item.statSound1 != null) {
				//trace("New sound created!");
				_sound = Audio.playFadingSound(_item.statSound1, this, fadeInDuration);
				_sound.volume = _item.statSound1Volume;
			}
		}
		
		
	}

}