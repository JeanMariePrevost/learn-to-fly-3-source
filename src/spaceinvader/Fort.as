package src.spaceinvader 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import lbg.collisiondetection.CollisionDetection;
	import lbg.utils.DisplayObjectUtil;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class Fort extends MovieClip 
	{
		public var leftTop:MovieClip;
		public var leftBot:MovieClip;
		public var center:MovieClip;
		public var rightTop:MovieClip;
		public var rightBot:MovieClip;
		
		protected var _hitTestP:Point = new Point();
		
		public function Fort() 
		{
			super();
			
			scaleX = scaleY = 0.9;
			
			leftBot.gotoAndStop(1);
			leftTop.gotoAndStop(1);
			center.gotoAndStop(1);
			rightTop.gotoAndStop(1);
			rightBot.gotoAndStop(1);
		}
		
		public function checkCollision(bullet:Bullet):Boolean {
			if (bullet.vy >= 0) {
				//Ennemy bullet, start from the top
				if (checkCollision2(bullet, leftTop)) return true;
				if (checkCollision2(bullet, center)) return true;
				if (checkCollision2(bullet, rightTop)) return true;
				if (checkCollision2(bullet, leftBot)) return true;
				if (checkCollision2(bullet, rightBot)) return true;
			}else {
				//Player bullet, start from the bottom
				if (checkCollision2(bullet, leftBot)) return true;
				if (checkCollision2(bullet, center)) return true;
				if (checkCollision2(bullet, rightBot)) return true;
				if (checkCollision2(bullet, leftTop)) return true;
				if (checkCollision2(bullet, rightTop)) return true;
			}
			
			return false;
		}
		
		protected function checkCollision2(bullet:Bullet, fortPart:MovieClip):Boolean {
			if (fortPart.currentFrame >= fortPart.totalFrames || !bullet.isActive) {
				return false;
			}else {
				var hit:Boolean = CollisionDetection.checkForCollision(bullet, fortPart, false, 255, Main.instance.transform.concatenatedMatrix);
				//_hitTestP.x = bullet.x;
				//_hitTestP.y = bullet.y;
				//_hitTestP = DisplayObjectUtil.localToLocal(_hitTestP, GameScreen.instance, fortPart);
				//var hit:Boolean = fortPart.hitTestPoint(_hitTestP.x, _hitTestP.y, true);
				if (hit) {
					fortPart.nextFrame();
					bullet.destroy();
				}
				return hit;
			}
		}
		
		public function destroy():void {
			leftTop = null;
			leftBot = null;
			center = null;
			rightTop = null;
			rightBot = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}