package src.game.hud.huds {
	import flash.text.TextField;
	import lbg.utils.NumberUtils;
	import src.game.GameMediator;
	import src.game.hud.HudComponent;
	import src.game.WindEngine;
	import src.Main;
	/**
	 * ...
	 * @author 
	 */
	public class DigitalWind extends DigitalBase 
	{
		
		public function DigitalWind() 
		{
			super();
			
			txtName.text = "Wind";
			
			txtValue.text = "0";
		}
		
		override public function init():void 
		{
			Main.unsafeTickSignal.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(delta:Number):void {
			txtValue.text = NumberUtils.numberDelimiter(WindEngine.wind);
		}
		
		override public function destroy():void 
		{
			Main.unsafeTickSignal.remove(onUpdate);
			super.destroy();
		}
		
	}

}