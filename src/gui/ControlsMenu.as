package src.gui 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import lbg.debug.Log;
	import lbg.utils.KeyboardKeysName;
	import lbg.utils.Tools;
	import src.UiScaler;
	import src.audio.Sfx;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.TweenPos;
	import src.system.Global;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ControlsMenu extends MovieClip 
	{
		public var box:DialogBox;
		
		public var btnBoost:OptionsToggleButton;
		public var btnBrake:OptionsToggleButton;
		public var btnLeft:OptionsToggleButton;
		public var btnRight:OptionsToggleButton;
		public var btnBoost1:OptionsToggleButton;
		public var btnBoost2:OptionsToggleButton;
		public var btnBoost3:OptionsToggleButton;
		public var btnBoost4:OptionsToggleButton;
		public var btnReady:OptionsToggleButton;
		
		public var btnBack:SimpleButton;
		public var btnDefault:SimpleButton;
		
		
		protected var _deco:Vector.<MouseBounce> = new Vector.<MouseBounce>();
		protected var _screenBlur:ScreenBlurEffect;
		protected var _buttonClicked:OptionsToggleButton;
		
		public function ControlsMenu() 
		{
			super();
			
			box.style.gotoAndStop(8);
			
			_deco.push(new MouseBounce(btnBoost));
			_deco.push(new MouseBounce(btnBrake));
			_deco.push(new MouseBounce(btnLeft));
			_deco.push(new MouseBounce(btnRight));
			_deco.push(new MouseBounce(btnBoost1));
			_deco.push(new MouseBounce(btnBoost2));
			_deco.push(new MouseBounce(btnBoost3));
			_deco.push(new MouseBounce(btnBoost4));
			_deco.push(new MouseBounce(btnReady));
			
			for each(var i:MouseBounce in _deco) {
				i.scaleMod = 0.03;
			}
			
			_deco.push(new MouseBounce(btnBack));
			_deco.push(new MouseBounce(btnDefault));
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			
			//Setup
			btnBoost.txtLabel.text = "Boost";
			btnBrake.txtLabel.text = "Brake";
			btnLeft.txtLabel.text = "Turn Left";
			btnRight.txtLabel.text = "Turn Right";
			btnBoost1.txtLabel.text = "Boost #1";
			btnBoost2.txtLabel.text = "Boost #2";
			btnBoost3.txtLabel.text = "Boost #3";
			btnBoost4.txtLabel.text = "Boost #4";
			btnReady.txtLabel.text = "Ready/Abort";
			
			readFromProfile();
			
			btnBoost.addEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBrake.addEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnLeft.addEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnRight.addEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBoost1.addEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBoost2.addEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBoost3.addEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBoost4.addEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnReady.addEventListener(MouseEvent.CLICK, onControlsMenuClick);
			
			btnBack.addEventListener(MouseEvent.CLICK, btnBackClick);
			btnDefault.addEventListener(MouseEvent.CLICK, btnDefaultClick);
		}
		
		protected function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			x = UiScaler.maxWidthAtCurrentRatio * 0.5;
			y = UiScaler.UNSCALED_STAGE_HEIGHT * 0.5;
			
			TweenPos.tweenToCurrentPosition(this, new Point(0, 550), 30, 0, TweenPos.EASE_OUT_CUBIC);
			
			//UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(this), 360, -360);
			
			_screenBlur = addBlurBehind();
		}
		
		protected function addBlurBehind():ScreenBlurEffect {
			var blur:ScreenBlurEffect = new ScreenBlurEffect();
			parent.addChild(blur);
			if (parent.getChildIndex(this) <= parent.getChildIndex(blur)) {
				parent.swapChildren(this, blur);
			}
			return blur;
		}
		
		protected function addBlurInside():ScreenBlurEffect {
			var blur:ScreenBlurEffect = new ScreenBlurEffect();
			blur.x = -x;
			blur.y = -y;
			addChild(blur);
			return blur;
		}
		
		protected function onControlsMenuClick(e:Event):void 
		{
			Sfx.playMediumClick();
			
			readFromProfile();
			
			if (e.currentTarget is OptionsToggleButton) {
				_buttonClicked = e.currentTarget as OptionsToggleButton;
				_buttonClicked.txtValue.text = "Press key...";
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			}
		}
		
		private function keyDown(e:KeyboardEvent):void 
		{
			if (_buttonClicked == null) return;
			
			if (e.keyCode == 27) {
				//Cancel with ESC
				readFromProfile();
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
				_buttonClicked = null;
				return;
			}
			
			switch(_buttonClicked) {
				case btnBoost:
					ProfileState.instance.controlsBoosts = e.keyCode;
					break;
				case btnBrake:
					ProfileState.instance.controlsBrake = e.keyCode;
					break;
				case btnLeft:
					ProfileState.instance.controlsTurnLeft = e.keyCode;
					break;
				case btnRight:
					ProfileState.instance.controlsTurnRight = e.keyCode;
					break;
				case btnBoost1:
					ProfileState.instance.controlsBoost1 = e.keyCode;
					break;
				case btnBoost2:
					ProfileState.instance.controlsBoost2 = e.keyCode;
					break;
				case btnBoost3:
					ProfileState.instance.controlsBoost3 = e.keyCode;
					break;
				case btnBoost4:
					ProfileState.instance.controlsBoost4 = e.keyCode;
					break;
				case btnReady:
					ProfileState.instance.controlsReadyAbort = e.keyCode;
					break;
				default:
					Log.log("ControlsMenu error - unknown _buttonClicked, cannot save preference to profile.");
					break;
					
			}
			
			Input.updateControlsFromProfile(ProfileState.instance);
			
			_buttonClicked.txtValue.text = KeyboardKeysName.getNameOfKey(e.keyCode);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			_buttonClicked = null;
			
		}
		
		protected function btnBackClick(e:Event):void 
		{
			Sfx.playMediumClick();
			
			btnBoost.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBrake.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnLeft.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnRight.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBoost1.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBoost2.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBoost3.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBoost4.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnReady.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBack.removeEventListener(MouseEvent.CLICK, btnBackClick);
			
			_screenBlur.deblurAndDestroy(10);
			TweenPos.tweenFromCurrentPosition(this, new Point(0, 550), 20, 0, TweenPos.EASE_IN).finishedSignal.addOnce(finishMenu);
		}
		
		protected function btnDefaultClick(e:Event):void 
		{
			Sfx.playMediumClick();
			
			var blur:ScreenBlurEffect = addBlurInside();
			var box:QuestionBox = new QuestionBox("Restore Defaults", "Are you sure you want to restore default controls?", restoreDefaultControls, null, blur.deblurAndDestroy);
			parent.addChild(box);
		}
		
		protected function restoreDefaultControls():void {
			_buttonClicked = null;
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			
			btnBoost.txtLabel.text = "Boost";
			btnBrake.txtLabel.text = "Brake";
			btnLeft.txtLabel.text = "Turn Left";
			btnRight.txtLabel.text = "Turn Right";
			btnBoost1.txtLabel.text = "Boost #1";
			btnBoost2.txtLabel.text = "Boost #2";
			btnBoost3.txtLabel.text = "Boost #3";
			btnBoost4.txtLabel.text = "Boost #4";
			btnReady.txtLabel.text = "Ready/Abort";
			
			ProfileState.instance.controlsBoosts = -1;
			ProfileState.instance.controlsBrake = -1;
			ProfileState.instance.controlsTurnLeft = -1;
			ProfileState.instance.controlsTurnRight = -1;
			ProfileState.instance.controlsBoost1 = -1;
			ProfileState.instance.controlsBoost2 = -1;
			ProfileState.instance.controlsBoost3 = -1;
			ProfileState.instance.controlsBoost4 = -1;
			ProfileState.instance.controlsReadyAbort = -1;
			
			Log.log("User control preferences restored to default...");
			
			readFromProfile();
		}
		
		/** Get options from profile and update the menu */
		public function readFromProfile():void {
			//UP
			if (ProfileState.instance.controlsBoosts < 0) {
				btnBoost.txtValue.text = "W";
			}else {
				btnBoost.txtValue.text = KeyboardKeysName.getNameOfKey(ProfileState.instance.controlsBoosts);
			}
			
			//DOWN
			if (ProfileState.instance.controlsBrake < 0) {
				btnBrake.txtValue.text = "S";
			}else {
				btnBrake.txtValue.text = KeyboardKeysName.getNameOfKey(ProfileState.instance.controlsBrake);
			}
			
			//LEFT
			if (ProfileState.instance.controlsTurnLeft < 0) {
				btnLeft.txtValue.text = "A";
			}else {
				btnLeft.txtValue.text = KeyboardKeysName.getNameOfKey(ProfileState.instance.controlsTurnLeft);
			}
			
			//RIGHT
			if (ProfileState.instance.controlsTurnRight < 0) {
				btnRight.txtValue.text = "D";
			}else {
				btnRight.txtValue.text = KeyboardKeysName.getNameOfKey(ProfileState.instance.controlsTurnRight);
			}
			
			//BOOST1
			if (ProfileState.instance.controlsBoost1 < 0) {
				btnBoost1.txtValue.text = "1";
			}else {
				btnBoost1.txtValue.text = KeyboardKeysName.getNameOfKey(ProfileState.instance.controlsBoost1);
			}
			
			//BOOST2
			if (ProfileState.instance.controlsBoost2 < 0) {
				btnBoost2.txtValue.text = "2";
			}else {
				btnBoost2.txtValue.text = KeyboardKeysName.getNameOfKey(ProfileState.instance.controlsBoost2);
			}
			
			//BOOST3
			if (ProfileState.instance.controlsBoost3 < 0) {
				btnBoost3.txtValue.text = "3";
			}else {
				btnBoost3.txtValue.text = KeyboardKeysName.getNameOfKey(ProfileState.instance.controlsBoost3);
			}
			
			//BOOST4
			if (ProfileState.instance.controlsBoost4 < 0) {
				btnBoost4.txtValue.text = "4";
			}else {
				btnBoost4.txtValue.text = KeyboardKeysName.getNameOfKey(ProfileState.instance.controlsBoost4);
			}
			
			//READY ABORT
			if (ProfileState.instance.controlsReadyAbort < 0) {
				btnReady.txtValue.text = "Enter";
			}else {
				btnReady.txtValue.text = KeyboardKeysName.getNameOfKey(ProfileState.instance.controlsReadyAbort);
			}
		}
		
		/** Get values from the menu and update the profile options */
		public function writeToProfile():void {
			
		}
		
		
		protected function finishMenu():void 
		{
			destroy();
		}
		
		public function destroy():void 
		{
			for each(var i:MouseBounce in _deco) {
				i.destroy();
			}
			_deco = null;
			
			btnBoost.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBrake.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnLeft.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnRight.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBoost1.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBoost2.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBoost3.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBoost4.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnReady.removeEventListener(MouseEvent.CLICK, onControlsMenuClick);
			btnBack.removeEventListener(MouseEvent.CLICK, btnBackClick);
			
			box.destroy();
			box = null;
			
			btnBoost.destroy();
			btnBrake.destroy();
			btnLeft.destroy();
			btnRight.destroy();
			btnBoost1.destroy();
			btnBoost2.destroy();
			btnBoost3.destroy();
			btnBoost4.destroy();
			btnReady.destroy();
			
			btnBoost = null;
			btnBrake = null;
			btnLeft = null;
			btnRight = null;
			btnBoost1 = null;
			btnBoost2 = null;
			btnBoost3 = null;
			btnBoost4 = null;
			btnReady = null;
			
			btnBack = null;
			
			
			_screenBlur = null;
			_buttonClicked = null;
		}
		
	}

}