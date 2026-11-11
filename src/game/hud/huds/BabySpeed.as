package src.game.hud.huds 
{
	/**
	 * ...
	 * @author 
	 */
	public class BabySpeed extends SpeedNeedleHud 
	{
		
		public function BabySpeed() 
		{
			super();
			
			_minNeedleAngle = -82;
			_topSpeedNeedleAngle = -24;
			_maxNeedleAngle = 20;
		}
		
		override protected function updateSpeedTexts():void {
			txt1.text = Math.round(_maxSpeed * 0).toFixed();
			txt2.text = Math.round(_maxSpeed * 0.50).toFixed();
			txt3.text = Math.round(_maxSpeed * 1).toFixed();
			//txt4.text = Math.round(_maxSpeed * 1.00).toFixed();
			//txt5.text = Math.round(_maxSpeed * 1.25).toFixed();
		}
		
	}

}