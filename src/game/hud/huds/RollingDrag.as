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
	public class RollingDrag extends RollingNumbers 
	{
		
		public function RollingDrag() 
		{
			super();
			
			txtName.text = "Drag";
			changeValue(0, 2);
		}
		
		override public function init():void 
		{
			GameMediator.updatePlayerDrag.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(drag:Number):void {
			changeValue(drag, 3);
		}
		
		override public function destroy():void 
		{
			GameMediator.updatePlayerDrag.remove(onUpdate);
			super.destroy();
		}
		
	}

}