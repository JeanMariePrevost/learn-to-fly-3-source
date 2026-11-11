package src.gui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	import src.UiScaler;
	import src.game.DeltaMovieClipWrapper;
	import src.Main;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Transition extends MovieClip 
	{
		protected static var _instance:Transition;
		protected static var _wrapper:DeltaMovieClipWrapper;
		//protected static var _snapshot:Sprite;
		protected static var _bmd:BitmapData = new BitmapData(UiScaler.SCREEN_WIDTH_AT_MAX_RATIO, UiScaler.UNSCALED_STAGE_HEIGHT, false, 0);
		protected static var _bm:Bitmap = new Bitmap(_bmd);
		
		protected static var _functionsAfterFade:Vector.<Function> = new Vector.<Function>();
		
		public var wink:MovieClip;
		
		public function Transition(singleton:Enforcer) 
		{
			wink.gotoAndStop(1);
		}
		
		private function tick(delta:Number):void 
		{
			wrapper.tick(delta)
			
			if (wrapper.currentLabel == "idle" || wrapper.currentLabel == "outEnd") {
				//Fading out is over, screen is black
				
				Log.log("Transition.tick()", _functionsAfterFade.length);
					
				if (_functionsAfterFade.length >= 1) {
					//On each frame, do one of the functions
					//_functionsAfterFade.shift()();
					for each(var f:Function in _functionsAfterFade) {
						f.apply();
					}
					
					//for (var i:int = 0; i < _functionsAfterFade.length; i++) {
						//_functionsAfterFade[i].apply();
						//_functionsAfterFade[i] = null;
					//}
					
					_functionsAfterFade.length = 0;
					
					
				}else {
					//if out of functions, move over to fadeIn
					fadeIn();
				}
			}else if (wrapper.currentLabel == "inEnd") {
				//fading in over, transition finished
				wrapper.setToIdle();
				Main.guiTickSignal.remove(tick);
				if (parent) parent.removeChild(this);
			}
		}
		
		/** Do a fade out, call function, then fade in */
		public static function transitionTo(...functionsAfterFading):void {
			if (functionsAfterFading) {
			
				_functionsAfterFade = new Vector.<Function>();
				for each(var f:Function in functionsAfterFading) {
					if (f != null && f is Function) {
						_functionsAfterFade.push(f);
					}else {
						Log.log("transitionTo() Error -> a param is null or is not a function");
					}
				}
			}
			fadeOut();
		}
		
		protected function addTickAndChild():void {
			GuiSettings.guiTickSignal.add(tick);
			Main.transitionLayer.addChild(_instance);
		}
		
		/** Takes a screen snapshot then plays the fade out anim */
		public static function fadeOut():void {
			//trace("Transition fadeOut()");
			
			instance.mouseEnabled = true;
			instance.mouseChildren = true;
			
			instance.wink.gotoAndStop(NumberUtils.randomRange(1, instance.wink.totalFrames, true));
			
			if (ProfileState.instance.optionEnableTransition) {
				instance.fadeOut2();
			}else {
				instance.addTickAndChild();
				wrapper.setToIdle();
				Main.instance.sysButtonsShow();
			}
		}
		
		protected function fadeOut2():void {
			addTickAndChild();
			
			var rect:Rectangle = new Rectangle(0, 0, 720, 540);
			_bmd.fillRect(rect, 0);
			_bmd.draw(Main.mainLayer);
			
			_bm.bitmapData = _bmd;
			addChildAt(_bm, 0);
			
			instance.x = NumberUtils.interpolate2(0, UiScaler.WIDTH_DIFF_BETWEEN_MIN_MAX_RATIOS / 2, UiScaler.MIN_ASPECT_RATIO, UiScaler.MAX_ASPECT_RATIO, UiScaler.previousAspectRatio);
			_bm.x = -instance.x;
			
			instance.mouseEnabled = true;
			instance.mouseChildren = true;
			instance.parent.mouseEnabled = true;
			instance.parent.mouseChildren = true;
			
			if (wrapper.currentState == "idle" || wrapper.currentState == "in") {
				wrapper.setToState("out");
			}
			
			Main.instance.sysButtonsShow();
		}
		
		public static function fadeIn():void {
			//trace("Transition fadeIn()");
			
			instance.mouseEnabled = false;
			instance.mouseChildren = false;
			
			if (ProfileState.instance.optionEnableTransition) {
				instance.fadeIn2();
			}else {
				instance.addTickAndChild();
				wrapper.gotoLabel("inEnd");
			}
		}
		
		protected function fadeIn2():void {
			if (_bm.parent) _bm.parent.removeChild(_bm);
			
			instance.mouseEnabled = false;
			instance.mouseChildren = false;
			instance.parent.mouseEnabled = false;
			instance.parent.mouseChildren = false;
			
			
			addTickAndChild();
			if (wrapper.currentState == "idle" || wrapper.currentState == "out") {
				wrapper.setToState("in");
			}
		}
		
		static public function get instance():Transition 
		{
			if (_instance == null) {
				_instance = new Transition(new Enforcer());
			}
			return _instance;
		}
		
		static public function get wrapper():DeltaMovieClipWrapper {
			if (_wrapper == null) {
				_wrapper = new DeltaMovieClipWrapper(instance, "idle");
				_wrapper.setAction("inStart", DeltaMovieClipWrapper.ACTION_PLAY);
				_wrapper.setAction("inEnd", DeltaMovieClipWrapper.ACTION_STOP);
				_wrapper.setAction("outStart", DeltaMovieClipWrapper.ACTION_PLAY);
				_wrapper.setAction("outEnd", DeltaMovieClipWrapper.ACTION_STOP);
				_wrapper.setAction("idle", DeltaMovieClipWrapper.ACTION_STOP);
			}
			
			return _wrapper;
		}
		
		
		
	}

}

class Enforcer { }
