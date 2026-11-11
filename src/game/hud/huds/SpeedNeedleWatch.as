package src.game.hud.huds 
{
	/**
	 * ...
	 * @author 
	 */
	public class SpeedNeedleWatch extends SpeedNeedleHud 
	{
		
		public function SpeedNeedleWatch() 
		{
			super();
			
			_minNeedleAngle = -27.5;
			_topSpeedNeedleAngle = 27.5;
			_maxNeedleAngle = 45;
		}
		
		override protected function updateSpeedTexts():void 
		{
			txt1.text = Math.round(0).toFixed();
			txt2.text = Math.round(_maxSpeed).toFixed();
		}
		
	}

}