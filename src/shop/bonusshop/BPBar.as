package src.shop.bonusshop 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import lbg.anticheatengine.SafeNumber;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.Main;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class BPBar extends MovieClip 
	{
		public var txtBP:TextField;
		
		
		protected var _startValue:Number = 0;
		protected var _targetValue:Number = 0;
		protected var _time:Number = 0;
		protected var _duration:Number = 40;
		
		protected var _startScaleX:Number = 1;
		protected var _startScaleY:Number = 1;
		protected var _scaleModX:Number = 0.07;
		protected var _scaleModY:Number = 0.14;
		
		public function BPBar() 
		{
			super();
			
			_startScaleX = scaleX;
			_startScaleY = scaleY;
			
			
			ProfileState.instance.bonusPoints.valueChangedSignal.add(updateBonusPoints);
			updateBonusPoints(ProfileState.instance.bonusPoints);
		}
		
		protected function updateBonusPoints(sn:SafeNumber):void {
			if (sn.value != _targetValue) {
				_startValue = _targetValue;
				_targetValue = sn.value;
				_time = 0;
				txtBP.text = NumberUtils.numberDelimiter(_startValue);
				Main.guiTickSignal.add(tweenValueTick);
			}else {
				txtBP.text = NumberUtils.numberDelimiter(sn.value);
			}
		}
		
		protected function tweenValueTick(delta:Number):void {
			_time += delta;
			_time = NumberUtils.constrain(_time, 0, _duration);
			
			scaleX = Easing.easeInQuad(_time, _startScaleX * (1 + _scaleModX), -_startScaleX * _scaleModX, _duration);
			scaleY = Easing.easeInQuad(_time, _startScaleY * (1 + _scaleModY), -_startScaleY * _scaleModY, _duration);
			//trace("scaleY:", scaleY);
			
			var tweenedValue:Number = Easing.easeOutQuad(_time, _startValue, _targetValue - _startValue, _duration);
			txtBP.text = NumberUtils.numberDelimiter(tweenedValue);
			
			if (_time >= _duration) {
				Main.guiTickSignal.remove(tweenValueTick);
				ProfileState.instance.bonusPoints.valueChangedSignal.add(updateBonusPoints);
			}
		}
		
		public function destroy():void {
			Main.guiTickSignal.remove(tweenValueTick);
			
			
			txtBP = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
	}

}