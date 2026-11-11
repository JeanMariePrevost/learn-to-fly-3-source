package src.spaceinvader 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import src.audio.Sfx;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameOver extends MovieClip 
	{
		public var txtScore:TextField;
		public var txtHighscore:TextField;
		
		protected var _timer:Number = 0;
		
		public function GameOver(score:Number, highscore:Number) 
		{
			super();
			
			txtScore.text = score.toFixed(0);
			txtHighscore.text = highscore.toFixed(0);
			
			_timer = getTimer();
			
			Input.instance.basicCommands.anyKey.signalCommandDown.add(onAnyKey);
		}
		
		private function onAnyKey():void 
		{
			if (getTimer() - _timer >= 1000) {
				Input.instance.basicCommands.anyKey.signalCommandDown.remove(onAnyKey);
				SpaceInvader.instance.startIntro(true);
				destroy();
			}
		}
		
		public function destroy():void {
			txtScore = null;
			txtHighscore = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}