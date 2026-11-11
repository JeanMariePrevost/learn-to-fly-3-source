package src.reg 
{
	/**
	 * ...
	 * @author 
	 */
	public class StatClassLevel 
	{
		public var level:Number;
		public var stat:Class;
		
		
		public function StatClassLevel(level:uint, classAtLevel:Class) 
		{
			this.level = level;
			this.stat = classAtLevel;
		}
		
	}

}