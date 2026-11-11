package src.gui 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import lbg.components.MySimpleButton;
	import lbg.utils.DisplayObjectUtil;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	import src.system.GameState;
	
	/**
	 * ...
	 * @author light_bringer777
	 */
	public class CompareProfileGameSlot extends MovieClip 
	{
		public var txtTitle:TextField;
		public var txtDay:TextField;
		public var txtCash:TextField;
		public var txtSlot:TextField;
		public var txtComplete:TextField;
		public var txtDate:TextField;
		public var txtTime:TextField;
		
		protected var _state:GameState;
		
		public function CompareProfileGameSlot() 
		{
			super();
			
			txtComplete.visible = false;
		}
		
		public function updateFromState(state:GameState):void {
			if (state) {
				//trace("State loaded:", state.gameMode);
				//Slot color
				switch(state.gameMode) {
					case "Story Mode":
						gotoAndStop(1);
						break;
					case "Payload Mode":
						gotoAndStop(3);
						break;
					case "Classic Mode":
						gotoAndStop(2);
						break;
					case "Sandbox":
						gotoAndStop(4);
						break;
					case "Empty":
						gotoAndStop(5);
						break;
				}
				
				if (state.gameCompleted.value) {
					txtComplete.visible = true;
				}
				
				if (state.gameMode == "Empty") {
					txtTitle.text = "Empty";
					txtDay.text = "";
					txtCash.text = "";
					txtDate.text = "";
					txtTime.text = "";
				}else {
					txtTitle.text = state.gameMode.replace(" Mode", "");
					txtDay.text = "Day " + state.day.value.toFixed();
					txtCash.text = "$ " + state.cash.value.toFixed();
					txtDate.text = state.timeDateString;
					txtTime.text = state.timeHourString;
				}
			}else {
				txtTitle.text = "Empty";
				txtDay.text = "";
				txtCash.text = "";
				txtDate.text = "";
				txtTime.text = "";
			}
			
			_state = state;
		}
		
		public function get isEmpty():Boolean {
			return (_state == null || _state.gameMode == "Empty");
		}
		
		public function get state():GameState 
		{
			return _state;
		}
		
		public function destroy():void {
			txtTitle = null;
			txtDay = null;
			txtCash = null;
			txtSlot = null;
			txtTime = null;
			txtDate = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
			
		}
		
	}

}