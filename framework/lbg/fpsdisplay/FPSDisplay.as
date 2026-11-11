package lbg.fpsdisplay
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author 
	 */
	public class FPSDisplay 
	{
		protected static const FIRST_FPS_BUFFER:uint = 5;
		protected static const SECOND_FPS_BUFFER:uint = 120;
		protected static const FPS_DECIMALS:uint = 2;
		protected static var _timerBuffer:Array = new Array();
		protected static var _stage:Stage;
		protected static var _straightFpsField:TextField;
		protected static var _bufferedFpsField:TextField;
		protected static var _sprite:Sprite;
		protected static var _oldTimer:Number = 0;
		
		public static function showFPS(stage:Stage):void {
			_stage = stage;
			if (_straightFpsField == null) {
				_straightFpsField = new TextField();
				_bufferedFpsField = new TextField();
				_sprite = new Sprite();
				_sprite.addChild(_straightFpsField);
				_sprite.addChild(_bufferedFpsField);
			}
			stage.addChild(_sprite);
			setupFpsBox(stage);
			_oldTimer = getTimer();
			_stage.addEventListener(Event.ENTER_FRAME, doEnterFrame);
		}
		
		public static function hideFPS():void {
			if (_straightFpsField == null) {
				return;
			}
			_timerBuffer = new Array();
			_sprite.parent.removeChild(_sprite);
			_stage.removeEventListener(Event.ENTER_FRAME, doEnterFrame);
		}
		
		protected static function setupFpsBox(stage:Stage):void {
				_straightFpsField.defaultTextFormat = new TextFormat("Arial", 20, 0x00FF00);
				_straightFpsField.autoSize = TextFieldAutoSize.LEFT;
				_straightFpsField.text = "str";
				_straightFpsField.x = 15;
				
				_bufferedFpsField.defaultTextFormat = new TextFormat("Arial", 20, 0x00FF00);
				_bufferedFpsField.autoSize = TextFieldAutoSize.LEFT;
				_bufferedFpsField.text = "buf";
				_bufferedFpsField.x = 160;
				
				_sprite.graphics.beginFill(0x00000);
				_sprite.graphics.drawRect(0, 0, 300, 30);
				_sprite.graphics.endFill();
		}
		
		protected static function doEnterFrame(e:Event):void {
			var timerDiff:Number = (getTimer() - _oldTimer);
			pushTimerDiff(timerDiff);
			var fps:Number = 1000 / timerDiff;
			_straightFpsField.text = "Fast: " + getBufferedFps(FIRST_FPS_BUFFER);
			_bufferedFpsField.text = "Stable: " + getBufferedFps(SECOND_FPS_BUFFER);
			_oldTimer = getTimer();
		}
		
		protected static function pushTimerDiff(diff:Number):void {
			_timerBuffer.unshift(diff);
			var maxBuffer:uint = uint(Math.max(FIRST_FPS_BUFFER, SECOND_FPS_BUFFER));
			while (_timerBuffer.length > maxBuffer) {
				_timerBuffer.pop();
			}
		}
		
		protected static function getBufferedFps(bufferAmmout:uint = 0):String {
			var constrainedBufferAmount:uint = uint(Math.min(bufferAmmout, _timerBuffer.length));
			var totalTime:Number = 0;
			for (var i:int = 0; i < constrainedBufferAmount; i++) {
				totalTime += _timerBuffer[i];
			}
			var averageDiff:Number = totalTime / constrainedBufferAmount;
			return formatNumberToString(1000 / averageDiff, FPS_DECIMALS);
		}
		
		protected static function formatNumberToString(value:Number, decimals:uint = 0, tailZeros:Boolean = true):String {
			if (decimals == 0) {
				return String(int(value));
			}
			var mult:uint = Math.pow(10, decimals);
			var intValue:int = int(value * mult);
			var result:String = String(intValue / mult);
			var missingDecimals:uint = 0;
			if (result.indexOf(".") == -1) {
				missingDecimals = decimals;
				result = result + ".";
			}else {
				missingDecimals = decimals - ((result.length -1) - result.indexOf("."));
			}
			for (var i:int = 1; i <= missingDecimals; i++) {
				result = result + "0";
			}
			return result;
		}
		
		public static function get visible():Boolean {
			if (_sprite == null) {
				return false;
			}else {
				return (_sprite.parent != null);
			}
		}
		
	}

}