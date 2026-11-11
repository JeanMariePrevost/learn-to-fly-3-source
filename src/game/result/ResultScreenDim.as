package src.game.result 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import lbg.utils.DisplayObjectUtil;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class ResultScreenDim extends MovieClip 
	{
		
		public function ResultScreenDim() 
		{
			super();
			
			Main.guiTickSignal.add(tick);
		}
		
		private function tick(delta:Number):void 
		{
			if (currentLabel != "start" || currentFrame < totalFrames) {
				nextFrame();
			}else if (currentFrame >= totalFrames) {
				Main.guiTickSignal.remove(tick);
			}
		}
		
		public function destroy():void {
			Main.guiTickSignal.remove(tick);
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
		
	}

}