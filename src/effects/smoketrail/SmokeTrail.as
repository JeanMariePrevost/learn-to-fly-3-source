package src.effects.smoketrail {
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import src.effects.smoketrail.Segment;
	import src.Main;
	import src.game.WindEngine;
	import src.system.ProfileState;
	
	/**
	 * To make this work, you add its visual to the display list, add segments and make it tick.
	 * Ticking at last segment and removing it (because alpha<=0) will make the trail destroy itself
	 * @author 
	 */
	public class SmokeTrail   
	{
		public var maxSegments:uint = 100;
		
		/** Number of segments that fade from length from the end of the trail */
		public var fadeOutLegnth:Number = 50;
		/** Alpha value at the end of the fadeOut */
		public var fadeOutAlpha:Number = 0;
		/** Easing of the fadeOut */
		public var fadeOutPower:Number = 1;
		
		/** Number of segments that fade from the start of the trail */
		public var fadeInLength:Number = 15;
		/** Alpha value at the end of the fadeIn */
		public var fadeInAlpha:Number = 0;
		/** Easing of the fadeIn */
		public var fadeInPower:Number = 1;
		
		public var minDistance:Number = 0;//Minimum distance between points to trigger a new segment
		public var lineWidth:Number = 1;
		public var color:uint = 0xFF0000;
		public var alpha:Number = 1;
		public var fadePerTick:Number = 0.01;
		
		//Smoketrail specific
		public var pushForce:Number = 0;//"wind" pushing the trail away from its spawning point
		public var pushForceDrag:Number = 1;
		public var spreadForce:Number = 0;//How the trail spreads out
		public var spreadForceDrag:Number = 1;
		public var windX:Number = 0;//Wind pushing the trail from a global perspective
		public var windY:Number = 0;//Wind pushing the trail from a global perspective
		
		protected var _segments:Vector.<Segment> = new Vector.<Segment>();
		protected var _visual:Sprite = new Sprite();
		
		public function SmokeTrail(useStaticFunctionInstead:Number) 
		{
			//blendMode = BlendMode.LAYER;
			Main.unsafeTickSignal.add(tick);
		}
		
		/** Returns a new SmokeTrail, used to return Null trails when game options disable them */
		public static function newSmokeTrail(bypassGameOptions:Boolean = false):SmokeTrail {
			if (bypassGameOptions || ProfileState.instance.optionSmoke == "On") {
				return new SmokeTrail(0);
			}else {
				return new SmokeTrailNull();
			}
		}
		
		public function addSegment(x:Number, y:Number, forcedAngle:Number = NaN):Boolean 
		{
			if (isNaN(x) || isNaN(y)) {
				Log.log("SmokeTrail.addSegment error -> coordinates are NaN");
				return false;
			}
			
			if (_segments == null) {
				destroy();
				return false;
			}
			
			addSegment2(x, y, forcedAngle);
			
			return true;
		}
		
		private function addSegment2(x:Number, y:Number, forcedAngle:Number = NaN):void 
		{
			var lastSegment:Segment;
			if (_segments.length >= 1) {
				lastSegment = _segments[0];
			}
			
			if (minDistance > 0) {
				if (lastSegment) {
					var lastSegmentPos:Point = new Point(lastSegment.x, lastSegment.y);
					var dis:Number = Point.distance(lastSegmentPos, new Point(x, y));
					if (dis <= minDistance) {
						return;
					}
				}
			}
			
			var s:Segment = getNewSegment(x, y, this, lastSegment, forcedAngle);
			addSegment3(s);
		}
		
		protected function getNewSegment(X:Number, Y:Number, trail:SmokeTrail, previousNode:Segment = null, forcedAngle:Number = NaN):Segment {
			return new Segment(X, Y, trail, color, previousNode, forcedAngle);
		}
		
		protected function addSegment3(node:Segment):void {
			_segments.unshift(node);
			
			while (_segments.length > maxSegments) {
				removeSegment();
			}
			
			for ( var i:int = 0; i < fadeInLength; i++) {
				if (i < _segments.length) {
					_segments[i].baseAlpha = NumberUtils.interpolate2(fadeInAlpha, alpha, 0, fadeInLength, i, fadeInPower);
				}else {
					//End of the trail reached
					break;
				}
			}
			
			//Give full alpha to the segment that just got out of the fade in
			if (_segments.length > fadeInLength) {
				_segments[fadeInLength].baseAlpha = alpha;
			}
			
			for (i = Math.max(0, (maxSegments - fadeOutLegnth)); i < maxSegments; i++) {
				if (i < _segments.length) {
					_segments[i].baseAlpha = NumberUtils.interpolate2(alpha, fadeOutAlpha, (maxSegments - fadeOutLegnth), maxSegments, i, fadeOutPower);
				}else {
					//End of the trail reached
					break;
				}
			}
		}
		
		protected function removeSegment():void {
			var popped:Segment = _segments.pop();
			popped.destroy();
		}
		
		protected function clearFinishedSegments():void {
			var atLastSegment:Boolean = (_segments.length == 1);
			
			for each(var s:Segment in _segments) {
				if (s.isDead) {
					removeSegment();
				}
			}
			
			if (atLastSegment && _segments.length <= 0) {
				destroy();
			}
		}
		
		/** Redraws the trail unto the visual */
		public function tick(delta:Number = 1):void {
			if (_visual == null) {
				Log.log("SmokeTrail Tick() ERROR - Ticking a trail with no visual, probably a destroyed one");
				return;
			}
			
			windX = WindEngine.wind;
			
			_visual.graphics.clear();
			_visual.graphics.lineStyle(0, 0, 0);
			
			var s:Segment;//Current
			var s2:Segment;//Next segment
			
			for each(s in _segments) {
				s.tick(delta);	
			}
			
			for (var i:int = 0; i < _segments.length - 1; i++) {
				s = _segments[i];
				s2 = _segments[i + 1];
				if (s.alpha > 0) {
					_visual.graphics.beginFill(s.color, s.alpha);
					_visual.graphics.moveTo(s.left.x, s.left.y);
					_visual.graphics.lineTo(s2.left.x, s2.left.y);
					_visual.graphics.lineTo(s2.right.x, s2.right.y);
					_visual.graphics.lineTo(s.right.x, s.right.y);
					_visual.graphics.lineTo(s.left.x, s.left.y);
					_visual.graphics.endFill();
				}
			}
			
			clearFinishedSegments();
		}
		
		public function get visual():Sprite 
		{
			return _visual;
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			
			if (_segments) {
				for each(var s:Segment in _segments) {
					s.destroy();
				}
				_segments.length = 0;
			}
			_segments = null;
			
			if (_visual) {
				while(_visual.numChildren >= 1) _visual.removeChildAt(0);
				if (_visual.parent) _visual.parent.removeChild(_visual);
			}
			_visual = null;
		}
		
	}

}