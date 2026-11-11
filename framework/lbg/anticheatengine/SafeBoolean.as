package lbg.anticheatengine
{
	import lbg.anticheatengine.codedobject.CodedObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author 
	 */
	public class SafeBoolean  extends CheatDetector
	{
		public static const EVENT_CHEAT_DETECTED:String = "cheat_detected";
		
		protected var _value:Boolean;
		protected var _valueReverse:Boolean;
		protected var _codedObject:CodedObject;
		protected var _valueChangedSignal:Signal = new Signal(SafeBoolean);
		
		public function SafeBoolean(value:Boolean = false) 
		{
			super(this);
			_codedObject = new CodedObject();
			
			this.value = value;
		}
		
		public function set value(value:Boolean):void {
			_value = value;
			_valueReverse = !value;
			_codedObject.storeData(_value);
			
			_valueChangedSignal.dispatch(this);
		}
		
		public function get value():Boolean {
			assertValue();
			return _value;
		}
		
		public function get valueChangedSignal():Signal 
		{
			return _valueChangedSignal;
		}
		
		protected function assertValue():void {
			if (_value != _codedObject.getData() || _value == _valueReverse) {
				trace("SafeBoolean broken");
				eventDispatcher.dispatchEvent(new Event(EVENT_CHEAT_DETECTED));
				_cheatDetectedSignal.dispatch();
				value = _codedObject.getData();
			}
		}
		
		public function destroy():void {
			if (_codedObject) _codedObject.destroy();
			
		}
	}

}