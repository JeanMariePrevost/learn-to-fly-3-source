/*
 * CollisionObject are returned by collision checks in order to get more detailled
 * information about the 2 objects colliding and the cillision itself
 */

package lbg.collisiondetection {
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;


	public class CollisionObject {
		protected var _overlap:Number;//How far into each other objects are
		protected var _direction:Number;//Angle from 1st to 2nd object
		protected var _object1:DisplayObjectContainer;//First object checked for collision
		protected var _object2:DisplayObjectContainer;//Second object checked for collision
		
		public function CollisionObject() {
			
		}
		
		protected function lineThroughRectangle(angle:Number, rect:Rectangle):Number {
			
		}
	}
}