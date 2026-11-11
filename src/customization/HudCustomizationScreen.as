package src.customization 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import lbg.anticheatengine.SafeString;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.Sfx;
	import src.game.hud.HudComponent;
	import src.gui.Transition;
	import src.Main;
	import src.reg.Registry;
	import src.reg.RegistryCompressionDictionary;
	import src.reg.RegistryEntry;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class HudCustomizationScreen extends MovieClip 
	{
		protected static var _instance:HudCustomizationScreen;
		
		public var txtBp:TextField;
		public var sidebarBg:MovieClip;
		public var txtHelp:TextField;
		public var screen:HudPreviewScreen;
		public var btnOk:SimpleButton;
		public var btnCancel:SimpleButton;
		public var customSidebar:HudCustomSidebar;
		public var presetSidebar:HudPresetSidebar;
		public var help:MovieClip;
		
		protected var _mouseOverHelp:Boolean = false;
		
		public function HudCustomizationScreen(singleton:Enforcer) 
		{
			////////////////////////////////////////
			//Unlocked by default keys
			profileAddId("speedNeedle");
			profileAddId("dragNeedle");
			profileAddId("altitudeNeedle");
			////////////////////////////////////////
			
			customSidebar = new HudCustomSidebar(screen);
			addChild(customSidebar);
			
			presetSidebar = new HudPresetSidebar(screen);
			addChild(presetSidebar);
			
			//presetSidebar.visible = false;
			customSidebar.visible = false;
			
			help.visible = false;
			help.mouseChildren = help.mouseEnabled = false;
			
			customSidebar.bpChangeSignal.add(refreshBP);
			customSidebar.btnPresets.addEventListener(MouseEvent.CLICK, btnPresetsClick);
			
			presetSidebar.btnCustom.addEventListener(MouseEvent.CLICK, btnCustomClick);
			presetSidebar.bpChangeSignal.add(refreshBP);
			
			txtHelp.addEventListener(MouseEvent.ROLL_OVER, onHelpOver);
			txtHelp.addEventListener(MouseEvent.ROLL_OUT, onHelpOut);
			
			btnOk.addEventListener(MouseEvent.CLICK, okClick);
			btnCancel.addEventListener(MouseEvent.CLICK, cancelClick);
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			
			Main.instance.sysButtonsHide();
			
			refreshBP();
			
			ProfileState.instance.bonusPoints.valueChangedSignal.add(refreshBP);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			UiScaler.addAbsoluteManually(this, 400, -400);
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(txtBp), -160, 160);
			UiScaler.addAbsoluteManually(sidebarBg, -160, 164);
			UiScaler.addAbsoluteManually(presetSidebar, -160, 160);
			UiScaler.addAbsoluteManually(customSidebar, -160, 160);
			
		}
		
		public static function profileOwnsId(hudId:String):Boolean {
			var shortID:String = RegistryCompressionDictionary.getGodeOfID(hudId);
			
			for each(var s:SafeString in ProfileState.instance.hudBoughtKeys) {
				if (s.value == shortID) {
					return true;
				}
			}
			
			return false;
		}
		
		public static function profileAddId(hudId:String):void {
			if (profileOwnsId(hudId) == false) {
				var ss:SafeString = new SafeString();
				ss.value = RegistryCompressionDictionary.getGodeOfID(hudId);
				ProfileState.instance.hudBoughtKeys.push(ss);
			}
		}
		
		private function onHelpOver(e:MouseEvent):void 
		{
			_mouseOverHelp = true;
			help.visible = true;
			removeChild(help);
			addChild(help);
		}
		
		private function onHelpOut(e:MouseEvent):void 
		{
			_mouseOverHelp = false;
		}
		
		private function onFrame(e:Event):void 
		{
			if (_mouseOverHelp) {
				help.alpha += 0.08;
				help.visible = true;
				if (help.alpha >= 1) {
					help.alpha = 1;
				}
			}else {
				help.alpha -= 0.11;
				if (help.alpha <= 0) {
					help.alpha = 0;
					help.visible = false;
				}
			}
		}
		
		private function okClick(e:MouseEvent):void 
		{
			//trace("okClick()");
			Sfx.playMediumClick();
			screen.saveToProfile();
			Transition.transitionTo(destroy, ScreenManager.loadShop);
		}
		
		private function cancelClick(e:MouseEvent):void 
		{
			//trace("cancelClick()");
			Sfx.playMediumClick();
			Transition.transitionTo(destroy, ScreenManager.loadShop);
		}
		
		private function btnPresetsClick(e:MouseEvent):void 
		{
			customSidebar.visible = false;
			presetSidebar.visible = true;
			presetSidebar.refreshButtons();
		}
		
		private function btnCustomClick(e:MouseEvent):void 
		{
			customSidebar.visible = true;
			presetSidebar.visible = false;
			customSidebar.refreshItem();
		}
		
		protected function refreshBP(_ = null):void {
			txtBp.text = NumberUtils.numberDelimiter(ProfileState.instance.bonusPoints.value) + " BP";
		}
		
		static public function get instance():HudCustomizationScreen 
		{
			if (_instance == null) {
				_instance = new HudCustomizationScreen(new Enforcer());
			}
			return _instance;
		}
		
		public static function destroy():void {
			if (_instance) _instance.destroy();
		}
		
		public function destroy():void {
			ProfileState.instance.bonusPoints.valueChangedSignal.remove(refreshBP);
			
			if (customSidebar) {
				if (customSidebar.btnPresets) customSidebar.btnPresets.removeEventListener(MouseEvent.CLICK, btnPresetsClick);
				customSidebar.destroy();
			}
			customSidebar = null;
			
			if (presetSidebar) {
				if (presetSidebar.btnCustom) presetSidebar.btnCustom.removeEventListener(MouseEvent.CLICK, btnCustomClick);
				presetSidebar.destroy();
			}
			presetSidebar = null;
			
			if (txtHelp) {
				txtHelp.removeEventListener(MouseEvent.ROLL_OVER, onHelpOver);
				txtHelp.removeEventListener(MouseEvent.ROLL_OUT, onHelpOut);
			}
			txtHelp = null;
			
			if(btnOk) btnOk.removeEventListener(MouseEvent.CLICK, okClick);
			btnOk = null;
			
			if(btnCancel) btnCancel.removeEventListener(MouseEvent.CLICK, cancelClick);
			btnCancel = null;
			
			removeEventListener(Event.ENTER_FRAME, onFrame);
			_instance = null;
			txtBp = null;
			
			if (screen) screen.destroy();
			screen = null;
			
			help = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
			
		}
	}

}

class Enforcer { }
