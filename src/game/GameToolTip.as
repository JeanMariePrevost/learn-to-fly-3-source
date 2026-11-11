package src.game {
	import flash.display.MovieClip;
	import flash.events.Event;
	import lbg.debug.Log;
	import src.UiScaler;
	import src.game.DeltaMovieClipWrapper;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameToolTip 
	{
		protected static var _wrapper:DeltaMovieClipWrapper;
		protected static var _tooltip:GameToolTipBaby;
		
		public static function show(tooltipID:String):void {
			if (_tooltip == null) {
				_tooltip = new GameToolTipBaby();
				_wrapper = new DeltaMovieClipWrapper(_tooltip);
			}
			
			_wrapper.setToInit();
			
			try {
				_tooltip.bubble.gotoAndStop(tooltipID);
			}catch (err:Error) {
				Log.log("GameToolTip error - labe [", tooltipID, "] not found in movieclip.");
				destroy();
			}
			
			GameCamera.instance.addChildToFixedLayer(_tooltip, 4);
			
			UiScaler.addAbsoluteManually(_tooltip, 720, -720);
		}
		
		public static function hide():void {
			if (_wrapper == null) return;
			
			_wrapper.setToDeath();
			_tooltip.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		static private function onEnterFrame(e:Event):void 
		{
			if (_tooltip.currentLabel == "deathEnd") {
				//Hiding over
				destroy();
			}
		}
		
		
		public static function destroy():void {
			if(_tooltip) _tooltip.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if (_wrapper) _wrapper.destroy();
			_wrapper = null;
			
			if (_tooltip) _tooltip.destroy();
			_tooltip = null;
		}
		
	}

}