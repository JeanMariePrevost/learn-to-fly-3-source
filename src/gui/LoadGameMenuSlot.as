package src.gui 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import lbg.components.MySimpleButton;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	import src.system.GameState;
	
	/**
	 * ...
	 * @author light_bringer777
	 */
	public class LoadGameMenuSlot extends lbg.components.MySimpleButton 
	{
		public var txtTitle:TextField;
		public var txtStoryGoal:TextField;
		public var txtDay:TextField;
		public var txtCash:TextField;
		public var txtSlot:TextField;
		public var txtComplete:TextField;
		
		public var deleteButton:MovieClip;//Set from outside the object
		public var deleteButtonBounce:MouseBounce2;//Set from outside the object
		
		public var color:MovieClip;
		
		public var bounce:MouseBounce2;
		protected var _glowFilter:GlowFilter;
		protected var _state:GameState;
		
		public function LoadGameMenuSlot() 
		{
			super();
			
			txtComplete.visible = false;
			
			bounce = new MouseBounce2(this);
			
			bounce.scaleMod = 0.1;
			
			_glowFilter = new GlowFilter(0, 1, 7, 7, 12, 1);
			filters = [_glowFilter];
			
		}
		
		override public function set enable(value:Boolean):void 
		{
			super.enable = value;
			
			var filtersArray:Array = filters.concat();
			for (var i:int = 0; i < filtersArray.length; i++) {
				if (filtersArray[i] == _glowFilter) return;//Already has the glow filter
			}
			filtersArray.push(_glowFilter);
			filters = filtersArray;
			
		}
		
		public function updateFromState(state:GameState):void {
			if (state) {
				//trace("State loaded:", state.gameMode);
				
				txtStoryGoal.text = "";
				var filtersArray:Array;
				
				//Slot color
				switch(state.gameMode) {
					case "Story Mode":
						color.gotoAndStop(1);
						color.alpha = 1;
						txtStoryGoal.text = "(" + NumberUtils.numberDelimiter(state.storyModeSpaceLevel) + ")"; //New, indicate selected goal
						DisplayObjectUtil.setColorMatrix(color);
						filtersArray = filters.concat();
						filtersArray.push(_glowFilter);
						filters = filtersArray;
						break;
					case "Payload Mode":
						color.gotoAndStop(3);
						color.alpha = 1;
						DisplayObjectUtil.setColorMatrix(color);
						filtersArray = filters.concat();
						filtersArray.push(_glowFilter);
						filters = filtersArray;
						break;
					case "Classic Mode":
						color.gotoAndStop(2);
						color.alpha = 1;
						DisplayObjectUtil.setColorMatrix(color);
						filtersArray = filters.concat();
						filtersArray.push(_glowFilter);
						filters = filtersArray;
						break;
					case "Sandbox":
						color.gotoAndStop(4);
						color.alpha = 1;
						DisplayObjectUtil.setColorMatrix(color);
						filtersArray = filters.concat();
						filtersArray.push(_glowFilter);
						filters = filtersArray;
						break;
					case "Empty":
						color.gotoAndStop(1);
						DisplayObjectUtil.setColorMatrix(color, 0, -100, 20);
						filtersArray = filters.concat();
						filtersArray.push(_glowFilter);
						filters = filtersArray;
						break;
				}
				
				if (state.gameCompleted.value) {
					txtComplete.visible = true;
				}else {
					txtComplete.visible = false;
				}
				
				if (state.gameMode == "Empty") {
					txtTitle.text = "NEW GAME";
					txtTitle.y += 30;
					txtDay.text = "";
					txtCash.text = "";
				}else {
					txtTitle.text = state.gameMode.replace(" Mode", "");
					txtDay.text = "Day " + state.day.value.toFixed();
					txtCash.text = "$ " + state.cash.value.toFixed();
				}
			}else {
				txtTitle.text = "Empty";
				txtDay.text = "";
				txtCash.text = "";
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
		
		override public function destroy():void {
			txtTitle = null;
			txtStoryGoal = null;
			txtDay = null;
			txtCash = null;
			txtSlot = null;
			txtComplete = null;
			
			deleteButton = null;
			
			if (deleteButtonBounce) deleteButtonBounce.destroy();
			deleteButtonBounce = null;
			
			color = null;
			
			if (bounce) bounce.destroy();
			bounce = null;
			
			_glowFilter = null;
			_state = null;
		
			super.destroy();
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}