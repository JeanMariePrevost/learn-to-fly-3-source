package  lbg.curveandsplines 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class QuadAnchor 
	{
		public var x:Number;
		public var y:Number;
		public var handleTX:Number;
		public var handleTY:Number;
		
		
		public function QuadAnchor(x:Number,y:Number,handleTX:Number = 0.5,handleTY:Number = 0.5) 
		{
			this.x = x;
			this.y = y;
			this.handleTX = handleTX;
			this.handleTY = handleTY;
		}
		
		public function getAnchorPoint():Point {
			return new Point(x, y);
		}
		
		public function calculateHandlePoint(toPoint:Point):Point {
			var p:Point = new Point();
			p.x = x + ((toPoint.x - x) * handleTX);
			p.y = y + ((toPoint.y - y) * handleTY);
			return p;
		}
		
	}

}