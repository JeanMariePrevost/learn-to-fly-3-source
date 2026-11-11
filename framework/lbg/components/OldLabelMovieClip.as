package lbg.components 
{
	import lbg.compositetick.ICompositeLeaf;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 
	 */
	public class OldLabelMovieClip extends MovieClip implements ICompositeLeaf
	{
		protected var _playLabels:Vector.<String> = new Vector.<String>;//If currentLabel, nextFrame()
		//protected var _stopLabels:Vector.<String> = new Vector.<String>;//If currentLabel, do nothing
		protected var _loopLabels:Vector.<String> = new Vector.<String>;//If currentLabel, goto previous label
		
		protected var _labels:Array;//All of this movieclips labels
		
		
		public function OldLabelMovieClip() 
		{
			extractLabelStrings();
		}
		
		protected function extractLabelStrings():void {
			_labels = new Array();
			for each(var i:FrameLabel in currentLabels) _labels.push(i.name);
		}
		
		/** Add a label at which the MovieClip will play */
		public function addPlayLabel(newLabel:String):void {
			if (_labels.indexOf(newLabel) <= -1) throw new Error("LabelMovieClip - Label not part of currentLabels");
			if (_playLabels.indexOf(newLabel) != -1) return;//Label already added
			_playLabels.push(newLabel);
		}
		
		/** Add a label at which the MovieClip will play */
		public function addLoopLabel(newLabel:String):void {
			if (_labels.indexOf(newLabel) <= -1) throw new Error("LabelMovieClip - Label not part of currentLabels");
			if (_loopLabels.indexOf(newLabel) != -1) return;//Label already added
			_loopLabels.push(newLabel);
		}
		
		
		///** Add a label at which the MovieClip will stop */
		//public function addPlayLabel(newLabel:String):void {
			//if (_labels.indexOf(newLabel) <= -1) throw new Error("LabelMovieClip - Label not part of currentLabels");
			//if (_playLabels.indexOf(newLabel) != -1) return;//Label already added
			//_playLabels.push(newLabel);
		//}
		
		public function tick(delta:Number):void {
			if (_playLabels.indexOf(currentLabel) != -1) {
				nextFrame();
				return;
			}else if (_loopLabels.indexOf(currentLabel) != -1) {
				loopLabel(currentLabel);
			}
		}
		
		protected function loopLabel(label:String):void {
		gotoAndStop(_labels[_labels.indexOf(label) - 1]);
		}
		
		public function destroy():void {
			_playLabels = null;
			_loopLabels = null;
			_labels = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}