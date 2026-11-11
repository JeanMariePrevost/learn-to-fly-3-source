package src.customization 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	import src.reg.RegistryEntry;
	
	/**
	 * ...
	 * @author 
	 */
	public class HudDraggable extends MovieClip 
	{
		public var mouseDownSignal:Signal = new Signal(HudDraggable);
		public var hudMovieClip:MovieClip;
		public var hudEntry:RegistryEntry;
		
		
		public function HudDraggable(hudComponent:MovieClip, hudEntry:RegistryEntry) 
		{
			this.hudEntry = hudEntry;
			
			hudMovieClip = hudComponent;
			addChild(hudMovieClip);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
			
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			e.stopPropagation();
			mouseDownSignal.dispatch(this);
		}
		
		public function destroy():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
			if(mouseDownSignal) mouseDownSignal.removeAll();
			mouseDownSignal = null;
			
			if (hudMovieClip) {
				while (hudMovieClip.numChildren >= 1) hudMovieClip.removeChildAt(0);
				if (hudMovieClip.parent) hudMovieClip.parent.removeChild(hudMovieClip);
			}
			
			hudMovieClip = null;
			hudEntry = null;
			
			while (numChildren >= 1) {
				removeChildAt(0);
			}
			
			if (parent) parent.removeChild(this);
		}
		
	}

}