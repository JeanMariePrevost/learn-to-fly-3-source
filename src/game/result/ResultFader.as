package src.game.result 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ResultFader extends MovieClip 
	{
		
		public function ResultFader() 
		{
			super();
			gotoAndStop(1);
			
		}
		
		public function setFader(norm:Number = 0):void {
			var f:int = int(NumberUtils.constrain(norm * totalFrames, 1, totalFrames));
			
			gotoAndStop(f);
			
			if (currentFrame <= 1) {
				visible = false;
			}else if(!ProfileState.instance.ultraLowQuality){
				visible = true;
			}
		}
		
	}

}