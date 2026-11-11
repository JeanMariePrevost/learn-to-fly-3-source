package src.shop 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author 
	 */
	public class ShopHintScreen extends MovieClip 
	{
		public var scanlines:MovieClip;
		public var tvSweep:MovieClip;
		
		
		public function ShopHintScreen() 
		{
			super();
			
			init();
		}
		
		protected function init():void {
			scanlines.cacheAsBitmap = true;
			scanlines.mouseEnabled = scanlines.mouseChildren = false;
		}
		
		
		
		public function destroy():void {
			
			
			
			
			scanlines = null;
			tvSweep = null;
			
			if (stage) parent.removeChild(this);
			while (numChildren >= 1) removeChildAt(0);
		}
		
	}

}