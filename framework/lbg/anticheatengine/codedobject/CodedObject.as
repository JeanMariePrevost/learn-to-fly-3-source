package lbg.anticheatengine.codedobject 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author 
	 */
	public class CodedObject implements ICodedObject
	{
		protected var _byteArray:ByteArray;
		
		public function CodedObject() 
		{
			_byteArray = new ByteArray();
		}
		
		public function storeData(value:*):void {
			_byteArray.clear();
			_byteArray.writeObject(value);
		}
		
		public function getData():* {
			_byteArray.position = 0;
			var s:* = _byteArray.readObject();
			return s;
		}
		
		public function destroy():void {
			_byteArray = null;
		}
	}

}