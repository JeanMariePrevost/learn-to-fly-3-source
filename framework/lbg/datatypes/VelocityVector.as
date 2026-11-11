package lbg.datatypes
{
	import tools.Tools;
	/**
	 * ...
	 * @author LightBringer
	 */
	public class VelocityVector extends Object
	{
		public const DEGREES_RADIANS_RATIO:Number = Tools.DEGREES_RADIANS_RATIO;
		private var _angle:Number;
		private var _angleRads:Number;
		private var _magnitude:Number;
		private var _vx:Number;
		private var _vy:Number;
		
		public function VelocityVector(magnitude:Number, angle:Number) 
		{
			_angle = angle % 360;
			_angleRads = _angle * Tools.DEGREES_RADIANS_RATIO;
			_magnitude = magnitude;
		}
		
		public function addXY(x:Number, y:Number):void {
			_vx = vectorX + x;
			_vy = vectorY + y;
			rebuildVectorFromXY(_vx, _vy);
		}
		
		public function addMagDir(magnitude:Number, angle:Number):void {
			rebuildVector(magnitude, angle);
			_vx = vectorX + getVectorX(magnitude,angle);
			_vy = vectorY + getVectorY(magnitude, angle);
			rebuildVectorFromXY(_vx, _vy);
		}
		
		public function rebuildVectorFromXY(vx:Number, vy:Number):void {
			_vx = vx;
			_vy = vy;
			_angleRads = Math.atan2(vy, vx);
			_angle = _angleRads / Tools.DEGREES_RADIANS_RATIO;
			_magnitude = Math.sqrt(Math.pow(_vx, 2) + Math.pow(_vy, 2));
		}
		
		public function rebuildVector(magnitude:Number, angle:Number):void {
			//_vx = vectorX + getVectorX(magnitude,angle);
			//_vy = vectorY + getVectorY(magnitude, angle);
			_vx = getVectorX(magnitude,angle);
			_vy = getVectorY(magnitude, angle);
			rebuildVectorFromXY(_vx, _vy);
		}
		
		private function getVectorX(magnitude:Number, angle:Number):Number {
			return Math.cos(angle*DEGREES_RADIANS_RATIO) * magnitude;
		}
		
		private function getVectorY(magnitude:Number, angle:Number):Number {
			return Math.sin(angle*DEGREES_RADIANS_RATIO) * magnitude;
		}
		
		public function get vectorX():Number {
			return getVectorX(_magnitude, _angle);
		}
		
		public function get vectorY():Number {
			return getVectorY(_magnitude, _angle);
		}
		
		public function get magnitude():Number {
			return _magnitude;
		}
		
		public function get angle():Number {
			return _angle;
		}
		
		public function set angle(newAngle:Number):void {
			_angle = newAngle;
			_angleRads = _angle * Tools.DEGREES_RADIANS_RATIO;
		}
		
		public function get angleInRads():Number {
			return _angleRads;
		}
		
		public function set angleInRads(newAngle:Number):void {
			_angleRads = newAngle;
			_angle = _angleRads / Tools.DEGREES_RADIANS_RATIO;
		}
	}

}