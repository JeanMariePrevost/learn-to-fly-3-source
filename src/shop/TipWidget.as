package src.shop 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import lbg.utils.NumberUtils;
	import src.Main;
	import src.audio.Sfx;
	
	/**
	 * ...
	 * @author 
	 */
	public class TipWidget extends MovieClip 
	{
		public var txtTip:TextField;
		public var btnPrevious:SimpleButton;
		public var btnNext:SimpleButton;
		public var tipTimer:MovieClip;
		
		protected var _tickFunction:Function;
		protected var _writingSpeed:Number = 2;
		protected var _writingCounter:Number = 0;
		
		protected var _standbyTime:Number = 700;
		protected var _standbyCounter:Number = 0;
		
		protected var _txtTipStartY:Number;
		
		protected var _tip:String;
		
		public function TipWidget() 
		{
			super();
			
			_txtTipStartY = txtTip.y;
			_tickFunction = tickStandby;
			newTip();
			
			Main.unsafeTickSignal.add(tick);
			btnPrevious.addEventListener(MouseEvent.CLICK, clickPrevious);
			btnNext.addEventListener(MouseEvent.CLICK, clickNext);
		}
		
		public function newTip(index:int = -1):void {
			tipTimer.gotoAndStop(tipTimer.totalFrames);
			
			if (index >= 0) {
				if (index >= GameTips.tips.length) {
					index = 0;
				}
				_tip = GameTips.tips[index];
			}else {
				_tip = GameTips.getRandomTip();
			}
			_tickFunction = tickErase;
		}
		
		private function clickPrevious(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			var i:int = GameTips.tips.indexOf(_tip);
			if (i == 0) {
				newTip(GameTips.tips.length - 1);
			}else {
				newTip(i - 1);
			}
		}
		
		private function clickNext(e:MouseEvent):void 
		{
			Sfx.playMediumClick();
			nextTip();
		}
		
		protected function nextTip():void {
			var i:int = GameTips.tips.indexOf(_tip);
			if (i == GameTips.tips.length - 1) {
				newTip(0);
			}else {
				newTip(i + 1);
			}
		}
		
		protected function tick(delta:Number):void {
			if(_tickFunction) _tickFunction(delta);
		}
		
		protected function tickStandby(delta:Number):void {
			_standbyCounter += delta;
			var f:Number = Math.round(NumberUtils.interpolate2(1, tipTimer.totalFrames, 0, _standbyTime, _standbyCounter));
			//trace("CircleTimerFrame:", f);
			tipTimer.gotoAndStop(f);
			
			if (_standbyCounter >= _standbyTime) {
				nextTip();
			}
		}
		
		protected function tickWrite(delta:Number):void {
			_writingCounter += delta * _writingSpeed;
			
			while (_writingCounter >= 1) {
				_writingCounter -= 1;
				var finished:Boolean = writeOneChar();
				if (finished) {
					_writingCounter = 0;
					_standbyCounter = 0;
					_tickFunction = tickStandby;
					return;
				}
			}
		}
		
		protected function tickErase(delta:Number):void {
			txtTip.text = "";
			_writingCounter = 0;
			_tickFunction = tickWrite;
			return;
					
			//_writingCounter += delta * _writingSpeed;
			//
			//while (_writingCounter >= 1) {
				//_writingCounter -= 1;
				//var finished:Boolean = eraseOneChar();
				//if (finished) {
					//_writingCounter = 0;
					//_tickFunction = tickWrite;
					//return;
				//}
			//}
		}
		
		
		/** Remove 1 char from tip, returns true when tip is fully erased */
		protected function eraseOneChar():Boolean {
			if (txtTip.length >= 1) {
				txtTip.text = txtTip.text.substr(0, txtTip.length - 1);
			}
			
			if (txtTip.length <= 0) {
				return true;
			}else {
				return false;
			}
		}
		
		/** Add 1 char from tip, returns true when tip is fully written */
		protected function writeOneChar():Boolean {
			if (txtTip.length < _tip.length) {
				txtTip.text = _tip.substr(0, txtTip.length + 1);
			}
			
			alignVertically();
			
			if (txtTip.length >= _tip.length) {
				return true;
			}else {
				return false;
			}
		}
		
		protected function alignVertically():void {
			var offset:Number = NumberUtils.interpolate2(40, 0, 30, 140, txtTip.textHeight);
			txtTip.y = _txtTipStartY + offset;
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			if(btnPrevious) btnPrevious.removeEventListener(MouseEvent.CLICK, clickPrevious);
			if (btnNext) btnNext.removeEventListener(MouseEvent.CLICK, clickNext);
			
			txtTip = null;
			btnPrevious = null;
			btnNext = null;
			tipTimer = null;
			_tickFunction = null;
			
			
			if (stage) parent.removeChild(this);
			while (numChildren >= 1) removeChildAt(0);
		}
		
	}

}