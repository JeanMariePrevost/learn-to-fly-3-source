package src.game.result 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import lbg.utils.StringUtils;
	
	/**
	 * ...
	 * @author 
	 */
	public class Node extends MovieClip 
	{
		public var txtLabel:TextField;
		public var txtCash:TextField;
		public var _cash:int = 0;
		
		public var bestPopup:MovieClip;
		public var progressBar:MovieClip;
		
		protected var _progressNorm:Number = 0;
		protected var _progressTime:Number = 0;
		protected var _progressDuration:Number = 70;
		protected var _delay:Number = 0;
		
		public function Node() 
		{
			super();
			
			bestPopup.gotoAndStop(1);
			bestPopup.visible = false;
			progressBar.gotoAndStop(1);
			
		}
		
		/** Send norm to the slot so it can update its progress bar and possibly trigger the best score popup */
		public function runProgressBar(delay:Number, norm:Number, hue:Number):void {
			_delay = delay;
			_progressNorm = NumberUtils.constrain(norm, 0, 1);
			//DisplayObjectUtil.setObjectTint(progressBar, color, 1);
			DisplayObjectUtil.setColorMatrix(progressBar, hue);
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		public function finishProgressBarNow():void {
			if (_progressTime < _progressDuration) {
				_delay = 0;
				_progressDuration *= 0.5;
				_progressTime = Math.min(_progressDuration - 1, _progressTime);
				onFrame(null);
			}
		}
		
		private function onFrame(e:Event):void 
		{
			_progressTime += 1;
			
			var timeWithDelay:Number = NumberUtils.constrain(_progressTime - _delay, 0, _progressDuration);
			var easeTime:Number = timeWithDelay;
			
			progressBar.gotoAndStop(Math.floor(Easing.easeBothInOutQuart(easeTime, 1, (progressBar.totalFrames -1) * _progressNorm, _progressDuration)));
			txtCash.text = "$ " + NumberUtils.numberDelimiter(Math.floor(Easing.easeOutQuart(easeTime, 0, _cash, _progressDuration)));
			
			if (timeWithDelay >= _progressDuration) {
				
				removeEventListener(Event.ENTER_FRAME, onFrame);
				
				txtCash.text = "$ " + NumberUtils.numberDelimiter(_cash);
				
				if (_progressNorm >= 1) {
					bestPopup.gotoAndPlay(1);
					bestPopup.visible = true;
				}
			}
			
		}
		
		public function get label():String {
			return txtLabel.text;
		}
		
		public function set label(value:String):void {
			txtLabel.text = value;
		}
		
		public function get cash():int {
			return _cash;
		}
		
		public function set cash(value:int):void {
			_cash = value;
			txtCash.text = "";
		}
		
		public function setTextColor(color:uint = 0x333333):void {
			txtCash.textColor = color;
			txtLabel.textColor = color;
		}
		
		public function destroy():void {
			removeEventListener(Event.ENTER_FRAME, onFrame);
			txtCash = null;
			txtLabel = null;
			if (stage) parent.removeChild(this);
		}
		
	}

}