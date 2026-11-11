package src.game.gameobjects.AnchorPoints 
{
	import GameObjects.Player.Body.IAnchoredBody;
	/**
	 * Anchors are the "invisible targets" that can be placed inside a movieclip to reference a coordinate
	 * @author 
	 */
	public class BodyAnchors
	{
		//public const TOP:String = "tTop";
		//public const CENTER:String = "tCenter";
		//public const BOTTOM:String = "tBottom";
		//public const LEFT:String = "tLeft";
		//public const RIGHT:String = "tRight";
		
		protected var _top:AnchorPoint;
		protected var _center:AnchorPoint;
		protected var _bottom:AnchorPoint;
		protected var _left:AnchorPoint;
		protected var _right:AnchorPoint;

		
		public function BodyAnchors(movieClip:IAnchoredBody) 
		{
			_top = new AnchorPoint(movieClip.tTop);
			_center = new AnchorPoint(movieClip.tCenter);
			_bottom = new AnchorPoint(movieClip.tBottom);
			_left = new AnchorPoint(movieClip.tLeft);
			_right = new AnchorPoint(movieClip.tRight);
		}
		
		public function get top():AnchorPoint 
		{
			return _top;
		}
		
		public function get center():AnchorPoint 
		{
			return _center;
		}
		
		public function get bottom():AnchorPoint 
		{
			return _bottom;
		}
		
		public function get left():AnchorPoint 
		{
			return _left;
		}
		
		public function get right():AnchorPoint 
		{
			return _right;
		}
		
	}

}