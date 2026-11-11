package src.compound 
{
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author 
	 */
	public class TimedMod extends Mod 
	{
		public var life:Number;
		public var maxLife:Number;
		public var fadePower:Number = 1;
		
		public var tickSignal:Signal;
		
		protected var _initAdd:Number;
		protected var _initMul:Number;
		
		/**
		 * Creates a mod that fades as time goes by and destroys itself when its duration is reached
		 * @param	add additive mod
		 * @param	mul multiplicative mod
		 * @param	duration duration in ticks
		 * @param	tickSignal Default tick signal, if null tick has to be called manually
		 */
		public function TimedMod(add:Number = 0, mul:Number = 1, duration:Number = 60, tickSignal:Signal = null) 
		{
			super(add, mul);
			
			_initAdd = add;
			_initMul = mul;
			
			life = maxLife = duration;
			
			if (tickSignal) {
				this.tickSignal = tickSignal;
				tickSignal.add(tick);
			}
		}
		
		public function tick(delta:Number = 1):void {
			life -= delta;
			
			if (life > 0) {
				updateTimedMod();
			}else {
				destroy();
				return;
			}
			
			//trace("TimedMod life:", life);
		}
		
		protected function updateTimedMod():void {
			_add = NumberUtils.interpolate2(_initAdd, 0, maxLife, 0, life, fadePower);
			_mul = NumberUtils.interpolate2(_initMul, 1, maxLife, 0, life, fadePower);
			_updateSignal.dispatch();
		}
		
		override public function destroy():void 
		{
			life = 0;
			updateTimedMod();
			if(tickSignal) tickSignal.remove(tick);
			tickSignal = null;
			
			super.destroy();
		}
		
	}

}