package src.game.classicmode 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.ScreenManager;
	import src.gui.Transition;
	import src.Main;
	import src.system.Global;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ClassicProgressScreen extends MovieClip 
	{
		protected static var _instance:ClassicProgressScreen;
		
		public var progress:MovieClip;
		public var txtBest:TextField;
		
		protected var _time:Number = 0;
		protected var _duration:Number = 90;
		protected var _targetFrame:Number = 1;
		
		public function ClassicProgressScreen(singleton:Enforcer) 
		{
			super();
			
			_targetFrame = Math.round(NumberUtils.interpolate2(1, progress.totalFrames, 0, Global.classicModeGoal, ProfileState.instance.currentGameState.classicTopDistance.value, 0.9));
			
			txtBest.text = NumberUtils.numberDelimiter(ProfileState.instance.currentGameState.classicTopDistance.value);
			
			Main.guiTickSignal.add(tick);
			
			Input.instance.basicCommands.anyKeyOrMouse.signalCommandDown.addOnce(onKeyPress);
		}
		
		protected function onKeyPress():void {
			Transition.transitionTo(destroy, ScreenManager.loadGameClassicMode);
		}
		
		protected function tick(delta:Number):void {
			if (stage) {
				progress.gotoAndStop(Math.round(Easing.easeOutQuart(_time, 1, _targetFrame - 1, _duration)));
				
				_time += delta;
				
				if (_time >= _duration) {
					progress.gotoAndStop(_targetFrame);
					Main.guiTickSignal.remove(tick);
				}
			}
		}
		
		public static function get instance():ClassicProgressScreen {
			if (_instance == null) {
				_instance = new ClassicProgressScreen(new Enforcer());
			}
			
			return _instance;
		}
		
		public static function destroy():void {
			if (_instance) {
				_instance.destroy();
			}
		}
		
		public function destroy():void {
			Main.guiTickSignal.remove(tick);
			
			_instance = null;
			
			progress = null;
			txtBest = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
		
	}

}

class Enforcer { }
