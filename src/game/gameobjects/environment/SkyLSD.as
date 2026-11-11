package src.game.gameobjects.environment 
{
	import com.gskinner.geom.ColorMatrix;
	import flash.filters.ColorMatrixFilter;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	/**
	 * ...
	 * @author 
	 */
	public class SkyLSD extends Sky 
	{
		protected var _colorMat:ColorMatrix;
		protected var _colorMatFilter:ColorMatrixFilter;
		protected var _hueSpeed:Number = 1;
		protected var _timeBeforeEasterEgg:Number = 999999999999;
		
		
		public function SkyLSD() 
		{
			super();
			
			_colorMat = DisplayObjectUtil.getColorMatrix( -180 + Math.random() * 360, 80, 0, 30);
			_colorMatFilter = new ColorMatrixFilter(_colorMat);
			_movieClip.filters = [_colorMatFilter];
			
			var rand:Number = Math.random();
			
			if (rand >= 0.5) {
				//Get easter egg
				_timeBeforeEasterEgg = NumberUtils.randomRange(200, 1500);
			}else {
				//Get  FAR OFF easter egg
				_timeBeforeEasterEgg = NumberUtils.randomRange(7500, 25000);
			}
			//if (rand >= 0) {
				////Get easter egg
				//_timeBeforeEasterEgg = 200;
			//}else {
				////Get  FAR OFF easter egg
				//_timeBeforeEasterEgg = NumberUtils.randomRange(7500, 25000);
			//}
			
		}
		
		override protected function altitudeChange(alt:Number):void 
		{
			super.altitudeChange(alt);
			
			_colorMat.adjustHue(_hueSpeed);
			_colorMatFilter.matrix = _colorMat;
			_movieClip.filters = [_colorMatFilter];
			
			
			//Easter egg
			_timeBeforeEasterEgg -= 1;
			//trace("_timeBeforeEasterEgg:", _timeBeforeEasterEgg.toFixed(0));
			if (_timeBeforeEasterEgg <= 0) {
				_timeBeforeEasterEgg = NumberUtils.randomRange(10000, 100000);
				
				//var rand:Number = Math.random();
				//if (rand <= 0.2) {
					//_movieClip.addChild(new src.game.gameobjects.environment.LSDSkyEgg1())
				//}else if (rand <= 0.4) {
					//_movieClip.addChild(new src.game.gameobjects.environment.LSDSkyEgg2())
				//}else if (rand <= 0.6) {
					//_movieClip.addChild(new src.game.gameobjects.environment.LSDSkyEgg3())
				//}else if (rand <= 0.8) {
					//_movieClip.addChild(new src.game.gameobjects.environment.LSDSkyEgg4())
				//}else {
					_movieClip.addChild(new src.game.gameobjects.environment.LSDSkyEgg5())
				//}
			}
		}
		
		override public function destroy():void 
		{
			if (_instance || _colorMat || _colorMatFilter) {
				_colorMat = null;
				_colorMatFilter = null;
				super.destroy();
			}
		}
	}

}