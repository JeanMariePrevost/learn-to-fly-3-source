package src.game.hud.huds 
{
	import lbg.utils.NumberUtils;
	import src.game.GameMediator;
	/**
	 * ...
	 * @author 
	 */
	public class BabyDistance extends BabyAltitude 
	{
		
		public function BabyDistance() 
		{
			super();
			
			txtName.text = "Distance";
		}
		
		override public function init():void 
		{
			GameMediator.updatePlayerPosition.add(onUpdate2);
			super.init();
		}
		
		protected function onUpdate2(x:Number, y:Number):void {
			txtValue.text = NumberUtils.numberDelimiter(x);
		}
		
		override protected function onUpdate(alt:Number):void 
		{
			//super.onUpdate(alt);
		}
		
		override public function destroy():void 
		{
			GameMediator.updatePlayerPosition.remove(onUpdate2);
			super.destroy();
		}
		
	}

}