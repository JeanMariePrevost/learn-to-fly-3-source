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
	public class RollingAltitude extends RollingNumbers 
	{
		
		public function RollingAltitude() 
		{
			super();
			
			txtName.text = "Altitude";
			changeValue(0, 0);
		}
		
		override public function init():void 
		{
			GameMediator.updatePlayerAltitude.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(alt:Number):void {
			changeValue(alt, 0);
		}
		
		override public function destroy():void 
		{
			GameMediator.updatePlayerAltitude.remove(onUpdate);
			super.destroy();
		}
		
	}

}