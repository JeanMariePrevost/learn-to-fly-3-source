package src.game.hud.huds 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import src.game.hud.HudComponent;
	import src.game.StatsOfTheDay;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class TimeWatch extends HudComponent 
	{
		public var seconds:MovieClip;
		public var minutes:MovieClip;
		
		public function TimeWatch() 
		{
			super();
			
		}
		
		override public function init():void 
		{
			Main.unsafeTickSignal.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(delta:Number):void {
			var timeInSec:Number = StatsOfTheDay.instance.newFlightTime * 0.001;
			var sec:Number = timeInSec % 60;
			var min = timeInSec / 60;
			
			seconds.rotation = NumberUtils.interpolateRotation(0, 360, sec / 60);
			minutes.rotation = NumberUtils.interpolateRotation(0, 360, min / 12);
		}
		
		override public function destroy():void 
		{
			seconds = null;
			minutes = null;
			Main.unsafeTickSignal.remove(onUpdate);
			super.destroy();
		}
		
	}

}