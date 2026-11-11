package src.customization 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import lbg.utils.DisplayObjectUtil;
	import org.osflash.signals.Signal;
	import src.game.hud.HudComponentEntry;
	import src.game.hud.HudComponentList;
	import src.gui.decorators.MouseBounce2;
	import src.reg.RegistryCompressionDictionary;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class HudPresetButton extends MovieClip 
	{
		public var previewSignal:Signal = new Signal(HudComponentList);
		public var buySignal:Signal = new Signal(HudComponentList, Number);
		public var txtName:TextField;
		public var txtValue:TextField;
		
		protected var _bounce:MouseBounce2;
		protected var _list:HudComponentList;
		
		public function HudPresetButton() 
		{
			super();
			
			_bounce = new MouseBounce2(this);
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.CLICK, onHudPresetClick);
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			previewSignal.dispatch(_list);
		}
		
		private function onHudPresetClick(e:MouseEvent):void 
		{
			buySignal.dispatch(_list, getPresetPrice(_list));
		}
		
		public function setName(name:String):void {
			txtName.text = name;
		}
		
		public function setList(list:HudComponentList):void {
			_list = list;
			
			setPrice(getPresetPrice(list));
		}
		
		protected function setPrice(price:Number):void {
			if (price <= 0) {
				//Everything owned
				txtValue.text = "Click to equip";
				DisplayObjectUtil.setColorMatrix(this, 90);
			}else if (price <= ProfileState.instance.bonusPoints.value) {
				//Can afford
				txtValue.text = price.toFixed() + " BP";
				DisplayObjectUtil.setColorMatrix(this, 0);
			}else {
				//Cannot afford
				txtValue.text = price.toFixed() + " BP";
				DisplayObjectUtil.setColorMatrix(this, -110, -50, -50);
			}
		}
		
		protected function getPresetPrice(list:HudComponentList):Number {
			var price:Number = 0;
			
			for each(var hud:HudComponentEntry in list.list) {
				if (HudCustomizationScreen.profileOwnsId(hud.id)) {
					//Owned
				}else {
					//Not owned
					price += hud.entry.statCost.valueAt(0);
				}
			}
			
			return price;
		}
		
		public function get list():HudComponentList 
		{
			return _list;
		}
		
		public function destroy():void {
			txtName = null;
			txtValue = null;
			if(_bounce) _bounce.destroy();
			_bounce = null;
			
			_list = null;
			
			if (previewSignal) previewSignal.removeAll();
			previewSignal = null;
			
			if (buySignal) buySignal.removeAll();
			buySignal = null;
			
			removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			removeEventListener(MouseEvent.CLICK, onHudPresetClick);
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
	}

}