package lbg.components.decorators {
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import lbg.debug.Log;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	import src.gui.GuiSettings;
	/**
	 * ...
	 * @author 
	 */
	public class TweenPos
	{
		public static const EASE_IN:Function = Easing.easeInQuad;
		public static const EASE_OUT:Function = Easing.easeOutQuad;
		public static const EASE_IN_OUT:Function = Easing.easeBothInOutQuad;
		public static const EASE_IN_CUBIC:Function = Easing.easeInCubic;
		public static const EASE_IN_QUINT:Function = Easing.easeInQuint;
		public static const EASE_OUT_CUBIC:Function = Easing.easeOutCubic;
		public static const EASE_OUT_QUINT:Function = Easing.easeOutQuint;
		public static const EASE_IN_OUT_CUBIC:Function = Easing.easeBothInOutCubic;
		public static const EASE_BOUNCE:Function = Easing.easeOutBounce;
		public static const EASE_BACK:Function = Easing.easeOutBack;
		public static const EASE_ELASTIC:Function = Easing.easeOutElastic;
		
		public var duration:Number;
		public var time:Number;
		public var startPoint:Point;
		public var modPoint:Point;
		
		protected var _target:DisplayObject;
		protected var _easingFunction:Function;
		
		protected var _isFinished:Boolean = false;
		protected var _finishedSignal:Signal = new Signal();
		
		
		public function TweenPos(obj:DisplayObject, startPoint:Point = null, displacement:Point = null, duration:Number = 10, delay:Number = 0, easeFunction:Function = null) 
		{
			_target = obj;
			if (startPoint == null) {
				startPoint = new Point(obj.x, obj.y);
			}
			
			if (displacement == null) {
				displacement = new Point();
			}
			
			this.startPoint = startPoint;
			modPoint = displacement;
			this.duration = duration;
			time = -delay;
			
			if (easeFunction == null) {
				_easingFunction = EASE_IN_OUT;
			}else {
				_easingFunction = easeFunction;
			}
			
			tick(0);
			
			GuiSettings.guiTickSignal.add(tick);
		}
		
		public static function tweenToCurrentPosition(obj:DisplayObject, startOffset:Point, duration:Number = 10, delay:Number = 0, easeFunction:Function = null):TweenPos {
			var startPoint:Point = new Point(obj.x + startOffset.x, obj.y + startOffset.y);
			var displacement:Point =  new Point(-startOffset.x, -startOffset.y);
			return new TweenPos(obj, startPoint, displacement, duration, delay, easeFunction);
		}
		
		/** Tween by set displacement from current position */
		public static function tweenFromCurrentPosition(obj:DisplayObject, displacement:Point, duration:Number = 10, delay:Number = 0, easeFunction:Function = null):TweenPos {
			return new TweenPos(obj, null, displacement, duration, delay, easeFunction);
		}
		
		/** Tween to set desitnation from current position */
		public static function tweenFromCurrentPosition2(obj:DisplayObject, destination:Point, duration:Number = 10, delay:Number = 0, easeFunction:Function = null):TweenPos {
			var displacement:Point = new Point();
			displacement.x = destination.x - obj.x;
			displacement.y = destination.y - obj.y;
			
			//Log.log("obj:", obj);
			//Log.log("destination:", destination);
			//Log.log("displacement:", displacement);
			//Log.log("duration:", duration);
			//Log.log("delay:", delay);
			//Log.log("easeFunction:", easeFunction);
			
			return new TweenPos(obj, null, displacement, duration, delay, easeFunction);
		}
		
		protected function tick(delta:Number):void 
		{
			time += delta;
			
			tween();
			
			if (time >= duration) {
				_isFinished = true;
				_finishedSignal.dispatch();
				destroy();
			}
		}
		
		protected function tween():void {
			if (_target) {
				var easeTime:Number = NumberUtils.constrain(time, 0, duration);
				_target.x = _easingFunction(easeTime, startPoint.x, modPoint.x, duration);
				_target.y = _easingFunction(easeTime, startPoint.y, modPoint.y, duration);
			}
		}
		
		public function destroy():void 
		{
			_finishedSignal.removeAll();
			startPoint = null;
			modPoint = null;
			_target = null
			//GuiSettings.guiTickSignal.remove(tick);
			//trace("Destroyed", this);
		}
		
		public function get isFinished():Boolean 
		{
			return _isFinished;
		}
		
		public function get finishedSignal():Signal 
		{
			return _finishedSignal;
		}
		
	}

}