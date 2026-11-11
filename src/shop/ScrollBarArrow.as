package src.shop 
{
	import flash.display.MovieClip;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class ScrollBarArrow extends MovieClip 
	{
		protected const FADE_IN_SPEED:Number = 0.02;
		protected const FADE_OUT_SPEED:Number = 0.15;
		protected var _maxAlpha:Number = 0;
		
		
		public function ScrollBarArrow() 
		{
			Main.unsafeTickSignal.add(tick);
			mouseEnabled = false;
		}
		
		private function tick(delta:Number):void 
		{
			if (alpha >= _maxAlpha) {
				//Fade out
				alpha = NumberUtils.interpolate(alpha, _maxAlpha, FADE_OUT_SPEED);
			}else {
				//fade in
				alpha = NumberUtils.interpolate(alpha, _maxAlpha, FADE_IN_SPEED);
			}
			if (alpha == 0) {
				visible = false;
			}else if (!visible) {
				visible = true;
				//gotoAndPlay("mid");
			}
		}
		
		
		public function updateFromSliderPosition(norm:Number):void {
			_maxAlpha = Math.min(1, norm * 4);
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
	}

}