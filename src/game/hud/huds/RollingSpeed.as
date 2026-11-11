package src.game.hud.huds 
{
	import flash.text.TextField;
	import lbg.utils.NumberUtils;
	import src.game.GameMediator;
	import src.game.hud.HudComponent;
	/**
	 * ...
	 * @author 
	 */
	public class RollingSpeed extends RollingNumbers 
	{
		
		public function RollingSpeed() 
		{
			super();
			
			
			txtName.text = "Speed";
			changeValue(0);
		}
		
		override public function init():void 
		{
			GameMediator.updatePlayerSpeed.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(speed:Number, angleInDegrees:Number):void {
			changeValue(speed);
		}
		
		override public function destroy():void 
		{
			GameMediator.updatePlayerSpeed.remove(onUpdate);
			super.destroy();
		}
		
		
	}

}