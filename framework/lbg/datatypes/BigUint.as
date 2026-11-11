package lbg.datatypes 
{
	/**
	 * ...
	 * @author 
	 */
	public class BigUint 
	{
		//protected var value:Vector.<int> = new Vector.<int>();
		protected var value:Array = new Array();
		
		public function BigUint(value:String = "0") 
		{
			this.value = stringToArray(value);
		}
		
		protected function stringToArray(str:String):Array {
			if (isNaN(Number(str))) {
				throw new Error("stringToArray - String is NaN");
			}
			var decimalIndex:int = str.indexOf(".");
			if (decimalIndex >= 1) {
				str = str.substring(0, decimalIndex);
			}else if (decimalIndex == 0) {
				str = "0";
			}
			
			var array:Array = new Array();
			
			for (var i:uint = 0; i < str.length; i++) {
				array.push(int(str.charAt(i)));
			}
			
			//return str.split("");
			removeLeadingZeroFrom(array);
			return array;
		}
		
		protected function removeLeadingZeroFrom(array:Array):void {
			while (array[0] == 0 && array.length > 1) {
				array.shift();
			}
		}
		
		public function setValue(value:String = "0"):void {
			this.value = stringToArray(value);
		}
		
		public function setValueFromNumber(num:Number = 0):void {
			//var workNum:Number = (num >= Number.POSITIVE_INFINITY) ? Number.MAX_VALUE * 0.5:num;
			var workNum:Number = num;
			var stepCount:int = 0;//Always start at 0
			var stepSize:Number = 10;
			var maxValue:Number = 99999999999999999999;//Max number to fit in toFixed()
			
			while (workNum > maxValue) {
				stepCount++;
				workNum = workNum / stepSize;
				if (stepCount >= 315) {
					trace(stepCount);
					trace(num);
					trace(workNum);
					trace(workNum > maxValue);
					throw new Error("StepCount loop as gone mad :O");
				}
			}
			setValue(workNum.toFixed());
			if (stepCount > 0) multiply(Math.pow(stepSize, stepCount));
		}
		
		public function add(num:String):void {
			var modArray:Array = stringToArray(num);
			var len:int = int(Math.max(modArray.length, value.length));
			var result:Array = new Array();
			var over:int = 0;
			
			for (var i:int = 0; i < len; i++) {
				var a:int = (i > modArray.length) ? 0:modArray[modArray.length - (i + 1)];
				var b:int = (i > value.length) ? 0:value[value.length - (i + 1)];
				var c:int = a + b + over;
				if (c >= 10) {
					over = 1;
					c = c % 10;
				}else {
					over = 0
				}
				result.unshift(c);
			}
			
			if (over >= 1) {
				result.unshift(over);
			}
			
			value = result;
		}
		
		public function substract(num:String):void {
			if (isLessThanEqualTo(num)) {
				value = [0];
				return;
			}
			
			var modArray:Array = stringToArray(num);
			var len:int = int(Math.max(modArray.length, value.length));
			var result:Array = new Array();
			var take:int = 0;
			
			for (var i:int = 0; i < len; i++) {
				var a:int = (i > modArray.length) ? 0:modArray[modArray.length - (i + 1)];
				var b:int = (i > value.length) ? 0:value[value.length - (i + 1)];
				var c:int = b - a - take;
				if (c < 0) {
					take = 1;
					c = c + 10;
				}else {
					take = 0
				}
				result.unshift(c);
			}
			
			removeLeadingZeroFrom(result);
			
			value = result;
		}
		
		public function multiply(byNum:Number, precision:uint = 4):void {
			
			//byNum = NumberUtils.setPrecison(byNum, precision);
			var num:String = byNum.toFixed(precision);
			
			while (num.charAt(num.length - 1) == "0" && num.indexOf(".") >= 0) {
				if (num.charAt(num.length - 1) == ".") {
					num = num.substr(0, num.length - 1);
					break;
				}
				num = num.substr(0, num.length - 1);
			}
			
			var decimals:uint = (num.indexOf(".") >= 0) ? num.length - num.indexOf(".") - 1:0;
			
			var workArray:Array = value.concat();
			
			
			if (decimals > 0) {
				//Remove all decimals by multiplying by 10 * decimals
				for (var i:int = 0; i < decimals; i++) {
					workArray.push(0);
				}
				num = num.substring(0, num.indexOf(".")) + num.substring(num.indexOf(".") + 1);
			}
			
			var mult:uint = uint(num);
			
			var over:uint = 0;
			
			var result:Array = new Array();
			for (i = 0; i < workArray.length; i++) {
				var a:uint = (i > workArray.length) ? 0:workArray[workArray.length - (i + 1)];
				var b:uint = uint(a * mult + over);
				if (b >= 10) {
					over = uint(b / 10);
					b = b % 10;
				}else {
					over = 0;
				}
				result.unshift(b);
			}
			if (over > 0) {
				var overStr:String = over.toFixed();
				for (i = 0; i < overStr.length; i++) {
					result.unshift(uint(overStr.charAt(overStr.length - i - 1)));
				}
			}
			
			if (decimals > 0) {
				for (i = 0; i < (decimals * 2); i++) {
					if (i == (decimals * 2) - 1) {
						//////////////////////////////////////////////////////////////////////////////////////////////
						//IMPORTANT
						//Rounding disabled because of a bug when rounding up a number to 10
						//causing a number to be in a single digit slot
						//Solution would be to re-scan array and carry anything above 9 to the next digit
						//////////////////////////////////////////////////////////////////////////////////////////////
						
						//Rouding
						if (result[result.length - 1] >= 5) {
							//round up
							if (result.length == 1) {
								result.unshift(1);
							}else { 
								result[result.length - 2] += 1;
								for (var j:int = result.length - 2; j >= 0; j--) {
									if (result[j] <= 9) {
										break;
									}else {
										result[j] -= 10;
										if (j == 0) {
											result.unshift(1);
										}else {
											result[j - 1] += 1;
										}
									}
								}
							}
						}else {
							//round down
						}
					}
					result.pop();
				}
			}
			if (result.length <= 0) {
				result = [0];
			}
			value = result;
		}
		
		public function multiply2(byNum:Number):void {
			var toNum:Number = toNumber();
			
			var result:Number = Math.round(toNum * byNum);
			
			setValueFromNumber(result);
		}
		
		public function divide(byNum:Number, precision:uint = 4):void {
			multiply(1 / byNum, precision);
		}
		
		public function isGreaterThan(num:String):Boolean {
			var numArray:Array = stringToArray(num);
			if (value.length > numArray.length) {
				return true;
			}else if (value.length < numArray.length) {
				return false;
			}else {
				for (var i:int = 0; i < value.length; i++) {
					if (value[i] > numArray[i]) {
						return true;
					}else if (value[i] < numArray[i]) {
						return false;
					}
				}
			}
			
			return false;
		}
		
		public function isGreaterThanEqualTo(num:String):Boolean {
			var numArray:Array = stringToArray(num);
			if (value.length > numArray.length) {
				return true;
			}else if (value.length < numArray.length) {
				return false;
			}else {
				for (var i:int = 0; i < value.length; i++) {
					if (value[i] > numArray[i]) {
						return true;
					}else if (value[i] < numArray[i]) {
						return false;
					}
				}
			}
			
			return true;
		}
		
		public function isLessThan(num:String):Boolean {
			return !(isGreaterThanEqualTo(num));
		}
		
		public function isLessThanEqualTo(num:String):Boolean {
			return !(isGreaterThan(num));
		}
		
		public function isEqualTo(num:String):Boolean {
			if (num.length != value.length) {
				return false;
			}
			
			var numArray:Array = stringToArray(num);
			for (var i:int = 0; i < value.length; i++) {
				if (value[i] != numArray[i]) {
					return false;
				}
			}
			
			return true;
		}
		
		public function toNumber():Number {
			return Number(toString());
		}
		
		public function toString():String {
			return value.join("");
		}
		
		/**
		 * Returns a number string separated at thousands and limited to # of digits (e.g. 1,000,000G)
		 * @param	maxDigits Max digits in string (separator aside)
		 * @param	trimStep How many thousands to trim at each step (e.g. 1 trims ,000; 2 trims ,000,000)
		 * @param	minimumTrimSteps Trim to step even if maxDigits is not reached
		 * @param	symbolSeparator String to insert between number and SI symbol (e.g. ,000_G)
		 * @return Returns a number string separated at thousands and limited to # of digits (e.g. 1,000,000G)
		 */
		public function toFormattedString(maxDigits:uint = 12, trimStep:uint = 1, minimumTrimSteps:uint = 0, symbolSeparator:String = ""):String {
			if (maxDigits < (trimStep * 3)) {
				throw new Error("toFormattedString - Trimming more than maximum digits");
			}
			var trim:uint = 0;
			var workArray:Array = value.concat();
			while (workArray.length > maxDigits) {
				for (var i:int = 0; i < trimStep; i++) {
					workArray.pop();
					workArray.pop();
					workArray.pop();
					trim += 1;
				}
			}
			
			if (trim < minimumTrimSteps) {
				var trimDiff:uint = minimumTrimSteps - trim;
				if (workArray.length <= trimDiff * 3) {
					workArray = ["0"];
				}else{
					for (var k:int = 0; k < trimDiff; k++) {
						workArray.pop();
						workArray.pop();
						workArray.pop();
					}
				}
				trim = minimumTrimSteps;
			}
			
			var trimmed:String = workArray.join("");
			
			//Delimitation
			var workString:String = trimmed;
			var result:String = "";
			
			while (workString.length > 3) {
				var s:String = workString.substr(workString.length - 3, 3);
				workString = workString.substring(0, workString.length - 3);
				result = "," + s + result;
			}
			result = workString + result;
			
			
			switch(trim) {
				case 0:
					//no suffix
					break;
				case 1:
					result = result + "k";
					break;
				case 2:
					result = result + "M";
					break;
				case 3:
					result = result + "G";
					break;
				case 4:
					result = result + "T";
					break;
				case 5:
					result = result + "P";
					break;
				case 6:
					result = result + "E";
					break;
				case 7:
					result = result + "Z";
					break;
				case 8:
					result = result + "Y";
					break;
				case 9:
					//result = result + "Oct";
					result = result + "Ot";
					break;
				case 10:
					//result = result + "Non";
					result = result + "Nn";
					break;
				case 11:
					//result = result + "Dec";
					result = result + "Dc";
					break;
				case 12:
					//result = result + "Und";
					result = result + "Ud";
					break;
				case 13:
					//result = result + "Duo";
					result = result + "Dd";
					break;
				case 14:
					//result = result + "Tre";
					result = result + "Td";
					break;
				case 15:
					//result = result + "Quatt";
					result = result + "Qd";
					break;
				case 16:
					//result = result + "Quinq";
					result = result + "Qd";
					break;
				case 17:
					//result = result + "Sed";
					result = result + "Sd";
					break;
				case 18:
					//result = result + "Sep";
					result = result + "Sp";
					break;
				case 19:
					//result = result + "Octod";
					result = result + "Od";
					break;
				case 20:
					//result = result + "Nov";
					result = result + "Nd";
					break;
				case 21:
					//result = result + "Vig";
					result = result + "Vt";
					break;
				default:
					result = result + "...";
					break;
			}
			
			if (result.length <= 0) {
				result = "0";
			}
			return result;
		}
		
		public function getFormattedStringTrimLevel(maxDigits:uint = 12, trimStep:uint = 1):uint {
			if (maxDigits < (trimStep * 3)) {
				throw new Error("toFormattedString - Trimming more than maximum digits");
			}
			var trim:uint = 0;
			var workArray:Array = value.concat();
			while (workArray.length > maxDigits) {
				for (var i:int = 0; i < trimStep; i++) {
					workArray.pop();
					workArray.pop();
					workArray.pop();
					trim += 1;
				}
			}
			return trim;
		}
		
	}

}