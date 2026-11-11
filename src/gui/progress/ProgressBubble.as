package src.gui.progress 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author 
	 */
	public class ProgressBubble extends MovieClip 
	{
		public var txtValue:TextField;
		
		protected var _selectedFormat:int = 0;
		
		public function ProgressBubble() 
		{
			super();
			
		}
		
		public function setValue(value:Number):void {
			txtValue.text = formatValue(value);
		}
		
		public function formatValue(value:Number):String {
			var v:Number = value;
			
			if (_selectedFormat <= 0) {
				return value.toFixed(0);
				
			}else if (_selectedFormat <= 1) {
				//1-9k
				//1234
				return value.toFixed(0);
				
			}else if (_selectedFormat <= 2) {
				//10-99k
				//12.34k
				v = value / 1000;
				return v.toFixed(2) + "k";
				
			}else if (_selectedFormat <= 3) {
				//100-999k
				//123.4k
				v = value / 1000;
				return v.toFixed(1) + "k";
				
			}else if (_selectedFormat <= 4) {
				//1-9M
				//1.234M
				v = value / 1000000;
				return v.toFixed(3) + "M";
				
			}else if (_selectedFormat <= 5) {
				//10-99M
				//12.34M
				v = value / 1000000;
				return v.toFixed(2) + "M";
				
			}else if (_selectedFormat <= 6) {
				//100-999M
				//123.4M
				v = value / 1000000;
				return v.toFixed(1) + "M";
				
			}else if (_selectedFormat <= 7) {
				//1-9B
				//1.234B
				v = value / 1000000000;
				return v.toFixed(3) + "B";
				
			}else {
				//>=10B
				//123.4B
				v = value / 1000000000;
				return v.toFixed(1) + "B";
			}
		}
		
		public function selectFormat(value:Number):void {
			if (value < 1000) {
				_selectedFormat = 0;
				
			}else if (value < 10000) {
				//1-9k
				//1.234k
				_selectedFormat = 1;
				
			}else if (value < 100000) {
				//10-99k
				//12.34k
				_selectedFormat = 2;
				
			}else if (value < 1000000) {
				//100-999k
				//123.4k
				_selectedFormat = 3;
				
			}else if (value < 10000000) {
				//1-9M
				//1.234M
				_selectedFormat = 4;
				
			}else if (value < 100000000) {
				//10-99M
				//12.34M
				_selectedFormat = 5;
				
			}else if (value < 1000000000) {
				//100-999M
				//123.4M
				_selectedFormat = 6;
				
			}else if (value < 10,000,000,000) {
				//1-9B
				//1.234B
				_selectedFormat = 7;
				
			}else {
				//>=10B
				//123.4B
				_selectedFormat = 8;
			}
		}
		
		public function destroy():void {
			txtValue = null;
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}