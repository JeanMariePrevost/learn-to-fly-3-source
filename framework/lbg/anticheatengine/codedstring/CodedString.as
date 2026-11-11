package lbg.anticheatengine.codedstring
{
	import lbg.anticheatengine.codedstring.ICodedString;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author light_bringer777
	 */
	public class CodedString implements ICodedString
	{
		protected var _byteArray:ByteArray;
		
		public function CodedString() 
		{
			_byteArray = new ByteArray();
		}
		
		public function storeData(string:String):void {
			_byteArray.clear();
			_byteArray.writeUTF(string);
		}
		
		public function getData():String {
			_byteArray.position = 0;
			var s:String = _byteArray.readUTF();
			return s;
		}
		
		public function destroy():void 
		{
			if (_byteArray) _byteArray.clear();
			_byteArray = null;
		}
		
	}

}