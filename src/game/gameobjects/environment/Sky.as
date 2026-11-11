package src.game.gameobjects.environment 
{
	import com.gskinner.geom.ColorMatrix;
	import flash.filters.ColorMatrixFilter;
	import lbg.compositetick.*;
	import flash.display.MovieClip;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.game.GameMediator;
	import src.Main;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Sky 
	{
		
		protected static var _instance:Sky;
		protected var _movieClip:MovieClip;
		
		public function Sky()
		{
			if (_instance) _instance.destroy();
			_instance = null;
			
			_movieClip = new DebugSkyVisual();
			setFrame(1);
			
			
			
			GameMediator.updatePlayerAltitude.add(altitudeChange);
			Main.destroyGameSignal.addOnce(destroy);
		}
		
		protected function altitudeChange(alt:Number):void 
		{
			var frame:uint = uint(NumberUtils.interpolate2(1, Global.SKY_MAX_FRAME, 0, Global.spaceAltitude, alt, 1));
			setFrame(frame);
			
			//trace("Sky received:", alt, "Frame:", frame);
		}
		
		public function get visual():MovieClip {
			return _movieClip;
		}
		
		public function get centerColor():uint {
			return DisplayObjectUtil.getPixelColor(_movieClip, _movieClip.width / 2, _movieClip.height / 2);
		}
		
		public static function destroy():void 
		{
			if (_instance != null) {
				_instance.destroy();
			}
		}
		
		public static function get instance():Sky 
		{
			if (_instance == null) {
				if (ProfileState.instance.cheatLSD) {
					trace("Loading LSD SKY :O !!!!!!!");
					_instance = new SkyLSD();
				}else {
					_instance = new Sky();
				}
			}
			
			return _instance;
		}
		
		public function setFrame(frame:int):void {
			//trace("Sky.setFrame()");
			//trace("frame:", frame, "Mc frame:", _movieClip.currentFrame);
			frame = Math.max(1, Math.min(Global.SKY_MAX_FRAME, frame));
			_movieClip.gotoAndStop(frame);
			//trace("frame:", frame, "Mc frame:", _movieClip.currentFrame);
			GameMediator.skyColor = centerColor;
			//trace("Sky color =", centerColor);
		}
		
		public function destroy():void {
			GameMediator.updatePlayerAltitude.remove(altitudeChange);
			Main.destroyGameSignal.remove(destroy);
			
			while (_movieClip.numChildren >= 1) _movieClip.removeChildAt(0);
			if (_movieClip.parent) _movieClip.parent.removeChild(_movieClip);
			
			_instance = null;
			_movieClip = null;
		}
		
	}

}

class Enforcer { }
