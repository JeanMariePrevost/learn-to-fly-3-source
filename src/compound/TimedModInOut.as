package src.compound 
{
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	
	/**
	 * Timed mod that has a start, mid and end point so that it may go from say 1->0->1 and end
	 * @author 
	 */
	public class TimedModInOut extends TimedMod 
	{
		public var startAdd:Number;
		public var midAdd:Number;
		public var startMul:Number;
		public var midMul:Number;
		public var midPointNorm:Number;
		public var fadePowerAfterMid:Number = 1;
		
		protected var _lifeAtMidPoint:Number;
		
		 /**
		  * 
		  * @param	startAdd add value at start
		  * @param	midAdd add value at mid
		  * @param	startMul mul value at start
		  * @param	midMul mul value at mid
		  * @param	midPointNorm 0-1 point at which mod reaches midpoint and starts going from midMult to 0 and destroy
		  */
		public function TimedModInOut(startAdd:Number, midAdd:Number, startMul:Number, midMul:Number, duration:Number = 60, midPointNorm:Number = 0.5, tickSignal:Signal=null) 
		{
			this.startAdd = startAdd;
			this.midAdd = midAdd;
			this.startMul = startMul;
			this.midMul = midMul;
			
			super(startAdd, startMul, duration, tickSignal);
			
			_lifeAtMidPoint = duration * (1 - midPointNorm);
		}
		
		override public function tick(delta:Number = 1):void {
			life -= delta;
			
			if (life > 0) {
				updateTimedMod();
			}else {
				destroy();
				return;
			}
			
			//trace("TimedMod life:", life, "add:", add, "mul:", mul);
		}
		
		override protected function updateTimedMod():void {
			if (life >= _lifeAtMidPoint) {
				_add = NumberUtils.interpolate2(startAdd, midAdd, maxLife, _lifeAtMidPoint, life, fadePower);
				_mul = NumberUtils.interpolate2(startMul, midMul, maxLife, _lifeAtMidPoint, life, fadePower);
			}else {
				_add =  NumberUtils.interpolate2(midAdd, 0, _lifeAtMidPoint, 0, life, fadePowerAfterMid);
				_mul = NumberUtils.interpolate2(midMul, 1, _lifeAtMidPoint, 0, life, fadePowerAfterMid);
			}
			_updateSignal.dispatch();
		}
	}

}