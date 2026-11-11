package src.effects {
	import flash.display.Graphics;
	import flash.geom.Point;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	/**
	 * ...
	 * @author light_bringer777
	 */
	public class Segment extends Object
	{
		public var start:Point = new Point();
		public var end:Point = new Point();
		public var innerAngle:Number = 0;
		public var startAngle:Number = 0;
		public var endAngle:Number = 0;
		public var alpha:Number = 1;
		
		public var width:Number = 1;
		
		public var previousNode:Segment;
		
		public var startLeft:Point = new Point();
		public var startRight:Point = new Point();
		public var endLeft:Point = new Point();
		public var endRight:Point = new Point();
		
		
		
		public function Segment(startX:Number, startY:Number, endX:Number, endY:Number, width:Number = 1, baseAlpha:Number = 1, previousNode:Segment = null) 
		{
			this.previousNode = previousNode;
			
			this.width = width;
			alpha = baseAlpha;
			
			start.x = startX;
			start.y = startY;
			end.x = endX;
			end.y = endY;
			
			innerAngle = Trig.angleTo(start.x, start.y, end.x, end.y);
			endAngle = innerAngle;
			
			if (previousNode == null) {
				startAngle = innerAngle;
				startLeft.x = start.x - Trig.vectorX(width, startAngle - 90);
				startLeft.y = start.y - Trig.vectorY(width, startAngle - 90);
				startRight.x = start.x + Trig.vectorX(width, startAngle - 90);
				startRight.y = start.y + Trig.vectorY(width, startAngle - 90);
			}else {
				startAngle = (previousNode.endAngle + innerAngle) / 2;
				previousNode.updateWithNextNode(this);
				startLeft.x = previousNode.endLeft.x;
				startLeft.y = previousNode.endLeft.y;
				startRight.x = previousNode.endRight.x;
				startRight.y = previousNode.endRight.y;
			}
			
			endLeft.x = end.x - Trig.vectorX(width, endAngle - 90);
			endLeft.y = end.y - Trig.vectorY(width, endAngle - 90);
			endRight.x = end.x + Trig.vectorX(width, endAngle - 90);
			endRight.y = end.y + Trig.vectorY(width, endAngle - 90);
		}
		
		public function drawUnto(graphics:Graphics):void {
			graphics.moveTo(startLeft.x, startLeft.y);
			graphics.lineTo(endLeft.x, endLeft.y);
			graphics.lineTo(endRight.x, endRight.y);
			graphics.lineTo(startRight.x, startRight.y);
			graphics.lineTo(startLeft.x, startLeft.y);
			
			graphics.drawCircle(start.x, start.y, 5);
			graphics.drawCircle(end.x, end.y, 5);
		}
		
		public function updateWithNextNode(node:Segment):void {
			return;
			var diff:Number = endAngle - node.startAngle;
			endAngle = node.startAngle;
			
			var wRight:Number;
			var wLeft:Number;
			
			if (diff > 0) {
				wRight = width * (1 + (diff / 45));
				wLeft = width * (1 - (diff / 60));
			}else {
				wRight = width * (1 + (diff / 60));
				wLeft = width * (1 - (diff / 45));
			}
			
			endLeft.x = end.x - Trig.vectorX(wLeft, endAngle - 90);
			endLeft.y = end.y - Trig.vectorY(wLeft, endAngle - 90);
			endRight.x = end.x + Trig.vectorX(wRight, endAngle - 90);
			endRight.y = end.y + Trig.vectorY(wRight, endAngle - 90);
		}
		
		public function destroy():void {
			start = null;
			end = null;
			previousNode = null;
			
			startLeft = null;
			startRight = null
			endLeft = null
			endRight = null
		}
		
	}

}