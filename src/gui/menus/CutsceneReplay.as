package src.gui.menus 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lbg.components.MySimpleButton;
	import src.ScreenManager;
	import src.UiScaler;
	import src.gui.Cutscene;
	import src.gui.Transition;
	import src.Main;
	import src.system.Links;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class CutsceneReplay extends MovieClip 
	{
		protected static var _instance:CutsceneReplay;
		
		public var btn1:CutsceneReplayButton;
		public var btn2:CutsceneReplayButton;
		public var btn3:CutsceneReplayButton;
		public var btn4:CutsceneReplayButton;
		public var btn5:CutsceneReplayButton;
		public var btn6:CutsceneReplayButton;
		public var btn7:CutsceneReplayButton;
		public var btn8:CutsceneReplayButton;
		public var btn9:CutsceneReplayButton;
		public var btn10:CutsceneReplayButton;
		public var btn11:CutsceneReplayButton;
		public var btn12:CutsceneReplayButton;
		public var btnBack:CutsceneReplayButton;
		
		public function CutsceneReplay(singleton:Enforcer = null) 
		{
			super();
			
			if (singleton == null) {
				trace("Something went wrong...");
				throw new Error();
				return;
			}
			
			btn1.txtLabel.text = "Intro";
			btn2.visible = false;
			btn3.txtLabel.text = "Story Mode Intro";
			btn4.txtLabel.text = "Story Mode Ending";
			btn5.txtLabel.text = "Moon Crusher";
			btn6.txtLabel.text = "Classic Mode Ending";
			btn7.txtLabel.text = "Credits";
			btn8.txtLabel.text = "Youtube trailer";
			btn9.txtLabel.text = "Easter Egg 1";
			btn10.txtLabel.text = "Easter Egg 2";
			btn11.txtLabel.text = "Easter Egg 3";
			btn12.txtLabel.text = "Easter Egg 4";
			btnBack.txtLabel.text = "Back";
			
			//btn4.visible = false;
			//btn5.visible = false;
			//btn6.visible = false;
			
			
			btn1.addEventListener(MouseEvent.CLICK, onBtn1Click);
			btn3.addEventListener(MouseEvent.CLICK, onBtn3Click);
			btn4.addEventListener(MouseEvent.CLICK, onBtn4Click);
			btn5.addEventListener(MouseEvent.CLICK, onBtn5Click);
			btn6.addEventListener(MouseEvent.CLICK, onBtn6Click);
			btn7.addEventListener(MouseEvent.CLICK, onBtn7Click);
			btn8.addEventListener(MouseEvent.CLICK, onBtn8Click);
			btn9.addEventListener(MouseEvent.CLICK, onBtn9Click);
			btn10.addEventListener(MouseEvent.CLICK, onBtn10Click);
			btn11.addEventListener(MouseEvent.CLICK, onBtn11Click);
			btn12.addEventListener(MouseEvent.CLICK, onBtn12Click);
			btnBack.addEventListener(MouseEvent.CLICK, onBtnBackClick);
			
			
			if (ProfileState.instance.cutsceneViewedStoryEnding == false) {
				btn4.txtLabel.textColor = 0x999999;
				btn4.txtLabel.text = "???";
				btn4.removeEventListener(MouseEvent.CLICK, onBtn4Click);
			}
			
			if (ProfileState.instance.cutsceneViewedMoonCrusher == false) {
				btn5.txtLabel.textColor = 0x999999;
				btn5.txtLabel.text = "???";
				btn5.removeEventListener(MouseEvent.CLICK, onBtn5Click);
			}
			
			if (ProfileState.instance.cutsceneViewedClassicEnding == false) {
				btn6.txtLabel.textColor = 0x999999;
				btn6.txtLabel.text = "???";
				btn6.removeEventListener(MouseEvent.CLICK, onBtn6Click);
			}
			
			if (ProfileState.instance.easterEggsFound <=0) {
				btn9.txtLabel.textColor = 0x999999;
				btn9.txtLabel.text = "???";
				btn9.removeEventListener(MouseEvent.CLICK, onBtn9Click);
			}
			
			if (ProfileState.instance.easterEggsFound <=1) {
				btn10.txtLabel.textColor = 0x999999;
				btn10.txtLabel.text = "???";
				btn10.removeEventListener(MouseEvent.CLICK, onBtn10Click);
			}
			
			if (ProfileState.instance.easterEggsFound <=2) {
				btn11.txtLabel.textColor = 0x999999;
				btn11.txtLabel.text = "???";
				btn11.removeEventListener(MouseEvent.CLICK, onBtn11Click);
			}
			
			if (ProfileState.instance.easterEggsFound <=3) {
				btn12.txtLabel.textColor = 0x999999;
				btn12.txtLabel.text = "???";
				btn12.removeEventListener(MouseEvent.CLICK, onBtn12Click);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			UiScaler.addAbsoluteManually(this, 360, -360);
		}
		
		private function onBtn1Click(e:MouseEvent):void 
		{
			clearListeners();
			Transition.transitionTo(destroy, Cutscene.playIntroFromVCR);
		}
		
		private function onBtn3Click(e:MouseEvent):void 
		{
			clearListeners();
			Transition.transitionTo(destroy, Cutscene.playNewGameIntroFromVCR);
		}
		
		private function onBtn4Click(e:MouseEvent):void 
		{
			clearListeners();
			Transition.transitionTo(destroy, Cutscene.playEndingFromVCR);
		}
		
		private function onBtn5Click(e:MouseEvent):void 
		{
			clearListeners();
			Transition.transitionTo(destroy, Cutscene.playMoonCrusherFromVCR);
		}
		
		private function onBtn6Click(e:MouseEvent):void 
		{
			clearListeners();
			Transition.transitionTo(destroy, Cutscene.playSupermanFromVCR);
		}
		
		private function onBtn7Click(e:MouseEvent):void 
		{
			clearListeners();
			Transition.transitionTo(destroy, Cutscene.playCreditsFromVCR);
		}
		
		private function onBtn8Click(e:MouseEvent):void 
		{
		}
		
		private function onBtn9Click(e:MouseEvent):void 
		{
			Links.linkEasterEgg1();
		}
		
		private function onBtn10Click(e:MouseEvent):void 
		{
			Links.linkEasterEgg2();
		}
		
		private function onBtn11Click(e:MouseEvent):void 
		{
			Links.linkEasterEgg3();
		}
		
		private function onBtn12Click(e:MouseEvent):void 
		{
			Links.linkEasterEgg4();
		}
		
		private function onBtnBackClick(e:MouseEvent):void 
		{
			clearListeners();
			Transition.transitionTo(destroy, ScreenManager.loadBonusShop);
		}
		
		protected function clearListeners():void {
			if(btn1) btn1.removeEventListener(MouseEvent.CLICK, onBtn1Click);
			if(btn3) btn3.removeEventListener(MouseEvent.CLICK, onBtn3Click);
			if(btn4) btn4.removeEventListener(MouseEvent.CLICK, onBtn4Click);
			if(btn5) btn5.removeEventListener(MouseEvent.CLICK, onBtn5Click);
			if(btn6) btn6.removeEventListener(MouseEvent.CLICK, onBtn6Click);
			if(btn7) btn7.removeEventListener(MouseEvent.CLICK, onBtn7Click);
			if(btnBack) btnBack.removeEventListener(MouseEvent.CLICK, onBtnBackClick);
		}
		
		static public function get instance():CutsceneReplay 
		{
			if (_instance == null) {
				_instance = new CutsceneReplay(new Enforcer());
			}
			return _instance;
		}
		
		static public function destroy():void 
		{
			if (_instance)_instance.destroy();
		}
		
		public function destroy():void {
			_instance = null;
			
			clearListeners();
			
			if (btn1) btn1.destroy();
			if (btn2) btn2.destroy();
			if (btn3) btn3.destroy();
			if (btn4) btn4.destroy();
			if (btn5) btn5.destroy();
			if (btn6) btn6.destroy();
			if (btn7) btn7.destroy();
			if (btnBack) btnBack.destroy();
			
			
			btn1 = null;
			btn2 = null;
			btn3 = null;
			btn4 = null;
			btn5 = null;
			btn6 = null;
			btn7 = null;
			btnBack = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
		
	}

}

class Enforcer { }
