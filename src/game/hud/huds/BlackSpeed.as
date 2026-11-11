package src.game.hud.huds 
{
	import flash.text.TextField;
	import src.game.hud.HudComponent;
	import lbg.utils.NumberUtils;
	import src.game.GameEngine;
	import src.game.GameMediator;
	import src.game.gameobjects.player.Player;
	
	/**
	 * ...
	 * @author 
	 */
	public class BlackSpeed extends HudComponent 
	{
		public var txtMin:TextField;
		public var txtMax:TextField;
		
		protected var _maxSpeed:Number = 0;
		
		public function BlackSpeed() 
		{
			super();
			
			gotoAndStop(1);
		}
		
		override public function init():void 
		{
			_maxSpeed = GameEngine.instance.player.topSpeed;
			GameMediator.updatePlayerSpeed.add(onPlayerSpeed);
			txtMin.text = "0";
			txtMax.text = _maxSpeed.toFixed(0);
		}
		
		protected function onPlayerSpeed(speed:Number, angleInDegrees:Number):void {
			gotoAndStop(Math.round(NumberUtils.interpolate2(1, totalFrames, 0, _maxSpeed * 1.54, speed)));
			
		}
		
		override public function destroy():void 
		{
			GameMediator.updatePlayerSpeed.remove(onPlayerSpeed);
			txtMin = null;
			txtMax = null;
			
			super.destroy();
		}
	}

}