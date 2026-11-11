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
	public class BabyDuration extends BabyAltitude 
	{
		
		public function BabyDuration() 
		{
			super();
			
			txtName.text = "Flight Time";
		}
		
		override public function init():void 
		{
			Main.unsafeTickSignal.add(onUpdate);
			super.init();
		}
		
		override protected function onUpdate(delta:Number):void {
			if (txtValue) {
				var timeInSeconds:Number = StatsOfTheDay.instance.newFlightTime * 0.001;
				txtValue.text = NumberUtils.numberDelimiter(timeInSeconds, ",", 10, 1);
			}
		}
		
	}

}