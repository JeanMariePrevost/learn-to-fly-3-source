package src.reg 
{
	/**
	 * ...
	 * @author 
	 */
	public class StatLevel extends Object 
	{
		public var level:Number;
		public var stat:Number;
		public var power:Number;
		
		
		public function StatLevel(level:Number, statAtLevel:Number, powerUntilNextPoint:Number) 
		{
			this.level = level;
			this.stat = statAtLevel;
			this.power = powerUntilNextPoint;
		}
		
	}

}