package src.game.hud.huds 
{
	import lbg.utils.NumberUtils;
	import src.game.GameMediator;
	import src.game.hud.HudComponent;
	import src.system.Global;
	
	/**
	 * ...
	 * @author 
	 */
	public class ProgressMeter extends HudComponent 
	{
		
		public function ProgressMeter() 
		{
			super();
			
			gotoAndStop(1);
		}
		
		override public function init():void 
		{
			GameMediator.updatePlayerAltitude.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(alt:Number):void {
			var progress:Number = alt / Global.spaceAltitude;
			
			gotoAndStop(int(NumberUtils.interpolate(1, totalFrames, progress)));
		}
		
		override public function destroy():void 
		{
			GameMediator.updatePlayerAltitude.remove(onUpdate);
			super.destroy();
		}
		
	}

}