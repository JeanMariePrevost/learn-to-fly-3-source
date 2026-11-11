package src.game.hud.huds 
{
	import lbg.utils.NumberUtils;
	import src.game.GameMediator;
	/**
	 * ...
	 * @author 
	 */
	public class CompactDrag extends CompactBarBase 
	{
		
		public function CompactDrag() 
		{
			super();
			
			txtName.text = "Drag";
			gotoAndStop(1);
		}
		override public function init():void 
		{
			GameMediator.updatePlayerDrag.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(drag:Number):void {
			gotoAndStop(int(NumberUtils.interpolate2(1, totalFrames, 1, 0.9, drag)));
		}
		
		override public function destroy():void 
		{
			GameMediator.updatePlayerDrag.remove(onUpdate);
			super.destroy();
		}
		
		
	}

}