package src.game.hud.huds 
{
	import lbg.utils.NumberUtils;
	import src.game.GameMediator;
	/**
	 * ...
	 * @author 
	 */
	public class DigitalDistance extends DigitalBase 
	{
		
		public function DigitalDistance() 
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