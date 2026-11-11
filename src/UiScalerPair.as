package src 
{
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 */
	public class UiScalerPair 
	{
		public var obj:DisplayObjectContainer;
		public var anchorPosition:Number;
		public var offset:Number;
		
		public function UiScalerPair(obj:DisplayObjectContainer, anchorPosition:Number, offset:Number = 0) 
		{
			this.obj = obj;
			this.anchorPosition = anchorPosition;
			this.offset = offset;
		}
		
		public function destroy():void {
			obj = null;
		}
		
	}

}