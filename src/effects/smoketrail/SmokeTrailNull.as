package src.effects.smoketrail 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class SmokeTrailNull extends SmokeTrail 
	{
		
		public function SmokeTrailNull() 
		{
			super(0);
			
			destroy();
			
			_visual = new Sprite;
		}
		
		override public function addSegment(x:Number, y:Number, forcedAngle:Number = NaN):Boolean 
		{
			return false;
			//return super.addSegment(x, y, forcedAngle);
		}
		
		override public function tick(delta:Number = 1):void 
		{
			//super.tick(delta);
		}
		
	}

}