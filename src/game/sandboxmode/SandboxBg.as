package src.game.sandboxmode 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import lbg.utils.NumberUtils;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class SandboxBg extends MovieClip 
	{
		
		public var txtBg:TextField;
		
		protected var _deltaPerChar:Number = 3;
		protected var _deltaCounter:Number = 0;
		
		protected var _targetString:String = "";
		protected var _cursorChar:String = "_";
		protected var _cursorTime:Number = 0;
		protected var _cursorDuration:Number = 35;
		
		protected var _minAutoLineTime:Number = 40;
		protected var _maxAutoLineTime:Number = 240;
		protected var _autoLineTime:Number = _maxAutoLineTime;
		
		protected var _everyLinePrefix:String = ">  ";
		
		protected var _lastLines:Array = new Array(); 
		
		protected var _lines:Array = new Array(
		"Acccessing ltf3/system/settings.sys",
		"Acccessing secretfolder/notnakedpenguins/naked.jpg",
		"Reading system constants...",
		"Checking the weather forecast...",
		"DodoMasterFile deleted.",
		"Login in to admin account...",
		"Changes applied.",
		"Settings saved.",
		"WARNING! DATA WAS LOST!",
		"Formatting drive C:",
		"Download more ram, Y/N?",
		"Not enough GHz on inserted floppy",
		"Adjusting fan voltage...",
		"WARNING! CPU TEMP HIGH!",
		"Are you sure you wish to erase MainProfile.dat? Y/N    Y",
		"Will you marry me? Y/N",
		"Do you wish to continue? Y/N",
		"WARNING! DATA TEMPRING DETECTED!",
		"Performing CPU backwash...",
		"Virus detected.",
		"Injecting value into adress 0E43",
		"Injecting value into adress 0E47",
		"Injecting value into adress 1337",
		"Injecting value into adress 8008",
		"Injecting value into adress TH15 15 N0T AN ADDR355",
		"0001 8003882 00xx",
		"0001 8006729 00xx",
		"8001 1000080 0001",
		"I can haz cheeburger? Y/N",
		"Isn't this game the best ever? Y/Y/Totally",
		"Is Light Bringer777 is sexy? Y/Y",
		"Altering data structure...",
		"You require administrator privileges to continue.",
		"You require your mom's permission to continue.",
		"You require a Big Key to continue.",
		"Unlock mouse clicking for $2.95? Y/N",
		"Did you just read that?",
		"Does anyone read these?",
		"100d0384 SEND HELP 14sso0p22Q",
		"JET FUEL CAN'T MELT ICEBERGS",
		"LtF3 was a hoax",
		"Are you there?",
		"If you can read this, send pizza to 255 South Pole St",
		"If you can read this, you can read",
		"This sponsored message is brought to you by: ERROR",
		"Saving game... CRITICAL ERROR",
		"Your save file has been marked as totally dank",
		"Your save file was lost",
		"Your save file was corrupted, rebooting from default file",
		"A/S/L?",
		"I SEE YOU",
		"Don't look over your shoulder...",
		"Feel that breathing down your neck?",
		"How can Fishes Be real if Our beaks Are Vector graphics?",
		"EZ mode engaged",
		"This kills the game...",
		"This action will break your save file, continue? Y/N     Y",
		".......",
		".......loading......",
		"LOAD ltf3/settings.ini",
		"LOAD ltf3/Global.ini",
		"LOAD ltf3/Save.dat",
		"LOAD sysDisplDrvr",
		"LOAD sysInputMngr",
		"LOAD sysTrnsltr",
		"LOAD pengOS64b",
		"Read error on sector 10283",
		"File corrupt",
		"Unercognized file extension",
		"PENGUINZ RULZ",
		"1337 HAX UNDERWAY!!!1!",
		".",
		" ",
		"          ",
		"                               ",
		"                                         ",
		"                                                       ",
		"        ",
		" ",
		" ");
		
		public function SandboxBg() 
		{
			super();
			
			Main.guiTickSignal.add(tick);
			txtBg.text = "";
			
			addLineFromText(".");
			addLineFromText("..");
			addLineFromText("...");
			addLineFromText("BIOS version 7.41-r002 . . . . . . . . . . . . . . .PASS");
			addLineFromText("pengOS 1.004.3558b");
			addLineFromText("Welcome to pengOS 1.004  ");
		}
		
		public function tick(delta:Number):void {
			if (writingComplete == false) {
				_deltaCounter += delta;
				
				while (_deltaCounter >= _deltaPerChar) {
					_deltaCounter -= _deltaPerChar;
					progressOneChar();
				}
			
			}else {
				if (_deltaCounter > 0) {
					txtBg.text = _targetString;
				}
				_deltaCounter = 0;
			}
			
			_cursorTime += delta;
			if (_cursorTime >= _cursorDuration) {
				_cursorTime = 0;
				toggleCursorChar();
			}
			
			_autoLineTime-= delta;
			if (_autoLineTime <= 0) {
				_autoLineTime = NumberUtils.randomRange(_minAutoLineTime, _maxAutoLineTime, true);
				addLineFromId();
			}
			
			if (txtBg.text.length >= 1000) {
				txtBg.text = txtBg.text.substr(500);
				_targetString = _targetString.substr(500);
			}else {
				//trace(txtBg.text.length);
			}
		}
		
		protected function get writingComplete():Boolean {
			if (txtBg.text.charAt(txtBg.text.length - 1) == _cursorChar) {
				//Take away 1 char from length because it's the cursor
				return ((txtBg.text.length - 1) >= _targetString.length);
			}else {
				return ((txtBg.text.length) >= _targetString.length);
			}
		}
		
		protected function progressOneChar():void {
			if (writingComplete == false) {
				removeCursorChar();
				txtBg.text = _targetString.substr(0, txtBg.text.length + 1);
				addCursorChar();
				_cursorTime = 0;
				txtBg.scrollV = txtBg.maxScrollV;
			}
		}
		
		protected function toggleCursorChar():void {
			if (txtBg.text.charAt(txtBg.text.length - 1) == _cursorChar) {
				removeCursorChar();
			}else {
				addCursorChar();
			}
		}
		
		protected function removeCursorChar():void {
			if (txtBg.text.charAt(txtBg.text.length - 1) == _cursorChar) {
				txtBg.text = txtBg.text.substr(0, txtBg.text.length - 1);
			}
		}
		
		protected function addCursorChar():void {
			if (txtBg.text.charAt(txtBg.text.length - 1) != _cursorChar) {
				txtBg.text = txtBg.text + _cursorChar;
			}
		}
		
		/** random line if -1 */
		public function addLineFromId(id:int = -1):void {
			var text:String;
			
			if (id <= -1 || id >= _lines.length) {
				do {
					id = NumberUtils.randomRange(0, _lines.length - 1, true);
				}while (_lastLines.indexOf(id) >= 0);
				
				_lastLines.unshift(id);
				while (_lastLines.length >= 7) _lastLines.pop();
			}
			
			text = _lines[id];
			
			_targetString = _targetString + "\n" + _everyLinePrefix + text;
		}
		
		public function addLineFromText(text:String):void {
			_targetString = _targetString + "\n" + _everyLinePrefix + text;
		}
		
		
		
	}

}