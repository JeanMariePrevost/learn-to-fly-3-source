package src.game.hud.huds 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class RollingNumbersSlot extends MovieClip 
	{
		public var txtValue:TextField;
		
		public function RollingNumbersSlot() 
		{
			super();
			
			txtValue.text = "";
			gotoAndStop(totalFrames);
		}
		
		public function setCharacter(char:String):void {
			if (char != txtValue.text) {
				txtValue.text = char;
				gotoAndStop(1);
				Main.unsafeTickSignal.add(tick);
			}
		}
		
		protected function tick(delta:Number):void {
			if (currentFrame >= totalFrames) {
				Main.unsafeTickSignal.remove(tick);
				gotoAndStop(totalFrames);
			}else {
				nextFrame();
			}
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			txtValue = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}