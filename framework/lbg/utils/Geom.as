package  
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class Geom 
	{
		
		public function lineIntersects(line1A:Point, line1B:Point, line2A:Point, line2B:Point):Boolean {
			var point:Point = getIntersection(line1A, line1B, line2A, line2B);
			if (point == null) return false;//Lines are parallel
			
			var leftX1:Number = Math.min(line1A.x, line1B.x);
			var rightX1:Number = Math.max(line1A.x, line1B.x);
			var topY1:Number = Math.min(line1A.y, line1B.y);
			var bottomY1:Number = Math.max(line1A.y, line1B.y);
			
			var leftX2:Number = Math.min(line2A.x, line2B.x);
			var rightX2:Number = Math.max(line2A.x, line2B.x);
			var topY2:Number = Math.min(line2A.y, line2B.y);
			var bottomY2:Number = Math.max(line2A.y, line2B.y);
			
			if (leftX1 <= point.x && point.x <= rightX1) {
				if (topY1 <= point.y && point.y <= bottomY1) {
					if (leftX2 <= point.x && point.x <= rightX2) {
						if (topY2 <= point.y && point.y <= bottomY2) {
							//Lines intersect within length of lineA and lineB
							return true;
						}
					}
				}
			}
			return false;
		}
		
		public function lineIntersection(line1A:Point, line1B:Point, line2A:Point, line2B:Point):Point {
			//A = y2-y1
			//B = x1-x2
			//C = A * x1 + B * y1
			
			var a1:Number = line1B.y - line1A.y;
			var b1:Number = line1A.x - line1B.x;
			var c1:Number = (a1 * line1A.x) + (b1 * line1A.y);
			var a2:Number = line2B.y - line2A.y;
			var b2:Number = line2A.x - line2B.x;
			var c2:Number = (a2 * line2A.x) + (b2 * line2A.y);
			
			var det:Number = (a1 * b2) - (a2 * b1);
			if(det == 0){
				//Lines are parallel
				return null;
			}else{
				var pointX:Number = (b2 * c1 - b1 * c2) / det;
				var pointY:Number = (a1 * c2 - a2 * c1) / det;
				return new Point(pointX, pointY);
			}
		}
	}

}