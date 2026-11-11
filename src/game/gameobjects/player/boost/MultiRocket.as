package src.game.gameobjects.player.boost 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import src.effects.smoketrail.SmokeTrail;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameCamera;
	import src.game.gameobjects.FallingObject;
	import src.game.gameobjects.IFallingObject;
	import src.game.gameobjects.player.Player;
	import src.game.PhysicsEngine;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	import src.system.Input;
	
	
	public class MultiRocket extends SimpleBoost 
	{
		protected var _trailLeft:SmokeTrail;
		protected var _trailRight:SmokeTrail;
		
		protected var _rocketCount:int;
		protected var _ready:Boolean;
		protected var _isOn:Boolean = false;
		
		public function MultiRocket(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			_rocketCount = _item.statBoostSlots;
			fuel.value = 0;
			_isOn = false;
			_ready = true;
		}
		
		protected function createTrails():void 
		{
			if (_trailLeft == null) {
				_trailLeft = SmokeTrail.newSmokeTrail();
				_trailLeft.color = 0xFFFFFF;
				_trailLeft.alpha = 0.5;
				_trailLeft.fadeInLength = 6;
				_trailLeft.fadeInAlpha = 0.1;
				_trailLeft.fadeInPower = 0.7;
				_trailLeft.fadeOutLegnth = 20;
				_trailLeft.pushForce = 25;
				_trailLeft.pushForceDrag = 0.85;
				_trailLeft.spreadForce = 1;
				_trailLeft.spreadForceDrag = 0.95;
				_trailLeft.fadePerTick = 0.01;
				_trailLeft.maxSegments = 50;
				_trailLeft.lineWidth = 6;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trailLeft.visual, leftVisual, -1);
			}
			
			if (_trailRight == null) {
				_trailRight = SmokeTrail.newSmokeTrail();
				_trailRight.color = 0xFFFFFF;
				_trailRight.alpha = 0.5;
				_trailRight.fadeInLength = 6;
				_trailRight.fadeInAlpha = 0.1;
				_trailRight.fadeInPower = 0.7;
				_trailRight.fadeOutLegnth = 20;
				_trailRight.pushForce = 25;
				_trailRight.pushForceDrag = 0.85;
				_trailRight.spreadForce = 1;
				_trailRight.spreadForceDrag = 0.95;
				_trailRight.fadePerTick = 0.01;
				_trailRight.maxSegments = 50;
				_trailRight.lineWidth = 6;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trailRight.visual, rightVisual, -1);
			}
		}
		
		override public function tick(delta:Number):void 
		{
			var preTickRocketCount:Number = _rocketCount;
			
			if (fuel.value > 0) {
				if(leftWrapper.currentState == "active"){
					//Boosting
					playSound(150);
					_isOn = true;
					applyThrust(delta);
				}
			}else if (!_ready) {
				if (_isOn) {
					//Boosting, but now out of fuel
					stopSound();
					_isOn = false;
					leftWrapper.gotoLabel("offStart");
					rightWrapper.gotoLabel("offStart");
				}else if (leftVisual.currentLabel == "offEnd") {
					//Off anim complete, ready for next
					dropPods();
					leftWrapper.gotoLabel("idleStart");
					rightWrapper.gotoLabel("idleStart");
					_ready = true;
				}
			}else if (_rocketCount > 0) {
				//Ready to trigger and still has rockets
				if ((Input.metaBoost.isDown || singleBoostInputIsDown)) {
					_ready = false;
					leftWrapper.gotoLabel("onStart");
					rightWrapper.gotoLabel("onStart");
					_isOn = true;
					fuel.value = _item.statFuel;
					_rocketCount --;
					_hudSignal.dispatch(_rocketCount / _item.statBoostSlots);
				}
			}else if (leftWrapper.currentState != "death") {
				leftWrapper.gotoLabel("deathStart");
				rightWrapper.gotoLabel("deathStart");
			}
			
			tickTrails(delta);
			
			if (preTickRocketCount >= 1 && _rocketCount <= 0 && fuel.value <= 0) {
				_player.updateBodyMass();
			}
		}
		
		protected function tickTrails(delta:Number):void {
			if (fuel.value <= 0) return;
			
			if (leftWrapper.currentState == "active") {
				createTrails();
				
				var p:Point = GameCamera.getPositionOnCamera(leftVisual.tBottom);
				_trailLeft.addSegment(p.x, p.y, _player.getMovieClip().rotation + 90);
				
				var p:Point = GameCamera.getPositionOnCamera(rightVisual.tBottom);
				_trailRight.addSegment(p.x, p.y, _player.getMovieClip().rotation + 90);
				
			}else {
				_trailLeft = null;
				_trailRight = null;
			}
		}
		protected function dropPods():void {
			var leftMc:MovieClip = leftVisual.pod;
			var rightMc:MovieClip = rightVisual.pod;
			
			DisplayObjectUtil.changeContainer(leftMc, GameCamera.instance.getMovingLayer(1));
			DisplayObjectUtil.changeContainer(rightMc, GameCamera.instance.getMovingLayer(1));
			
			var fallingObjLeft:IFallingObject = FallingObject.getNewFallingObject(leftMc);
			var fallingObjRight:IFallingObject = FallingObject.getNewFallingObject(rightMc);
			fallingObjLeft.setPhysicsEngine(PhysicsEngine.instance);
			fallingObjRight.setPhysicsEngine(PhysicsEngine.instance);
			
			fallingObjLeft.mimicBodyMomentum(_player.getBody(), 0.8, 3.5);
			fallingObjRight.mimicBodyMomentum(_player.getBody(), 0.8, 3.5);
			
			fallingObjLeft.applyRelativeAngleForce(300, 90);
			fallingObjRight.applyRelativeAngleForce( -300, -90);
			
			fallingObjLeft.applyRotation(-Math.random() * 10);
			fallingObjRight.applyRotation(Math.random() * 10);
		}

		
		override protected function applyThrust(delta:Number):void 
		{
			var thrust:Number = power * StatHooks.boostPowerMult.value * delta * _item.getPowerAtWeightMult(_player.getBody().mass)
			_player.applyThrust(thrust);
			fuel.value -= delta;
		}
		
		override protected function setupVisual():void 
		{
			leftVisual = new _item.statVisualClass();
			leftWrapper = new MultiRocketMCWrapper(leftVisual, "initStart");
			_player.getMovieClip().addChildAt(leftVisual, 0);//Add child BEHIND body

			rightVisual = new _item.statVisualClass();
			rightVisual.scaleY = -1;//Flip around
			rightWrapper = new MultiRocketMCWrapper(rightVisual, "initStart");
			_player.getMovieClip().addChildAt(rightVisual, 0);//Add child BEHIND body
		}
		
		override public function get preventDayEnd():Boolean 
		{
			return _isOn;
		}
		
		override public function get weight():Number 
		{
			if (_rocketCount <= 0) {
				return 0;
			}else {
				return _item.statWeight;
			}
		}
		
		
	}

}