package src.compound 
{
	import lbg.debug.Log;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author 
	 */
	public class CompoundNumber 
	{
		/** Dispatches (CompoundNumber) */
		protected var _signalChange:Signal = new Signal(CompoundNumber);
		protected var _base:Number;
		protected var _mods:Vector.<Mod> = new Vector.<Mod>();
		protected var _value:Number;
		
		public function CompoundNumber(base:Number = 0) 
		{
			_base = base;
			recalculate();
		}
		
		public function addMod(mod:Mod):void {
			_mods.push(mod);
			mod.updateSignal.add(recalculate);
			mod.destroySignal.add(removeMod);
			recalculate();
		}
		
		public function addMod2(add:Number = 0, mul:Number = 1):Mod {
			var m:Mod = new Mod(add, mul);
			addMod(m);
			return m;
		}
		
		public function removeMod(mod:Mod):void {
			if (_mods.indexOf(mod) >= 0) {
				_mods.splice(_mods.indexOf(mod), 1);
				mod.updateSignal.remove(recalculate);
				recalculate();
			}else {
				Log.log("CompoundNumber error - Trying to remove a Mod that is not part of CompoundNumber");
			}
		}
		
		public function clearMods():void {
			for each(var m:Mod in _mods) {
				m.updateSignal.remove(recalculate);
				m.destroySignal.remove(removeMod);
				m.destroy();
			}
			_mods = new Vector.<Mod>();
			recalculate();
		}
		
		/** Force recalculation of compund value */
		public function recalculate():void {
			//Current model: multiplications before additions
			
			var val:Number = _base;
			
			for each(var m:Mod in _mods) {
				val *= m.mul;
			}
			
			for each(m in _mods) {
				val += m.add;
			}
			
			if (isNaN(val)) {
				_value = _base;
			}
			
			
			_value = val;
			
			//trace("Dispatching recalculate signal...");
			_signalChange.dispatch(this);
		}
		
		public function get base():Number 
		{
			return _base;
		}
		
		public function set base(value:Number):void 
		{
			_base = value;
			recalculate();
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		/** Signal(CompoundNumber) */
		public function get signalChange():Signal 
		{
			return _signalChange;
		}
		
		public function destroy():void {
			clearMods();
			
			//Clear signal AFTER mods because one final update will dispatch
			if(_signalChange) _signalChange.removeAll();
			_signalChange = null;
			_mods = null;
		}
	}

}