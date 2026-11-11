package src.gui.menus 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import src.audio.Sfx;
	import src.cards.CardVisual;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	import src.gui.decorators.TweenPos;
	import src.Main;
	import src.reg.Registry;
	import src.reg.RegistryEntry;
	import src.shop.ShopTooltip;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class EndGameCard extends MovieClip 
	{
		public var newItem:MovieClip;
		public var hitzone:MovieClip;
		
		protected var _brightness:Number = 1.5;
		protected var _newItemDelay:Number = 60;
		protected var _visual:CardVisual;
		protected var _bounce:MouseBounce2;
		
		public function EndGameCard(boosterPack:MovieClip, frame:Object) 
		{
			super();
			
			_visual = new CardVisual();
			addChild(_visual);
			
			newItem = _visual.newItem;
			hitzone = _visual.hitzone;
			
			hitArea = hitzone;
			hitzone.alpha = 0.0001;
			
			DisplayObjectUtil.setObjectTint(this, 0xFFFFFF, _brightness);
			
			_visual.gotoAndStop(frame);
			
			if (frame == "omegaBalloon") {
				_visual.setOmegaProgress(ProfileState.instance.stats.omegaBalloonCardsEarned + 1, true);
				if (ProfileState.instance.stats.omegaBalloonCardsEarned < 2) {
					_visual.showNewFragment();
					Main.unsafeTickSignal.add(tickNewFragment);
				}
			}else if (frame == "omegaBoosters") {
				_visual.setOmegaProgress(ProfileState.instance.stats.omegaBoostersCardsEarned + 1, true);
				if (ProfileState.instance.stats.omegaBoostersCardsEarned < 2) {
					_visual.showNewFragment();
					Main.unsafeTickSignal.add(tickNewFragment);
				}
			}else if (frame == "omegaBrick") {
				_visual.setOmegaProgress(ProfileState.instance.stats.omegaBrickCardsEarned + 1, true);
				if (ProfileState.instance.stats.omegaBrickCardsEarned < 2) {
					_visual.showNewFragment();
					Main.unsafeTickSignal.add(tickNewFragment);
				}
			}else if (frame == "omegaCoil") {
				_visual.setOmegaProgress(ProfileState.instance.stats.omegaCoilCardsEarned + 1, true);
				if (ProfileState.instance.stats.omegaCoilCardsEarned < 2) {
					_visual.showNewFragment();
					Main.unsafeTickSignal.add(tickNewFragment);
				}
			}else if (frame == "omegaRocket") {
				_visual.setOmegaProgress(ProfileState.instance.stats.omegaRocketCardsEarned + 1, true);
				if (ProfileState.instance.stats.omegaRocketCardsEarned < 2) {
					_visual.showNewFragment();
					Main.unsafeTickSignal.add(tickNewFragment);
				}
			}else if (frame == "omegaShuttle") {
				_visual.setOmegaProgress(ProfileState.instance.stats.omegaShuttleCardsEarned + 1, true);
				if (ProfileState.instance.stats.omegaShuttleCardsEarned < 2) {
					_visual.showNewFragment();
					Main.unsafeTickSignal.add(tickNewFragment);
				}
			}else if (_visual.currentFrame <= 7) {
				//BP, not an item
			}else {
				Main.unsafeTickSignal.add(tickNewItem);
				_visual.showNewItem();
			}
			
			_visual.newFragment.visible = false;
			_visual.newFragment.alpha = 0;
			newItem.visible = false;
			newItem.alpha = 0;
			
			x = boosterPack.x;
			y = boosterPack.y;
			
			if (boosterPack.stage) {
				boosterPack.parent.addChild(this);
			}
			
			Main.unsafeTickSignal.add(tick);
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			Sfx.playClick3().volume = 0.7;
			DisplayObjectUtil.setObjectTint(this, 0xFFFFFF, 0.2);
			if (_visual.omegaProgress >= 1 && _visual.omegaProgress <= 2) {
				ShopTooltip.show(this, "Omega Item", "You have found a fragment of omega item!");
			}else if (_visual.currentLabel.indexOf("bp") >= 0) {
				ShopTooltip.show(this, "Free Bonus Points!");
			}else {
				var entry:RegistryEntry = Registry.getEntry(_visual.currentLabel);
				ShopTooltip.show(this, entry.name, entry.shopDescription.valueAt(0));
			}
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			DisplayObjectUtil.setObjectTint(this, 0xFFFFFF, 0);
		}
		
		protected function tick(delta:Number):void {
			if (_brightness > 0) {
				_brightness -= 0.02;
				DisplayObjectUtil.setObjectTint(this, 0xFFFFFF, _brightness);
			}else {
				DisplayObjectUtil.setObjectTint(this, 0xFFFFFF, 0);
				Main.unsafeTickSignal.remove(tick);
				
				_bounce = new MouseBounce2(this);
				_bounce.scaleMod = 0.05;
				_bounce.enableMouseDownAnim = false;
				
				addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
		}
		
		protected function tickNewItem(delta:Number):void {
			if (_newItemDelay >= 0) {
				_newItemDelay -= delta;
				//trace("Delay:", _newItemDelay);
			}else {
				if (newItem.visible == false) {
					newItem.visible = true;
					TweenPos.tweenToCurrentPosition(newItem, new Point(0, 80), 50, 0, TweenPos.EASE_OUT_CUBIC);
				}else if (newItem.alpha < 1) {
					newItem.alpha += 0.025;
				}else {
					Main.unsafeTickSignal.remove(tickNewItem);
				}
			}
		}
		
		protected function tickNewFragment(delta:Number):void {
			if (_newItemDelay >= 0) {
				_newItemDelay -= delta;
				//trace("Delay:", _newItemDelay);
			}else {
				if (_visual.newFragment.visible == false) {
					_visual.newFragment.visible = true;
					TweenPos.tweenToCurrentPosition(_visual.newFragment, new Point(0, 80), 50, 0, TweenPos.EASE_OUT_CUBIC);
				}else if (_visual.newFragment.alpha < 1) {
					_visual.newFragment.alpha += 0.025;
				}else {
					Main.unsafeTickSignal.remove(tickNewFragment);
				}
			}
		}
		
		public function get id():String {
			return _visual.currentLabel;
		}
		
		public function destroy():void {
			newItem = null;
			hitzone = null;
			if (_visual) _visual.destroy();
			_visual = null;
			if(_bounce) _bounce.destroy();
			_bounce = null;
			
			Main.unsafeTickSignal.remove(tick);
			Main.unsafeTickSignal.remove(tickNewItem);
			Main.unsafeTickSignal.remove(tickNewFragment);
			removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}