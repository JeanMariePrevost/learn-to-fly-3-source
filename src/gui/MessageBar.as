package src.gui {
	import flash.display.MovieClip;
	import flash.events.Event;
	import src.Main;
	import src.UiScaler;
	
	/**
	 * ...
	 * @author 
	 */
	public class MessageBar extends MovieClip 
	{
		public var bar:MessageBarBar;
		
		public function MessageBar(message:String = "(message)", topMargin:Number = 0) 
		{
			super();
			gotoAndStop(1);
			
			y = topMargin;
			bar.setMessage(message);
			
			mouseEnabled = false;
			mouseChildren = false;
			
			cacheAsBitmap = true;
			
			//Main.tick.add(tick);
			GuiSettings.guiTickSignal.add(tick);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			UiScaler.addAbsolute(this, false, 360);
		}
		
		protected function tick(delta:Number):void 
		{
			nextFrame();
			
			if (currentFrame >= totalFrames) {
				//finished
				destroy();
			}
		}
		
		public function destroy():void {
			GuiSettings.guiTickSignal.remove(tick);
			if(bar) bar.destroy();
			bar = null;
			if (stage) {
				parent.removeChild(this);
			}
			
			while (numChildren) removeChildAt(0);
		}
	}

}