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
	public class HologramDistance extends HologramBase 
	{
		
		public function HologramDistance() 
		{
			super();
			
			txtName.text = "Dist";
			
			txtValue.text = "0";
		}
		
		override public function init():void 
		{
			GameMediator.updatePlayerPosition.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(x:Number, y:Number):void {
			txtValue.text = NumberUtils.numberDelimiter(x);
		}
		
		override public function destroy():void 
		{
			GameMediator.updatePlayerPosition.remove(onUpdate);
			super.destroy();
		}
		
	}

}