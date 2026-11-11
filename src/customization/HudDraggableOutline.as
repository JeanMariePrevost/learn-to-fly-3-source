package src.customization 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import lbg.utils.Tools;
	
	/**
	 * ...
	 * @author 
	 */
	public class HudDraggableOutline extends Sprite 
	{
		protected var _clone:MovieClip;
		
		public function HudDraggableOutline(hud:MovieClip) 
		{
			var c:Class = Tools.getClassOf(hud);
			
			mouseEnabled = mouseChildren = false;
			
			_clone = new c();
			addChild(_clone);
			setToStrongOutline();
		}
		
		public function setToStrongOutline():void {
			filters = [new GlowFilter(0xFFFFFF, 1, 3, 3, 1.9, 1, true, true)];
		}
		
		public function setToWeakOutline():void {
			filters = [new GlowFilter(0xFFFFFF, 0.9, 3, 3, 1.5, 1, true, true)];
		}
		
		public function destroy():void {
			_clone = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}