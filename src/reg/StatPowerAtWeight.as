package src.reg 
{
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	/**
	 * Unlike leveled stats, this one returns a mult for a given weight
	 * Any weight pass the cutoff weight is divided by 2 for each "step"
	 * @author 
	 */
	public class StatPowerAtWeight implements IStat
	{
		protected var _powerAtZero:Stat = new Stat();
		protected var _cutoffMass:Stat = new Stat();
		protected var _halfSteps:Stat = new Stat();
		
		public function StatPowerAtWeight() 
		{
			
		}
		
		
		/**
		 * @param	powerMultAtZero Mult when mass = 0
		 * @param	cutoffMass Mass at which power = 1
		 * @param	halfPowerSteps Steps in mass past cutoffMass at which power decays 50% each step
		 */
		public function addLevel(level:uint, powerMultAtZero:Number, cutoffMass:Number, halfPowerSteps:Number, powerUntilNextPoint:Number = 1):void {
			_powerAtZero.addLevel(level, powerMultAtZero, powerUntilNextPoint);
			_cutoffMass.addLevel(level, cutoffMass, powerUntilNextPoint);
			_halfSteps.addLevel(level, halfPowerSteps, powerUntilNextPoint);
		}
		
		public function valueAt(level:Number = 0):Number {
			return _cutoffMass.valueAt(level);
		}
		
		
		public function powerRatioAt(level:Number, mass:Number):Number 
		{
			var powerAtZero:Number = _powerAtZero.valueAt(level);
			var cutoffMass:Number = _cutoffMass.valueAt(level);
			var halfLife:Number = _halfSteps.valueAt(level);
			
			var power:Number;
			
			if (mass <= 0) {
				//Max power
				power = powerAtZero;
			}else if (mass < cutoffMass) {
				power = NumberUtils.interpolate2(powerAtZero, 1, 0, cutoffMass, mass, 1.4);
			}else if (mass == cutoffMass) {
				power = 1;
			}else {
				//Beyond cutoff, stat decays
				if (mass < cutoffMass + halfLife) {
					//First step, soften
					power = NumberUtils.interpolate2(1, 0.5, cutoffMass, cutoffMass + halfLife, mass, 1.6);
				}else {
					//later steps, decay normally
					power = 1 * Math.pow(0.5, (mass - cutoffMass) / halfLife);
				}
			}
			
			return power;
		}
		
	}

}