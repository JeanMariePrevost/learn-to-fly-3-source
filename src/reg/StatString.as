package src.reg 
{
	/**
	 * ...
	 * @author 
	 */
	public class StatString 
	{
		protected var _levels:Vector.<StatStringLevel>;
		
		public function StatString() 
		{
			_levels = new Vector.<StatStringLevel>();
		}
		
		public function addLevel(level:uint, stringAtLevel:String):void {
			var newLevel:StatStringLevel = new StatStringLevel(level, stringAtLevel);
			_levels.push(newLevel);
		}
		
		public function valueAt(level:Number = 0):String {
			if (_levels.length <= 0 || _levels == null) {
				throw new Error("Requesting a stat from empty stat object");
				return null;
			}
			
			if (level < _levels[0].level) {
				throw new Error("Level below list limit");
				return _levels[0].stat;
			}
			
			if (level > _levels[_levels.length - 1].level) {
				//throw new Error("Level above list limit");
				return _levels[_levels.length - 1].stat;
			}
			
			
			
			var levelBefore:StatStringLevel;
			
			for (var i:int = 0; i < _levels.length; i++) {
				if (_levels[i].level == level) {
					//Perfect match, use directly
					return _levels[i].stat;
				}
				
				if (i == _levels.length) {
					//Final level reached
					levelBefore = _levels[i - 1];
					break;
				}else if ((_levels[i].level <= level) && (_levels[i + 1].level > level)) {
					//Found bounds
					levelBefore = _levels[i];
					break;
				}
			}
			
			if (levelBefore == null) {
				throw new Error("Requested stat not within range");
				return _levels[0].stat;
			}
			
			return levelBefore.stat;
			
		}
		
		public function get isEmpty():Boolean {
			return _levels.length <= 0;
		}
	}

}