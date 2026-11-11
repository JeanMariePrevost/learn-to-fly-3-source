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
	public class BabyDrag extends BabyAltitude 
	{
		
		public function BabyDrag() 
		{
			super();
			
			txtName.text = "Drag";
		}
		
		override public function init():void 
		{
			GameMediator.updatePlayerDrag.add(onUpdate);
			//super.init();
		}
		
		override protected function onUpdate(drag:Number):void {
			txtValue.text = NumberUtils.numberDelimiter(1 - drag, ",", 3, 3);
		}
		
		override public function destroy():void 
		{
			super.destroy();
			GameMediator.updatePlayerDrag.remove(onUpdate);
		}
		
	}

}