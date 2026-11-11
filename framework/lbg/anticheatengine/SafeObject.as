package lbg.anticheatengine
{
	import anticheatengine.codedobject.CodedObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author 
	 */
	public class SafeObject extends CheatDetector
	{
		public static const EVENT_CHEAT_DETECTED:String = "cheat_detected";
		
		protected var _value:*;
		protected var _codedObject:CodedObject;
		
		public function SafeObject() 
		{
			super(this);
			_codedObject = new CodedObject();
		}
		
		public function set value(value:*):void {
			_value = value;
			_codedObject.storeData(_value);
		}
		
		public function get value():* {
			assertValue();
			return _value;
		}
		
		protected function assertValue():void {
			if (_value != _codedObject.getData()) {
				trace("SafeObject broken");
				eventDispatcher.dispatchEvent(new Event(EVENT_CHEAT_DETECTED));
				_cheatDetectedSignal.dispatch();
				value = _codedObject.getData();
			}
		}
	}

}