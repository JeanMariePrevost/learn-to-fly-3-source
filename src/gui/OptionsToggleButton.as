package src.gui 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import lbg.components.MySimpleButton;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	
	/**
	 * ...
	 * @author 
	 */
	//public class OptionsToggleButton extends MovieClip 
	public class OptionsToggleButton extends MySimpleButton 
	{
		public var hitBox:MovieClip;
		public var txtLabel:TextField;
		public var txtValue:TextField;
		
		protected var _possibleValues:Array = new Array();
		
		public function OptionsToggleButton() 
		{
			super();
			hitBox.alpha = 0;
			
			gotoAndStop(1);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			txtLabel.mouseEnabled = false;
			txtValue.mouseEnabled = false;
		}
		
		private function onEnterFrame(e:Event):void 
		{
			//Color change as to be done with code because we're using dynamic text
			switch(currentLabel) {
				case "idle":
					txtLabel.textColor = 0xFFFFFF;
					txtValue.textColor = 0xFFFFFF;
					break;
				case "over":
					txtLabel.textColor = 0x00FF00;
					txtValue.textColor = 0x00FF00;
					break;
				case "down":
					txtLabel.textColor = 0x00DD00;
					txtValue.textColor = 0x00DD00;
					break;
			}
		}
		
		public function addPossibleValue(value:String):void {
			if (_possibleValues.length <= 0) {
				txtValue.text = value;
			}
			
			if (_possibleValues.indexOf(value) < 0) {
				_possibleValues.push(value);
			}
		}
		
		/** Sets the button value text to specified value if it exists, otherwise set to first value */
		public function setValueTo(value:String):Boolean {
			if (_possibleValues.indexOf(value) >= 0) {
				txtValue.text = value;
				return true;
			}else if ( _possibleValues.length >= 1) {
				txtValue.text = _possibleValues[0];
				Log.log("OptionsToggleButton error - incorrect value [", value, "] on ", this);
				return false;
			}else {
				txtValue.text = "NoValue";
				Log.log("OptionsToggleButton error - no possible values on ", this);
				return false;
			}
		}
		
		public function nextValue():void {
			var i:int = _possibleValues.indexOf(txtValue.text);
			
			if (i + 1 < _possibleValues.length) {
				setValueTo(_possibleValues[i + 1]);
			}else {
				setValueTo(_possibleValues[0]);
			}
		}
		
		public function previousValue():void {
			var i:int = _possibleValues.indexOf(txtValue.text);
			
			if (i - 1 >= 0) {
				setValueTo(_possibleValues[i - 1]);
			}else {
				setValueTo(_possibleValues[_possibleValues.length - 1]);
			}
		}
		
		override public function destroy():void {
			txtLabel = null;
			txtValue = null;
			_possibleValues = null;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			super.destroy();
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
		
	}

}