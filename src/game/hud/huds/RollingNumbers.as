package src.game.hud.huds 
{
	import flash.text.TextField;
	import lbg.utils.NumberUtils;
	import src.game.hud.HudComponent;
	
	/**
	 * ...
	 * @author 
	 */
	public class RollingNumbers extends HudComponent 
	{
		protected const SLOT_COUNT:uint = 10;
		protected const LAST_SLOT_X:Number = 138;
		protected const LAST_SLOT_Y:Number = 0;
		protected const SLOT_SPACING:Number = 17;
		
		public var txtName:TextField;
		
		
		protected var _slots:Vector.<RollingNumbersSlot> = new Vector.<RollingNumbersSlot>();
		
		public function RollingNumbers() 
		{
			super();
			
			for (var i:int = 0; i < SLOT_COUNT; i++) {
				var s:RollingNumbersSlot = new RollingNumbersSlot();
				addChild(s);
				_slots.push(s);
				
				s.x = LAST_SLOT_X - (i * SLOT_SPACING);
				s.y = LAST_SLOT_Y;
			}
			
		}
		
		public function changeValue(value:Number, decimals:uint = 1):void {
			var str:String = NumberUtils.numberDelimiter(value, "", 3, decimals);
			
			for (var i:int = 0; i < SLOT_COUNT; i++) {
				var slot:RollingNumbersSlot = _slots[i];
				slot.setCharacter(str.charAt(str.length - i - 1));
			}
			
		}
		
		override public function destroy():void 
		{
			txtName = null;
			if (_slots) {
				for each(var s:RollingNumbersSlot in _slots) {
					s.destroy();
				}
				_slots.length = 0;
			}
			_slots = null;
			super.destroy();
		}
		
	}

}