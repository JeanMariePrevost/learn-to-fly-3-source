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
	import src.UiScaler;
	import src.audio.*;
	import sound.*;
	import src.game.GameMediator;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	import src.gui.decorators.TweenPos;
	import src.Main;
	import src.shop.ShopTooltip;
	import src.system.*;
	
	/**
	 * ...
	 * @author 
	 */
	public class OptionsMenu extends MovieClip 
	{
		public var box:DialogBox;
		
		public var btnFullscreen:OptionsToggleButton;
		public var btnQuality:OptionsToggleButton;
		public var btnFallingObjects:OptionsToggleButton;
		public var btnSmoke:OptionsToggleButton;
		public var btnOther:OptionsToggleButton;
		public var btnUltraLow:OptionsToggleButton;
		public var btnMenuAnimations:OptionsToggleButton;
		public var btnControls:OptionsToggleButton;
		public var btnEndDay:OptionsToggleButton;
		
		public var btnMoreOptions:SimpleButton;
		public var btnBack:SimpleButton;
		
		public var soundSlider:OptionsSlider;
		public var musicSlider:OptionsSlider;
		
		public var txtSound:TextField;
		public var txtMusic:TextField;
		
		public var enableTooltip:Boolean = true;
		
		protected var _deco:Vector.<MouseBounce2> = new Vector.<MouseBounce2>();
		protected var _screenBlur:ScreenBlurEffect;
		protected var _soundPreview:ISound;
		
		protected var _pauseStartTimer:Number = 0;
		
		protected var _moreOptionsMenu:OptionsMenu2;
		
		public function OptionsMenu() 
		{
			super();
			
			enableTooltip = true;
			
			box.style.gotoAndStop(7);
			
			_deco.push(new MouseBounce2(btnFullscreen));
			_deco.push(new MouseBounce2(btnQuality));
			_deco.push(new MouseBounce2(btnFallingObjects));
			_deco.push(new MouseBounce2(btnSmoke));
			_deco.push(new MouseBounce2(btnOther));
			_deco.push(new MouseBounce2(btnUltraLow));
			_deco.push(new MouseBounce2(btnMenuAnimations));
			_deco.push(new MouseBounce2(btnControls));
			_deco.push(new MouseBounce2(btnEndDay));
			_deco.push(new MouseBounce2(soundSlider));
			_deco.push(new MouseBounce2(musicSlider));
			
			for each(var i:MouseBounce2 in _deco) {
				i.scaleMod = 0.03;
				i.signalOverTarget.add(onOver);
			}
			
			_deco.push(new MouseBounce2(btnMoreOptions));
			_deco.push(new MouseBounce2(btnBack));
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			
			//Setup
			btnFullscreen.txtLabel.text = "Render Quality";
			btnQuality.txtLabel.text = "Render Quality";
			btnFallingObjects.txtLabel.text = "Physics particles";
			btnSmoke.txtLabel.text = "Smoke / trails";
			btnOther.txtLabel.text = "Clouds";
			btnUltraLow.txtLabel.text = "Disable all filters (buggy!)";
			btnMenuAnimations.txtLabel.text = "Pause on focus lost";
			btnEndDay.txtLabel.text = "Day ends automatically";
			btnControls.txtLabel.text = "Controls";
			
			btnFullscreen.addPossibleValue("1.0x");
			btnFullscreen.addPossibleValue("1.5x");
			btnFullscreen.addPossibleValue("Full (Can be slow)");
			btnFullscreen.addPossibleValue("0.7x");
			
			btnQuality.addPossibleValue("Medium");
			btnQuality.addPossibleValue("High");
			btnQuality.addPossibleValue("Low");
			
			btnFallingObjects.addPossibleValue("On");
			btnFallingObjects.addPossibleValue("Off");
			
			btnSmoke.addPossibleValue("On");
			btnSmoke.addPossibleValue("Off");
			
			btnOther.addPossibleValue("High (blur)");
			btnOther.addPossibleValue("Medium");
			btnOther.addPossibleValue("Low");
			btnOther.addPossibleValue("Off");
			
			btnUltraLow.addPossibleValue("On");
			btnUltraLow.addPossibleValue("Off");
			
			btnMenuAnimations.addPossibleValue("On");
			btnMenuAnimations.addPossibleValue("Off");
			
			btnEndDay.addPossibleValue("On");
			btnEndDay.addPossibleValue("Off");
			
			btnControls.addPossibleValue("Customize");
			
			btnQuality.visible = false;
			
			
			readFromProfile();
		}
		
		private function soundMouseUp(e:Event):void 
		{
			if (_soundPreview) _soundPreview.fadeOut(300);
			_soundPreview = null;
		}
		
		private function soundMouseDown(e:MouseEvent):void 
		{
			_soundPreview = Audio.playFadingSoundLoop(sound.Bubble1, this, 30);
		}
		
		private function onOver(target:DisplayObject):void 
		{
			if (!enableTooltip) return;
			
			var tip:String;
			//Log.log("onOver", target);
			
			switch(target) {
				case btnFullscreen:
					tip = "Resolution used when fullscreen. Vector graphics can be expensive at high resolutions.";
					break;
				case btnQuality:
					tip = "The rendering quality of the flash player";
					break;
				case btnFallingObjects:
					tip = "Physics objects such as dropped stages and boosts";
					break;
				case btnSmoke:
					tip = "Smoke puffs and trails effects";
					break;
				case btnOther:
					tip = "High: Clouds with transparency and motion blur effect\r Med: Clouds with transparency\r Low: Clouds are fully opaque\r Off: No clouds";
					break;
				case btnUltraLow:
					tip = "Disabling all filters can greatly improve performance, however it is buggy and will have some weird side effects. Use only if needed.";
					break;
				case btnMenuAnimations:
					tip = "Whether the game is paused when the flash player loses mouse focus";
					break;
				case btnEndDay:
					tip = "Finish the day after falling down for too long without using any stage or boost";
					break;
				case btnControls:
					tip = "Customize your controls here";
					break;
			}
			
			if (tip) {
				ShopTooltip.show(target, tip); 
			}
		}
		
		private function btnUltraLowOver(e:MouseEvent):void 
		{
			var tt:ToolTip = ShopTooltip.show(btnUltraLow, "Ultra Low settings removes a lot of visual effects from the game,\r but this is buggy and has many weird side effects. \rYou might need to reload the game\r after turning it off too."); 
			tt.parent.addChild(tt);
		}
		
		protected function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			enableTooltip = true;
			
			_moreOptionsMenu = new OptionsMenu2(this);
			parent.addChild(_moreOptionsMenu);
			_moreOptionsMenu.visible = false;
			//_moreOptionsMenu.x = 10000;
			//_moreOptionsMenu.y = y;
			
			
			_pauseStartTimer = getTimer();
			
			x = UiScaler.maxWidthAtCurrentRatio * 0.5
			y = UiScaler.UNSCALED_STAGE_HEIGHT * 0.5
			UiScaler.addAbsoluteManually(this, UiScaler.UNSCALED_STAGE_WIDTH / 2);
			
			TweenPos.tweenToCurrentPosition(this, new Point(0, 560), 30, 0, TweenPos.EASE_OUT_CUBIC);
			
			_screenBlur = addBlurBehind();
			
			Main.instance.enableFocusLostPausing = false;
			Main.instance.gamePaused = true;
			//Audio.pauseAllAudio(true);
			
			btnFullscreen.addEventListener(MouseEvent.CLICK, btnFullscreenClick);
			btnQuality.addEventListener(MouseEvent.CLICK, btnQualityClick);
			btnFallingObjects.addEventListener(MouseEvent.CLICK, btnFallingObjectsClick);
			btnSmoke.addEventListener(MouseEvent.CLICK, btnSmokeClick);
			btnOther.addEventListener(MouseEvent.CLICK, btnOtherClick);
			btnUltraLow.addEventListener(MouseEvent.CLICK, btnUltraLowClick);
			btnMenuAnimations.addEventListener(MouseEvent.CLICK, btnMenuAnimationsClick);
			btnEndDay.addEventListener(MouseEvent.CLICK, btnEndDayClick);
			btnControls.addEventListener(MouseEvent.CLICK, btnControlsClick);
			btnMoreOptions.addEventListener(MouseEvent.CLICK, btnMoreOptionsClick);
			btnBack.addEventListener(MouseEvent.CLICK, btnBackClick);
			
			musicSlider.changeSignal.add(changeMusicVolume);
			soundSlider.changeSignal.add(changeSoundVolume);
			soundSlider.addEventListener(MouseEvent.MOUSE_DOWN, soundMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, soundMouseUp);
			
			Input.esc.signalCommandDown.add(escPressed);
		}
		
		protected function btnFullscreenClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			btnFullscreen.nextValue();
			switch(btnFullscreen.txtValue.text) {
				case "1.0x":
				case "1x":
					ProfileState.instance.fullscreenMode = "1.0x";
					break;
				case "1.5x":
					ProfileState.instance.fullscreenMode = "1.5x";
					break;
				case "Full (Can be slow)":
					ProfileState.instance.fullscreenMode = "FULL";
					break;
				case "0.7x":
					ProfileState.instance.fullscreenMode = "0.7x";
					break;
				default:
					Log.log("btnFullscreenClick error - unexpected value...", btnFullscreen.txtValue.text);
					ProfileState.instance.fullscreenMode = "1.0x";
					break;
			}
			
			Main.instance.refreshFullscreenMode();
		}
		
		protected function btnQualityClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			
			btnQuality.nextValue();
			
			switch(btnQuality.txtValue.text) {
				case "High":
				case "high":
				case "HIGH":
					Main.instance.stage.quality = StageQuality.HIGH;
					ProfileState.instance.optionQuality = StageQuality.HIGH;
					//Log.log("btnQualityClick() -> High", btnQuality.txtValue.text, Main.instance.stage.quality);
					break;
				case "Medium":
				case "medium":
				case "MEDIUM":
					Main.instance.stage.quality = StageQuality.MEDIUM;
					ProfileState.instance.optionQuality = StageQuality.MEDIUM;
					//Log.log("btnQualityClick() -> Medium", btnQuality.txtValue.text, Main.instance.stage.quality);
					break;
				case "Low":
				case "low":
				case "LOW":
					Main.instance.stage.quality = StageQuality.LOW;
					ProfileState.instance.optionQuality = StageQuality.LOW;
					//Log.log("btnQualityClick() -> Low", btnQuality.txtValue.text, Main.instance.stage.quality);
					break;
				default:
					Log.log("btnQualityClick error - unexpected value...");
					Main.instance.stage.quality = StageQuality.MEDIUM;
					ProfileState.instance.optionQuality = StageQuality.MEDIUM;
					//Log.log("btnQualityClick() -> Defaulting...", btnQuality.txtValue.text, Main.instance.stage.quality);
					break;
			}
			
			Main.debugLayer.stage.quality = ProfileState.instance.optionQuality;
			Log.log("btnQualityClick()", btnQuality.txtValue.text, "->", stage.quality);
		}
		
		protected function btnFallingObjectsClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			btnFallingObjects.nextValue();
			ProfileState.instance.optionFallingObjects = btnFallingObjects.txtValue.text;
		}
		
		protected function btnSmokeClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			btnSmoke.nextValue();
			ProfileState.instance.optionSmoke = btnSmoke.txtValue.text;
		}
		
		protected function btnOtherClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			btnOther.nextValue();
			ProfileState.instance.optionClouds = btnOther.txtValue.text;
		}
		
		protected function btnUltraLowClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			btnUltraLow.nextValue();
			ProfileState.instance.ultraLowQuality = (btnUltraLow.txtValue.text == "On");
		}
		
		protected function btnMenuAnimationsClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			btnMenuAnimations.nextValue();
			ProfileState.instance.optionPauseOnFocusLost = btnMenuAnimations.txtValue.text;
		}
		
		protected function btnEndDayClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			btnEndDay.nextValue();
			ProfileState.instance.optionEndDayAuto = (btnEndDay.txtValue.text == "On");
		}
		
		protected function btnControlsClick(e:MouseEvent):void 
		{
			enableTooltip = false;
			Input.esc.signalCommandDown.remove(escPressed);
			Sfx.playMediumClick();
			Main.showControlsMenu();
		}
		
		protected function escPressed():void {
			btnBackClick(null);
		}
		
		protected function btnMoreOptionsClick(e:MouseEvent):void 
		{
			_moreOptionsMenu.y = y;
			y = 10000;
			_moreOptionsMenu.visible = true;
			visible = false;
		}
		
		public function btnBackClick(e:MouseEvent):void 
		{
			Input.esc.signalCommandDown.remove(escPressed);
			Sfx.playMediumClick();
			if (btnQuality) {
				btnFullscreen.removeEventListener(MouseEvent.CLICK, btnFullscreenClick);
				btnQuality.removeEventListener(MouseEvent.CLICK, btnQualityClick);
				btnFallingObjects.removeEventListener(MouseEvent.CLICK, btnFallingObjectsClick);
				btnSmoke.removeEventListener(MouseEvent.CLICK, btnSmokeClick);
				btnOther.removeEventListener(MouseEvent.CLICK, btnOtherClick);
				btnControls.removeEventListener(MouseEvent.CLICK, btnControlsClick);
				btnBack.removeEventListener(MouseEvent.CLICK, btnBackClick);
				musicSlider.changeSignal.remove(changeMusicVolume);
				soundSlider.changeSignal.remove(changeSoundVolume);
			}
			
			Main.saveGame();
			
			TweenPos.tweenFromCurrentPosition(this, new Point(0, 560), 20, 0, TweenPos.EASE_IN).finishedSignal.addOnce(finishMenu);
			_screenBlur.deblurAndDestroy(30);
			
			Main.instance.enableFocusLostPausing = true;
			Main.instance.gamePaused = false;
			
			var pauseDuration:Number = getTimer() - _pauseStartTimer;
			GameMediator.gameResumed.dispatch();
			GameMediator.gameResumedWithDuration.dispatch(pauseDuration);
		}
		
		protected function changeMusicVolume(value:Number):void {
			Log.log("Debug-> Music volume ", value);
			ProfileState.instance.musicVolume = value;
			Audio.musicVolume = value;
		}
		
		protected function changeSoundVolume(value:Number):void {
			Log.log("Debug-> Sound volume ", value);
			ProfileState.instance.soundVolume = value;
			Audio.soundVolume = value;
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
			switch(ProfileState.instance.fullscreenMode) {
				case "0.7x":
					btnFullscreen.setValueTo("0.7x");
					break;
				case "1.0x":
				case "1x":
					btnFullscreen.setValueTo("1.0x");
					break;
				case "1.5x":
					btnFullscreen.setValueTo("1.5x");
					break;
				case "FULL":
					btnFullscreen.setValueTo("Full (Can be slow)");
					break;
				default:
					Log.log("OptionsMenu error - Can't recognize fullscreen mode, using default.", ProfileState.instance.fullscreenMode);
					btnFullscreen.setValueTo("1.0x");
					break;
					
			}
			switch(Main.debugLayer.stage.quality) {
				case StageQuality.HIGH:
				case StageQuality.BEST:
				case "HIGH":
					btnQuality.setValueTo("High");
					break;
				case StageQuality.MEDIUM:
				case "MEDIUM":
					btnQuality.setValueTo("Medium");
					break;
				case StageQuality.LOW:
				case "LOW":
					btnQuality.setValueTo("Low");
					break;
				default:
					Log.log("OptionsMenu ERROR - Can't recognize stage quality, defaulted to Medium.");
					Main.debugLayer.stage.quality = StageQuality.MEDIUM;
					btnQuality.setValueTo("High");
					break;
					
			}
			btnFallingObjects.setValueTo(ProfileState.instance.optionFallingObjects);
			btnSmoke.setValueTo(ProfileState.instance.optionSmoke);
			btnOther.setValueTo(ProfileState.instance.optionClouds);
			if (ProfileState.instance.ultraLowQuality) {
				btnUltraLow.setValueTo("On");
			}else {
				btnUltraLow.setValueTo("Off");
			}
			btnMenuAnimations.setValueTo(ProfileState.instance.optionPauseOnFocusLost);
			
			if (ProfileState.instance.optionEndDayAuto) {
				btnEndDay.setValueTo("On");
			}else {
				btnEndDay.setValueTo("Off");
			}
			
			musicSlider.value = ProfileState.instance.musicVolume;
			soundSlider.value = ProfileState.instance.soundVolume;
		}
		
		/** Get values from the menu and update the profile options */
		public function writeToProfile():void {
			
		}
		
		protected function finishMenu():void {
			Input.updateControlsFromProfile(ProfileState.instance);
			destroy();
		}
		
		public function destroy():void {
			for each(var i:MouseBounce2 in _deco) {
				i.destroy();
			}
			_deco = null;
			
			if(box) box.destroy();
			box = null;
			
			//Audio.resumeAllAudio();
			
			if (_moreOptionsMenu) {
				_moreOptionsMenu.destroy();
				_moreOptionsMenu = null;
			}
			
			if (btnQuality) {
				btnQuality.removeEventListener(MouseEvent.CLICK, btnQualityClick);
				btnFallingObjects.removeEventListener(MouseEvent.CLICK, btnFallingObjectsClick);
				btnSmoke.removeEventListener(MouseEvent.CLICK, btnSmokeClick);
				btnOther.removeEventListener(MouseEvent.CLICK, btnOtherClick);
				btnControls.removeEventListener(MouseEvent.CLICK, btnControlsClick);
				btnBack.removeEventListener(MouseEvent.CLICK, btnBackClick);
				musicSlider.changeSignal.remove(changeMusicVolume);
				soundSlider.changeSignal.remove(changeSoundVolume);
				
				btnQuality.destroy();
				btnFallingObjects.destroy();
				btnSmoke.destroy();
				btnOther.destroy();
				btnControls.destroy();
				soundSlider.destroy();
				musicSlider.destroy();
			}
			
			btnQuality = null;
			btnFallingObjects = null;
			btnSmoke = null;
			btnOther = null;
			btnControls = null;
			btnBack = null;
			soundSlider = null;
			musicSlider = null;
			
			_screenBlur = null;
			
			txtSound = null;
			txtMusic = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
		
		
	}

}