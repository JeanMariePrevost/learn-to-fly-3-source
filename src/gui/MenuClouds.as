package src.gui 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.UiScaler;
	
	/**
	 * ...
	 * @author 
	 */
	public class MenuClouds extends MovieClip 
	{
		public var vx:Number;
		
		
		public function MenuClouds() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			randomize();
			
			x = (UiScaler.maxWidthAtCurrentRatio + 400) * Math.random() - 100;
			y = - 50 + ((UiScaler.UNSCALED_STAGE_HEIGHT + 100) * Math.random());
			
			GuiSettings.guiTickSignal.add(tick);
		}
		
		protected function tick(delta:Number):void 
		{
			x += vx;
			
			if (getBounds(parent).right <= - 40) {
				randomize();
				x = UiScaler.maxWidthAtCurrentRatio + (100 * Math.random() + 400);
				y = - 20 + ((UiScaler.UNSCALED_STAGE_HEIGHT + 40) * Math.random());
				
				//trace("Cloud randomized:", x, y, vx);
			}
		}
		
		public function randomize():void {
			gotoAndStop(Math.ceil(totalFrames));
			scaleX = scaleY = 0.4 + (Math.random() * 0.9);
			vx = NumberUtils.randomRange(-3,-6) * scaleX;
			
			alpha = scaleX;
			
			//DisplayObjectUtil.setObjectTint(this, 0xCCE0FF, 1.3 - scaleX);
		}
		
		public function destroy():void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			GuiSettings.guiTickSignal.remove(tick);
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}