package src.effects {
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import src.system.ProfileState;
	
	/**
	 * First, create a new LineTrail by calling the static function
	 * add the visual to the display list
	 * addSegment() every frame you wish for a new segment to be made
	 * fadeLine() every frame if you wish the line to decay from time
	 * update() every frame to refresh the visual
	 * @author 
	 */
	public class LineTrail extends Object 
	{
		public var maxSegments:uint = 100;
		/** What the minimum alpha is on the fade-in, default 0 */
		public var fadeInMinAlpha:Number = 0;
		
		/** How many segments are fading-in at the start of the line, 0 for disabled */
		public var fadeInLength:Number = 0;
		
		/** Easing power on the fade-in effect */
		public var fadeInPower:Number = 1;
		
		/** From which segment until the end line starts fading */
		public var fadeFromLength:Number = 15;
		
		/** Minimum distance to trigger a new segment, default 0 */
		public var minDistance:Number = 0;
		
		/** In pixels, default 1 */
		public var lineWidth:Number = 1;
		public var color:uint = 0xFF0000;
		
		/** Alpha of segments outside of fade in/out */
		public var baseAlpha:Number = 1;
		
		
		
		protected var _segments:Vector.<Segment> = new Vector.<Segment>();
		protected var _visual:Sprite = new Sprite();
		
		protected var _previousPos:Point;
		protected var _previousL2:Point;
		protected var _previousR2:Point;
		
		public function LineTrail(useStaticFunctionInstead:Number) 
		{
			//blendMode = BlendMode.LAYER;
		}
		
		/** Returns a new LineTrail, used to return Null trails when game options disable them */
		public static function newLineTrail(bypassGameOptions:Boolean = false):LineTrail {
			if (bypassGameOptions || ProfileState.instance.optionSmoke == "On") {
				return new LineTrail(0);
			}else {
				return new LineTrailNull();
			}
		}
		
		public function addSegment(x:Number, y:Number):Boolean 
		{
			if(_previousPos){
				if (x == _previousPos.x && y == _previousPos.y) {
					//trace("LineTrail coordinates are the same, no movement");
					return false;
				}
				if(minDistance > 0){
					var dis:Number = Point.distance(_previousPos, new Point(x, y));
					//if (Math.abs(_previousPos.x - x) <= minDistance && Math.abs(_previousPos.y - y) <= minDistance) {
					if (dis <= minDistance) {
						return false;
					}
				}
			}else {
				//First segment
				_previousPos = new Point(x, y);
			}
			
			if (_segments.length <= 0) {
				addSegment2(new Segment(_previousPos.x, _previousPos.y, x, y, lineWidth, baseAlpha, null));
			}else {
				addSegment2(new Segment(_previousPos.x, _previousPos.y, x, y, lineWidth, baseAlpha, _segments[0]));
			}
			
			_previousPos.x = x;
			_previousPos.y = y;
			
			return true;
		}
		
		protected function addSegment2(node:Segment):void {
			_segments.unshift(node);
			
			while (_segments.length > maxSegments) {
				removeSegment();
			}
			
			if (fadeFromLength > 0) {
				for ( var i:int = fadeFromLength; i < _segments.length; i++) {
					_segments[i].alpha = Math.min(_segments[i].alpha, NumberUtils.interpolate2(baseAlpha, 0, fadeFromLength, maxSegments, i));
				}
			}
		}
		
		protected function removeSegment():void {
			_segments.pop();
		}
		
		/** Reduces the alpha of every segment */
		public function fadeLine(amount:Number = 0.02):void {
			for each (var s:Segment in _segments) {
				s.alpha -= amount;
			}
		}
		
		protected function clearFinishedSegments():void {
			for each(var s:Segment in _segments) {
				if (s.alpha <= 0) {
					removeSegment();
				}
			}
		}
		
		/** Redraws the trail unto the visual */
		public function update():void {
			_visual.graphics.clear();
			_visual.graphics.lineStyle(0, 0, 0);
			
			var s:Segment;
			
			for (var i:int = 0; i < _segments.length; i++) {
				s = _segments[i];
				
				var segmentAlpha:Number = s.alpha;
				
				if (i < fadeInLength) {
					segmentAlpha = Math.min(segmentAlpha, NumberUtils.interpolate2(fadeInMinAlpha, 1, 0, fadeInLength, i, fadeInPower));
				}
				
				if (segmentAlpha > 0) {
					_visual.graphics.beginFill(color, segmentAlpha);
					_visual.graphics.moveTo(s.endLeft.x, s.endLeft.y);
					_visual.graphics.lineTo(s.startLeft.x, s.startLeft.y);
					_visual.graphics.lineTo(s.startRight.x, s.startRight.y);
					_visual.graphics.lineTo(s.endRight.x, s.endRight.y);
					_visual.graphics.lineTo(s.endLeft.x, s.endLeft.y);
					_visual.graphics.endFill();
				}
			}
		}
		
		public function get visual():Sprite 
		{
			return _visual;
		}
		
		
		public function destroy():void {
			if (_segments) {
				for each(var s:Segment in _segments) {
					s.destroy();
				}
			}
			_segments = null;
			if (_visual) {
				if (_visual.stage) {
					_visual.parent.removeChild(_visual);
				}
			}
			
			_visual = null;
			
			_previousPos = null;
			_previousL2 = null;
			_previousR2 = null;
		}
		
	}
}


