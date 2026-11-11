package src.game.gameobjects.AnchorPoints 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class AnchorPoint 
	{
		protected var _object:DisplayObjectContainer;
		
		public function AnchorPoint(object:DisplayObjectContainer) 
		{
			_object = object;
		}
		
		public function get localX():Number {
			return _object.x;
		}
		
		public function get localY():Number {
			return _object.y;
		}
		
		public function get globalCoordinates():Point {
			var p:Point = new Point(_object.x, _object.y);
			p = _object.localToGlobal(p);
			return p;
		}

	}

}