package src.game.hud.huds 
{
	/**
	 * ...
	 * @author 
	 */
	public class SpeedHudWood extends SpeedNeedleHud 
	{
		
		public function SpeedHudWood() 
		{
			super();
			
			_minNeedleAngle = -37.5;
			_topSpeedNeedleAngle = 22.5;
			_maxNeedleAngle = 45;
		}
		
		override protected function updateSpeedTexts():void 
		{
			txt1.text = Math.round(0).toFixed();
			txt2.text = Math.round(_maxSpeed * 0.5).toFixed();
			txt3.text = Math.round(_maxSpeed).toFixed();
		}
		
	}

}