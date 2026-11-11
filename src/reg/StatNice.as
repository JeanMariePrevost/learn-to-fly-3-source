package src.reg 
{
	import lbg.utils.NumberUtils;
	/**
	 * Nice stats do rounding and precision work on stat results
	 * Small numbers get their precision adjusted (1.12345 becomes 1.12)
	 * Big numbers get their smallers digits removed (123456 becomes 123000)
	 * @author 
	 */
	public class StatNice extends Stat 
	{
		public var lowValuePrecision:uint = 2;//Number of digits on small numbers (e.g. 1.12345453546 -> 1.12)
		public var highValuePrecision:uint = 3;//Number of digits to keep at start of big numbers (e.g. 475,238.12 -> 475,000)
		
		public function StatNice() 
		{
			super();
			
		}
		
		override public function valueAt(level:Number = 0):Number {
			var rawStat:Number = super.valueAt(level);
			
			var niceStat:Number;
			
			if (rawStat <= 10) {
				niceStat = NumberUtils.setPrecison(rawStat, lowValuePrecision);
			}else if (rawStat < 100) {
				niceStat = Math.round(rawStat);
			}else if (rawStat < 1000) {
				rawStat = Math.round(rawStat);
				niceStat = NumberUtils.roundToNearest(10, rawStat);
			}else {
				rawStat = Math.round(rawStat);
				var length:int = rawStat.toFixed().length;
				var roundTo:Number = Math.pow(10, length) / Math.pow(10,highValuePrecision);
				niceStat = NumberUtils.roundToNearest(roundTo, rawStat);
			}
			
			return niceStat;
			
		}

		
	}

}