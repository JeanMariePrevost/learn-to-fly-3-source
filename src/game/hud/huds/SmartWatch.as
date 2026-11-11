package src.game.hud.huds 
{
	import flash.text.TextField;
	import lbg.utils.NumberUtils;
	import src.game.GameMediator;
	import src.game.hud.HudComponent;
	
	/**
	 * ...
	 * @author 
	 */
	public class SmartWatch extends HudComponent 
	{
		
		public var txtSpeed:TextField;
		public var txtDrag:TextField;
		public var txtAltitude:TextField;
		
		public function SmartWatch() 
		{
			super();
			
			txtSpeed.text = "0";
			txtDrag.text = "0.00";
			txtAltitude.text = "0k";
		}
		
		override public function init():void 
		{
			GameMediator.updatePlayerSpeed.add(onSpeed);
			GameMediator.updatePlayerDrag.add(onDrag);
			GameMediator.updatePlayerAltitude.add(onAltitude);
			super.init();
		}
		
		protected function onSpeed(speed:Number, angleInDegrees:Number):void {
			txtSpeed.text = NumberUtils.numberDelimiter(speed);
		}
		
		protected function onDrag(drag:Number):void {
			txtDrag.text = NumberUtils.numberDelimiter(drag, ",", 3, 2);
		}
		
		protected function onAltitude(alt:Number):void {
			var thousands:Number = Math.floor(alt / 1000);
			txtAltitude.text = NumberUtils.numberDelimiter(thousands) + "k";
		}
		
		override public function destroy():void 
		{
			txtSpeed = null;
			txtDrag = null;
			txtAltitude = null;
			
			GameMediator.updatePlayerSpeed.remove(onSpeed);
			GameMediator.updatePlayerDrag.remove(onDrag);
			GameMediator.updatePlayerAltitude.remove(onAltitude);
			
			super.destroy();
		}
		
		
	}

}