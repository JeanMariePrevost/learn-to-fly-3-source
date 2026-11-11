package src.gui.progress 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import src.Main;
	import src.game.GameEnginePayload;
	import src.gui.Transition;
	import src.reg.Registry;
	import src.reg.RegistryEntry;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class MainScreenPayload extends AbstractMainScreen 
	{
		public var highlight1:PayloadProgressHighlight;
		public var highlight2:PayloadProgressHighlight;
		public var highlight3:PayloadProgressHighlight;
		public var highlight4:PayloadProgressHighlight;
		
		public var hit1:MovieClip;
		public var hit2:MovieClip;
		public var hit3:MovieClip;
		public var hit4:MovieClip;
		
		public var progress1:MovieClip;
		public var progress2:MovieClip;
		public var progress3:MovieClip;
		public var progress4:MovieClip;
		
		protected var _objectUnderMouse:MovieClip;
		protected var _clickedHighlight:MovieClip;
		
		public function MainScreenPayload() 
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
			
			highlight1.initBounce(hit1);
			highlight2.initBounce(hit2);
			highlight3.initBounce(hit3);
			highlight4.initBounce(hit4);
			
			hit1.alpha = hit2.alpha = hit3.alpha = hit4.alpha = 0.001;
			
			highlight1.bounce.signalClickTarget.add(onClick);
			highlight2.bounce.signalClickTarget.add(onClick);
			highlight3.bounce.signalClickTarget.add(onClick);
			highlight4.bounce.signalClickTarget.add(onClick);
			
			switch(ProfileState.instance.currentGameState.payloadSelected) {
				case 1:
				default:
					GameEnginePayload.selectedPayload = Registry.getEntry("payload1");
					highlight1.selected = true;
					break;
				case 2:
					GameEnginePayload.selectedPayload = Registry.getEntry("payload2");
					highlight2.selected = true;
					break;
				case 3:
					GameEnginePayload.selectedPayload = Registry.getEntry("payload3");
					highlight3.selected = true;
					break;
				case 4:
					GameEnginePayload.selectedPayload = Registry.getEntry("payload4");
					highlight4.selected = true;
					break;
			}
		}
		
		protected function onClick(target:DisplayObject) {
			highlight1.selected = (target == highlight1);
			highlight2.selected = (target == highlight2);
			highlight3.selected = (target == highlight3);
			highlight4.selected = (target == highlight4);
			
			if (highlight1.selected) {
				GameEnginePayload.selectedPayload = Registry.getEntry("payload1");
				ProfileState.instance.currentGameState.payloadSelected = 1;
			}else if (highlight2.selected) {
				GameEnginePayload.selectedPayload = Registry.getEntry("payload2");
				ProfileState.instance.currentGameState.payloadSelected = 2;
			}else if (highlight3.selected) {
				GameEnginePayload.selectedPayload = Registry.getEntry("payload3");
				ProfileState.instance.currentGameState.payloadSelected = 3;
			}else if (highlight4.selected) {
				GameEnginePayload.selectedPayload = Registry.getEntry("payload4");
				ProfileState.instance.currentGameState.payloadSelected = 4;
			}else {
				//Error...
				GameEnginePayload.selectedPayload = Registry.getEntry("payload1");
				ProfileState.instance.currentGameState.payloadSelected = 1;
			}
		}
		
		public function get selectedPayload():int {
			if (highlight1.selected) return 1;
			if (highlight2.selected) return 2;
			if (highlight3.selected) return 3;
			if (highlight4.selected) return 4;
			return 1;
		}
		
		
		override public function destroy():void 
		{
			highlight1 = null;
			highlight2 = null;
			highlight3 = null;
			highlight4 = null;
			
			progress1 = null;
			progress2 = null;
			progress3 = null;
			progress4 = null;
			
			_objectUnderMouse = null;
			
			super.destroy();
		}
		
	}

}