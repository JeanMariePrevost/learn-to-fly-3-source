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
	public class HologramDuration extends HologramBase 
	{
		
		public function HologramDuration() 
		{
			super();
			
			txtName.text = "Flight Time";
			
			txtValue.text = "0";
		}
		
		override public function init():void 
		{
			Main.unsafeTickSignal.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(delta:Number):void {
			var timeInSeconds:Number = StatsOfTheDay.instance.newFlightTime * 0.001;
			txtValue.text = NumberUtils.numberDelimiter(timeInSeconds, ",", 10, 1);
		}
		
		override public function destroy():void 
		{
			Main.unsafeTickSignal.remove(onUpdate);
			super.destroy();
		}
		
	}

}