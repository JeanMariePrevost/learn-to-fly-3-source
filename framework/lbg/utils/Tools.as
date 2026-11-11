package lbg.utils {
	import fl.motion.Color;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	


	public class Tools {
		
		
		/**Used to get the audio-tapered value for a volume between 0 and 1, beyond 1 is linear*/
		public static function audioTaper(value:Number, maxVolume:Number = 1):Number {
			var volume:Number = value;
			
			if (value <= 1) {
				volume = Math.pow(value, 2.2);
			}else {
				volume = value * 2.2;
			}
			
			return NumberUtils.constrain(volume, 0, maxVolume);
		}
		
		public static function subsctractMatrices(mat1:Matrix, mat2:Matrix):Matrix {
			var m2:Matrix = mat2.clone();
			var m1:Matrix = mat1.clone();
			m2.invert();
			m1.concat(m2);
			return m1;
		}
		
		/**
		 * Returns the binary equivalent of a given int
		 * @param	adjustLength Adds extra "0" to have a length divisible by 4
		 * @return
		 */
		public static function decimalToBinary(num:int, adjustLength:Boolean = false):String {
			var bin:String = "";
			var len:uint = decimalBinaryLength(num);
			
			if(adjustLength){
				if((len % 4) > 0){
					while((len % 4) > 0){
						len++;
					}
				}
			}
			
			for(var i:uint = 0; i < len; i++) {
				bin += String((num & ((0x01 << (len - 1)) >> i)) >> (len - 1 - i));
			}
			
			return bin;
		}
		
		/**
		 * This function is only used within other functions to get the length of a bianry string from a decimal
		 */
		private static function decimalBinaryLength(dec:int):int {
			var len:uint = 0;
			var check = true;
			if(dec != 0){
				len = 1;
				while(check){
					if((dec >> len) == 0){
						check = false;
					}
					else{
						len++;
					}
				}
			}
			return len;
		}
		
		/**
		 * Returns the decimal value of a binary string
		 */
		public static function binaryToInt(num:String):int {
			return parseInt(num, 2);
		}
		
		/**
		 * Function used to get the Class Object of a instance
		 * @param	obj Instance to get the Class from
		 * @return Class of the specified instance
		 */
		public static function getClassOf(obj:*):Class {
			var objClass:Class = Class(getDefinitionByName(getQualifiedClassName(obj)));
			return objClass;
		}
		
		/** Takes Red/Green/Blue values and returns the color uint */
		public static function rgbToColor(r:int, g:int, b:int):uint	{
			var hex:uint = r << 16 | g << 8 | b;
			return hex;
		}
		
		/** Returns a formatted timestamp string */
		public static function getTimeString(UTC:Boolean = true, year:Boolean = true, month:Boolean = true, day:Boolean = true, hour:Boolean = true, minute:Boolean = true, seconds:Boolean = true):String {
			var dateObj:Date = new Date();
			
			var yearNum:Number;
			var monthNum:Number;
			var dayNum:Number;
			var hoursNum:Number;
			var minsNum:Number;
			var secsNum:Number;
			
			if (UTC) {
				yearNum = dateObj.getUTCFullYear()();
				monthNum = (dateObj.getUTCMonth() + 1)
				dayNum = (dateObj.getUTCDate())
				hoursNum = (dateObj.getUTCHours())
				minsNum = (dateObj.getUTCMinutes())
				secsNum = (dateObj.getUTCSeconds())
			}else {
				yearNum = dateObj.getFullYear();
				monthNum = (dateObj.getMonth() + 1)
				dayNum = (dateObj.getDate())
				hoursNum = (dateObj.getHours())
				minsNum = (dateObj.getMinutes())
				secsNum = (dateObj.getSeconds())
			}
			
			
			
			var yearStr:String = yearNum.toFixed();
			
			var monthStr:String = monthNum.toFixed();
			if (monthStr.length <= 1) monthStr = "0" + monthStr;
			
			var dayStr:String = dayNum.toFixed();
			if (dayStr.length <= 1) dayStr = "0" + dayStr;
			
			var hoursStr:String = hoursNum.toFixed();
			if (hoursStr.length <= 1) hoursStr = "0" + hoursStr;
			
			var minsStr:String = minsNum.toFixed();
			if (minsStr.length <= 1) minsStr = "0" + minsStr;
			
			var secsStr:String = secsNum.toFixed();
			if (secsStr.length <= 1) secsStr = "0" + secsStr;
			
			
			//Building the string
			var timeString:String = "";
			
			if (year) timeString = yearStr;
			
			if (month) {
				if (year) {
					timeString = timeString + "-" + monthStr;
				}else {
					timeString = timeString + monthStr;
				}
			}
			
			if (day) {
				if (year || month) {
					timeString = timeString + "-" + dayStr;
				}else {
					timeString = timeString + dayStr;
				}
			}
			
			
			
			if (hour) {
				if (year || month || day) {
					timeString = timeString + " " + hoursStr;
				}else {
					timeString = timeString + hoursStr;
				}
			}
			
			if (minute) {
				if (year || month || day) {
					if (hour) {
						timeString = timeString + ":" + minsStr;
					}else {
						timeString = timeString + " " + minsStr;
					}
				}else {
					timeString = timeString + minsStr;
				}
			}
			
			if (seconds) {
				if (year || month || day) {
					if (hour) {
						timeString = timeString + ":" + secsStr;
					}else {
						timeString = timeString + " " + secsStr;
					}
				}else {
					timeString = timeString + secsStr;
				}
			}
			
			return timeString;
			
		}
		
		/** Returns a HHH:MM:SS from a number of millisedonds */
		public static function millisecondsToTimeString(ms:Number):String {
			var seconds:Number = Math.floor(ms / 1000);
			
			var minutes:Number = Math.floor(seconds / 60);
			seconds = seconds % 60;
			
			var hours:Number = Math.floor(minutes / 60);
			minutes = minutes % 60;
			
			var secondString:String = seconds.toFixed();
			while (secondString.length <= 1) secondString = "0" + secondString;
			var minuteString:String = minutes.toFixed();
			while (minuteString.length <= 1) minuteString = "0" + minuteString;
			var hourString:String = hours.toFixed();
			while (hourString.length <= 1) hourString = "0" + hourString;
			
			return hourString + ":" + minuteString + ":" + secondString;
		}
		
		/** Returns a MMMM:SS.XXX from a number of millisedonds */
		public static function millisecondsToTimeString2(ms:Number, decimals:Number = 1):String {
			var seconds:Number = Math.floor(ms / 1000);
			
			var minutes:Number = Math.floor(seconds / 60);
			
			seconds = ms / 1000;
			seconds = seconds % 60;
			
			var secondString:String = seconds.toFixed(decimals);
			if (seconds.toFixed(0).length <= 1) secondString = "0" + secondString;
			var minuteString:String = minutes.toFixed();
			//while (minuteString.length <= 1) minuteString = "0" + minuteString;
			
			return minuteString + ":" + secondString;
		}
		
		
		/** returns an array of objects with .name, .type, .access, .declared by and .value properties */
		public static function describeObject(obj:*):Array {
			var _description : XML = describeType(obj);
			var _properties : Array = new Array();
			for each (var prop:XML in _description..variable){
				var _property : Object = new Object();
				_property.name = String(prop.@name);
				_property.type = String(simple_type(prop.@type));
				_property.access = String(prop.@access);
				_property.declaredBy = String(prop.@declaredBy);
				try
				{
				   _property.value = obj[_property.name];
				}
				catch (e : Error)
				{
				   _property.value = "";
				}
				_properties.push(_property)
			}
			_properties.sortOn("name");
			return _properties;
		}
		
		/** Used by DescribeObject */
		private static function simple_type(_type : String) : String
		{
			var lastIndex : int = _type.lastIndexOf("::");
			_type = lastIndex > 0 ? _type.substr(lastIndex + 2) : _type;
			return _type;
		}
		
		
	}
}