package src.shop 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class CashPopup extends MovieClip 
	{
		public const MOVE_DISTANCE:Number = -50;
		
		public var txtCash:TextField;
		
		public var duration:int = 130;
		public var time:int = -1;
		
		protected var _startY:Number;
		
		public function CashPopup(cash:Number, X:Number = 0, Y:Number = 0) 
		{
			
			txtCash.text = "$ " + NumberUtils.numberDelimiter(cash);
			if (cash < 0) {
				txtCash.textColor = 0xFF0000;
			}
			x = X;
			y = _startY = Y;
			
			Main.unsafeTickSignal.add(tick);
			
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		private function tick(delta:Number):void 
		{
			time ++;
			y = Easing.easeOutQuad(time, _startY, MOVE_DISTANCE, duration);
			alpha = Easing.easeOutQuad(time, 2, -2, duration);
			
			if (time >= duration) {
				//Anim finished
				Main.unsafeTickSignal.remove(tick);
				if (stage) {
					txtCash = null;
					while (numChildren >= 1) removeChildAt(0);
					parent.removeChild(this);
				}
			}
			
		}
		
	}

}