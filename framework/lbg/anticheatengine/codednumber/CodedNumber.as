package lbg.anticheatengine.codednumber
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author light_bringer777
	 */
	public class CodedNumber implements ICodedNumber
	{
		protected var _byteArray:ByteArray;
		
		public function CodedNumber() 
		{
			_byteArray = new ByteArray();
		}
		
		public function storeData(value:Number):void {
			_byteArray.clear();
			_byteArray.writeDouble(value);
		}
		
		public function getData():Number {
			_byteArray.position = 0;
			var s:Number = _byteArray.readDouble();
			return s;
		}
		
		public function destroy():void 
		{
			if(_byteArray) _byteArray.clear();
			_byteArray = null;
		}
		
	}

}