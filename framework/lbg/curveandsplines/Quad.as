package lbg.curveandsplines 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class Quad 
	{
		
		/**
		 * Returns a point of time t on quad curve
		 * @param	t
		 * @param	p p0-p2 are the anchors, p1 is the handle
		 * @return
		 */
		public static function quadCurve(t:Number,p:Array):Point{
            var result:Point = new Point();
            var oneMinusTSq:Number = (1-t) * (1-t);
            var TSq:Number = t*t;
            result.x = oneMinusTSq*p[0].x+2*(1-t)*t*p[1].x+TSq*p[2].x;
            result.y = oneMinusTSq*p[0].y+2*(1-t)*t*p[1].y+TSq*p[2].y;
            return result;
        }	
		
		/**
		 * Returns the Y value for a given x on in a series of linked quad curves
		 * @return
		 */
		public static function yForXMultiQuads(X:Number, anchors:Vector.<QuadAnchor>):Number {
			var p1:QuadAnchor;
			var p2:QuadAnchor;
			
			//Select anchors
			if (X < anchors[0].x) {
				//below minimum, use lowest anchors
				p1 = anchors[0];
				p2 = anchors[1];
			}else if (X > anchors[anchors.length - 1].x) {
				//beyond maximum, use highest anchors
				p1 = anchors[anchors.length - 2];
				p2 = anchors[anchors.length - 1];
			}else {
				for (var j:int = 0; j < anchors.length - 1; j++) {
					if (anchors[j].x <= X && anchors[j + 1].x >= X) {
						p1 = anchors[j];
						p2 = anchors[j + 1];
						break;
					}
				}
				if (p1 == null || p2 == null) {
					throw new Error("Something went wrong...");
				}
			}
			
			var pt:Array = new Array();
			pt.push(p1.getAnchorPoint());
			pt.push(p1.calculateHandlePoint(p2.getAnchorPoint()));
			pt.push(p2.getAnchorPoint());
			
			var t:Number = (X - p1.x) / (p2.x - p1.x);
			var p:Point = quadCurve(t, pt);
			
			return p.y;
		}
		
		
		
	}

}