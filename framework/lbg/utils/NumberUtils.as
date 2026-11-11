package lbg.utils {
	import flash.display.DisplayObjectContainer;
	import flash.utils.ByteArray;

	public class NumberUtils {
		

		/**
		 * returns the average of all values in a array
		 */
		public static function averageArray(array:Array):Number {
			var t:Number = 0;
			for each(var i:Number in array) {
				t += i;
			}
			return t / array.length;
		}
		
		/**
		 * returns the average of all values
		 */
		public static function average(...values):Number {
			var t:Number = 0;
			for each(var i:Number in values) {
				t += i;
			}
			return t / values.length;
		}
		
		/**
		 * Returns the distance between two points
		 */
		public static function distanceBetween(x1:Number, y1:Number,  x2:Number, y2:Number):Number {
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * Returns a number between a low and high value, depending on the position specified
		 * @param	a Value at position = 0
		 * @param	b Value at position = 1
		 * @param	position Position between a/b values to calculate, 0.5 being average/center (can go <0 or >1)
		 * @param	power Used to create easing in/out. 1 = linear function
		 * @param   constrain If set to true, value cannot be below low or above high
		 * @return Value between low and high value at specified position (0 if NaN)
		 */
		public static function interpolate(valueA:Number, valueB:Number, position:Number = 0.5, power:Number = 1, constrain:Boolean = true):Number {
			if (constrain) position = NumberUtils.constrain(position, 0, 1);
			var value:Number = valueA + ((valueB - valueA) * Math.pow(position, power));
			
			if (isNaN(value)) return NaN;
			return isNaN(value) ? 0:value;
		}
		
		/**
		 * Returns a number between a low and high value, depending on the position between a high and low position range
		 * @param	a Value at lowPosition
		 * @param	b Value at highPosition
		 * @param	aPosition Position at which value = low
		 * @param	bPosition Position at which value = high
		 * @param	position Current position within range
		 * @param	power Used to create easing in/out. 1 = linear function
		 * @param   constrain If set to true, value cannot be below low or above high
		 * @return Value between low and high value at specified position within range (0 if NaN)
		 */
		public static function interpolate2(valueA:Number, valueB:Number, positionA:Number, positionB:Number, currentPosition:Number, power:Number = 1, constrain:Boolean = true):Number {
			if (positionA == positionB) return valueB;
			return interpolate(valueA, valueB, (currentPosition - positionA) / (positionB - positionA), power, constrain);
		}
		
		public static function normalize(min:Number, max:Number, value:Number, constrain:Boolean = true):Number {
			return interpolate2(0, 1, min, max, value, 1, constrain);
		}
		
		/**
		 * Returns an angle between min and max values, useful for tweening from <-90 to >90
		 * @param	a Value at lowPosition
		 * @param	b Value at highPosition
		 * @param	position Current position within range
		 * @param	power Used to create easing in/out. 1 = linear function
		 * @param   constrain If set to true, value cannot be below low or above high
		 * @return Value between low and high value at specified position within range (0 if NaN)
		 */
		public static function interpolateRotation(minValue:Number, maxValue:Number, position:Number = 0.5, power:Number = 1, constrain:Boolean = false):Number {
			//If rotation is bigger by the "positive side" (passing by "0" instead of going from <-90 to >90)
			//bring up the negative rotation value by 360 to make the interpolation shorter by the other side
			if (Math.abs(minValue - maxValue) > 180) {
				if (minValue < 0) {
					minValue += 360;
				}else if (maxValue < 0) {
					maxValue += 360;
				}
			}
			return interpolate(minValue, maxValue, position, power, constrain);
		}
		
		/**
		 * Limits the value between a min and max
		 */
		public static function constrain(value:Number, minValue:Number = 0, maxValue:Number = 1):Number {
			if (minValue > maxValue) {
				var holder:Number = minValue;
				minValue = maxValue;
				maxValue = minValue;
			}
			if (value < minValue) return minValue;
			if (value > maxValue) return maxValue;
			return value;
		}	
		
		/**
		 * Returns a random value within specified range
		 */
		public static function randomRange(minValue:Number, maxValue:Number, round:Boolean = false):Number {
			var value:Number = (minValue + Math.random() * (maxValue - minValue));
			 
			if (round) return Math.round(value);
			return value;
		}	
		
		/**
		 * Returns a random number between -0.5 and 0.5 times value
		 * @return -0.5 to 0.5 of value
		 */
		public static function randomBoth(value:Number):Number {
			return (Math.random() - 0.5) * value;
		}
		
		/**
		 * Returns true if value is NaN
		 * @param	value Value to check
		 * @return True if NaN, false if Number
		 */
		public static function isNaN(value:Number):Boolean {
			return value != value;
		}
		
		/**
		 * Round numbers to the nearest N value
		 */
		public static function roundToNearest(roundTo:Number, value:Number):Number{
			return Math.round(value/roundTo)*roundTo;
		}
		
		/**
		 * Returns a number with a certain number of decimals
		 */
		public static function setPrecison(number:Number, decimals:Number = 0):Number {
			decimals = Math.pow(10,Math.max(0, Math.round(decimals)));
			return (Math.round(number * decimals) / decimals);
		}
		
		
		/**
		 * Used to add comas to separate thousands in a number
		 */
		public static function numberDelimiter(num:Number, delimiter:String = ",", numCharGroup:Number = 3, decimalPrecision:int = 0):String 
		{
			var decimal:String = "", newVal:Number = Math.abs(num);
			if (decimalPrecision != 0) 
			{
				decimal = String((newVal % 1).toFixed(decimalPrecision)).substring(1); // if left negative, could be -0.x
			}
			var newString:String = "";
			var numberString:String = Math.floor(newVal).toString();
			for (var index:int = numberString.length, col:int = 0; ~--index; ) 
			{
				newString = numberString.substr(index, 1) + newString;
				if (++col == numCharGroup && index) 
				{
					newString = delimiter + newString;
					col = 0;
				}
			}
			return ((num < 0) ? "-" : "") + newString + decimal;
		}
		
		/** Solves the log of a value on a specific base, e.g. to find the exponent in 10 to power 3 (1000), logx(1000,10) returns 3 */
		public static function logx(val:Number, base:Number=10):Number {
			return Math.log(val)/Math.log(base)
		}
		
		
		/**
		 * Calculates a soft-cap much like income tax, where each successive bracket is progressively reduced up to a certain point
		 * @param	value Initial value to process
		 * @param	capBeginsAtValue Value at which the caps begins to apply
		 * @param	braketSize Step at which brackets increment
		 * @param	changePerBracket Mult lost per bracket (e.g. 0.01 = 1% per bracket)
		 * @param	strongestBracketMult Strongest loss possible (e.g. 0.5 = no more than 50% brackets)
		 * @return
		 */
		public static function progressiveCap(value:Number, capBeginsAtValue:Number, bracketSize:Number, changePerBracket:Number, strongestBracketMult:Number = 0):Number {
			if (value <= capBeginsAtValue) return value;
			
			var remain:Number = value - capBeginsAtValue;
			var result:Number = capBeginsAtValue;
			var currentChange:Number = 1 - changePerBracket;
			
			var loopLimit:Number = 10000000;
			
			for (var i:int = 0; i < loopLimit; i++) {
				if (remain <= bracketSize) {
					result += remain * currentChange;
					return result;
				}else {
					result += bracketSize * currentChange;
					remain -= bracketSize;
					currentChange = Math.max(currentChange - changePerBracket, strongestBracketMult);
				}
			}
			
			throw new Error("Global.progressiveCap limit reached");
			return value;
		}
		
		/**
		 * Calculates a soft-cap much like income tax, where each successive bracket is progressively reduced up to a certain point
		 * @param	value Initial value to process
		 * @param	capBeginsAtValue Value at which the caps begins to apply
		 * @param	bracketAmount Number of brackets from beginning to end
		 * @param	capEndsAtValue At what value the stronget cap ends
		 * @param	strongestBracketMult Strongest loss possible (e.g. 0.5 = no more than 50% brackets)
		 * @param	power Adjusts the "curve" of the brackets
		 * @return
		 */
		public static function progressiveCap2(value:Number, capBeginsAtValue:Number, bracketCount:Number, capEndsAtValue:Number, strongestBracketMult:Number = 0, power:Number = 1):Number {
			if (value <= capBeginsAtValue) return value;
			
			var bracketSize:Number = (capEndsAtValue - capBeginsAtValue) / bracketCount;
			
			var remain:Number = value - capBeginsAtValue;
			var result:Number = capBeginsAtValue;
			var currentChange:Number = 1;
			
			for (var i:int = 0; i <= bracketCount; i++) {
				currentChange = NumberUtils.interpolate2(1, strongestBracketMult, 0, bracketCount, i, power);
				if (remain <= bracketSize) {
					result += remain * currentChange;
					return result;
				}else {
					result += bracketSize * currentChange;
					remain -= bracketSize;
				}
			}
			
			if (remain > 0) {
				result += remain * strongestBracketMult;
			}
			
			return result;
		}
		
		
	}
}