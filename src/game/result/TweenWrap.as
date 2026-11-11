package src.game.result 
{
	import flash.display.DisplayObjectContainer;
	import lbg.utils.Easing;
	import src.Main;
	/**
	 * ...
	 * @author 
	 */
	public class TweenWrap 
	{
		protected var _obj:DisplayObjectContainer;
		
		public var time:int;
		public var duration:int;
		public var startX:Number;
		public var startY:Number;
		public var modX:Number;
		public var modY:Number;
		
		public function TweenWrap(object:DisplayObjectContainer, modX:Number = 0, modY:Number = 0, duration:int = 60) 
		{
			_obj = object;
			
			startX = obj.x;
			startY = obj.y;
			this.modX = modX;
			this.modY = modY;
			this.time = 0;
			this.duration = duration;
			
			Main.unsafeTickSignal.add(tick);
		}
		
		private function tick(delta:Number):void 
		{
			_obj.x = Easing.easeOutQuad(time, startX, modX, duration);
			_obj.y = Easing.easeOutQuad(time, startY, modY, duration);
			
			if (time >= duration) {
				destroy();
			}
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			_obj = null;
		}
		
	}

}