package src.game.hud.huds 
{
	import lbg.utils.NumberUtils;
	import src.game.GameMediator;
	import src.game.hud.HudComponent;
	
	/**
	 * ...
	 * @author 
	 */
	public class DragNeedle extends HudComponent 
	{
		
		public function DragNeedle() 
		{
			super();
			
			gotoAndStop(1);
		}
		
		override public function init():void 
		{
			GameMediator.updatePlayerDrag.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(drag:Number):void {
			//trace("Drag:", drag);
			gotoAndStop(int(NumberUtils.interpolate2(1, totalFrames, 1, 0.92, drag)));
		}
		
		override public function destroy():void 
		{
			GameMediator.updatePlayerDrag.remove(onUpdate);
			super.destroy();
		}
		
	}

}