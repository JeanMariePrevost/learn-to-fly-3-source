package src.game.gameobjects 
{
	import flash.geom.Point;
	import lbg.utils.NumberUtils;
	import nape.phys.Body;
	/**
	 * ...
	 * @author 
	 */
	public class GameObjectBounds 
	{
		protected var _gameObject:IGameObject;
		protected var _body:Body;
		
		public function GameObjectBounds(object:IGameObject) 
		{
			_gameObject = object;
			_body = object.getBody();
		}
		
		public function get centerX():Number {
			return _body.position.x;
		}
		
		public function get centerY():Number {
			return _body.position.y;
		}
		
		public function get top():Number {
			return _body.bounds.y;
		}
		
		public function get bottom():Number {
			return _body.bounds.y + _body.bounds.height;
		}
		
		public function get left():Number {
			return _body.bounds.x;
		}
		
		public function get right():Number {
			return _body.bounds.x + _body.bounds.width;
		}
		
		/**
		 * Move move object custom registration point (e.g. move "bottom" of object to (X,Y))
		 */
		public function setPositionFromAnchor(X:Number, Y:Number, leftToRightPosition:Number, topToBottomPosition:Number):void {
			var offsetX:Number = centerX - NumberUtils.interpolate(left,right,leftToRightPosition);
			var offsetY:Number = centerY - NumberUtils.interpolate(top, bottom, topToBottomPosition);
			_gameObject.setPosition(X + offsetX, Y + offsetY);
		}
		
		public function destroy():void {
			_gameObject = null;
			_body = null;
		}
	}

}