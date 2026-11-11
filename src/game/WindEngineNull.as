package src.game 
{
	/**
	 * ...
	 * @author 
	 */
	public class WindEngineNull extends WindEngine 
	{
		
		public function WindEngineNull() 
		{
			super();
			
		}
		
		override public function tick(delta:Number):void 
		{
			_wind = 0;
		}
		
	}

}