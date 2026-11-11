package src.game.hud.huds {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import lbg.components.NumberBuffer;
	import lbg.utils.NumberUtils;
	import src.game.GameEngine;
	import src.game.GameMediator;
	import src.game.gameobjects.player.Player;
	import src.game.hud.HudComponent;
	/**
	 * ...
	 * @author 
	 */
	public class SpeedNeedleHud extends HudComponent
	{
		public var txt1:TextField;
		public var txt2:TextField;
		public var txt3:TextField;
		public var txt4:TextField;
		public var txt5:TextField;
		public var speedNeedle:MovieClip;
		
		protected var _minNeedleAngle:Number;
		protected var _topSpeedNeedleAngle:Number;
		protected var _maxNeedleAngle:Number;
		protected var _maxSpeed:Number;
		
		protected var _needleAdjustSpeed:Number ;//Speed at which the needle moves, 0-1
		
		
		public function SpeedNeedleHud() 
		{
			_minNeedleAngle = -135;
			_topSpeedNeedleAngle = 45;
			_maxNeedleAngle = 135;
			
			_needleAdjustSpeed = 0.05;
			
		}
		
		override public function init():void 
		{
			_maxSpeed = GameEngine.instance.player.topSpeed;
			GameMediator.updatePlayerSpeed.add(onPlayerSpeed);
			updateSpeedTexts();
			super.init();
		}
		
		protected function updateSpeedTexts():void {
			txt1.text = Math.round(_maxSpeed * 0.25).toFixed();
			txt2.text = Math.round(_maxSpeed * 0.50).toFixed();
			txt3.text = Math.round(_maxSpeed * 0.75).toFixed();
			txt4.text = Math.round(_maxSpeed * 1.00).toFixed();
			txt5.text = Math.round(_maxSpeed * 1.25).toFixed();
		}
		
		protected function onPlayerSpeed(speed:Number, angleInDegrees:Number):void {
			var targetAngle:Number = NumberUtils.interpolate2(_minNeedleAngle, _topSpeedNeedleAngle, 0, _maxSpeed, speed, 1, false);
			targetAngle = NumberUtils.constrain(targetAngle, _minNeedleAngle, _maxNeedleAngle);
			speedNeedle.rotation -= (speedNeedle.rotation - targetAngle) * _needleAdjustSpeed;
		}
		
		override public function destroy():void 
		{
			GameMediator.updatePlayerSpeed.remove(onPlayerSpeed);
			txt1 = null;
			txt2 = null;
			txt3 = null;
			txt4 = null;
			txt5 = null;
			speedNeedle = null;
			
			super.destroy();
		}
		
	}

}