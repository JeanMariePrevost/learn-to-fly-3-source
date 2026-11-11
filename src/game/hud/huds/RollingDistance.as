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
	public class RollingDistance extends RollingNumbers 
	{
		
		public function RollingDistance() 
		{
			super();
			
			txtName.text = "Distance";
			changeValue(0, 0);
		}
		
		override public function init():void 
		{
			GameMediator.updatePlayerPosition.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(x:Number, y:Number):void {
			changeValue(x, 0);
		}
		
		override public function destroy():void 
		{
			GameMediator.updatePlayerPosition.remove(onUpdate);
			super.destroy();
		}
		
		
	}

}