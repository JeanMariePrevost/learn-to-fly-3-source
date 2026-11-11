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
	public class HologramDrag extends HologramBase 
	{
		
		public function HologramDrag() 
		{
			super();
			
			txtName.text = "Drag";
			
			txtValue.text = "0";
		}
		
		override public function init():void 
		{
			GameMediator.updatePlayerDrag.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(drag:Number):void {
			txtValue.text = NumberUtils.numberDelimiter(drag, ",", 3, 3);
		}
		
		override public function destroy():void 
		{
			GameMediator.updatePlayerDrag.remove(onUpdate);
			super.destroy();
		}
		
	}

}