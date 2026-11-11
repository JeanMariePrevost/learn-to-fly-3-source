package src.compound 
{
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author 
	 */
	public class Mod 
	{
		protected var _add:Number;
		protected var _mul:Number;
		
		/** Dispatches to let affected CompundNumber to update its value */
		protected var _updateSignal:Signal = new Signal();
		
		/** Dispatches to let affected CompundNumber to remove this Mod */
		protected var _destroySignal:Signal = new Signal(Mod);
		
		public function Mod(add:Number = 0, mul:Number = 1)
		{
			_add = add;
			_mul = mul;
			dispatchUpdate();
		}
		
		//Has to dispatch an update event for the CompoundNumber to be recalculated
		protected function dispatchUpdate():void {
			_updateSignal.dispatch();
		}
		
		public function get add():Number 
		{
			return _add;
		}
		
		public function set add(value:Number):void 
		{
			if (_add == value) return;//No change, don't recalculate
			_add = value;
			dispatchUpdate();
		}
		
		public function get mul():Number 
		{
			return _mul;
		}
		
		public function set mul(value:Number):void 
		{
			if (_mul == value) return;//No change, don't recalculate
			_mul = value;
			dispatchUpdate();
		}
		
		public function get updateSignal():Signal 
		{
			return _updateSignal;
		}
		
		public function get destroySignal():Signal 
		{
			return _destroySignal;
		}
		
		public function destroy():void {
			_destroySignal.dispatch(this);
			
			_destroySignal.removeAll();
			_destroySignal = null;
			
			_updateSignal.removeAll();
			_updateSignal = null;
		}
		
	}

}