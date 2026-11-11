package lbg.debug 
{
	import fl.controls.TextArea;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import lbg.utils.NumberUtils;
	import lbg.utils.StringUtils;
	import lbg.utils.Tools;
	/**
	 * ...
	 * @author 
	 */
	public class Log
	{
		protected static const MAX_LOG:uint = 500;//150;
		protected static const TIMESTAMP:Boolean = true;
		protected static const TRACE:Boolean = true;
		protected static const HIGHLIGHT_KEYWORDS:Array = ["error", "Error", "ERROR"];//Will mark the corresponding lines if these strings are found, empty array to disable feature
		protected static const HIGHLIGHT_STRING:String =  "█ERROR►";
		protected static const LOG_SHOW_LOG_CALLS:Boolean = true;//Write to log when the log is shown, usefull for knowing when's the last time you checked it
		protected static const LOG_SHOW_LOG_CALLS_STRING:String = "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬█ Log opened █▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬";
		protected static const LOG_SHOW_LOG_CALLS_PREVENT_DOUBLES:Boolean = true;//Won't log the LOG_SHOW_LOG_CALLS_STRING if it's already the latest thing on the log
		
		protected static var _screen:Sprite;
		protected static var _txt:TextArea = new TextArea();
		protected static var _log:Vector.<String> = new Vector.<String>();
		protected static var _joinedString:String = "";
		
		protected static var _linkedExternalTextField:TextField;//Used to output everything in the logs to an existing text field, works when log isn't even initialized
		
		public static function initiate(container:DisplayObjectContainer):void {
			if (_screen == null) {
				_screen = new Sprite();
				_screen.graphics.beginFill(0xFFFFFF, 0.9);
				_screen.graphics.drawRect(0, 0, container.stage.stageWidth - 1, container.stage.stageHeight - 1);
				_screen.graphics.endFill();
				_screen.addChild(_txt);
				_screen.visible = false;
			}
			_txt.width = container.stage.stageWidth - 1;
			_txt.height = container.stage.stageHeight - 1;
			_txt.setStyle("textFormat", new TextFormat("Courier New", 16));
			_txt.editable = false;
			_txt.opaqueBackground = null;
			_txt.textField.border = true;
			_txt.textField.borderColor = 0x000000;
			_txt.textField.background = false;
			_txt.textField.selectable = true;
			_txt.textField.wordWrap = true;
			_txt.textField.mouseWheelEnabled = true;
			if (_screen.stage) _screen.parent.removeChild(_screen);
			container.addChild(_screen);
		}
		
		public static function linkExternalTextField(tf:TextField):void {
			_linkedExternalTextField = tf;
		}
		
		public static function refreshSize():void {
			if (_screen && _screen.parent) {
				var container:DisplayObjectContainer = _screen.parent;
				_screen.graphics.clear();
				_screen.graphics.beginFill(0xFFFFFF, 0.9);
				_screen.graphics.drawRect(0, 0, container.stage.stageWidth - 1, container.stage.stageHeight - 1);
				_screen.graphics.endFill();
				_txt.width = container.stage.stageWidth - 1;
				_txt.height = container.stage.stageHeight - 1;
			}
			
		}
		
		public static function refreshSizeManually(height:Number, width:Number):void {
			if (_screen) {
				_screen.graphics.clear();
				_screen.graphics.beginFill(0xFFFFFF, 0.9);
				_screen.graphics.drawRect(0, 0, width - 1, height - 1);
				_screen.graphics.endFill();
				_txt.width = width - 1;
				_txt.height = height - 1;
			}
			
		}
		
		public static function show():void {
			if (LOG_SHOW_LOG_CALLS && _screen.visible == false) logThatTheLogWasJustOpened();
			_screen.visible = true;
			update();
		}
		
		public static function hide():void {
			_screen.visible = false;
		}
		
		public static function toggleVisibility():void {
			if (LOG_SHOW_LOG_CALLS && _screen.visible == false) logThatTheLogWasJustOpened();
			_screen.visible = !_screen.visible;
			update();
		}
		
		protected static function logThatTheLogWasJustOpened():void {
			if (LOG_SHOW_LOG_CALLS) {
				if (LOG_SHOW_LOG_CALLS_PREVENT_DOUBLES && _log[0].indexOf(LOG_SHOW_LOG_CALLS_STRING) >= 0) {
					//Already sitting at the top of the log
				}else {
					log(LOG_SHOW_LOG_CALLS_STRING);
				}
			}
		}
		
		public static function get isVisible():Boolean {
			if (_screen) {
				return _screen.visible;
			}else {
				return false;
			}
		}
		
		public static function log(... arguments):void {
			if (TIMESTAMP) {
				var d:Date = new Date();
				var hour:String = String(d.getHours());
				if (hour.length == 1) hour = "0" + hour;
				var min:String = String(d.getMinutes());
				if (min.length == 1) min = "0" + min;
				var sec:String = String(d.getSeconds());
				if (sec.length == 1) sec = "0" + sec;
				var timeStamp:String = hour + ":" + min + ":" +sec;
			}
			
			var logString:String = "";
			for each(var i:* in arguments) {
				var argString:String = (i is String) ? i:String(i);
				logString = logString + argString + " ";
			}
			
			if (logString == null || logString == "") return;
			
			
			//Highlighting
			for each(var highlightKeywords:String in HIGHLIGHT_KEYWORDS) {
				if (logString.indexOf(highlightKeywords) >= 0) {
					logString = HIGHLIGHT_STRING + logString;
					break;
				}
			}
			
			
			if (TIMESTAMP) {
				_log.unshift(timeStamp + " > " + logString);
			}else {
				_log.unshift(logString);
			}
			
			if (TRACE) {
				trace("LOG: " + timeStamp + " > " + logString);
			}
			
			while (_log.length > MAX_LOG) {
				_log.pop();
			}
			
			if ((_screen && _screen.visible) || _linkedExternalTextField) update();
		}
		
		protected static function update():void {
			_joinedString = "";
			for each(var s:String in _log) {
				_joinedString += (s + "\n");
			}
			_txt.text = _joinedString;
			if (_linkedExternalTextField) {
				_linkedExternalTextField.text = _joinedString;
			}
		}
		
		
		
	}

}