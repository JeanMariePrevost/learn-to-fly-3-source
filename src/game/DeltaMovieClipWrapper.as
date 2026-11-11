package src.game 
{
	import flash.display.MovieClip;
	import lbg.components.labelmovieclip.LabelMovieClip;
	import lbg.debug.Log;
	import org.osflash.signals.Signal;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class DeltaMovieClipWrapper extends LabelMovieClip 
	{
		public static const ACTION_PLAY:String = LabelMovieClip.ACTION_PLAY;
		public static const ACTION_STOP:String = LabelMovieClip.ACTION_STOP;
		
		protected const TRACE_ERRORS:Boolean = true;//Used to send traces of minor errors such as missing labels
		
		public var deathSignal:Signal = new Signal();//Signals when deathEnd is reached
		protected var _beforeTickLabel:String;
		
		public function DeltaMovieClipWrapper(movieClip:MovieClip, startAtFrame:Object = 1) 
		{
			super(movieClip, src.Main.unsafeTickSignal);
			
			_movieClip.gotoAndStop(startAtFrame);
			_realFrame = _movieClip.currentFrame;
		}
		
		override public function tick(delta:Number):void 
		{
			_beforeTickLabel = _movieClip.currentLabel;
			
			super.tick(delta);
			
			if (_movieClip.currentLabel == "deathEnd" && _beforeTickLabel != "deathEnd") {
				deathSignal.dispatch();
			}
		}
		
		override protected function customActionsHook():void 
		{
			//Stop labels
			setAction("idle", ACTION_STOP);
			setAction("deathEnd", ACTION_STOP);
			setAction("specialEnd", ACTION_STOP);
			
			//Play-through labels
			setAction("idleStart", ACTION_PLAY);
			setAction("initStart", ACTION_PLAY);
			setAction("onStart", ACTION_PLAY);
			setAction("activeStart", ACTION_PLAY);
			setAction("offStart", ACTION_PLAY);
			setAction("deathStart", ACTION_PLAY);
			setAction("specialStart", ACTION_PLAY);
			setAction("idleStart", ACTION_PLAY);
			
			//Goto labels
			setAction("idleEnd", "idleStart");
			setAction("initEnd", "idleStart");
			
			setAction("onEnd", "activeStart");
			setAction("activeEnd", "activeStart");
			
			setAction("offEnd", "idleStart");
		}
		
		/** Returns the frame number of the "Start" label of the current state */
		public function get startFrame():int {
			var f:int;
			
			switch(_movieClip.currentLabel) {
				case "idle":
				case "idleStart":
				case "idleEnd":
					f = getLabel("idleStart").frame;
					break;
					
				case "initStart":
				case "initEnd":
					f = getLabel("initStart").frame;
					break;
					
				case "onStart":
				case "onEnd":
					f = getLabel("onStart").frame;
					break;
					
				case "activeStart":
				case "activeEnd":
					f = getLabel("activeStart").frame;
					break;
					
				case "offStart":
				case "offEnd":
					f = getLabel("offStart").frame;
					break;
					
				case "deathStart":
				case "deathEnd":
					f = getLabel("deathStart").frame;
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
					f = getLabel("idleEnd").frame;
					break;
					
				case "initStart":
				case "initEnd":
					f = getLabel("initEnd").frame;
					break;
					
				case "onStart":
				case "onEnd":
					f = getLabel("onEnd").frame;
					break;
					
				case "activeStart":
				case "activeEnd":
					f = getLabel("activeEnd").frame;
					break;
					
				case "offStart":
				case "offEnd":
					f = getLabel("offEnd").frame;
					break;
					
				case "specialStart":
				case "specialEnd":
					f = getLabel("specialEnd").frame;
					break;
					
				case "deathStart":
				case "deathEnd":
					f = getLabel("deathEnd").frame;
					break;
					
				default:
					f = currentFrame;//? - return -1 instead? Throw error?
					Log.log("DeltaMovieClipWrapper Error - No End frame on label [", _movieClip.currentLabel, "]");
					break;
			}
			
			return f;
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
		
		
		public function setToState(state:String):void {
			if (currentState != state) {
				var label:String = state + "Start";
				if(getLabel(label) != null){
					gotoLabel(label);
				}else {
					labelNotFound(label, _movieClip);
				}
			}
		}
		
		public function setToActive():void {
			if (_movieClip.currentLabel == "activeStart" || _movieClip.currentLabel == "activeEnd") return;
			
			var label:String = "activeStart";
			if(getLabel(label) != null){
				gotoLabel(label);
			}else {
				labelNotFound(label, _movieClip);
			}
		}
		
		public function setToIdle():void {
			if (_movieClip.currentLabel == "idleStart" || _movieClip.currentLabel == "idleEnd") return;
			
			var label:String = "idleStart";
			if(getLabel(label) != null){
				gotoLabel(label);
			}else {
				label = "idle";//Special case for non-animated idle
				if(getLabel(label) != null){
					gotoLabel(label);
				}else {
					labelNotFound(label, _movieClip);
				}
			}
		}
		
		public function setToInit():void {
			if (_movieClip.currentLabel == "initStart" || _movieClip.currentLabel == "initEnd") return;
			
			var label:String = "initStart";
			if(getLabel(label) != null){
				gotoLabel(label);
			}else {
				setToIdle();
				labelNotFound(label, _movieClip);
			}
		}
		
		public function setToOn():void {
			if (_movieClip.currentLabel == "onStart" || _movieClip.currentLabel == "onEnd" || _movieClip.currentLabel == "activeStart" || _movieClip.currentLabel == "activeEnd") return;
			
			var label:String = "onStart";
			if(getLabel(label) != null){
				gotoLabel(label);
			}else {
				setToActive();
				//labelNotFound(label, _movieClip);
			}
		}
		
		public function setToOff():void {
			if (_movieClip.currentLabel == "onStart" || _movieClip.currentLabel == "onEnd" || _movieClip.currentLabel == "activeStart" || _movieClip.currentLabel == "activeEnd") {
				var label:String = "offStart";
				if(getLabel(label) != null){
					gotoLabel(label);
				}else {
					setToIdle();
					//labelNotFound(label, _movieClip);
				}
			}
		}
		
		public function setToSpecial():void {
			if (_movieClip.currentLabel != "specialStart" && _movieClip.currentLabel != "specialEnd") {
				var label:String = "specialStart";
				if(getLabel(label) != null){
					gotoLabel(label);
				}else {
					setToIdle();
					labelNotFound(label, _movieClip);
				}
			}
		}
		
		public function setToDeath():Signal {
			if (_movieClip.currentLabel == "deathStart" || _movieClip.currentLabel == "deathEnd") return deathSignal;
			
			var label:String = "deathStart";
			if(getLabel(label) != null){
				gotoLabel(label);
			}else {
				labelNotFound(label, _movieClip);
			}
			
			return deathSignal;
		}
		
		protected function labelNotFound(label:String, object:MovieClip):void {
			if(TRACE_ERRORS) trace("DeltaMovieClipWrapper - Unable to find label [", label, "] on ", object);
		}

		
	}

}