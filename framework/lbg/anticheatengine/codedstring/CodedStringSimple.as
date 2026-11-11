package lbg.anticheatengine.codedstring 
{
	/**
	 * ...
	 * @author 
	 */
	public class CodedStringSimple implements ICodedString 
	{
		protected var _string:String;
		protected var _key:String;
		protected static const _charList:Array = new Array("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ",", ".", "-", "/", "*", "+", " ", "_", "'", "!", "@", "#", "$", "%", "?", "&", "*", "(", ")", "{", "}", "[", "]");
		
		public function CodedStringSimple() 
		{
			_string = "";
			_key = _charList[int(Math.random() * _charList.length)];
		}
		
		public function storeData(value:String):void 
		{
			_string = _key + value;
		}
		
		public function getData():String 
		{
			return _string.substr(1);
		}
		
		public function destroy():void 
		{
			//Nothing
		}
		
	}

}