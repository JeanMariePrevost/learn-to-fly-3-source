/*
 * WARNING
 * SAFETY_MINIMAL can be altered/locked by CheatEngine
 * It _will_ however be detected by the SafeNumber and CheatingDetected event will be dispatched
 */

package lbg.anticheatengine
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import lbg.anticheatengine.codedstring.*;
	/**
	 * ...
	 * @author light_bringer777
	 */
	public class SafeString extends CheatDetector
	{
		public static const EVENT_CHEAT_DETECTED:String = "cheat_detected";
		public static const SAFETY_MINIMAL:String = "safety_min";
		public static const SAFETY_BYTE:String = "safety_byte";
		public static const SAFETY_ENCRYPT:String = "safety_bytexor";
		public static const SAFETY_BYTE_ENCRYPT:String = "safety_bytexor_byte";
		protected var _value:String;
		protected var _encryptedString:ICodedString;
		protected var _codedString:ICodedString;
		
		public function SafeString(safety:String = SAFETY_BYTE) 
		{
			super(this);
			switch(safety) {
				case SAFETY_MINIMAL:
					_encryptedString = new CodedStringSimple();
					_codedString = new CodedStringSimple();
					break;
				case SAFETY_BYTE:
					_encryptedString = new CodedStringSimple();
					_codedString = new CodedString();
					break;
				case SAFETY_ENCRYPT:
					_encryptedString = new CodedStringDictionary();
					_codedString = new CodedStringSimple();
					break;
				case SAFETY_BYTE_ENCRYPT:
					_encryptedString = new CodedStringDictionary();
					_codedString = new CodedString();
					break;
				default:
					trace("SafeNumber - Incorrect safetyType, defaulted to SAFETY_BYTE");
					_encryptedString = new CodedStringSimple();
					_codedString = new CodedString();
					break;
			}
			
		}
		
		public function set value(value:String):void {
			_value = value;
			_codedString.storeData(_value);
			_encryptedString.storeData(_value);
		}
		
		public function get value():String {
			assertValue();
			return _value;
		}
		
		protected function assertValue():void {
			if (_value != _codedString.getData() || _value != _encryptedString.getData()) {
				trace("SafeString broken");
				//trace(_codedString.getData());
				//trace(_encryptedString.getData());
				eventDispatcher.dispatchEvent(new Event(EVENT_CHEAT_DETECTED));
				_cheatDetectedSignal.dispatch();
				value = _codedString.getData();
			}
		}
		
		public function destroy():void {
			if (_encryptedString) _encryptedString.destroy();
			if (_codedString) _codedString.destroy();
			
			_encryptedString = null;
			_codedString = null;
		}
		
	}

}