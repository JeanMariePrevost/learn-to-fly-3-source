package src.reg 
{
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	/**
	 * Flat stats do not interpolate values between levels.
	 * Any value is kept the same until a new point is reached (e.g. 1-1-1-1-4-4-4-8-8-8)
	 * @author 
	 */
	public class StatFlat extends Stat 
	{
		
		public function StatFlat(defaultValue:Number = NaN) 
		{
			super(defaultValue);
		}
		
		override public function valueAt(level:Number = 0):Number {
			if (_levels.length <= 0 || _levels == null) {
				if (!isNaN(_defaultValue)) {
					return _defaultValue;
				}else {
					Log.log("StatFlat Error - Requesting a stat from empty stat object with no default value");
					throw new Error("Requesting a stat from empty stat object with no default value");
					return 0;
				}
			}
			
			if (level < _levels[0].level) {
				//throw new Error("Level below list limit");
				return _levels[0].stat;
			}
			
			if (level > _levels[_levels.length - 1].level) {
				//throw new Error("Level above list limit");
				return _levels[_levels.length - 1].stat;
			}
			
			
			
			var levelBefore:StatLevel;
			
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
				return 0;
			}
			
			return levelBefore.stat;
			
		}
	}

}