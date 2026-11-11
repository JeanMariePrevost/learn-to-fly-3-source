package src.customization 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import src.gui.decorators.MouseBounce2;
	
	/**
	 * ...
	 * @author 
	 */
	public class HudPresetsButton extends MovieClip 
	{
		
		protected var _bounce:MouseBounce2;
		
		public function HudPresetsButton() 
		{
			super();
			
			_bounce = new MouseBounce2(this);
			_bounce.scaleMod = 0.05;
		}
		
		public function destroy():void 
		{
			if(_bounce) _bounce.destroy();
			_bounce = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}