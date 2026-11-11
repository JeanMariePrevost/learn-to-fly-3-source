package src.customization 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import lbg.anticheatengine.SafeString;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	import src.audio.Sfx;
	import src.game.hud.HudComponent;
	import src.reg.Registry;
	import src.reg.RegistryCompressionDictionary;
	import src.reg.RegistryEntry;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class HudCustomSidebar extends MovieClip 
	{
		protected static const PREVIEW_HEIGHT:Number = 170;
		protected static const PREVIEW_WIDTH:Number = 150;
		
		public var bpChangeSignal:Signal = new Signal();
		
		public var hudTarget:MovieClip;
		public var txtName:TextField;
		public var txtLocked:TextField;
		public var btnPrev:SimpleButton;
		public var btnNext:SimpleButton;
		public var btnBuy:HudUnlockButton;
		public var btnPresets:HudPresetsButton;
		
		protected var _list:Vector.<RegistryEntry>;
		protected var _currenIndex:int = 0;
		protected var _currenHud:HudComponent;
		
		protected var _screen:HudPreviewScreen;
		
		
		public function HudCustomSidebar(screen:HudPreviewScreen) 
		{
			_screen = screen;
			
			hudTarget.visible = true;
			
			_list = Registry.getEntriesOfType(Registry.TYPE_HUD);
			
			loadItem(_currenIndex);
			
			btnPrev.addEventListener(MouseEvent.CLICK, prevClick);
			btnNext.addEventListener(MouseEvent.CLICK, nextClick);
			btnBuy.addEventListener(MouseEvent.CLICK, buyClick);
			
			hudTarget.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
		}
		
		public function refreshItem():void {
			loadItem(_currenIndex);
		}
		
		private function buyClick(e:MouseEvent):void {
			var entry:RegistryEntry = _list[_currenIndex]
			
			if (ProfileState.instance.bonusPoints.value >= entry.statCost.valueAt(0)) {
				Sfx.playShopClick();
				for each(var s:SafeString in ProfileState.instance.hudBoughtKeys) {
					if (s.value == RegistryCompressionDictionary.getGodeOfID(entry.id)) {
						//Key owned
						throw new Error("HudCustomizationScreen ERROR - Trying to buy a HUD ID that is already owned ->", entry.id);
					}
				}
				
				ProfileState.spendBonusPoints(entry.statCost.valueAt(0));
				var ss:SafeString = new SafeString();
				ss.value = RegistryCompressionDictionary.getGodeOfID(entry.id);
				ProfileState.instance.hudBoughtKeys.push(ss);
				
				loadItem(_currenIndex);
			}
			
		}
		
		private function nextClick(e:MouseEvent):void 
		{
			Sfx.playShopClick();
			_currenIndex += 1;
			
			if (_currenIndex >= _list.length) {
				_currenIndex = 0;
			}
			
			loadItem(_currenIndex);
		}
		
		private function prevClick(e:MouseEvent):void 
		{
			Sfx.playShopClick();
			_currenIndex -= 1;
			
			if (_currenIndex < 0) {
				_currenIndex = _list.length - 1;
			}
			
			loadItem(_currenIndex);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			var entry:RegistryEntry = _list[_currenIndex];
			if (HudCustomizationScreen.profileOwnsId(entry.id)) {
				_screen.newHud(entry.id);
			}
		}
		
		protected function loadItem(index:int):void {
			while (hudTarget.numChildren >= 1) hudTarget.removeChildAt(0);
			
			if (_currenHud) {
				_currenHud.destroy();
				_currenHud = null;
			}
			
			var entry:RegistryEntry = _list[index];
			txtName.text = entry.name;
			_currenHud = new (entry.gameClass.valueAt(0) as Class)();
			hudTarget.addChild(_currenHud);
			
			var scale:Number = Math.min(1.1, PREVIEW_WIDTH / _currenHud.width, PREVIEW_HEIGHT / _currenHud.height);
			_currenHud.scaleX = _currenHud.scaleY = scale;
			
			if (HudCustomizationScreen.profileOwnsId(entry.id)) {
				btnBuy.visible = false;
				txtLocked.visible = false;
			}else {
				btnBuy.visible = true;
				txtLocked.visible = true;
				DisplayObjectUtil.setObjectSaturation(_currenHud, 0.4, 0.6);
				
				btnBuy.txtValue.text = entry.statCost.valueAt(0).toFixed() + " BP";
				
				if (ProfileState.instance.bonusPoints.value >= entry.statCost.valueAt(0)) {
					btnBuy.gotoAndStop(1);
				}else {
					btnBuy.gotoAndStop(2);
				}
			}
			
			bpChangeSignal.dispatch();
		}
		
		public function destroy():void {
			if(bpChangeSignal) bpChangeSignal.removeAll();
			bpChangeSignal = null;
			
			hudTarget = null;
			txtName = null;
			txtLocked = null;
			btnPrev = null;
			btnNext = null;
			btnBuy = null;
			if (btnPresets) btnPresets.destroy();
			btnPresets = null;
			
			if (_list) _list.length = 0;
			_list = null;
			
			if (_currenHud) _currenHud.destroy();
			_currenHud = null;
			
			if (_screen) _screen.destroy();
			_screen = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}