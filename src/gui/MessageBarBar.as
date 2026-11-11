package src.gui {
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author 
	 */
	public class MessageBarBar extends MovieClip 
	{
		public var txtOutline:TextField;
		public var txtMask:TextField;
		public var fill:MovieClip;
		
		/** Only on medal message bar */
		public var txtBP:TextField;
		
		public function MessageBarBar() 
		{
			super();
			fill.mask = txtMask;
			
			
			mouseEnabled = false;
			mouseChildren = false;
			
			txtOutline.mouseEnabled = false;
			txtMask.mouseEnabled = false;
			txtOutline.mouseEnabled = false;
			fill.mouseEnabled = false;
			fill.mouseChildren = false;
		}
		
		public function setMessage(msg:String):void {
			txtMask.text = txtOutline.text = msg;
		}
		
		public function destroy():void {
			txtOutline = null;
			txtMask = null;
			fill = null;
			
			if (stage) {
				parent.removeChild(this);
			}
			
			while (numChildren) {
				removeChildAt(0);
			}
		}
	}

}