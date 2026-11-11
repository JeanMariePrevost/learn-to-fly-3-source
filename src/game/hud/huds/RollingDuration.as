package src.game.hud.huds 
{
	import flash.text.TextField;
	import lbg.utils.NumberUtils;
	import src.game.GameMediator;
	import src.game.hud.HudComponent;
	import src.game.StatsOfTheDay;
	import src.Main;
	/**
	 * ...
	 * @author 
	 */
	public class RollingDuration extends RollingNumbers 
	{
		
		public function RollingDuration() 
		{
			super();
			txtName.text = "Time";
			changeValue(0,0);
		}
		
		override public function init():void 
		{
			Main.unsafeTickSignal.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(delta:Number):void {
			var timeInSeconds:Number = StatsOfTheDay.instance.newFlightTime * 0.001;
			changeValue(timeInSeconds, 1);
		}
		
		override public function destroy():void 
		{
			Main.unsafeTickSignal.remove(onUpdate);
			super.destroy();
		}
		
	}

}