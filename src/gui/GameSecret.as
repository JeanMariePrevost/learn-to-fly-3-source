package src.gui 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import src.Main;
	import src.ScreenManager;
	import src.UiScaler;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameSecret extends MovieClip 
	{
		
		protected static var _instance:GameSecret;
		
		public function GameSecret() 
		{
			super();
			
			
			Input.instance.basicCommands.anyKeyOrMouse.signalCommandDown.add(onKeyDown);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			UiScaler.addAbsoluteManually(this, 360, -360);
		}
		
		protected function onKeyDown():void {
			if (currentFrame >= 190) {
				Input.instance.basicCommands.anyKeyOrMouse.signalCommandDown.remove(onKeyDown);
				Transition.transitionTo(destroy, ScreenManager.loadMainMenu);
			}
		}
		
		public function destroy():void {
			_instance = null;
			
			Input.instance.basicCommands.anyKeyOrMouse.signalCommandDown.remove(onKeyDown);
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
		static public function get instance():GameSecret 
		{
			if (_instance == null) {
				_instance = new GameSecret();
			}
			return _instance;
		}
		
		static public function destroy():void {
			if (_instance) {
				_instance.destroy();
			}
		}
	}

}