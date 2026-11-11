package src.customization 
{
	import flash.display.MovieClip;
	import src.Main;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import lbg.anticheatengine.SafeString;
	import org.osflash.signals.Signal;
	import src.game.hud.HudComponent;
	import src.game.hud.HudComponentEntry;
	import src.game.hud.HudComponentList;
	import src.game.hud.huds.*;
	import src.gui.decorators.MouseBounce2;
	import src.reg.Registry;
	import src.reg.RegistryCompressionDictionary;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class HudPresetSidebar extends MovieClip 
	{
		public var bpChangeSignal:Signal = new Signal();
		
		public var btn1:HudPresetButton;
		public var btn2:HudPresetButton;
		public var btn3:HudPresetButton;
		public var btn4:HudPresetButton;
		public var btn5:HudPresetButton;
		public var btn6:HudPresetButton;
		public var btn7:HudPresetButton;
		public var btnCustom:HudCustomButton;
		
		protected var _screen:HudPreviewScreen;
		protected var _btns:Vector.<HudPresetButton> = new Vector.<HudPresetButton>();
		protected var _bounces:Vector.<MouseBounce2> = new Vector.<MouseBounce2>();
		
		protected var _customHudState:ByteArray;
		
		public function HudPresetSidebar(screen:HudPreviewScreen) 
		{
			_screen = screen;
			
			_btns.push(btn1);
			_btns.push(btn2);
			_btns.push(btn3);
			_btns.push(btn4);
			_btns.push(btn5);
			_btns.push(btn6);
			_btns.push(btn7);
			
			for (var i:int = 0; i < 7; i++) {
				var b:MouseBounce2 = new MouseBounce2(_btns[i]);
				b.scaleMod = 0.05;
				_bounces.push(b);
				
				_btns[i].previewSignal.add(previewList);
				_btns[i].buySignal.add(buyList);
				_btns[i].addEventListener(MouseEvent.ROLL_OUT, onOut);
			}
			
			refreshButtons();
		}
		
		protected function previewList(list:HudComponentList):void {
			_customHudState = _screen.getState();
			trace("previewList()");
			_screen.loadFromList(list);
		}
		
		protected function buyList(list:HudComponentList, price:Number):void {
			trace("buyList(), price:",price);
			if (ProfileState.instance.bonusPoints.value >= price) {
				for each(var hud:HudComponentEntry in list.list) {
					if (HudCustomizationScreen.profileOwnsId(hud.entry.id) == false) {
						ProfileState.spendBonusPoints(hud.entry.statCost.valueAt(0));
						var ss:SafeString = new SafeString();
						ss.value = RegistryCompressionDictionary.getGodeOfID(hud.entry.id);
						ProfileState.instance.hudBoughtKeys.push(ss);
					}
				}
				bpChangeSignal.dispatch();
				_screen.loadFromList(list);
				refreshButtons();
			}else {
				Main.displayMessage("Not enough Bonus Points");
			}
			//_screen.saveToProfile();
		}
		
		protected function onOut(e:MouseEvent):void {
			_screen.setState(_customHudState);
		}
		
		public function refreshButtons():void {
			btn1.setName("Basic");
			btn1.setList(presetBasic);
			
			btn2.setName("Smart watch");
			btn2.setList(presetWatch);
			
			btn3.setName("Rollers");
			btn3.setList(presetRolling);
			
			btn4.setName("High Tech");
			btn4.setList(presetHighTech);
			
			btn5.setName("Sleek");
			btn5.setList(presetSleek);
			
			btn6.setName("Holographic");
			btn6.setList(presetHolograms);
			
			btn7.setName("Team Baby");
			btn7.setList(presetBaby);
			
			_customHudState = _screen.getState();
		}
		
		
		protected function get presetHighTech():HudComponentList {
			var list:HudComponentList = new HudComponentList();
			
			list.addComponent(Registry.getEntry("blackSpeed"), 520, 477, 1.035, 0);
			list.addComponent(Registry.getEntry("digitalAltitude"), 636, 432, 1, 0);
			list.addComponent(Registry.getEntry("digitalDrag"), 636, 475, 1, 0);
			list.addComponent(Registry.getEntry("digitalWind"), 636, 518, 1, 0);
			
			return list;
		}
		
		protected function get presetSleek():HudComponentList {
			var list:HudComponentList = new HudComponentList();
			
			list.addComponent(Registry.getEntry("compactAltitude"), 613, 375, 1.2, 0);
			list.addComponent(Registry.getEntry("compactDistance"), 613, 405, 1.2, 0);
			list.addComponent(Registry.getEntry("compactSpeed"), 613, 435, 1.2, 0);
			list.addComponent(Registry.getEntry("compactDrag"), 613, 465, 1.2, 0);
			list.addComponent(Registry.getEntry("compactWind"), 613, 495, 1.2, 0);
			list.addComponent(Registry.getEntry("compactDuration"), 613, 525, 1.2, 0);
			
			//Compact Speed 613 435 1.2
			//Compact Drag 613 465 1.2
			//Compact Wind 613 495 1.2
			//Compact Flight Time 613 525 1.2
			//Compact Distance 612.45 404 1.2270000000000003
			//Compact Altitude 610.4 372 1.2
			
			return list;
		}
		
		protected function get presetBasic():HudComponentList {
			var list:HudComponentList = new HudComponentList();
			
			list.addComponent(Registry.getEntry("speedNeedle"), 572, 474, 1, 0);
			list.addComponent(Registry.getEntry("dragNeedle"), 695, 333, 1, 0);
			list.addComponent(Registry.getEntry("altitudeNeedle"), 679, 456, 1, 0);
			
			return list;
		}
		
		protected function get presetBaby():HudComponentList {
			var list:HudComponentList = new HudComponentList();
			
			list.addComponent(Registry.getEntry("babyWind"), 660, 251, 1, 0);
			list.addComponent(Registry.getEntry("babyAltitude"), 660, 333, 1, 0);
			list.addComponent(Registry.getEntry("babyDrag"), 662, 406, 1, 0);
			list.addComponent(Registry.getEntry("babySpeed"), 635, 495, 1, 0);
			
			return list;
		}
		
		protected function get presetRolling():HudComponentList {
			var list:HudComponentList = new HudComponentList();
			
			list.addComponent(Registry.getEntry("progressMeter"), 698, 233, 1.1, 0);
			list.addComponent(Registry.getEntry("rollingSpeed"), 568, 523, 1, 0);
			list.addComponent(Registry.getEntry("rollingAltitude"), 568, 486, 1, 0);
			
			return list;
		}
		
		protected function get presetWatch():HudComponentList {
			var list:HudComponentList = new HudComponentList();
			
			list.addComponent(Registry.getEntry("smartWatch"), 640, 477, 1.117, 0);
			
			return list;
		}
		
		protected function get presetHolograms():HudComponentList {
			var list:HudComponentList = new HudComponentList();
			
			list.addComponent(Registry.getEntry("hologramAltitude"), 656, 346, 1.1, 0);
			list.addComponent(Registry.getEntry("hologramDistance"), 656, 400, 1.1, 0);
			list.addComponent(Registry.getEntry("hologramSpeed"), 530, 454, 1, 0);
			list.addComponent(Registry.getEntry("hologramDrag"), 656, 454, 1, 0);
			list.addComponent(Registry.getEntry("hologramWind"), 530, 508, 1, 0);
			list.addComponent(Registry.getEntry("hologramDuration"), 656, 508, 1, 0);
			
			//hologramSpeed 530 454 1
			//hologramDrag 656 454 1
			//hologramWind 530 508 1
			//hologramDuration 656 511 1
			//hologramAltitude 654.65 345.8 1.1
			//hologramDistance 654.75 396.1 1
			
			return list;
		}
		
		public function destroy():void {
			if (_bounces) {
				for each(var bo:MouseBounce2 in _bounces) {
					bo.destroy();
				}
				_bounces.length = 0;
			}
			_bounces = null;
			
			if (_btns) {
				for each(var b:HudPresetButton in _btns) {
					b.removeEventListener(MouseEvent.ROLL_OUT, onOut);
					b.destroy();
				}
				_btns.length = 0;
				_btns.length = 0;
			}
			_btns = null;
			
			
			if (bpChangeSignal) bpChangeSignal.removeAll();
			bpChangeSignal = null;
			
			btn1 = null;
			btn2 = null;
			btn3 = null;
			btn4 = null;
			btn5 = null;
			btn6 = null;
			btn7 = null;
			if (btnCustom) btnCustom.destroy();
			btnCustom = null;
			
			if (_screen) _screen.destroy();
			_screen = null;
			
			if (_customHudState) _customHudState.clear();
			_customHudState = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
	}

}