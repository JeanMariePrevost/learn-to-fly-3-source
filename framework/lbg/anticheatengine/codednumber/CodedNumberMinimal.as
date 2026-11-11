package lbg.anticheatengine.codednumber 
{
	/**
	 * ...
	 * @author 
	 */
	public class CodedNumberMinimal implements ICodedNumber
	{
		protected var _number:Number;
		protected var _key:Number;
		
		public function CodedNumberMinimal() 
		{
			_key = int(3 + Math.random() * 900);
		}
		
		public function storeData(value:Number):void {
			_number = value + _key;
		}
		
		public function getData():Number {
			return _number - _key;
		}
		
		public function destroy():void 
		{
			//Nothing to do
		}
	}

}