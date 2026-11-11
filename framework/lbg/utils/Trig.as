package lbg.utils 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class Trig 
	{
		public static const DEGREES_RADIANS_RATIO:Number = Math.PI / 180;
		public static const RADIANS_DEGREES_RATIO:Number = 180 / Math.PI;
		
		/**
		 * Returns the angle from a x/y displacement
		 * @return (Angle in degrees)
		 */
		public static function angleFromDisplacement(x:Number, y:Number, inDegrees:Boolean = true):Number {
			if (inDegrees) {
				return Math.atan2(y, x) / DEGREES_RADIANS_RATIO;
			}else {
				return Math.atan2(y, x);
			}
		}

		/**
		 * Returns the angle from the 1st x/y to the 2nd  x/y
		 * @return (Angle in degrees)
		 */
		public static function angleTo(x1:Number,y1:Number,x2:Number,y2:Number, inDegrees:Boolean = true):Number {
			if (inDegrees) {
				return Math.atan2(y2 - y1, x2 - x1) / DEGREES_RADIANS_RATIO;
			}else {
				return Math.atan2(y2 - y1, x2-x1);
			}
		}

		/**
		 * Returns the angle from the 1st object to the 2nd using x/y coordinates
		 * @return (Angle in degrees)
		 */
		public static function angleToObject(clip1:DisplayObjectContainer, clip2:DisplayObjectContainer, inDegrees:Boolean = true):Number {
			if (inDegrees) {
				return Math.atan2(clip2.y - clip1.y, clip2.x - clip1.x) / DEGREES_RADIANS_RATIO;
			}else {
				return Math.atan2(clip2.y - clip1.y, clip2.x - clip1.x);
			}
		}
		
		/**
		 * Returns the angle from the 1st point to the 2nd using x/y coordinates
		 * @return (Angle in degrees)
		 */
		public static function angleToPoint(p1:Point, p2:Point, inDegrees:Boolean = true):Number {
			if (inDegrees) {
				return Math.atan2(p2.y - p1.y, p2.x - p1.x) / DEGREES_RADIANS_RATIO;
			}else {
				return Math.atan2(p2.y - p1.y, p2.x - p1.x);
			}
		}
		
		public static function getEllipseRadiusAt(degrees:Number, width:Number, height:Number):Number {
			//var part1:Number = Math.pow(Math.cos(rads), 2) / Math.pow(width, 2);
			//var part2:Number = Math.pow(Math.sin(rads),2) / Math.pow(height,2)
			var rads:Number = Trig.toRadians(degrees);
			var radius:Number = 1 / Math.pow(Math.pow(Math.cos(rads), 2) / Math.pow(width, 2) + Math.pow(Math.sin(rads), 2) / Math.pow(height, 2), 1 / 2);
			if (radius != radius) {
				//radius is NaN
				radius = 0;
			}
			return radius;
		}
		
		public static function toDegrees(angleInRadians:Number):Number {
			return angleInRadians * RADIANS_DEGREES_RATIO;
		}
		
		public static function toRadians(angleInDegrees:Number):Number {
			return angleInDegrees * DEGREES_RADIANS_RATIO;
		}
		
		/**
		 * Returns the x displacement at a certain magnitude/angle
		 */
		public static function vectorX(magnitude:Number, angleInDegree:Number):Number {
			return Math.cos(angleInDegree * DEGREES_RADIANS_RATIO) * magnitude;
		}
		
		/**
		 * Returns the y displacement at a certain magnitude/angle
		 */
		public static function vectorY(magnitude:Number, angleInDegree:Number):Number {
			return Math.sin(angleInDegree * DEGREES_RADIANS_RATIO) * magnitude;
		}
		/**
		 * Returns the x displacement at a certain magnitude/angle
		 */
		public static function vectorXRads(magnitude:Number, angleInRads:Number):Number {
			return Math.cos(angleInRads) * magnitude;
		}
		
		/**
		 * Returns the y displacement at a certain magnitude/angle
		 */
		public static function vectorYRads(magnitude:Number, angleInRads:Number):Number {
			return Math.sin(angleInRads) * magnitude;
		}
	}

}