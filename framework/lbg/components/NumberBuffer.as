package lbg.components 
{
	/**
	 * Returns the average of X amount of given values
	 * @author 
	 */
	public class NumberBuffer 
	{
		public var bufferSize:uint;
		
		protected var _buffer:Vector.<Number> = new Vector.<Number>();
		
		/**
		 * Used to get a rolling average of given numbers in realtime
		 * @param	bufferSize Size of numbers pool to average
		 * @param	fillWith Fill the buffer with a starting value, e.g. 0 to start the average at 0
		 */
		public function NumberBuffer(bufferSize:uint = 60, fillWith:Number = NaN) 
		{
			this.bufferSize = bufferSize;
			
			if (!isNaN(fillWith)) {
				for (var i:int = 0; i < this.bufferSize; i++) {
					add(fillWith);
				}
			}
		}
		
		public function add(value:Number):void {
			_buffer.unshift(value);
			while (_buffer.length > bufferSize) {
				_buffer.pop();
			}
		}
		
		public function get value():Number {
			var total:Number = 0;
			
			for each(var n:Number in _buffer) {
				total += n;
			}
			
			return total / _buffer.length;
		}
		
		public function destroy():void {
			if (_buffer) _buffer.length = 0;
			_buffer = null;
		}
		
	}

}