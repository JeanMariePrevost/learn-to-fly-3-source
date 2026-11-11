package lbg.compositetick 
{
	import flash.utils.getTimer;
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	/**
	 * ...
	 * @author 
	 */
	public class DeltaTimer 
	{
		public static var DELTA_MAX:Number = 7;//2.5;
		public static var DELTA_MIN:Number = 0.3;//0.5;
		
		protected var _frameRate:Number;
		protected var _buffer:Number;
		protected var _deltaTimes:Array = new Array();
		protected var _oldTimer:Number = 0;
		protected var _targetDeltaTime:Number//Typically 1000 / framerate
		protected var _minDeltaTime:Number;
		protected var _maxDeltaTime:Number;
		
		public function DeltaTimer(frameRate:Number = 60, buffer:uint = 60) 
		{
			_frameRate = frameRate;
			_buffer = buffer;
			_oldTimer = 0;
			_targetDeltaTime = 1000 / frameRate;
			
			_minDeltaTime = _targetDeltaTime * DELTA_MIN;
			_maxDeltaTime = _targetDeltaTime * DELTA_MAX;
		}
		
		
		public function tickTimer():Number {
			if (_oldTimer == 0) {
				//No times added yet (first frame ever?), return default value for now
				_oldTimer = getTimer();
				return 1;
			}
			var deltaTime:Number = getTimer() - _oldTimer;
			_oldTimer = getTimer();
			addDeltaTime(deltaTime);
			return getDelta();
		}
		
		/** Empties and refills the buffer with perfect values, useful when coming back from a pause */
		public function clearBuffer():void {
			trace("DeltaTimer - clearBuffer()");
			_deltaTimes.length = 0;
			_oldTimer = getTimer();
			
			for (var i:int = 0; i < _buffer; i++) {
				_deltaTimes.push(_targetDeltaTime);
			}
		}
		
		protected function addDeltaTime(deltaTime:Number):void {
			deltaTime = Math.min(_maxDeltaTime, Math.max(_minDeltaTime, deltaTime));
			_deltaTimes.unshift(deltaTime);
			
			for (var i:int = 0; i <= 20; i++ ) { 
				if (i >= 2) {
					//Log.log("addDeltaTime for loop now at... " + i);
				}
				if (_deltaTimes.length > _buffer) {
					_deltaTimes.pop();
				}else {
					break;
				}
			}
		}
		
		protected function getDelta():Number {
			var totalDeltaTime:Number = 0;
			for each(var i:Number in _deltaTimes) {
				totalDeltaTime += i;
			}
			var averageDeltaTime:Number = totalDeltaTime / _deltaTimes.length;
			var delta:Number = averageDeltaTime / _targetDeltaTime;
			delta = NumberUtils.constrain(delta, DELTA_MIN, DELTA_MAX);
			return delta;
		}
		
	}

}