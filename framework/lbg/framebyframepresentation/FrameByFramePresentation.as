package lbg.framebyframepresentation 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class FrameByFramePresentation extends MovieClip 
	{
		public var controls:PresentationController;
		
		public function FrameByFramePresentation() 
		{
			stop();
			controls = new PresentationController(this.stage);
			controls.previous.listenForActivation(doPrevious);
			controls.next.listenForActivation(doNext);
		}
		
		public function doPrevious():void {
			this.prevFrame();
		}
		
		public function doNext():void {
			this.nextFrame();
		}
		
		
		
	}

}