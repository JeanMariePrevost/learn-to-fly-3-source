package lbg.anticheatengine.codednumber
{
	import flash.utils.ByteArray;
	import lbg.utils.StringUtils;
	/**
	 * ...
	 * @author light_bringer777
	 */
	public class CodedNumberXORAndByte implements ICodedNumber
	{
		protected var _byteArray:ByteArray;
		protected var _byteArray2:ByteArray;
		protected var _key:ByteArray;
		
		public function CodedNumberXORAndByte() 
		{
			_byteArray = new ByteArray();
			_byteArray2 = new ByteArray();
			_key = new ByteArray();
			//var keyString:String = "hd7d64hh54nsjs8y3754hh5njhtiouf8f";
			var keyString:String = StringUtils.randomString(10);
			_key.writeUTF(keyString);
		}
		
		public function storeData(value:Number):void {
			_byteArray.clear();
			_byteArray.writeDouble(value);
			XOR(_byteArray, _key);
			_byteArray2.clear();
			_byteArray2.writeDouble(value);
		}
		
		public function getData():Number {
			XOR(_byteArray, _key);
			_byteArray.position = 0;
			var s:Number = _byteArray.readDouble();
			XOR(_byteArray, _key);
			_byteArray2.position = 0;
			if (s != _byteArray2.readDouble()) {
				trace("CodedNumberXORAndByte ERROR - 2 values not equals");
				return NaN;
			}else {
				return s;
			}
		}
		
		protected function XOR(binaryData1:ByteArray, binaryData2:ByteArray):void{
			for(var i:Number=0;i<binaryData1.length;i++){
				binaryData1[i]=binaryData1[i]^binaryData2[i];
			}
		}
		
		public function destroy():void 
		{
			if(_byteArray) _byteArray.clear();
			_byteArray = null;
			
			if(_byteArray2) _byteArray2.clear();
			_byteArray2 = null;
			
			if(_key) _key.clear();
			_key = null;
		}
		
	}

}