package src.customization 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import src.gui.decorators.MouseBounce2;
	
	/**
	 * ...
	 * @author 
	 */
	public class HudUnlockButton extends MovieClip 
	{
		
		public var txtValue:TextField;
		
		protected var _bounce:MouseBounce2;
		
		public function HudUnlockButton() 
		{
			super();
			
			_bounce = new MouseBounce2(this);
			_bounce.scaleMod = 0.05;
			
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		private function removed(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			txtValue = null;
			if(_bounce) _bounce.destroy();
			_bounce = null;
		}
		
	}

}