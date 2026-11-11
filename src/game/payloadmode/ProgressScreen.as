package src.game.payloadmode 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import lbg.debug.Log;
	import src.ScreenManager;
	import src.game.GameEnginePayload;
	import src.gui.Transition;
	import src.Main;
	import src.reg.Registry;
	import src.reg.RegistryEntry;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ProgressScreen extends MovieClip 
	{
		protected static var _instance:ProgressScreen;
		
		public var highlight1:MovieClip;
		public var highlight2:MovieClip;
		public var highlight3:MovieClip;
		public var highlight4:MovieClip;
		
		public var progress1:MovieClip;
		public var progress2:MovieClip;
		public var progress3:MovieClip;
		public var progress4:MovieClip;
		
		protected var _highlights:Vector.<MovieClip> = new Vector.<MovieClip>();
		protected var _objectUnderMouse:MovieClip;
		protected var _clickedHighlight:MovieClip;
		
		public function ProgressScreen(singleton:Enforcer) 
		{
			super();
			
			if (ProfileState.instance.currentGameState.payloadTopAltitude1.value >= 200000) {
				progress1.gotoAndStop(6);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude1.value >= 100000) {
				progress1.gotoAndStop(5);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude1.value >= 50000) {
				progress1.gotoAndStop(4);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude1.value >= 25000) {
				progress1.gotoAndStop(3);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude1.value >= 10000) {
				progress1.gotoAndStop(2);
			}else {
				progress1.gotoAndStop(1);
			}
			
			if (ProfileState.instance.currentGameState.payloadTopAltitude2.value >= 200000) {
				progress2.gotoAndStop(6);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude2.value >= 100000) {
				progress2.gotoAndStop(5);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude2.value >= 50000) {
				progress2.gotoAndStop(4);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude2.value >= 25000) {
				progress2.gotoAndStop(3);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude2.value >= 10000) {
				progress2.gotoAndStop(2);
			}else {
				progress2.gotoAndStop(1);
			}
			
			if (ProfileState.instance.currentGameState.payloadTopAltitude3.value >= 200000) {
				progress3.gotoAndStop(6);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude3.value >= 100000) {
				progress3.gotoAndStop(5);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude3.value >= 50000) {
				progress3.gotoAndStop(4);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude3.value >= 25000) {
				progress3.gotoAndStop(3);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude3.value >= 10000) {
				progress3.gotoAndStop(2);
			}else {
				progress3.gotoAndStop(1);
			}
			
			if (ProfileState.instance.currentGameState.payloadTopAltitude4.value >= 200000) {
				progress4.gotoAndStop(6);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude4.value >= 100000) {
				progress4.gotoAndStop(5);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude4.value >= 50000) {
				progress4.gotoAndStop(4);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude4.value >= 25000) {
				progress4.gotoAndStop(3);
			}else if (ProfileState.instance.currentGameState.payloadTopAltitude4.value >= 10000) {
				progress4.gotoAndStop(2);
			}else {
				progress4.gotoAndStop(1);
			}
			
			var entry:RegistryEntry = Registry.getEntry("payload1");
			progress1.txtBp1.text = entry.statSpecial.valueAt(0).toFixed() +"BP";
			progress1.txtBp2.text = entry.statSpecial.valueAt(1).toFixed() +"BP";
			progress1.txtBp3.text = entry.statSpecial.valueAt(2).toFixed() +"BP";
			progress1.txtBp4.text = entry.statSpecial.valueAt(3).toFixed() +"BP";
			progress1.txtBp5.text = entry.statSpecial.valueAt(4).toFixed() +"BP";
			
			entry = Registry.getEntry("payload2");
			progress2.txtBp1.text = entry.statSpecial.valueAt(0).toFixed() +"BP";
			progress2.txtBp2.text = entry.statSpecial.valueAt(1).toFixed() +"BP";
			progress2.txtBp3.text = entry.statSpecial.valueAt(2).toFixed() +"BP";
			progress2.txtBp4.text = entry.statSpecial.valueAt(3).toFixed() +"BP";
			progress2.txtBp5.text = entry.statSpecial.valueAt(4).toFixed() +"BP";
			
			entry = Registry.getEntry("payload3");
			progress3.txtBp1.text = entry.statSpecial.valueAt(0).toFixed() +"BP";
			progress3.txtBp2.text = entry.statSpecial.valueAt(1).toFixed() +"BP";
			progress3.txtBp3.text = entry.statSpecial.valueAt(2).toFixed() +"BP";
			progress3.txtBp4.text = entry.statSpecial.valueAt(3).toFixed() +"BP";
			progress3.txtBp5.text = entry.statSpecial.valueAt(4).toFixed() +"BP";
			
			entry = Registry.getEntry("payload4");
			progress4.txtBp1.text = entry.statSpecial.valueAt(0).toFixed() +"BP";
			progress4.txtBp2.text = entry.statSpecial.valueAt(1).toFixed() +"BP";
			progress4.txtBp3.text = entry.statSpecial.valueAt(2).toFixed() +"BP";
			progress4.txtBp4.text = entry.statSpecial.valueAt(3).toFixed() +"BP";
			progress4.txtBp5.text = entry.statSpecial.valueAt(4).toFixed() +"BP";
			
			
			_highlights.push(highlight1);
			_highlights.push(highlight2);
			_highlights.push(highlight3);
			_highlights.push(highlight4);
			
			for each(var h:MovieClip in _highlights) {
				h.alpha = 0;
			}
			
			Main.guiTickSignal.add(tick);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		private function mouseDown(e:MouseEvent):void 
		{
			mouseMove(e);
			if (_objectUnderMouse) {
				_clickedHighlight = _objectUnderMouse;
			}
		}
		
		private function mouseUp(e:MouseEvent):void 
		{
			mouseMove(e);
			if (_objectUnderMouse) {
				_objectUnderMouse.alpha = 0.35;
			}
			
			if (_clickedHighlight != null && _objectUnderMouse == _clickedHighlight) {
				//Select
				Transition.transitionTo(destroy, ScreenManager.loadGamePayloadMode);
				if (_clickedHighlight == highlight1) {
					GameEnginePayload.selectedPayload = Registry.getEntry("payload1");
				}else if (_clickedHighlight == highlight2) {
					GameEnginePayload.selectedPayload = Registry.getEntry("payload2");
				}else if (_clickedHighlight == highlight3) {
					GameEnginePayload.selectedPayload = Registry.getEntry("payload3");
				}else if (_clickedHighlight == highlight4) {
					GameEnginePayload.selectedPayload = Registry.getEntry("payload4");
				}else {
					throw new Error("ProgressScreen mouseUp() ERROR - could not identify clicked payload button");
					Log.log("ProgressScreen mouseUp() ERROR - could not identify clicked payload button");
					GameEnginePayload.selectedPayload = Registry.getEntry("payload1");
				}
			}
			
			_clickedHighlight = null;
		}
		
		private function mouseMove(e:MouseEvent):void 
		{
			for each(var h:MovieClip in _highlights) {
				if (h.hitTestPoint(e.stageX, e.stageY, true)) {
					_objectUnderMouse = h;
					return;
				}
			}
			
			_objectUnderMouse = null;
		}
		
		public static function get instance():ProgressScreen {
			if (_instance == null) {
				_instance = new ProgressScreen(new Enforcer());
			}
			
			return _instance;
		}
		
		protected function tick(delta:Number):void {
			for each(var h:MovieClip in _highlights) {
				if (h == _objectUnderMouse) {
					h.alpha += (0.35 - h.alpha) * 0.1;
				}else {
					h.alpha = Math.max(0, h.alpha - 0.025);
				}
			}
			
			if(_clickedHighlight) _clickedHighlight.alpha = 0.45;
		}
		
		public static function destroy():void {
			if (_instance) {
				_instance.destroy();
			}
		}
		
		public function destroy():void {
			_instance = null;
			
			highlight1 = null;
			highlight2 = null;
			highlight3 = null;
			highlight4 = null;
			
			progress1 = null;
			progress2 = null;
			progress3 = null;
			progress4 = null;
			
			if(_highlights) _highlights.length = 0;
			_highlights = null;
			
			_objectUnderMouse = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}

class Enforcer { }
