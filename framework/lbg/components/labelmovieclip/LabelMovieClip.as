package lbg.components.labelmovieclip {
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author 
	 */
	public class LabelMovieClip 
	{
		public static const ACTION_PLAY:String = "»»»»play";
		public static const ACTION_STOP:String = "»»»»stop";
		
		public var useDeltaTime:Boolean = true;
		public var deltaThreshold:Number = 0.10;//Value below which delta differences are not accounted for
		
		
		
		protected var _movieClip:MovieClip;
		protected var _tickSignal:Signal;
		
		protected var _labels:Vector.<LabelObject> = new Vector.<LabelObject>();
		
		protected var _realFrame:Number = 1;
		
		protected const MAXIMUM_RECURSIVE_TICKS:uint = 10;//Maximum amount of recursive ticks in a single funciton call, prevents lag / overflow with big delta values
		protected var _recursiveTickSafety:Number = 0;//Counts ticks on the same delta value
		
		/**
		 * Wrapper to add start/end labels functions to movieclips
		 * @param	movieClip Target MovieClip
		 * @param	tickSignal Default delta tick signal, can also be ticked manually
		 */
		public function LabelMovieClip(movieClip:MovieClip, tickSignal:Signal = null) 
		{
			_movieClip = movieClip;
			_movieClip.stop();
			
			mapLabels();
			
			customActionsHook();
			
			_tickSignal = tickSignal;
			
			if (_tickSignal != null) {
				_tickSignal.add(tick);
			}
		}
		
		protected function customActionsHook():void {
			//Override this to insert custom actions after labels have been mapped, like so
			//getLabel("onEnd").action = "activeStart"; //This would be a goto action
			//getLabel("activeEnd").action = ACTION_STOP; //This makes the playhead stop at this label
		}
		
		/** Used to override actions without encoutering errors if specified label does not exist on current movieclip */
		public function setAction(label:String, action:String):Boolean {
			var l:LabelObject = getLabel(label);
			if (l != null) {
				l.action = action;
				return true;
			}else {
				return false;
			}
		}
		
		/** Allows automatic ticking from set _tickSignal */
		public function play():void {
			//_playingEnabled = true;
			if (_tickSignal != null) {
				_tickSignal.add(tick);
			}
		}
		
		/** Stops automatic ticking from set _tickSignal */
		public function stop():void {
			//_playingEnabled = false;
			if (_tickSignal != null) {
				_tickSignal.remove(tick);
			}
		}
		
		public function gotoFrame(frame:uint):void {
			_movieClip.gotoAndStop(frame);
			_realFrame = _movieClip.currentFrame;
		}
		
		public function gotoLabel(label:String):void {
			_movieClip.gotoAndStop(label);
			_realFrame = _movieClip.currentFrame;
		}
		
		/** Goto start label of action if not currently in action */
		public function gotoAction(action:String):void {
			if (currentAction != action) {
				_movieClip.gotoAndStop(action + "Start");
				_realFrame = _movieClip.currentFrame;
			}
		}
		
		//Checks if label contains a string, useful for checking if currently in a "set" of labels (e.g. "activeStart" and "activeEnd")
		public function labelContains(string:String):Boolean {
			return currentLabel.indexOf(string) >= 0;
		}
		
		public function get currentLabel():String {
			return _movieClip.currentLabel;
		}
		
		/** Returns the current label with "Start" or "End" removed */
		public function get currentAction():String {
			var label:String = _movieClip.currentLabel;
			label = label.replace("Start", "");
			label = label.replace("End", "");
			return label;
		}
		
		public function get currentFrame():int {
			return _movieClip.currentFrame;
		}
		
		public function get currentLabelObject():LabelObject {
			for (var i:int = 0; i < _labels.length; i++) {
				if (_labels[i].name == currentLabel) {
					return _labels[i];
				}
			}
			
			throw new Error("LabelMovieClip _nextLabelObject - Could not find current label in list...");
			return _labels[0];//Something went wrong
		}
		
		public function get nextLabelObject():LabelObject {
			for (var i:int = 0; i < _labels.length; i++) {
				if (_labels[i].name == currentLabel) {
					if (i + 1 >= _labels.length) {
						//Last label reached, return self, this shouldn't happen with correct labeling
						return _labels[i];
					}else {
						return _labels[i + 1];
					}
				}
			}
			
			throw new Error("LabelMovieClip _nextLabelObject - Could not find current label in list...");
			return _labels[0];//Something went wrong
		}
		
		public function tick(delta:Number):void {
			if (_movieClip == null) {
				destroy();
				return;
			}
			
			if (!useDeltaTime) {
				delta = 1;
			}else if (delta <= (1 + deltaThreshold) && delta >= (1 - deltaThreshold)) {
				//Delta within threshold, don't use
				delta = 1;
			}
			
			var action:String = getLabel(currentLabel).action;
			var remainingDelta:Number;
			
			if (action == ACTION_PLAY) {
				//Inside a play-label, ticking...
				
				if (_realFrame >= _movieClip.totalFrames) {
					//Handle end-of-movieclip event
					//Stop or loop?
					return;
				}
				
				var nextRealFrame:Number = _realFrame + delta;
				
				if (nextRealFrame < nextLabelObject.frame) {
					//Staying in same label
					_realFrame += delta;
					uppdateVisual();
				}else {
					//Crossing a label
					//Apply its action and re-tick with remaining delta, costs at least 1 delta
					remainingDelta = delta - Math.max(1, (nextLabelObject.frame - _realFrame));
					_realFrame = nextLabelObject.frame;
					uppdateVisual();
					
					if (remainingDelta > 0) {
						recursiveTick(remainingDelta);
						return;
					}
				}
			}else if (action == ACTION_STOP) {
				//Do nothing, action is to stop
			}else if (getLabel(action)) {
				//Action is an existing label, goto
				_movieClip.gotoAndStop(action);
				_realFrame = _movieClip.currentFrame;
				uppdateVisual();
				
				remainingDelta = delta - 1;//Applying an action costs 1 delta (e.g. a gotoFrame counts as 1 passed frame)
				if (remainingDelta > 0) {
					recursiveTick(remainingDelta);
					return;
				}
			}else {
				//Unknown action, probably a missing or mistyped label
				Log.log("LabelMovieClip Error - Unkown action [", action, "] on movieclip [", _movieClip, "]");
			}
			
			_recursiveTickSafety = 0;
		}
		
		/** Used tthis function when using recursive tick to ensure they never get out of hand */
		protected function recursiveTick(delta:Number):void {
			_recursiveTickSafety ++;
			if (_recursiveTickSafety < MAXIMUM_RECURSIVE_TICKS) {
				//Within recursion limit
				tick(delta);
			}else{
				Log.log("recursiveTick - Recursion cap reached on [", _movieClip, "] with [", delta, "] left.");
				_recursiveTickSafety = 0;
			}
		}
		
		
		/** Sets the current label at a point between the current label and the next, useful to control playback */
		public function interpolateCurrentLabel(norm:Number):void {
			var startFrame:Number = currentLabelObject.frame;
			var endFrame:Number = nextLabelObject.frame;
			
			var frame:int = int(NumberUtils.interpolate(startFrame, endFrame, norm, 1, true));
			
			gotoFrame(frame);
		}
		
		/** Returns the normalized point in current state */
		public function get currentStateNorm():Number {
			var startFrame:Number = currentLabelObject.frame;
			var endFrame:Number = nextLabelObject.frame;
			var norm:Number = (currentFrame - startFrame) / (endFrame - startFrame);
			
			return norm;
		}
		
		/** Sets the current label at a point between the specified label and the next, useful to control playback */
		public function interpolateLabel(label:String, norm:Number, reachNextLabel:Boolean = false):void {
			_movieClip.gotoAndStop(label);
			
			var startFrame:Number = currentLabelObject.frame;
			var endFrame:Number = (reachNextLabel) ? nextLabelObject.frame : nextLabelObject.frame - 1;
			
			var frame:int = int(NumberUtils.interpolate(startFrame, endFrame, norm, 1, true));
			
			gotoFrame(frame);
		}
		
		protected function uppdateVisual():void {
			_movieClip.gotoAndStop(Math.round(_realFrame));
		}
		
		protected function mapLabels():void {
			var mcLabels:Array = _movieClip.currentLabels;
			
			if (mcLabels.length <= 0) {
				throw new Error("LabelMovieClip - mapLabels() - Movieclip has no labels, cannot map.");
			}
			
			for (var i:int = 0; i < mcLabels.length; i++) {
				var l:FrameLabel = mcLabels[i] as FrameLabel;
				addLabel(l.name, l.frame, ACTION_PLAY);
			}
		}
		
		protected function addLabel(name:String, frame:int, action:String):void {
			var l:LabelObject = getLabel(name);
			if (l == null) {
				_labels.push(new LabelObject(name, frame, action));
			}else {
				//Name already in list, update info
				Log.log("LabelMovieClip addLabel - Duplicate label name [", name, "] on movieclip.");
				l.action = action;
				l.frame = frame;
			}
		}
		
		protected function getLabel(name:String):LabelObject {
			if (name == null) return null;//No label specified, probably no currentLabel
			
			for each(var l:LabelObject in _labels) {
				if (l.name == name) return l;//Label found
			}
			
			return null;
		}
		
		
		public function destroy():void {
			_movieClip = null;
			
			if (_tickSignal != null) _tickSignal.remove(tick);
			_tickSignal = null;
			
			_labels = null;
		}
		
	}

}