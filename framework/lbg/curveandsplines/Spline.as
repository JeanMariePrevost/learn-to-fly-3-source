package lbg.curveandsplines 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class Spline 
	{
		
		
		
        /* 
        * Calculates 2D cubic Catmull-Rom spline. Spline is between p1-p2, p0 and p3 are "handles"
        * @see http://www.mvps.org/directx/articles/catmull/ 
        */ 
        public static function catmullRom (p0:Point, p1:Point, p2:Point, p3:Point, t:Number):Point 
        {
            return new Point (
				0.5 * ((          2*p1.x) +
					t * (( -p0.x           +p2.x) +
					t * ((2*p0.x -5*p1.x +4*p2.x -p3.x) +
					t * (  -p0.x +3*p1.x -3*p2.x +p3.x)))),
				0.5 * ((          2*p1.y) +
					t * (( -p0.y           +p2.y) +
					t * ((2*p0.y -5*p1.y +4*p2.y -p3.y) +
					t * (  -p0.y +3*p1.y -3*p2.y +p3.y))))
			);
        }
		
		/**
		 * returns the Y value at a given X on a simple, left to right catmull rom spline
		 * @param	points Any number of anchors points >4
		 * @param	x X on curve, within the range of value in 'points' vector
		 */
		public static function yForXOnCatmullRom(points:Vector.<Point>, x:Number):Number {
			if (points.length < 4) {
				throw new Error("yForXOnComplexCatmullRom - Less than 4 points given");
				return 0;
			}
			
			for (var i:int = 0; i < points.length - 1; i++) {
				if (x >= points[i].x && x <= points[i + 1].x) {
					var p0:Point = (i > 0) ? points[i - 1]:points[0];
					var p1:Point = points[i];
					var p2:Point = points[i + 1];
					//If i+2 exists, use it as handle, otherwise reuse the same point
					var p3:Point = ((i + 2) < points.length) ? points[i + 2]:points[i + 1];
					break;
				}
			}
			
			if (p0 == null || p1 == null || p2 == null || p3 == null) {
				throw new Error("yForXOnComplexCatmullRom - given x outside curve");
				//Interpolate a new linear point?
				//var p1:Point = points[points.length - 2];
				//var p2:Point = points[points.length - 1];
				//var p3:Point = points[points.length - 1];
				return 0;
			}
			
			var t:Number = (x - p1.x) / (p2.x - p1.x);
			//trace(t);
			
			//return catmullRom(p0, p1, p2, p3, t).y;
			return catmullRom2(p0, p1, p2, p3, t).y;
		}
		
		public static function catmullRom2(P0:Object, P1:Object, P2:Object, P3:Object, t:Number):Object{
			var t2 = (t*t), t3 = t*t2;
			return {x: 0.5 *((2 * P1.x) + (-P0.x + P2.x) * t +(2*P0.x - 5*P1.x + 4*P2.x - P3.x) * t2 + (-P0.x + 3*P1.x- 3*P2.x + P3.x) * t3),
					y: 0.5 *((2 * P1.y) + (-P0.y + P2.y) * t +(2*P0.y - 5*P1.y + 4*P2.y - P3.y) * t2 + (-P0.y + 3*P1.y- 3*P2.y + P3.y) * t3)};
		}
		
	}

}