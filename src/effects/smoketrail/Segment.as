package src.effects.smoketrail 
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	/**
	 * ...
	 * @author light_bringer777
	 */
	public class Segment  
	{
		public var left:Point = new Point();
		public var right:Point = new Point();
		public var angle:Number = 0;
		
		public var baseAlpha:Number = 1;
		public var width:Number = 1;
		public var color:uint = 0xFF0000;
		
		protected var _previousNode:Segment;
		
		protected var _fadeAmount:Number = 0;//Cumulative alpha fade from ticks, adde on top of baseAlpha
		
		protected var _x:Number;
		protected var _y:Number;
		
		protected var _pushVx:Number = 0;
		protected var _pushVy:Number = 0;
		protected var _spreadVx:Number = 0;
		protected var _spreadVy:Number = 0;
		
		protected var _trail:SmokeTrail;
		
		
		public function Segment(X:Number, Y:Number, trail:SmokeTrail, color:uint, previousNode:Segment = null, forcedAngle:Number = NaN) 
		{
			_trail = trail;
			this._previousNode = previousNode;
			
			_x = X;
			_y = Y;
			
			width = trail.lineWidth;
			baseAlpha = trail.alpha;
			
			angle = forcedAngle;
			
			if (previousNode) {
				if(isNaN(angle)) angle = Trig.angleTo(x, y, previousNode.x, previousNode.y);
				left.x = x - Trig.vectorX(width, angle - 90);
				left.y = y - Trig.vectorY(width, angle - 90);
				right.x = x + Trig.vectorX(width, angle - 90);
				right.y = y + Trig.vectorY(width, angle - 90);
				
				_pushVx = Trig.vectorX(trail.pushForce, angle);
				_pushVy = Trig.vectorY(trail.pushForce, angle);
				_spreadVx = Trig.vectorX(trail.spreadForce, angle - 90);
				_spreadVy = Trig.vectorY(trail.spreadForce, angle - 90);
				
			}else {
				if (isNaN(angle)) {
					angle = 0;
					left.x = x;
					left.y = y;
					right.x = x;
					right.y = y;
				}else {
					left.x = x - Trig.vectorX(width, angle - 90);
					left.y = y - Trig.vectorY(width, angle - 90);
					right.x = x + Trig.vectorX(width, angle - 90);
					right.y = y + Trig.vectorY(width, angle - 90);
					
					_pushVx = Trig.vectorX(trail.pushForce, angle);
					_pushVy = Trig.vectorY(trail.pushForce, angle);
					_spreadVx = Trig.vectorX(trail.spreadForce, angle - 90);
					_spreadVy = Trig.vectorY(trail.spreadForce, angle - 90);
				}
			}
		}
		
		public function tick(delta:Number):void {
			_pushVx *= _trail.pushForceDrag;
			_pushVy *= _trail.pushForceDrag;
			_spreadVx *= _trail.spreadForceDrag;
			_spreadVy *= _trail.spreadForceDrag;
			
			_x += _pushVx;
			_y += _pushVy;
			
			left.x += _pushVx;
			left.y += _pushVy;
			right.x += _pushVx;
			right.y += _pushVy;
			
			left.x -= _spreadVx;
			left.y -= _spreadVy;
			right.x += _spreadVx;
			right.y += _spreadVy;
			
			_x += _trail.windX;
			_y += _trail.windY;
			left.x += _trail.windX;
			left.y += _trail.windY;
			right.x += _trail.windX;
			right.y += _trail.windY;
			
			
			_fadeAmount += _trail.fadePerTick;
		}
		
		public function get x():Number 
		{
			return _x;
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function get alpha():Number {
			return baseAlpha - _fadeAmount;
		}
		
		public function get isDead():Boolean {
			return (_fadeAmount > _trail.alpha && alpha <= 0);
		}
		
		
		public function destroy():void {
			left = null;
			right = null;
			_previousNode = null;
			_trail = null;
		}
		
	}

}