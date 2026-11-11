package src.customization 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.Sfx;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	import src.gui.QuestionBox;
	import src.gui.ScreenBlurEffect;
	import src.gui.Transition;
	import src.Main;
	import src.Penguin;
	import src.shop.ShopTooltip;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class CustomScreen extends MovieClip 
	{
		protected static var _instance:CustomScreen;
		
		public var txtBp:TextField;
		public var btnBuy:MovieClip;
		
		public var penguin:Penguin;
		public var txtHat:TextField;
		public var txtFace:TextField;
		public var txtSuit:TextField;
		public var txtBody:TextField;
		
		public var btnNextHat:SimpleButton;
		public var btnResetHat:SimpleButton;
		public var btnPrevHat:SimpleButton;
		
		public var btnNextFace:SimpleButton;
		public var btnResetFace:SimpleButton;
		public var btnPrevFace:SimpleButton;
		
		public var btnNextSuit:SimpleButton;
		public var btnResetSuit:SimpleButton;
		public var btnPrevSuit:SimpleButton;
		
		public var btnNextBody:SimpleButton;
		public var btnResetBody:SimpleButton;
		public var btnPrevBody:SimpleButton;
		
		public var btnNextHue:SimpleButton;
		public var btnResetHue:SimpleButton;
		public var btnPrevHue:SimpleButton;
		
		public var btnNextBrightness:SimpleButton;
		public var btnResetBrightness:SimpleButton;
		public var btnPrevBrightness:SimpleButton;
		
		public var btnNextSaturation:SimpleButton;
		public var btnResetSaturation:SimpleButton;
		public var btnPrevSaturation:SimpleButton;
		
		public var btnNextContrast:SimpleButton;
		public var btnResetContrast:SimpleButton;
		public var btnPrevContrast:SimpleButton;
		
		public var hueSlider:Slider;
		public var brightnessSlider:Slider;
		public var saturationSlider:Slider;
		public var contrastSlider:Slider;
		
		public var btnOk:SimpleButton;
		public var btnCancel:SimpleButton;
		public var btnShip:SimpleButton;
		
		protected var _okBounce:MouseBounce;
		protected var _cancelBounce:MouseBounce;
		protected var _shipBounce:MouseBounce;
		protected var _buyBounce:MouseBounce2;
		
		protected var _dirty:Boolean = false;
		
		public function CustomScreen(singleton:Enforcer) 
		{
			btnNextHat.addEventListener(MouseEvent.CLICK, nextHat);
			btnResetHat.addEventListener(MouseEvent.CLICK, resetHat);
			btnPrevHat.addEventListener(MouseEvent.CLICK, prevHat);
			
			btnNextFace.addEventListener(MouseEvent.CLICK, nextFace);
			btnResetFace.addEventListener(MouseEvent.CLICK, resetFace);
			btnPrevFace.addEventListener(MouseEvent.CLICK, prevFace);
			
			btnNextSuit.addEventListener(MouseEvent.CLICK, nextSuit);
			btnResetSuit.addEventListener(MouseEvent.CLICK, resetSuit);
			btnPrevSuit.addEventListener(MouseEvent.CLICK, prevSuit);
			
			btnNextBody.addEventListener(MouseEvent.CLICK, nextBody);
			btnResetBody.addEventListener(MouseEvent.CLICK, resetBody);
			btnPrevBody.addEventListener(MouseEvent.CLICK, prevBody);
			
			btnNextHue.addEventListener(MouseEvent.CLICK, increaseHue);
			btnResetHue.addEventListener(MouseEvent.CLICK, resetHue);
			btnPrevHue.addEventListener(MouseEvent.CLICK, decreaseHue);
			
			btnNextBrightness.addEventListener(MouseEvent.CLICK, increaseBrightness);
			btnResetBrightness.addEventListener(MouseEvent.CLICK, resetBrightness);
			btnPrevBrightness.addEventListener(MouseEvent.CLICK, decreaseBrightness);
			
			btnNextSaturation.addEventListener(MouseEvent.CLICK, increaseSaturation);
			btnResetSaturation.addEventListener(MouseEvent.CLICK, resetSaturation);
			btnPrevSaturation.addEventListener(MouseEvent.CLICK, decreaseSaturation);
			
			btnNextContrast.addEventListener(MouseEvent.CLICK, increaseContrast);
			btnResetContrast.addEventListener(MouseEvent.CLICK, resetContrast);
			btnPrevContrast.addEventListener(MouseEvent.CLICK, decreaseContrast);
			
			
			//Tooltips
			btnNextHat.addEventListener(MouseEvent.ROLL_OVER, showToolTipNext);
			btnResetHat.addEventListener(MouseEvent.ROLL_OVER, showToolTipClear);
			btnPrevHat.addEventListener(MouseEvent.ROLL_OVER, showToolTipPrevious);
			
			btnNextFace.addEventListener(MouseEvent.ROLL_OVER, showToolTipNext);
			btnResetFace.addEventListener(MouseEvent.ROLL_OVER, showToolTipClear);
			btnPrevFace.addEventListener(MouseEvent.ROLL_OVER, showToolTipPrevious);
			
			btnNextSuit.addEventListener(MouseEvent.ROLL_OVER, showToolTipNext);
			btnResetSuit.addEventListener(MouseEvent.ROLL_OVER, showToolTipClear);
			btnPrevSuit.addEventListener(MouseEvent.ROLL_OVER, showToolTipPrevious);
			
			btnNextBody.addEventListener(MouseEvent.ROLL_OVER, showToolTipNext);
			btnResetBody.addEventListener(MouseEvent.ROLL_OVER, showToolTipClear);
			btnPrevBody.addEventListener(MouseEvent.ROLL_OVER, showToolTipPrevious);
			
			btnNextHue.addEventListener(MouseEvent.ROLL_OVER, showToolTipIncrease);
			btnResetHue.addEventListener(MouseEvent.ROLL_OVER, showToolTipReset);
			btnPrevHue.addEventListener(MouseEvent.ROLL_OVER, showToolTipDecrease);
			
			btnNextBrightness.addEventListener(MouseEvent.ROLL_OVER, showToolTipIncrease);
			btnResetBrightness.addEventListener(MouseEvent.ROLL_OVER, showToolTipReset);
			btnPrevBrightness.addEventListener(MouseEvent.ROLL_OVER, showToolTipDecrease);
			
			btnNextSaturation.addEventListener(MouseEvent.ROLL_OVER, showToolTipIncrease);
			btnResetSaturation.addEventListener(MouseEvent.ROLL_OVER, showToolTipReset);
			btnPrevSaturation.addEventListener(MouseEvent.ROLL_OVER, showToolTipDecrease);
			
			btnNextContrast.addEventListener(MouseEvent.ROLL_OVER, showToolTipIncrease);
			btnResetContrast.addEventListener(MouseEvent.ROLL_OVER, showToolTipReset);
			btnPrevContrast.addEventListener(MouseEvent.ROLL_OVER, showToolTipDecrease);
			
			
			
			_okBounce = new MouseBounce(btnOk);
			_cancelBounce = new MouseBounce(btnCancel);
			_shipBounce = new MouseBounce(btnShip);
			_buyBounce = new MouseBounce2(btnBuy);
			
			btnOk.addEventListener(MouseEvent.CLICK, btnOkClick);
			btnCancel.addEventListener(MouseEvent.CLICK, btnCancelClick);
			btnShip.addEventListener(MouseEvent.CLICK, btnShipClick);
			_buyBounce.signalClickTarget.add(btnBuyClick);
			
			hueSlider.signalChange.add(updateColor);
			brightnessSlider.signalChange.add(updateColor);
			saturationSlider.signalChange.add(updateColor);
			contrastSlider.signalChange.add(updateColor);
			
			hueSlider.value = ProfileState.instance.customizationData.penguinHue;
			brightnessSlider.value = ProfileState.instance.customizationData.penguinBrightness;
			saturationSlider.value = ProfileState.instance.customizationData.penguinSaturation;
			contrastSlider.value = ProfileState.instance.customizationData.penguinContrast;
			
			updateTxts();
			updateColor();
			
			ProfileState.instance.bonusPoints.valueChangedSignal.add(bpChanged);
			
			
			Main.instance.sysButtonsHide();
			
			_dirty = false;
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			UiScaler.addAbsoluteManually(this, 360, -360);
		}
		
		private function bpChanged(_):void 
		{
			updateTxts();
			updateCost();
			updateColor();
		}
		
		protected function showToolTipNext(e:MouseEvent):void {
			ShopTooltip.show(e.target as DisplayObject, "Next");
		}
		
		protected function showToolTipPrevious(e:MouseEvent):void {
			ShopTooltip.show(e.target as DisplayObject, "Previous");
		}
		
		protected function showToolTipClear(e:MouseEvent):void {
			ShopTooltip.show(e.target as DisplayObject, "Clear");
		}
		
		protected function showToolTipIncrease(e:MouseEvent):void {
			ShopTooltip.show(e.target as DisplayObject, "Increase");
		}
		
		protected function showToolTipDecrease(e:MouseEvent):void {
			ShopTooltip.show(e.target as DisplayObject, "Decrease");
		}
		
		protected function showToolTipReset(e:MouseEvent):void {
			ShopTooltip.show(e.target as DisplayObject, "Reset");
		}
		
		
		private function btnOkClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			
			//Save and quit
			
			//Save only if selected item is owned
			if(ProfileState.instance.customizationData.playerOwnsBody(penguin.currentFrame)) ProfileState.instance.customizationData.body = penguin.currentFrame;
			if(ProfileState.instance.customizationData.playerOwnsHat(penguin.hats.currentFrame)) ProfileState.instance.customizationData.hat = penguin.hats.currentFrame;
			if(ProfileState.instance.customizationData.playerOwnsFace(penguin.faces.currentFrame)) ProfileState.instance.customizationData.face = penguin.faces.currentFrame;
			if(ProfileState.instance.customizationData.playerOwnsSuit(penguin.suits.currentFrame)) ProfileState.instance.customizationData.suit = penguin.suits.currentFrame;
			
			ProfileState.instance.customizationData.penguinHue = hueSlider.value;
			ProfileState.instance.customizationData.penguinBrightness = brightnessSlider.value;
			ProfileState.instance.customizationData.penguinSaturation = saturationSlider.value;
			ProfileState.instance.customizationData.penguinContrast = contrastSlider.value;
			
			Transition.transitionTo(ScreenManager.unloadCustomization, ScreenManager.loadShop);
		}
		
		private function btnCancelClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			//Quit and discard changes
			Transition.transitionTo(ScreenManager.unloadCustomization, ScreenManager.loadShop);
		}
		
		protected function btnBuyClick(obj:DisplayObject):void {
			if (getSkinCost() <= ProfileState.instance.bonusPoints.value) {
				//Buy skin
				ProfileState.spendBonusPoints(getSkinCost());
				ProfileState.instance.customizationData.addOwnedBody(penguin.currentFrame);
				ProfileState.instance.customizationData.addOwnedHat(penguin.hats.currentFrame);
				ProfileState.instance.customizationData.addOwnedFace(penguin.faces.currentFrame);
				ProfileState.instance.customizationData.addOwnedSuit(penguin.suits.currentFrame);
			}else {
				Main.displayMessage("Not enough Bonus Points");
			}
			
			updateTxts();
		}
		
		private function btnShipClick(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			if (_dirty) {
				var mouseBlock:Sprite = new Sprite();
				mouseBlock.graphics.beginFill(0);
				mouseBlock.graphics.drawRect(0, 0, 720, 540);
				mouseBlock.graphics.endFill();
				mouseBlock.alpha = 0.001;
				addChild(mouseBlock);
				var qb:QuestionBox = new QuestionBox("Save changes?", "Do you want to save the changes you made before leaving this screen?", toPenguinAndSave, toPenguinAndDiscard);
				addChild(qb);
				qb.x -= this.x;
			}else {
				Transition.transitionTo(ScreenManager.unloadCustomization, ScreenManager.loadShipCustomization);
			}
		}
		
		protected function toPenguinAndSave():void {
			//Save and quit
			
			//Save only if selected item is owned
			if(ProfileState.instance.customizationData.playerOwnsBody(penguin.currentFrame)) ProfileState.instance.customizationData.body = penguin.currentFrame;
			if(ProfileState.instance.customizationData.playerOwnsHat(penguin.hats.currentFrame)) ProfileState.instance.customizationData.hat = penguin.hats.currentFrame;
			if(ProfileState.instance.customizationData.playerOwnsFace(penguin.faces.currentFrame)) ProfileState.instance.customizationData.face = penguin.faces.currentFrame;
			if(ProfileState.instance.customizationData.playerOwnsSuit(penguin.suits.currentFrame)) ProfileState.instance.customizationData.suit = penguin.suits.currentFrame;
			
			ProfileState.instance.customizationData.penguinHue = hueSlider.value;
			ProfileState.instance.customizationData.penguinBrightness = brightnessSlider.value;
			ProfileState.instance.customizationData.penguinSaturation = saturationSlider.value;
			ProfileState.instance.customizationData.penguinContrast = contrastSlider.value;
			
			Transition.transitionTo(ScreenManager.unloadCustomization, ScreenManager.loadShipCustomization);
		}
		
		protected function toPenguinAndDiscard():void {
			Transition.transitionTo(ScreenManager.unloadCustomization, ScreenManager.loadShipCustomization);
		}
		
		protected function nextHat(e:Event):void {
			Sfx.playShopClick();
			nextItem(penguin.hats);
			penguin.hatsBehind.gotoAndStop(penguin.hats.currentFrame);
			updateTxts();
		}
		
		protected function prevHat(e:Event):void {
			Sfx.playShopClick();
			previousItem(penguin.hats);
			penguin.hatsBehind.gotoAndStop(penguin.hats.currentFrame);
			updateTxts();
		}
		
		protected function resetHat(e:Event):void {
			Sfx.playShopClick();
			penguin.hats.gotoAndStop(1);
			penguin.hatsBehind.gotoAndStop(penguin.hats.currentFrame);
			updateTxts();
		}
		
		protected function nextFace(e:Event):void {
			Sfx.playShopClick();
			nextItem(penguin.faces);
			penguin.facesBehind.gotoAndStop(penguin.faces.currentFrame);
			updateTxts();
		}
		
		protected function prevFace(e:Event):void {
			Sfx.playShopClick();
			previousItem(penguin.faces);
			penguin.facesBehind.gotoAndStop(penguin.faces.currentFrame);
			updateTxts();
		}
		
		protected function resetFace(e:Event):void {
			Sfx.playShopClick();
			penguin.faces.gotoAndStop(1);
			penguin.facesBehind.gotoAndStop(penguin.faces.currentFrame);
			updateTxts();
		}
		
		protected function nextSuit(e:Event):void {
			Sfx.playShopClick();
			nextItem(penguin.suits);
			penguin.suitsBehind.gotoAndStop(penguin.suits.currentFrame);
			updateTxts();
		}
		
		protected function prevSuit(e:Event):void {
			Sfx.playShopClick();
			previousItem(penguin.suits);
			penguin.suitsBehind.gotoAndStop(penguin.suits.currentFrame);
			updateTxts();
		}
		
		protected function resetSuit(e:Event):void {
			Sfx.playShopClick();
			penguin.suits.gotoAndStop(1);
			penguin.suitsBehind.gotoAndStop(penguin.suits.currentFrame);
			updateTxts();
		}
		
		protected function nextBody(e:Event):void {
			Sfx.playShopClick();
			nextItem(penguin);
			updateTxts();
		}
		
		protected function prevBody(e:Event):void {
			Sfx.playShopClick();
			previousItem(penguin);
			updateTxts();
		}
		
		protected function resetBody(e:Event):void {
			Sfx.playShopClick();
			penguin.gotoAndStop(1);
			updateTxts();
		}
		
		protected function increaseHue(e:Event):void {
			Sfx.playShopClick();
			hueSlider.value += 0.02;
			updateColor();
		}
		
		protected function resetHue(e:Event):void {
			Sfx.playShopClick();
			hueSlider.value = 0.5;
			updateColor();
		}
		
		protected function decreaseHue(e:Event):void {
			Sfx.playShopClick();
			hueSlider.value -= 0.02;
			updateColor();
		}
		
		protected function increaseBrightness(e:Event):void {
			Sfx.playShopClick();
			brightnessSlider.value += 0.02;
			updateColor();
		}
		
		protected function resetBrightness(e:Event):void {
			Sfx.playShopClick();
			brightnessSlider.value = 0.5;
			updateColor();
		}
		
		protected function decreaseBrightness(e:Event):void {
			Sfx.playShopClick();
			brightnessSlider.value -= 0.02;
			updateColor();
		}
		
		protected function increaseSaturation(e:Event):void {
			Sfx.playShopClick();
			saturationSlider.value += 0.02;
			updateColor();
		}
		
		protected function resetSaturation(e:Event):void {
			Sfx.playShopClick();
			saturationSlider.value = 0.5;
			updateColor();
		}
		
		protected function decreaseSaturation(e:Event):void {
			Sfx.playShopClick();
			saturationSlider.value -= 0.02;
			updateColor();
		}
		
		protected function increaseContrast(e:Event):void {
			Sfx.playShopClick();
			contrastSlider.value += 0.02;
			updateColor();
		}
		
		protected function resetContrast(e:Event):void {
			Sfx.playShopClick();
			contrastSlider.value = 0.5;
			updateColor();
		}
		
		protected function decreaseContrast(e:Event):void {
			Sfx.playShopClick();
			contrastSlider.value -= 0.02;
			updateColor();
		}
		
		protected function updateTxts():void {
			_dirty = true;
			txtBp.text = NumberUtils.numberDelimiter(ProfileState.instance.bonusPoints.value) + " BP";
			txtHat.text = (penguin.hats.currentFrameLabel) ? penguin.hats.currentFrameLabel:"???";
			txtFace.text = (penguin.faces.currentFrameLabel) ? penguin.faces.currentFrameLabel:"???";
			txtSuit.text = (penguin.suits.currentFrameLabel) ? penguin.suits.currentFrameLabel:"???";
			txtBody.text = (penguin.currentFrameLabel) ? penguin.currentFrameLabel:"???";
			
			
			
			updateCost();
		}
		
		protected function updateColor(notInUse:Number = 0):void {
			_dirty = true;
			var hue:Number = -180 + (360 * hueSlider.value);
			var brightness:Number = -100 + (200 * brightnessSlider.value);
			var saturation:Number = -100 + (200 * saturationSlider.value);
			var contrast:Number = -100 + (200 * contrastSlider.value);
			
			DisplayObjectUtil.setColorMatrix(penguin, hue, saturation, brightness, contrast);
		}
		
		protected function updateCost():void {
			var cost:Number = getSkinCost();
			
			if (cost <= 0) {
				btnBuy.visible = false;
			}else {
				
				if (cost <= ProfileState.instance.bonusPoints.value) {
					DisplayObjectUtil.setColorMatrix(btnBuy);
				}else {
					DisplayObjectUtil.setColorMatrix(btnBuy, 0, -100, -30, 0);
				}
				btnBuy.visible = true;
				btnBuy.txtValue.text = cost.toFixed(0) + " BP";
			}
		}
		
		protected function getSkinCost():Number {
			var cost:Number = 0;
			
			var formatOwned:TextFormat = txtHat.defaultTextFormat;
			formatOwned.color = 0xCCCCCC;
			
			var formatNotOwned:TextFormat = txtBody.defaultTextFormat;
			formatNotOwned.color = 0xFF9999;
			
			if (ProfileState.instance.customizationData.playerOwnsHat(penguin.hats.currentFrame) == false) {
				cost += 10;
				txtHat.defaultTextFormat = formatNotOwned;
				txtHat.setTextFormat(formatNotOwned)
			}else {
				txtHat.defaultTextFormat = formatOwned;
				txtHat.setTextFormat(formatOwned)
			}
			if (ProfileState.instance.customizationData.playerOwnsFace(penguin.faces.currentFrame) == false) {
				cost += 10;
				txtFace.defaultTextFormat = formatNotOwned;
				txtFace.setTextFormat(formatNotOwned)
			}else {
				txtFace.defaultTextFormat = formatOwned;
				txtFace.setTextFormat(formatOwned)
			}
			if (ProfileState.instance.customizationData.playerOwnsSuit(penguin.suits.currentFrame) == false) {
				cost += 10;
				txtSuit.defaultTextFormat = formatNotOwned;
				txtSuit.setTextFormat(formatNotOwned)
			}else {
				txtSuit.defaultTextFormat = formatOwned;
				txtSuit.setTextFormat(formatOwned)
			}
			if (ProfileState.instance.customizationData.playerOwnsBody(penguin.currentFrame) == false) {
				cost += 10;
				txtBody.defaultTextFormat = formatNotOwned;
				txtBody.setTextFormat(formatNotOwned)
			}else {
				txtBody.defaultTextFormat = formatOwned;
				txtBody.setTextFormat(formatOwned)
			}
			return cost;
		}
		
		protected function nextItem(mc:MovieClip):void {
			if (mc.currentFrame >= mc.totalFrames) {
				mc.gotoAndStop(1);
			}else {
				mc.nextFrame();
			}
			
		}
		
		protected function previousItem(mc:MovieClip):void {
			if (mc.currentFrame <= 1) {
				mc.gotoAndStop(mc.totalFrames);
			}else {
				mc.prevFrame();
			}
			
		}
		
		
		static public function get instance():CustomScreen 
		{
			if (_instance == null) {
				_instance = new CustomScreen(new Enforcer());
			}
			return _instance;
		}
		
		public static function destroy():void {
			if (_instance) _instance.destroy();
		}
		
		public function destroy():void {
			_instance = null;
			
			ProfileState.instance.bonusPoints.valueChangedSignal.remove(bpChanged);
			
			if (btnNextHat) {
				btnNextHat.removeEventListener(MouseEvent.CLICK, nextHat);
				btnResetHat.removeEventListener(MouseEvent.CLICK, resetHat);
				btnPrevHat.removeEventListener(MouseEvent.CLICK, prevHat);
				
				btnNextFace.removeEventListener(MouseEvent.CLICK, nextFace);
				btnResetFace.removeEventListener(MouseEvent.CLICK, resetFace);
				btnPrevFace.removeEventListener(MouseEvent.CLICK, prevFace);
				
				btnNextSuit.removeEventListener(MouseEvent.CLICK, nextSuit);
				btnResetSuit.removeEventListener(MouseEvent.CLICK, resetSuit);
				btnPrevSuit.removeEventListener(MouseEvent.CLICK, prevSuit);
				
				btnNextBody.removeEventListener(MouseEvent.CLICK, nextBody);
				btnResetBody.removeEventListener(MouseEvent.CLICK, resetBody);
				btnPrevBody.removeEventListener(MouseEvent.CLICK, prevBody);
				
				btnNextHue.removeEventListener(MouseEvent.CLICK, increaseHue);
				btnResetHue.removeEventListener(MouseEvent.CLICK, resetHue);
				btnPrevHue.removeEventListener(MouseEvent.CLICK, decreaseHue);
				
				btnNextBrightness.removeEventListener(MouseEvent.CLICK, increaseBrightness);
				btnResetBrightness.removeEventListener(MouseEvent.CLICK, resetBrightness);
				btnPrevBrightness.removeEventListener(MouseEvent.CLICK, decreaseBrightness);
				
				btnNextSaturation.removeEventListener(MouseEvent.CLICK, increaseSaturation);
				btnResetSaturation.removeEventListener(MouseEvent.CLICK, resetSaturation);
				btnPrevSaturation.removeEventListener(MouseEvent.CLICK, decreaseSaturation);
				
				btnNextContrast.removeEventListener(MouseEvent.CLICK, increaseContrast);
				btnResetContrast.removeEventListener(MouseEvent.CLICK, resetContrast);
				btnPrevContrast.removeEventListener(MouseEvent.CLICK, decreaseContrast);
				
				
				btnNextHat.removeEventListener(MouseEvent.ROLL_OVER, showToolTipNext);
				btnResetHat.removeEventListener(MouseEvent.ROLL_OVER, showToolTipClear);
				btnPrevHat.removeEventListener(MouseEvent.ROLL_OVER, showToolTipPrevious);
				
				btnNextFace.removeEventListener(MouseEvent.ROLL_OVER, showToolTipNext);
				btnResetFace.removeEventListener(MouseEvent.ROLL_OVER, showToolTipClear);
				btnPrevFace.removeEventListener(MouseEvent.ROLL_OVER, showToolTipPrevious);
				
				btnNextSuit.removeEventListener(MouseEvent.ROLL_OVER, showToolTipNext);
				btnResetSuit.removeEventListener(MouseEvent.ROLL_OVER, showToolTipClear);
				btnPrevSuit.removeEventListener(MouseEvent.ROLL_OVER, showToolTipPrevious);
				
				btnNextBody.removeEventListener(MouseEvent.ROLL_OVER, showToolTipNext);
				btnResetBody.removeEventListener(MouseEvent.ROLL_OVER, showToolTipClear);
				btnPrevBody.removeEventListener(MouseEvent.ROLL_OVER, showToolTipPrevious);
				
				btnNextHue.removeEventListener(MouseEvent.ROLL_OVER, showToolTipIncrease);
				btnResetHue.removeEventListener(MouseEvent.ROLL_OVER, showToolTipReset);
				btnPrevHue.removeEventListener(MouseEvent.ROLL_OVER, showToolTipDecrease);
				
				btnNextBrightness.removeEventListener(MouseEvent.ROLL_OVER, showToolTipIncrease);
				btnResetBrightness.removeEventListener(MouseEvent.ROLL_OVER, showToolTipReset);
				btnPrevBrightness.removeEventListener(MouseEvent.ROLL_OVER, showToolTipDecrease);
				
				btnNextSaturation.removeEventListener(MouseEvent.ROLL_OVER, showToolTipIncrease);
				btnResetSaturation.removeEventListener(MouseEvent.ROLL_OVER, showToolTipReset);
				btnPrevSaturation.removeEventListener(MouseEvent.ROLL_OVER, showToolTipDecrease);
				
				btnNextContrast.removeEventListener(MouseEvent.ROLL_OVER, showToolTipIncrease);
				btnResetContrast.removeEventListener(MouseEvent.ROLL_OVER, showToolTipReset);
				btnPrevContrast.removeEventListener(MouseEvent.ROLL_OVER, showToolTipDecrease);
			}
			
			if (_okBounce) _okBounce.destroy();
			_okBounce = null;
			
			if (_cancelBounce) _cancelBounce.destroy();
			_cancelBounce = null;
			
			if (_shipBounce) _shipBounce.destroy();
			_shipBounce = null;
			
			if (_buyBounce) _buyBounce.destroy();
			_buyBounce = null;
			
			if (btnOk) btnOk.removeEventListener(MouseEvent.CLICK, btnOkClick);
			btnOk = null;
			
			if (btnCancel) btnCancel.removeEventListener(MouseEvent.CLICK, btnCancelClick);
			btnCancel = null;
			
			if (btnShip) btnShip.removeEventListener(MouseEvent.CLICK, btnShipClick);
			btnShip = null;
			
			if (hueSlider) hueSlider.destroy();
			hueSlider = null;
			
			if (brightnessSlider) brightnessSlider.destroy();
			brightnessSlider = null;
			
			if (saturationSlider) saturationSlider.destroy();
			saturationSlider = null;
			
			if (contrastSlider) contrastSlider.destroy();
			contrastSlider = null;
			
			if (penguin) penguin.destroy();
			penguin = null;
			
			txtBody = null;
			txtFace = null;
			txtHat = null;
			txtSuit = null;
			txtBp = null;
			btnBuy = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
		
		
	}

}

class Enforcer { }
