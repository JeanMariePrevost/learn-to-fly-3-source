package src.gui 
{
	import com.hybrid.ui.ToolTip;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getAliasName;
	import flash.utils.getTimer;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.*;
	import sound.*;
	import src.game.GameMediator;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.TweenPos;
	import src.Main;
	import src.shop.ShopTooltip;
	import src.system.*;
	
	/**
	 * ...
	 * @author 
	 */
	public class OptionsMenu2 extends MovieClip 
	{
		public var box:DialogBox;
		
		public var btnDelta:OptionsToggleButton;
		public var btnShopAnim:OptionsToggleButton;
		public var btnTransition:OptionsToggleButton;
		public var btnMouseControl:OptionsToggleButton;
		public var btnMouseBoost:OptionsToggleButton;
		
		public var btnBasicOptions:SimpleButton;
		public var btnBack:SimpleButton;
		public var btnErase:SimpleButton;
		
		public var steeringPowerSlider:OptionsSliderNoBar;
		public var smoothSteeringSlider:OptionsSliderNoBar;
		
		protected var _deco:Vector.<MouseBounce> = new Vector.<MouseBounce>();
		
		protected var _basicOptionsMenu:OptionsMenu;
		
		public function OptionsMenu2(basicOptionsMenu:OptionsMenu) 
		{
			super();
			_basicOptionsMenu = basicOptionsMenu;
			
			
			box.style.gotoAndStop(7);
			
			_deco.push(new MouseBounce(btnDelta));
			_deco.push(new MouseBounce(btnShopAnim));
			_deco.push(new MouseBounce(btnTransition));
			_deco.push(new MouseBounce(btnMouseControl));
			_deco.push(new MouseBounce(btnMouseBoost));
			_deco.push(new MouseBounce(steeringPowerSlider));
			_deco.push(new MouseBounce(smoothSteeringSlider));
			
			for each(var i:MouseBounce in _deco) {
				i.scaleMod = 0.03;
			}
			
			_deco.push(new MouseBounce(btnBasicOptions));
			_deco.push(new MouseBounce(btnBack));
			_deco.push(new MouseBounce(btnErase));
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			
			//Setup
			btnDelta.txtLabel.text = "Delta Time";
			btnShopAnim.txtLabel.text = "Shop movement effect";
			btnTransition.txtLabel.text = "Screen Transitions";
			btnMouseControl.txtLabel.text = "Use Mouse Control";
			btnMouseBoost.txtLabel.text = "Mouse triggers boosts";
			
			btnDelta.addPossibleValue("Normal");
			btnDelta.addPossibleValue("Low");
			btnDelta.addPossibleValue("Off");
			
			btnShopAnim.addPossibleValue("On");
			btnShopAnim.addPossibleValue("Off");
			
			btnTransition.addPossibleValue("On");
			btnTransition.addPossibleValue("Off");
			
			btnMouseBoost.addPossibleValue("On");
			btnMouseBoost.addPossibleValue("Off");
			
			btnMouseControl.addPossibleValue("Off");
			btnMouseControl.addPossibleValue("With indicator");
			btnMouseControl.addPossibleValue("W/o indicator");
			
			readFromProfile();
		}
		
		private function onOver(e:MouseEvent):void 
		{
			var tip:String;
			
			switch(e.target) {
				case btnDelta:
					tip = "How much the game compensates for FPS drop, maintaining the same speed even when lagging";
					break;
				case btnShopAnim:
					tip = "The little movement effect in the shop screens when you move the cursor";
					break;
				case btnTransition:
					tip = "Enable or disable the transition between each screen";
					break;
				case btnMouseControl:
					tip = "Steer with the mouse instead of the keyboard";
					break;
				case btnMouseBoost:
					tip = "Use the left mouse button to trigger all boosts";
					break;
				case steeringPowerSlider:
					tip = "Flight controls feel too fast? Reduce steering here.";
					break;
				case smoothSteeringSlider:
					tip = "Adds a smooth-in effect to flight controls. Steering will gradually fade in.";
					break;
				case btnErase:
					tip = "Erase all your data and start over";
					break;
			}
			
			if (tip) {
				ShopTooltip.show(e.target as DisplayObjectContainer, tip); 
			}
		}
		
		protected function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			x = UiScaler.maxWidthAtCurrentRatio * 0.5
			y = UiScaler.UNSCALED_STAGE_HEIGHT * 0.5
			UiScaler.addAbsoluteManually(this, UiScaler.UNSCALED_STAGE_WIDTH / 2);
			
			btnDelta.addEventListener(MouseEvent.CLICK, btnDeltaClick);
			btnShopAnim.addEventListener(MouseEvent.CLICK, btnShopAnimClick);
			btnTransition.addEventListener(MouseEvent.CLICK, btnTransitionClick);
			btnMouseControl.addEventListener(MouseEvent.CLICK, btnMouseControlClick);
			btnMouseBoost.addEventListener(MouseEvent.CLICK, btnMouseBoostClick);
			
			btnBasicOptions.addEventListener(MouseEvent.CLICK, btnBasicOptionsClick);
			btnBack.addEventListener(MouseEvent.CLICK, btnBackClick);
			btnErase.addEventListener(MouseEvent.CLICK, btnEraseClick);
			
			btnDelta.addEventListener(MouseEvent.ROLL_OVER, onOver);
			btnShopAnim.addEventListener(MouseEvent.ROLL_OVER, onOver);
			btnTransition.addEventListener(MouseEvent.ROLL_OVER, onOver);
			btnMouseControl.addEventListener(MouseEvent.ROLL_OVER, onOver);
			btnMouseBoost.addEventListener(MouseEvent.ROLL_OVER, onOver);
			
			steeringPowerSlider.changeSignal.add(changePowerSlider);
			smoothSteeringSlider.changeSignal.add(changeSmoothSlider);
			
			steeringPowerSlider.addEventListener(MouseEvent.ROLL_OVER, onOver);
			smoothSteeringSlider.addEventListener(MouseEvent.ROLL_OVER, onOver);
			
			Input.esc.signalCommandDown.add(escPressed);
		}
		
		protected function btnDeltaClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			btnDelta.nextValue();
			
			ProfileState.instance.optionDeltaTime = btnDelta.txtValue.text;
		}
		
		protected function btnShopAnimClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			btnShopAnim.nextValue();
			ProfileState.instance.optionEnableShopAnim = (btnShopAnim.txtValue.text == "On");
		}
		
		protected function btnTransitionClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			btnTransition.nextValue();
			ProfileState.instance.optionEnableTransition = (btnTransition.txtValue.text == "On");
		}
		
		protected function btnMouseControlClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			btnMouseControl.nextValue();
			switch(btnMouseControl.txtValue.text) {
				case "Off":
				default:
					ProfileState.instance.optionMouseControl = 0;
					break;
				case "With indicator":
					ProfileState.instance.optionMouseControl = 1;
					break;
				case "W/o indicator":
					ProfileState.instance.optionMouseControl = 2;
					break;
			}
		}
		
		protected function btnMouseBoostClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			btnMouseBoost.nextValue();
			ProfileState.instance.controlsUseMouseBoost = (btnMouseBoost.txtValue.text == "On");
		}
		
		protected function changePowerSlider(value:Number):void {
			ProfileState.instance.optionSteeringPower = value;
			steeringPowerSlider.txtBar.text = NumberUtils.numberDelimiter(value * 100, ",", 3, 1) + "%";
		}
		
		protected function changeSmoothSlider(value:Number):void {
			ProfileState.instance.optionSmoothSteering = value;
			var delay:Number = NumberUtils.interpolate2(0, 3, 0, 1, value, 1, true);
			var delayString:String = NumberUtils.numberDelimiter(delay, "", 3, 2);
			
			if (delay <= 0) {
				delayString += " seconds";
			}else if (delay <= 1.009999999999) {
				delayString += " second";
			}else {
				delayString += " seconds";
			}
			
			smoothSteeringSlider.txtBar.text = delayString;
		}
		
		protected function escPressed():void {
			btnBackClick(null);
		}
		
		protected function btnBasicOptionsClick(e:MouseEvent):void 
		{
			_basicOptionsMenu.y = y;
			y = 10000;
			_basicOptionsMenu.visible = true;
			visible = false;
		}
		
		protected function btnBackClick(e:MouseEvent):void 
		{
			Input.esc.signalCommandDown.remove(escPressed);
			Sfx.playMediumClick();
			if (btnDelta) {
				btnDelta.removeEventListener(MouseEvent.CLICK, btnDeltaClick);
				btnShopAnim.removeEventListener(MouseEvent.CLICK, btnShopAnimClick);
				btnTransition.removeEventListener(MouseEvent.CLICK, btnTransitionClick);
				btnMouseControl.removeEventListener(MouseEvent.CLICK, btnMouseControlClick);
				btnMouseBoost.removeEventListener(MouseEvent.CLICK, btnMouseBoostClick);
				
				btnBack.removeEventListener(MouseEvent.CLICK, btnBackClick);
				btnErase.removeEventListener(MouseEvent.CLICK, btnEraseClick);
				
				btnDelta.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				btnShopAnim.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				btnTransition.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				btnMouseControl.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				btnMouseBoost.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				
				steeringPowerSlider.changeSignal.remove(changePowerSlider);
				smoothSteeringSlider.changeSignal.remove(changeSmoothSlider);
			}
			
			TweenPos.tweenFromCurrentPosition(this, new Point(0, 560), 20, 0, TweenPos.EASE_IN).finishedSignal.addOnce(finishMenu);
			_basicOptionsMenu.btnBackClick(null);
		}
		
		protected function btnEraseClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			var blur:ScreenBlurEffect = addBlurInside();
			var box:QuestionBox = new QuestionBox("Erase Game Data?", "All saves, options, medals and\rbonus shop items will be lost.\r\rErase game data?", eraseAllDataDoubleCheck, null, blur.deblurAndDestroy);
			parent.addChild(box);
		}
		
		protected function eraseAllDataDoubleCheck():void {
			var blur:ScreenBlurEffect = addBlurInside();
			var box:QuestionBox = new QuestionBox3("Are you sure?", "All game data will be lost. Continue?", eraseGame, null, blur.deblurAndDestroy);
			parent.addChild(box);
		}
		
		protected function eraseGame():void {
			eraseAllData();
			destroy();
		}
		
		public static function eraseAllData():void {
			var musicVol:Number = ProfileState.instance.musicVolume;
			var soundVol:Number = ProfileState.instance.soundVolume;
			var mute:Number = ProfileState.instance.mute;
			
			ProfileState.destroy();
			
			var emptyProfile:ProfileState = ProfileState.loadDebugInstance();
			emptyProfile.musicVolume = musicVol;
			emptyProfile.soundVolume = soundVol;
			emptyProfile.mute = mute;
			
			SaveLoadModule.saveProfileToFile(emptyProfile);//Save empty profile over old one
			ProfileState.initProfileState();//Load empty profile
			
			ProfileState.instance.musicVolume = musicVol;
			ProfileState.instance.soundVolume = soundVol;
			ProfileState.instance.mute = mute;
			
			Main.returnToMainMenu();
			
			Log.log("All profile and save states data cleared.");
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
		
		/** Get options from profile and update the menu */
		public function readFromProfile():void {
			btnDelta.setValueTo(ProfileState.instance.optionDeltaTime);
			if (ProfileState.instance.optionEnableShopAnim) {
				btnShopAnim.setValueTo("On");
			}else {
				btnShopAnim.setValueTo("Off");
			}
			if (ProfileState.instance.optionEnableTransition) {
				btnTransition.setValueTo("On");
			}else {
				btnTransition.setValueTo("Off");
			}
			if (ProfileState.instance.optionMouseControl == 1) {
				btnMouseControl.setValueTo("With indicator");
			}else if (ProfileState.instance.optionMouseControl == 2) {
				btnMouseControl.setValueTo("W/o indicator");
			}else {
				btnMouseControl.setValueTo("Off");
			}
			if (ProfileState.instance.controlsUseMouseBoost) {
				btnMouseBoost.setValueTo("On");
			}else {
				btnMouseBoost.setValueTo("Off");
			}
			
			steeringPowerSlider.value = ProfileState.instance.optionSteeringPower;
			smoothSteeringSlider.value = ProfileState.instance.optionSmoothSteering;
			
			changePowerSlider(steeringPowerSlider.value);
			changeSmoothSlider(smoothSteeringSlider.value);
		}
		
		protected function finishMenu():void {
			destroy();
		}
		
		public function destroy():void {
			if (_deco) {
				for each(var i:MouseBounce in _deco) i.destroy();
			}
			_deco = null;
			
			if(box) box.destroy();
			box = null;
			
			if (btnDelta) {
				btnDelta.removeEventListener(MouseEvent.CLICK, btnDeltaClick);
				btnDelta.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				btnDelta.destroy();
			}
				
			if (btnShopAnim) {
				btnShopAnim.removeEventListener(MouseEvent.CLICK, btnShopAnimClick);
				btnShopAnim.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				btnShopAnim.destroy();
			}
			
			if (btnTransition) {
				btnTransition.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				btnTransition.removeEventListener(MouseEvent.CLICK, btnTransitionClick);
				btnTransition.destroy();
			}
			
			if (btnMouseControl) {
				btnMouseControl.removeEventListener(MouseEvent.CLICK, btnMouseControlClick);
				btnMouseControl.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				btnMouseControl.destroy();
			}
			
			if (btnBack) btnBack.removeEventListener(MouseEvent.CLICK, btnBackClick);
			if (btnErase) btnErase.removeEventListener(MouseEvent.CLICK, btnEraseClick);
				
			if (steeringPowerSlider) {
				if(steeringPowerSlider.changeSignal) steeringPowerSlider.changeSignal.remove(changePowerSlider);
				steeringPowerSlider.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				steeringPowerSlider.destroy();
			}
			
			if (smoothSteeringSlider) {
				smoothSteeringSlider.changeSignal.remove(changeSmoothSlider);
				smoothSteeringSlider.removeEventListener(MouseEvent.ROLL_OVER, onOver);
				smoothSteeringSlider.destroy();
			}
			
			btnDelta = null;
			btnShopAnim = null;
			btnTransition = null;
			btnMouseControl = null;
			btnErase = null;
			btnBack = null;
			steeringPowerSlider = null;
			smoothSteeringSlider = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
		
		
	}

}