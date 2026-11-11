package src.game.hud 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import src.game.GameMediator;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class HudWeight extends MovieClip 
	{
		public var txtWeight:TextField;
		protected var _weight:Number = 0;
		protected var _previousWeight:Number = 0;
		protected var _tweenCount:Number = 0;
		protected const _tweenDuration:Number = 20;
		
		public function HudWeight() 
		{
			Main.unsafeTickSignal.add(tick);
			GameMediator.playerWeightChange.add(changeWeight);
			_tweenCount = _tweenDuration;
		}
		
		private function tick(delta:Number):void 
		{
			if (_tweenCount < _tweenDuration) {
				_tweenCount += delta;
				var w:Number = Easing.linear(_tweenCount, _previousWeight, _weight - _previousWeight, _tweenDuration);
				txtWeight.text = w.toFixed(1);
			}else {
				txtWeight.text = _weight.toFixed(1);
			}
		}
		
		public function changeWeight(weight:Number):void {
			if (weight != _weight) {
				_previousWeight = _weight;
				_weight = weight;
				_tweenCount = 0;
			}
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			GameMediator.playerWeightChange.remove(changeWeight);
			txtWeight = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}