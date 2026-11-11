package src.effects.smoketrail 
{
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import lbg.utils.Tools;
	import lbg.utils.Trig;
	/**
	 * ...
	 * @author ...
	 */
	public class RainbowTrail extends SmokeTrail 
	{
		protected var red:Number = 255;
		protected var green:Number = 0;
		protected var blue:Number = 0;
		
		protected var _time:Number = 0;
		protected var _stage:String = "red";
		protected var _speed:Number = 40;
		
		
		
		
		public function RainbowTrail(useStaticFunctionInstead:Number) 
		{
			super(useStaticFunctionInstead);
		}
		
		override protected function getNewSegment(X:Number, Y:Number, trail:SmokeTrail, previousNode:Segment = null, forcedAngle:Number = NaN):Segment 
		{
			_time+= 8;
			if (_time > 360) _time-= 360;
			
			var angleMod:Number = Math.sin(Trig.toRadians(_time)) * 8;
			
			var s:Segment = super.getNewSegment(X, Y, trail, previousNode, forcedAngle + angleMod);
			
			
			switch(_stage) {
				case "red":
					if (red < 255) {
						red += _speed;
						red = Math.min(255, red);
					}else {
						blue -= _speed;
						blue = Math.max(0, blue);
					}
					if (red >= 255 && blue <= 0) _stage = "green";
					break;
				case "green":
					if (green < 255) {
						green += _speed;
						green = Math.min(255, green);
					}else {
						red -= _speed;
						red = Math.max(0, red);
					}
					if (green >= 255 && red <= 0) _stage = "blue";
					break;
				case "blue":
					if (blue < 255) {
						blue += _speed;
						blue = Math.min(255, blue);
					}else {
						green -= _speed;
						green = Math.max(0, green);
					}
					if (blue >= 255 && green <= 0) _stage = "red";
					break;
			}
			
			
			
			
			s.color = Tools.rgbToColor(red, green, blue);
			
			//trace("Rainbow:", red, green, blue, _stage);
			
			return s;
		}
	}

}