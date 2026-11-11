package lbg.anticheatengine.codedstring 
{
	/**
	 * ...
	 * @author 
	 */
	public class CodedStringNullObject implements ICodedString 
	{
		protected var _string:String;
		
		public function CodedStringNullObject() 
		{
			_string = "";
		}
		
		public function storeData(value:String):void 
		{
			_string = value;
		}
		
		public function getData():String 
		{
			return _string;
		}
		
	}

}
