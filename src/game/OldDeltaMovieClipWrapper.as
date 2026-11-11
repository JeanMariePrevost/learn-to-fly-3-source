package src.game 
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	import src.Main;
	/**
	 * ...
	 * @author 
	 */
	public class OldDeltaMovieClipWrapper 
	{
		protected const TRACE_ERRORS:Boolean = false;//Used to send traces of minor errors such as missing labels
		
		protected var _movieClip:MovieClip;
		protected var _currentFrame:Number;
		protected var _labelMap:Object;
		
		protected var _endFrame:int;//Holds the last frame of an animation label, used to prevent passing over an end label and into another animation
		
		public var useDeltaTime:Boolean = true;
		
		public function OldDeltaMovieClipWrapper(movieClip:MovieClip, startAtFrame:Object = 1) 
		{
			_movieClip = movieClip;
			mapLabels();
			Main.unsafeTickSignal.add(tick);
			
			try {
				_movieClip.gotoAndStop(startAtFrame);
			}catch (e:Error) {
				_movieClip.gotoAndStop(1);
			}
			_currentFrame = _movieClip.currentFrame;
		}
		
		public function tick(delta:Number):void {
			if (!useDeltaTime) delta = 1;
			
			if (checkAndSetLabel()) {
				_currentFrame = Math.min(endFrame, _currentFrame + delta);
				_movieClip.gotoAndStop(currentFrame);
			}
		}
		
		public function play():void {
			Main.unsafeTickSignal.add(tick);
		}
		
		public function stop():void {
			Main.unsafeTickSignal.remove(tick);
		}
		
		public function get currentFrame():Number 
		{
			//return _movieClip.currentFrame;
			return int(Math.max(1, _currentFrame));
		}
		
		public function get currentLabel():String 
		{
			return _movieClip.currentLabel;
		}
		
		/** Returns the label without the "start" or "end" part (e.g. "active" for both "activeStart" and "activeEnd") */
		public function get currentState():String {
			var str:String = _movieClip.currentLabel;
			var i:int;
			
			i = str.indexOf("Start");
			if (i >= 1) {
				str = str.substring(0, i);
			}
			
			i = str.indexOf("End");
			if (i >= 1) {
				str = str.substring(0, i);
			}
			
			return str;
		}
		
		protected function checkAndSetLabel():Boolean {
			//idle stays
			//idleStart plays to idleEnd, into idleStart (loop)
			//initStart plays to intiEnd, into idle
			//onStart plays to onEnd, indo activeStart
			//activeStart plays to activeEnd, into activeStart (loop)
			//offStart plays to offEnd, into idle
			//deathStart plays into deathEnd, stops at deathEnd (only anim to stop and destroy object)
			
			switch(_movieClip.currentLabel) {
				case "idle":
					//no animation
					return false;
				case "idleStart":
				case "initStart":
				case "onStart":
				case "activeStart":
				case "offStart":
				case "deathStart":
				case "specialStart"://Used for single animation, no automatic behavior but playing
					//Play through animation
					return true;
				case "idleEnd":
				case "initEnd":
					gotoLabel("idleStart");
					return false;
				case "onEnd":
				case "activeEnd":
					gotoLabel("activeStart");
					return false;
				case "offEnd":
					gotoLabel("idleStart");
					return false;
				case "deathEnd":
					//Death stops animation process
					//CLEARS REFERENCES
					//re-enable auto-destroying?
					
					//destroy();
					return false;
				case "specialEnd":
				default:
					return false;
			}
		}
		
		public function gotoFrame(frame:int = 1):void {
			_currentFrame = frame;
			_movieClip.gotoAndStop(frame);
			//trace("Endframe:", endFrame);
			
		}
		
		public function gotoLabel(label:String) {
			//if (isValidLabel(label)) {
			if (hasLabel(label)) {
				gotoFrame(_labelMap[label]);
			}
			//}
		}
		
		/** Sets the current state at a point between its start and finish point, useful to control playback */
		public function interpolateLabel(norm:Number):void {
			var frame:int = int(NumberUtils.interpolate(startFrame, endFrame, norm, 1, true));
			gotoFrame(frame);
		}
		
		/** Returns the frame number of the "Start" label of the current state */
		public function get startFrame():int {
			var f:int;
			
			switch(_movieClip.currentLabel) {
				case "idle":
				case "idleStart":
				case "idleEnd":
					f = _labelMap["idleStart"];
					break;
					
				case "initStart":
				case "initEnd":
					f = _labelMap["initStart"];
					break;
					
				case "onStart":
				case "onEnd":
					f = _labelMap["onStart"];
					break;
					
				case "activeStart":
				case "activeEnd":
					f = _labelMap["activeStart"];
					break;
					
				case "offStart":
				case "offEnd":
					f = _labelMap["offStart"];
					break;
					
				case "deathStart":
				case "deathEnd":
					f = _labelMap["deathStart"];
					break;
					
				default:
					f = currentFrame;//? - return -1 instead? Throw error?
					Log.log("DeltaMovieClipWrapper Error - No start frame on label [", _movieClip.currentLabel, "]");
					break;
			}
			
			return f;
		}
		
		/** Returns the frame number of the "End" label of the current state */
		public function get endFrame():int {
			var f:int;
			
			switch(_movieClip.currentLabel) {
				case "idle":
				case "idleStart":
				case "idleEnd":
					f = _labelMap["idleEnd"];
					break;
					
				case "initStart":
				case "initEnd":
					f = _labelMap["initEnd"];
					break;
					
				case "onStart":
				case "onEnd":
					f = _labelMap["onEnd"];
					break;
					
				case "activeStart":
				case "activeEnd":
					f = _labelMap["activeEnd"];
					break;
					
				case "offStart":
				case "offEnd":
					f = _labelMap["offEnd"];
					break;
					
				case "specialStart":
				case "specialEnd":
					f = _labelMap["specialEnd"];
					break;
					
				case "deathStart":
				case "deathEnd":
					f = _labelMap["deathEnd"];
					break;
					
				default:
					f = currentFrame;//? - return -1 instead? Throw error?
					Log.log("DeltaMovieClipWrapper Error - No End frame on label [", _movieClip.currentLabel, "]");
					break;
			}
			
			return f;
		}
		
		public function setToActive():void {
			if (_movieClip.currentLabel == "activeStart" || _movieClip.currentLabel == "activeEnd") return;
			
			var label:String = "activeStart";
			if(_labelMap[label]){
				gotoLabel(label);
			}else {
				if(TRACE_ERRORS) trace("Unable to find label [", label, "]");
			}
		}
		
		public function setToIdle():void {
			if (_movieClip.currentLabel == "idleStart" || _movieClip.currentLabel == "idleEnd") return;
			
			var label:String = "idleStart";
			if(_labelMap[label]){
				gotoLabel(label);
			}else {
				label = "idle";//Special case for non-animated idle
				if(_labelMap[label]){
					gotoLabel(label);
				}else {
					if(TRACE_ERRORS) trace("Unable to find label [", label, "]");
				}
			}
		}
		
		public function setToInit():void {
			if (_movieClip.currentLabel == "initStart" || _movieClip.currentLabel == "initEnd") return;
			
			var label:String = "initStart";
			if(_labelMap[label]){
				gotoLabel(label);
			}else {
				setToIdle();
				if(TRACE_ERRORS) trace("Unable to find label [", label, "]");
			}
		}
		
		public function setToOn():void {
			if (_movieClip.currentLabel == "onStart" || _movieClip.currentLabel == "onEnd" || _movieClip.currentLabel == "activeStart" || _movieClip.currentLabel == "activeEnd") return;
			
			var label:String = "onStart";
			if(_labelMap[label]){
				gotoLabel(label);
			}else {
				setToActive();
				if(TRACE_ERRORS) trace("Unable to find label [", label, "]");
			}
		}
		
		public function setToOff():void {
			if (_movieClip.currentLabel == "onStart" || _movieClip.currentLabel == "onEnd" || _movieClip.currentLabel == "activeStart" || _movieClip.currentLabel == "activeEnd") {
				var label:String = "offStart";
				if(_labelMap[label]){
					gotoLabel(label);
				}else {
					setToIdle();
					if(TRACE_ERRORS) trace("Unable to find label [", label, "]");
				}
			}
		}
		
		public function setToSpecial():void {
			if (_movieClip.currentLabel != "specialStart" || _movieClip.currentLabel != "specialEnd") {
				var label:String = "specialStart";
				if(_labelMap[label]){
					gotoLabel(label);
				}else {
					setToIdle();
					if(TRACE_ERRORS) trace("Unable to find label [", label, "]");
				}
			}
		}
		
		public function setToDeath():void {
			if (_movieClip.currentLabel == "deathStart" || _movieClip.currentLabel == "deathEnd") return;
			
			var label:String = "deathStart";
			if(_labelMap[label]){
				gotoLabel(label);
			}else {
				if(TRACE_ERRORS) trace("Unable to find label [", label, "]");
			}
		}
		
		protected function mapLabels():void {
			_labelMap = new Object();
			
			for each (var l:FrameLabel in _movieClip.currentLabels) {
				if (isValidLabel(l.name)) {
					if (l.name == "idle") {
						//correct "idle" to "idleStart
						_labelMap["idleStart"] = l.frame;
					}
					_labelMap[l.name] = l.frame;
				}
			}
			if (!_labelMap["idleStart"]) {
				throw new Error("No idle label on movieclip" + _movieClip + _movieClip.name);
				_labelMap.idleStart = 1;
			}
		}
		
		protected function isValidLabel(label:String):Boolean {
			if (label == "idle" ||
			label == "idleStart" ||
			label == "idleEnd" ||
			label == "initStart" ||
			label == "initEnd" ||
			label == "onStart" ||
			label == "onEnd" ||
			label == "activeStart" ||
			label == "activeEnd" ||
			label == "offStart" ||
			label == "offEnd" ||
			label == "specialStart" ||
			label == "specialEnd" ||
			label == "deathStart" ||
			label == "deathEnd") {
				return true;
			}else {
				trace("isValidLabel error - [", _movieClip, _movieClip.name, "] has invalid label [", label, "]");
				return false;
			}
		}
		
		public function hasLabel(label:String):Boolean {
			return _labelMap[label] != null;
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			_movieClip = null;
			_labelMap = null;
			
		}
	}

}