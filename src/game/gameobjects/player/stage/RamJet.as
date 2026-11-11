package src.game.gameobjects.player.stage 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.effects.LineTrail;
	import src.effects.smoketrail.SmokeTrail;
	import src.game.GameCamera;
	import src.game.gameobjects.player.Player;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class RamJet extends Banshee 
	{
		protected var _trailLeft:SmokeTrail;
		protected var _trailRight:SmokeTrail;
		
		//Used to maintain IDE fire scaling
		protected var _baseScaleX:Number;
		protected var _baseScaleY:Number;
		
		protected var _speedNorm:Number;//Power mult from speed
		
		public function RamJet(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override public function startStage():void 
		{
			super.startStage();
			
			if ("fire" in _visualLeft) {
				_baseScaleX = _visualLeft.fire.scaleX;
				_baseScaleY = _visualLeft.fire.scaleY;
				
				_visualLeft.fire.visible = false;
				_visualRight.fire.visible = false;
			}
		}
		
		
		override protected function applyPower(delta:Number, forceThrustRelativeAngle:Number = NaN):void 
		{
			var p:Number = power * delta * _item.getPowerAtWeightMult(_player.getBody().mass) * StatHooks.stagePowerMult.value;
			
			//Special!
			var targetSpeed:Number = _item.statTopSpeed;
			_speedNorm = NumberUtils.constrain(_player.speed / targetSpeed);
			var multFromSpeed:Number = Easing.easeInQuad(_speedNorm, _item.statSpecial, 1 - _item.statSpecial, 1);
			//trace("Speed mult:", multFromSpeed);
			//trace("Player speed:", _player.speed);
			//trace("Resulting power:", p * multFromSpeed);
			
			//trace("//Stage thrust debug//////////////////////////////")
			//trace("Base power:", power, "  Passive boostPowerMult:", StatHooks.stagePowerMult.value, "  Power At Weight:", _item.getPowerAtWeightMult(_player.getBody().mass));
			//trace("Stage thrust:", p, "Mass:", _player.getBody().mass);
			
			_player.applyThrust(p * multFromSpeed);
		}
		
		protected function createTrails():void 
		{
			if (_trailLeft == null) {
				_trailLeft = SmokeTrail.newSmokeTrail();
				_trailLeft.color = 0xBBEBFF;
				_trailLeft.alpha = 1;
				_trailLeft.fadeInLength = 6;
				_trailLeft.fadeInAlpha = 0.1;
				_trailLeft.fadeInPower = 0.7;
				_trailLeft.fadeOutLegnth = 20;
				_trailLeft.pushForce = 20;
				_trailLeft.pushForceDrag = 0.95;
				_trailLeft.spreadForce = 0.9;
				_trailLeft.fadePerTick = 0.025;
				_trailLeft.maxSegments = 50;
				_trailLeft.lineWidth = 20;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trailLeft.visual, _visualLeft, -1);
			}
			
			if (_trailRight == null) {
				_trailRight = SmokeTrail.newSmokeTrail();
				_trailRight.color = 0xBBEBFF;
				_trailRight.alpha = 1;
				_trailRight.fadeInLength = 6;
				_trailRight.fadeInAlpha = 0.1;
				_trailRight.fadeInPower = 0.7;
				_trailRight.fadeOutLegnth = 20;
				_trailRight.pushForce = 20;
				_trailRight.pushForceDrag = 0.95;
				_trailRight.spreadForce = 0.9;
				_trailRight.fadePerTick = 0.025;
				_trailRight.maxSegments = 50;
				_trailRight.lineWidth = 20;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trailRight.visual, _visualRight, -1);
			}
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (_isFinished) return;
			
			if (_wrapperLeft.currentState == "on" || _wrapperLeft.currentState == "active") {
				createTrails();
				
				var p:Point = GameCamera.getPositionOnCamera(_visualLeft.tBottom);
				_trailLeft.addSegment(p.x, p.y, _player.getMovieClip().rotation + 90);
				
				var p:Point = GameCamera.getPositionOnCamera(_visualRight.tBottom);
				_trailRight.addSegment(p.x, p.y, _player.getMovieClip().rotation + 90);
				
				if ("fire" in _visualLeft) {
					_visualLeft.fire.visible = true;
					_visualRight.fire.visible = true;
					
					var xScale:Number = _baseScaleX * NumberUtils.randomRange(0.97, 1.03);
					var yScale:Number = _baseScaleY * NumberUtils.randomRange(0.95, 1.1) * NumberUtils.interpolate2(0.25,1.2,0,1,_speedNorm,1.4);
					_visualLeft.fire.scaleX = xScale;
					_visualLeft.fire.scaleY = yScale;
					_visualRight.fire.scaleX = xScale;
					_visualRight.fire.scaleY = yScale;
				}
			}else {
				if (_visualLeft) {
					if ("fire" in _visualLeft) {
						_visualLeft.fire.visible = false;
						_visualRight.fire.visible = false;
					}
				}
				_trailLeft = null;
				_trailRight = null;
			}
		}
		
		override protected function doDeath():void 
		{
			if ("fire" in _visualLeft) {
				_visualLeft.fire.visible = false;
				_visualRight.fire.visible = false;
			}
			super.doDeath();
		}
		
		override protected function playSound(fadeInDuration:Number = NaN):void 
		{
			if (isNaN(fadeInDuration)) fadeInDuration = 100;
			super.playSound(fadeInDuration);
		}
		
		override protected function stopSound(fadeOutDuration:Number = NaN):void 
		{
			if (isNaN(fadeOutDuration)) fadeOutDuration = 100;
			super.stopSound(fadeOutDuration);
		}
		
		
	}

}