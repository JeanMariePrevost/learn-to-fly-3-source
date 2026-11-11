package src.gui.progress 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.Main;
	import src.system.Global;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author 
	 */
	public class MainScreenClassic extends AbstractMainScreen 
	{
		public var progress:MovieClip;
		public var txtBest:TextField;
		
		protected var _time:Number = 0;
		protected var _duration:Number = 90;
		protected var _targetFrame:Number = 1;
		
		public function MainScreenClassic() 
		{
			super();
			
			_targetFrame = Math.round(NumberUtils.interpolate2(1, progress.totalFrames, 0, Global.classicModeGoal, ProfileState.instance.currentGameState.classicTopDistance.value, 0.9));
			
			txtBest.text = NumberUtils.numberDelimiter(ProfileState.instance.currentGameState.classicTopDistance.value);
			
			Main.guiTickSignal.add(tick);
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
		
		override public function destroy():void {
			Main.guiTickSignal.remove(tick);
			
			progress = null;
			txtBest = null;
			
			super.destroy();
		}
		
	}

}