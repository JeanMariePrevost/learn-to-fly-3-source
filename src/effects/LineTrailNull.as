package src.effects 
{
	/**
	 * ...
	 * @author ...
	 */
	public class LineTrailNull extends LineTrail 
	{
		
		public function LineTrailNull() 
		{
			super(0);
			
		}
		
		override public function addSegment(x:Number, y:Number):Boolean 
		{
			return false;
		}
		
		override public function fadeLine(amount:Number = 0.02):void {
		}
		
		override public function update():void {
		}
		
		
	}

}