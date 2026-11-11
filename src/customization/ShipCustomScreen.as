package src.customization 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import lbg.utils.DisplayObjectUtil;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.Sfx;
	import src.game.gameobjects.player.Player;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	import src.gui.QuestionBox;
	import src.gui.QuestionBox2;
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
	public class ShipCustomScreen extends MovieClip 
	{
		protected static var _instance:ShipCustomScreen;
		
		public var shipTarget:MovieClip;
		
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
		public var btnPenguin:SimpleButton;
		
		protected var _okBounce:MouseBounce;
		protected var _cancelBounce:MouseBounce;
		protected var _penguinBounce:MouseBounce;
		
		protected var _ship:Player;
		
		protected var _dirty:Boolean = false;
		
		public function ShipCustomScreen(singleton:Enforcer) 
		{
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
			_penguinBounce = new MouseBounce(btnPenguin);
			
			btnOk.addEventListener(MouseEvent.CLICK, btnOkClick);
			btnCancel.addEventListener(MouseEvent.CLICK, btnCancelClick);
			btnPenguin.addEventListener(MouseEvent.CLICK, btnPenguinClick);
			
			hueSlider.signalChange.add(updateColor);
			brightnessSlider.signalChange.add(updateColor);
			saturationSlider.signalChange.add(updateColor);
			contrastSlider.signalChange.add(updateColor);
			
			hueSlider.value = ProfileState.instance.customizationData.shipHue;
			brightnessSlider.value = ProfileState.instance.customizationData.shipBrightness;
			saturationSlider.value = ProfileState.instance.customizationData.shipSaturation;
			contrastSlider.value = ProfileState.instance.customizationData.shipContrast;
			
			
			_ship = new (ProfileState.instance.currentGameState.body.statGameClass)(ProfileState.instance.currentGameState);
			if(_ship.penguin) _ship.penguin.visible = false;
			while (shipTarget.numChildren >= 1) shipTarget.removeChildAt(0);
			shipTarget.addChild(_ship.getMovieClip());
			shipTarget.visible = true;
			_ship.setPositionFromAnchor(0, 0, Player.ANCHOR_BOTTOM);
			updateColor();
			Main.instance.sysButtonsHide();
			_dirty = false;
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			UiScaler.addAbsoluteManually(this, 360, -360);
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
			//Save and quit
			ProfileState.instance.customizationData.shipHue = hueSlider.value;
			ProfileState.instance.customizationData.shipBrightness = brightnessSlider.value;
			ProfileState.instance.customizationData.shipSaturation = saturationSlider.value;
			ProfileState.instance.customizationData.shipContrast = contrastSlider.value;
			
			Transition.transitionTo(ScreenManager.unloadShipCustomization, ScreenManager.loadShop);
		}
		
		private function btnCancelClick(e:MouseEvent):void 
		{
			//Quit and discard changes
			Transition.transitionTo(ScreenManager.unloadShipCustomization, ScreenManager.loadShop);
		}
		
		private function btnPenguinClick(e:MouseEvent):void 
		{
			if (_dirty) {
				var mouseBlock:Sprite = new Sprite();
				mouseBlock.graphics.beginFill(0);
				mouseBlock.graphics.drawRect(0, 0, 720, 540);
				mouseBlock.graphics.endFill();
				mouseBlock.alpha = 0.001;
				addChild(mouseBlock);
				var qb:QuestionBox = new QuestionBox("Save changes?", "Do you want to save the changes you made to the ship before leaving this screen?", toPenguinAndSave, toPenguinAndDiscard);
				addChild(qb);
				qb.x -= this.x;
			}else {
				Transition.transitionTo(ScreenManager.unloadShipCustomization, ScreenManager.loadCustomization);
			}
		}
		
		protected function toPenguinAndSave():void {
			ProfileState.instance.customizationData.shipHue = hueSlider.value;
			ProfileState.instance.customizationData.shipBrightness = brightnessSlider.value;
			ProfileState.instance.customizationData.shipSaturation = saturationSlider.value;
			ProfileState.instance.customizationData.shipContrast = contrastSlider.value;
			
			Transition.transitionTo(ScreenManager.unloadShipCustomization, ScreenManager.loadCustomization);
		}
		
		protected function toPenguinAndDiscard():void {
			Transition.transitionTo(ScreenManager.unloadShipCustomization, ScreenManager.loadCustomization);
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
		
		protected function updateColor(notInUse:Number = 0):void {
			_dirty = true;
			
			var hue:Number = -180 + (360 * hueSlider.value);
			var brightness:Number = -100 + (200 * brightnessSlider.value);
			var saturation:Number = -100 + (200 * saturationSlider.value);
			var contrast:Number = -100 + (200 * contrastSlider.value);
			
			DisplayObjectUtil.setColorMatrix(_ship.getMovieClip(), hue, saturation, brightness, contrast);
		}
		
		static public function get instance():ShipCustomScreen 
		{
			if (_instance == null) {
				_instance = new ShipCustomScreen(new Enforcer());
			}
			return _instance;
		}
		
		public static function destroy():void {
			if (_instance) _instance.destroy();
		}
		
		public function destroy():void {
			_instance = null;
			if (_ship) _ship.destroy();
			_ship = null;
			
			if (btnNextHue) {
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
			if (_cancelBounce)_cancelBounce.destroy();
			if (_penguinBounce) _penguinBounce.destroy();
			
			_okBounce = null;
			_cancelBounce = null;
			_penguinBounce = null;
			
			if (btnOk) btnOk.removeEventListener(MouseEvent.CLICK, btnOkClick);
			if (btnCancel) btnCancel.removeEventListener(MouseEvent.CLICK, btnCancelClick);
			if (btnPenguin) btnPenguin.removeEventListener(MouseEvent.CLICK, btnPenguinClick);
			
			btnOk = null;
			btnCancel = null;
			btnPenguin = null;
			
			if (hueSlider) hueSlider.destroy();
			if(brightnessSlider) brightnessSlider.destroy();
			if(saturationSlider) saturationSlider.destroy();
			if (contrastSlider) contrastSlider.destroy();
			
			hueSlider = null;
			brightnessSlider = null;
			saturationSlider = null;
			contrastSlider = null;
			
			shipTarget = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
		
		
	}

}

class Enforcer { }
