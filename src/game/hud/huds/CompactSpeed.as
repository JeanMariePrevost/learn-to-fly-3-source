package src.game.hud.huds 
{
	import lbg.utils.NumberUtils;
	import src.game.GameEngine;
	import src.game.GameMediator;
	/**
	 * ...
	 * @author 
	 */
	public class CompactSpeed extends CompactBarBase 
	{
		
		protected var _maxSpeed:Number;
		
		public function CompactSpeed() 
		{
			super();
			
			txtName.text = "Speed";
			
			gotoAndStop(1);
		}
		override public function init():void 
		{
			_maxSpeed = GameEngine.instance.player.topSpeed;
			GameMediator.updatePlayerSpeed.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(speed:Number, angleInDegrees:Number):void {
			if (speed <= _maxSpeed) {
				gotoAndStop(int(NumberUtils.interpolate2(1, 400, 0, _maxSpeed, speed)));
			}else {
				gotoAndStop(int(NumberUtils.interpolate2(401, 800, _maxSpeed, _maxSpeed * 2, speed)));
			}
		}
		
		override public function destroy():void 
		{
			GameMediator.updatePlayerSpeed.remove(onUpdate);
			super.destroy();
		}
		
	}

}