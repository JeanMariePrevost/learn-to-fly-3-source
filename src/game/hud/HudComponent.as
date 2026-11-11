package src.game.hud 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import src.UiScaler;
	
	/**
	 * ...
	 * @author 
	 */
	public class HudComponent extends MovieClip 
	{
		
		public function HudComponent() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			if (x >= 360) {
				UiScaler.addAbsoluteManually(this, 720, x - 720);
				//UiScaler.addAbsoluteManually(this, 720, (UiScaler.maxWidthAtCurrentRatio - UiScaler.SCREEN_WIDTH_AT_MIN_RATIO));
			}
		}
		
		/** Hook to call to tell the HudComponent to start ticking, used to prevent bugs when customizing huds */
		public function init():void {
			
		}
		
		public function destroy():void {
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}