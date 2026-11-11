package src.reg 
{
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	/**
	 * ...
	 * @author 
	 */
	public class Stat extends Object implements IStat
	{
		protected var _levels:Vector.<StatLevel>;
		protected var _defaultValue:Number;
		
		
		public function Stat(defaultValue:Number = NaN) 
		{
			_defaultValue = defaultValue;
			_levels = new Vector.<StatLevel>();
		}
		
		public function addLevel(level:Number, statAtLevel:Number, powerUntilNextPoint:Number = 1):void {
			var newLevel:StatLevel = new StatLevel(level, statAtLevel, powerUntilNextPoint);
			_levels.push(newLevel);
		}
		
		
		public function valueAt(level:Number = 0):Number {
			if (_levels.length <= 0 || _levels == null) {
				if (!isNaN(_defaultValue)) {
					return _defaultValue;
				}else {
					Log.log("Stat Error - Requesting a stat from empty stat object with no default value");
					throw new Error("Requesting a stat from empty stat object with no default value");
					return 0;
				}
			}
			
			if (level < _levels[0].level) {
				throw new Error("Level below list limit, probably no level 0 stat in registry. " + this);
				return _levels[0].stat;
			}
			
			if (level > _levels[_levels.length - 1].level) {
				//throw new Error("Level above list limit");
				//Log.log("Requesting stat above list limit", this);
				//When beyond listed stats, just used highest value
				return _levels[_levels.length - 1].stat;
			}
			
			
			
			var levelBefore:StatLevel;
			var levelAfter:StatLevel;
			
			for (var i:int = 0; i < _levels.length; i++) {
				if (_levels[i].level == level) {
					//Perfect match, use directly
					return _levels[i].stat;
				}
				
				if (i == _levels.length) {
					//Final level reached
					levelBefore = _levels[i - 1];
					levelAfter = _levels[i];
					break;
				}else if ((_levels[i].level <= level) && (_levels[i + 1].level > level)) {
					//Found bounds
					levelBefore = _levels[i];
					levelAfter = _levels[i + 1];
					break;
				}
			}
			
			if (levelBefore == null || levelAfter == null) {
				//throw new Error("Requested stat not within range");
				return 0;
			}
			
			var interpolatedStat:Number = NumberUtils.interpolate2(levelBefore.stat, levelAfter.stat, levelBefore.level, levelAfter.level, level, levelBefore.power);
			
			return interpolatedStat;
			
		}
	}

}