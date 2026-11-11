package src.game.gameobjects.obstacles 
{
	import src.reg.Stat;
	/**
	 * ...
	 * @author 
	 */
	public class ObstacleDataEntry extends Object 
	{
		public var obstacleClass:Class;
		public var spawnRates:Stat = new Stat(0);
		
		
		public function ObstacleDataEntry() 
		{
			super();
			
		}
		
		
		
	}

}