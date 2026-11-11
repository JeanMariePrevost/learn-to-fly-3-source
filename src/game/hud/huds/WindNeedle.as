package src.game.hud.huds 
{
	import lbg.utils.NumberUtils;
	import src.game.hud.HudComponent;
	import src.game.WindEngine;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class WindNeedle extends HudComponent 
	{
		
		public function WindNeedle() 
		{
			super();
			
			gotoAndStop(200);
		}
		
		override public function init():void 
		{
			Main.unsafeTickSignal.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(delta:Number):void {
			var wind:Number = WindEngine.wind;
			if (wind >= 0) {
				gotoAndStop(Math.round(NumberUtils.interpolate2(200, 400, 0, 10, wind)));
			}else {
				gotoAndStop(Math.round(NumberUtils.interpolate2(200, 1, 0, -10, wind)));
			}
			
		}
		
		override public function destroy():void 
		{
			Main.unsafeTickSignal.remove(onUpdate);
			super.destroy();
		}
		
	}

}