/*
 * WARNING
 * SAFETY_MINIMAL can be altered/locked by CheatEngine
 * It _will_ however be detected by the SafeNumber and CheatingDetected event will be dispatched
 */

package lbg.anticheatengine
{
	import lbg.anticheatengine.codednumber.*
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author light_bringer777
	 */
	public class SafeNumber extends CheatDetector
	{
		public static const EVENT_CHEAT_DETECTED:String = "cheat_detected";
		/** Stores data as number + random key, hiding the real value */
		public static const SAFETY_MINIMAL:String = "safety_min";
		/** Stores data as ByteArray */
		public static const SAFETY_BYTE:String = "safety_byte";
		/** Stores data as ByteArray with simple XOR cipher */
		public static const SAFETY_BYTEXOR:String = "safety_bytexor";
		/** Stores data as ByteArray and ByteArray with simple XOR cipher */
		public static const SAFETY_BYTEXOR_BYTE:String = "safety_bytexor_byte";
		protected var _value:Number;
		protected var _reverseDouble:Number;
		protected var _codedNumber:ICodedNumber;
		protected var _valueChangedSignal:Signal = new Signal(SafeNumber);
		
		/** Creates and returns a SafeNumber with a specified value */
		public static function creatwWithValueOf(value:Number = 0, safety:String = SAFETY_BYTEXOR):SafeNumber {
			return new SafeNumber(safety, value);
		}
		
		public function SafeNumber(safety:String = SAFETY_BYTEXOR_BYTE, value:Number = 0) 
		{
			super(this);
			switch(safety) {
				case SAFETY_MINIMAL:
					_codedNumber = new CodedNumberMinimal();
					break;
				case SAFETY_BYTE:
					_codedNumber = new CodedNumber();
					break;
				case SAFETY_BYTEXOR:
					_codedNumber = new CodedNumberXOR();
					break;
				case SAFETY_BYTEXOR_BYTE:
					_codedNumber = new CodedNumberXORAndByte();
					break;
				default:
					trace("SafeNumber - Incorrect safetyType, defaulted to SAFETY_BYTE");
					_codedNumber = new CodedNumber();
					break;
			}
			this.value = value;
		}
		
		public function set value(value:Number):void {
			//trace("SafeNumber value changing from", _value, "to", value);
			_value = value;
			setNumberToReverse(_value);
			setNumberToCoded(_value);
			
			_valueChangedSignal.dispatch(this);
			//trace("SafeNumber value changed to", _value, "by param", value);
		}
		
		public function get value():Number {
			assertValue();
			return _value;
		}
		
		/** Signal(SafeNumber) */
		public function get valueChangedSignal():Signal 
		{
			return _valueChangedSignal;
		}
		
		protected function getNumberFromReverse():Number {
			return _reverseDouble * -0.5;
		}
		
		protected function setNumberToReverse(number:Number):void {
			_reverseDouble =  number * -2;
		}
		
		protected function getNumberFromCoded():Number {
			return _codedNumber.getData();
		}
		
		protected function setNumberToCoded(number:Number):void {
			_codedNumber.storeData(number);
		}
		
		protected function assertValue():void {
			if (_value != getNumberFromCoded() || _value != getNumberFromReverse()) {
				if (isNaN(_value) && isNaN(getNumberFromCoded()) && isNaN(getNumberFromReverse())) {
					//Not actual data tampering, NaN simply never is == to itself....
				}else {
					//trace("SafeNumber assert failed.");
					eventDispatcher.dispatchEvent(new Event(EVENT_CHEAT_DETECTED));
					_cheatDetectedSignal.dispatch();
					value = getNumberFromCoded();
				}
			}
		}
		
		public function destroy():void {
			_codedNumber.destroy();
		}
		
	}

}