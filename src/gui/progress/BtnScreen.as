package src.gui.progress 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import src.Main;
	import src.ScreenManager;
	import src.audio.Sfx;
	import src.gui.ScreenBlurEffect;
	import src.gui.Transition;
	import src.gui.decorators.MouseBounce2;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class BtnScreen extends MovieClip 
	{
		public var btnTakeoff:MovieClip;
		public var btnBack:MovieClip;
		
		public var bounceReady:MouseBounce2;
		public var bounceBack:MouseBounce2;
		private var _tookOff:Boolean = false;
		
		
		public function BtnScreen() 
		{
			super();
			
		}
		
		public function init():void {
			gotoAndStop(2);
			btnTakeoff.gotoAndStop(1);
			bounceReady = new MouseBounce2(btnTakeoff);
			bounceReady.signalClickTarget.add(onTakeoff);
			Input.readyAbort.signalCommandDown.add(onTakeoff2);

			bounceBack = new MouseBounce2(btnBack);
			bounceBack.signalClickTarget.add(onBack);
		}
		
		public function onTakeoff2():void {
			if (Input.instance.basicCommands.alt.isDown == false) onTakeoff(btnTakeoff);//Not if alt to prevent alt-enter from triggering it
			
		}
		
		public function onTakeoff(target:DisplayObject):void {
			if (_tookOff) return;
			_tookOff = true;
			Sfx.playButtonClick();
			finalizeAndGoToGameEngine();
		}
		
		protected function finalizeAndGoToGameEngine():void {
			switch(ProfileState.instance.currentGameState.gameMode) {
				case "Story Mode":
				default:
					Transition.transitionTo(StoryProgressScreen.destroy, ScreenManager.loadGame);
					break;
				case "Payload Mode":
					Transition.transitionTo(StoryProgressScreen.destroy, ScreenManager.loadGamePayloadMode);
					break;
				case "Classic Mode":
					Transition.transitionTo(StoryProgressScreen.destroy, ScreenManager.loadGameClassicMode);
					break;
				case "Sandbox":
					Transition.transitionTo(StoryProgressScreen.destroy, ScreenManager.loadGameSandboxMode);
					break;
			}
		}
		
		
		public function onBack(target:DisplayObject):void {
			Transition.transitionTo(StoryProgressScreen.destroy, ScreenManager.loadShop);
		}
		
		public function destroy():void {
			
			Input.readyAbort.signalCommandDown.remove(onTakeoff2);
			
			btnTakeoff = null;
			btnBack = null;
			
			
			
			
			if (bounceBack) bounceBack.destroy();
			bounceBack = null;
			
			if (bounceReady) bounceReady.destroy();
			bounceReady = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}