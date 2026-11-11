package src.gui 
{
	import lbg.utils.Easing;
	import src.reg.RegistryEntry;
	
	/**
	 * ...
	 * @author 
	 */
	public class PayloadMilestoneBar extends MedalMessageBar 
	{
		
		public function PayloadMilestoneBar(entry:RegistryEntry, topMargin:Number, level:uint) 
		{
			super(entry, topMargin, level);
		}
		
		override protected function getBpReward(entry:RegistryEntry, level:uint):Number 
		{
			return entry.statSpecial.valueAt(level);
		}
		
		override protected function getTitleText(entry:RegistryEntry, level:uint):String 
		{
			return entry.statCost.valueAt(level).toFixed(0) + "' reached!";
		}
		
		override protected function tick(delta:Number):void 
		{
			if (bar && medal) {
				_bpTweenTime += delta;
				if (_bpTweenTime < BP_TWEEN_START_DELAY) {
					bar.txtBP.text = "";
				}else if (_bpTweenTime - BP_TWEEN_START_DELAY <= BP_TWEEN_DURATION) {
					var time:Number = Math.max(0, Math.min(BP_TWEEN_DURATION, _bpTweenTime - BP_TWEEN_START_DELAY));
					var bp:Number = Easing.easeOutQuad(time, 0, _bpReward, BP_TWEEN_DURATION);
					bar.txtBP.text = "+" + bp.toFixed(0) + " BP";
				}else {
					bar.txtBP.text = "+" + _bpReward + " BP";
				}
				medal.tick(delta);
				super.tick(delta);
			}
		}
		
	}

}