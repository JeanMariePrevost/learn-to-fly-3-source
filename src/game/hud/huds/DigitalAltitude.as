package src.game.hud.huds {
	import flash.text.TextField;
	import lbg.utils.NumberUtils;
	import src.game.GameMediator;
	import src.game.hud.HudComponent;
	/**
	 * ...
	 * @author 
	 */
	public class DigitalAltitude extends DigitalBase 
	{
		
		public function DigitalAltitude() 
		{
			super();
			
			txtName.text = "Alt";
			
			txtValue.text = "0";
		}
		
		override public function init():void 
		{
			GameMediator.updatePlayerAltitude.add(onUpdate);
			super.init();
		}
		
		protected function onUpdate(alt:Number):void {
			txtValue.text = NumberUtils.numberDelimiter(alt);
		}
		
		override public function destroy():void 
		{
			GameMediator.updatePlayerAltitude.remove(onUpdate);
			super.destroy();
		}
		
	}

}