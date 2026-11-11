package src.game.sandboxmode 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import lbg.utils.NumberUtils;
	import lbg.utils.StringUtils;
	import lbg.utils.Tools;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class MatrixBgChain extends Sprite 
	{
		
		protected var _fadeSpeed:Number;
		protected var _stepSize:Number;
		protected var _stepDuration:Number;
		protected var _stepTime:Number;
		protected var _textFormat:TextFormat;
		protected var _textFormat2:TextFormat;//First letter only
		protected var _chars:Vector.<TextField> = new Vector.<TextField>();
		
		public function MatrixBgChain() 
		{
			super();
			
			_stepDuration = NumberUtils.randomRange(2, 7);
			var greenAmount:uint = uint(NumberUtils.randomRange(40, 190));
			_textFormat = new TextFormat(null, NumberUtils.randomRange(15, 40), Tools.rgbToColor(0, greenAmount, 0));
			_textFormat2 = new TextFormat(null, _textFormat.size, Tools.rgbToColor(60, greenAmount + 65, 60));
			_stepSize = Number(_textFormat.size);
			_fadeSpeed = NumberUtils.randomRange(0.03, 0.6);
			
			Main.unsafeTickSignal.add(tick);
			
		}
		
		protected function tick(delta:Number):void {
			if (_stepTime < _stepDuration) {
				_stepTime += delta;
			}else {
				newStep();
				_stepTime = 0;
			}
			
			for each(var tf:TextField in _chars) {
				tf.alpha -= _fadeSpeed;
			}
			
			//Cleanup
			if (_chars.length >= 1) {
				if (_chars[_chars.length - 1].alpha <= 0) {
					var popped:TextField = _chars.pop();
					popped.parent.removeChild(popped);
					if (popped.y >= 580) {
						dispatchEvent(new Event("destroy"));
						destroy();
						return;
					}
				}
			}
		}
		
		protected function newStep():void {
			var tf:TextField = new TextField();
			tf.defaultTextFormat = _textFormat2;
			tf.text = StringUtils.randomString(1);
			tf.selectable = tf.mouseEnabled = tf.mouseWheelEnabled = false;
			addChild(tf);
			//trace("New step!", tf.text);
			if (_chars.length >= 1) {
				_chars[0].defaultTextFormat = _textFormat;
				tf.y = _chars[0].y + _stepSize;
				_chars[0].text = StringUtils.randomString(1);
				_chars[0].cacheAsBitmap = true;
			}
			_chars.unshift(tf);
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			_textFormat = null;
			
			if (_chars) _chars.length = 0;
			_chars = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
	}

}