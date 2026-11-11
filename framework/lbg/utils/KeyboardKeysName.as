package lbg.utils 
{
	/**
	 * ...
	 * @author 
	 */
	public class KeyboardKeysName 
	{
		
		//Array of strings representing each keycode, useful for display pressed key like "CTRL" and "Tab" 
			private static var _keyCodeNames:Array = new Array();
			private static var keyIterator:int = 0;
			for (keyIterator = 0; keyIterator <= 300; keyIterator++) {
				_keyCodeNames[keyIterator]="?"
			}
			_keyCodeNames[8] = "Backspace";
			_keyCodeNames[9] = "Tab";
			_keyCodeNames[13] = "Enter";
			_keyCodeNames[16] = "Shift";
			_keyCodeNames[17] = "COntrol";
			_keyCodeNames[19] = "Pause/Break";
			_keyCodeNames[20] = "CapsLock";
			_keyCodeNames[27] = "Esc";
			_keyCodeNames[32] = "Spacebar";
			_keyCodeNames[33] = "PageUp";
			_keyCodeNames[34] = "PageDown";
			_keyCodeNames[35] = "End";
			_keyCodeNames[36] = "Home";
			_keyCodeNames[37] = "LeftArrow";
			_keyCodeNames[38] = "UpArrow";
			_keyCodeNames[39] = "RightArrow";
			_keyCodeNames[40] = "DownArrow";
			_keyCodeNames[45] = "Insert";
			_keyCodeNames[46] = "Delete";
			_keyCodeNames[48] = "0";
			_keyCodeNames[49] = "1";
			_keyCodeNames[50] = "2";
			_keyCodeNames[51] = "3";
			_keyCodeNames[52] = "4";
			_keyCodeNames[53] = "5";
			_keyCodeNames[54] = "6";
			_keyCodeNames[55] = "7";
			_keyCodeNames[56] = "8";
			_keyCodeNames[57] = "9";
			_keyCodeNames[65] = "A";
			_keyCodeNames[66] = "B";
			_keyCodeNames[67] = "C";
			_keyCodeNames[68] = "D";
			_keyCodeNames[69] = "E";
			_keyCodeNames[70] = "F";
			_keyCodeNames[71] = "G";
			_keyCodeNames[72] = "H";
			_keyCodeNames[73] = "I";
			_keyCodeNames[74] = "J";
			_keyCodeNames[75] = "K";
			_keyCodeNames[76] = "L";
			_keyCodeNames[77] = "M";
			_keyCodeNames[78] = "N";
			_keyCodeNames[79] = "O";
			_keyCodeNames[80] = "P";
			_keyCodeNames[81] = "Q";
			_keyCodeNames[82] = "R";
			_keyCodeNames[83] = "S";
			_keyCodeNames[84] = "T";
			_keyCodeNames[85] = "U";
			_keyCodeNames[86] = "V";
			_keyCodeNames[87] = "W";
			_keyCodeNames[88] = "X";
			_keyCodeNames[89] = "Y";
			_keyCodeNames[90] = "Z";
			_keyCodeNames[96] = "Num 0";
			_keyCodeNames[97] = "Num 1";
			_keyCodeNames[98] = "Num 2";
			_keyCodeNames[99] = "Num 3";
			_keyCodeNames[100] = "Num 4";
			_keyCodeNames[101] = "Num 5";
			_keyCodeNames[102] = "Num 6";
			_keyCodeNames[103] = "Num 7";
			_keyCodeNames[104] = "Num 8";
			_keyCodeNames[105] = "Num 9";
			_keyCodeNames[106] = "*";
			_keyCodeNames[107] = "+";
			_keyCodeNames[109] = "-";
			_keyCodeNames[110] = ".";
			_keyCodeNames[111] = "/";
			_keyCodeNames[112] = "F1";
			_keyCodeNames[113] = "F2";
			_keyCodeNames[114] = "F3";
			_keyCodeNames[115] = "F4";
			_keyCodeNames[116] = "F5";
			_keyCodeNames[117] = "F6";
			_keyCodeNames[118] = "F7";
			_keyCodeNames[119] = "F8";
			_keyCodeNames[120] = "F9";
			_keyCodeNames[121] = "F10";
			_keyCodeNames[122] = "F11";
			_keyCodeNames[123] = "F12";
			_keyCodeNames[124] = "F13";
			_keyCodeNames[125] = "F14";
			_keyCodeNames[126] = "F15";
			_keyCodeNames[144] = "NumLock";
			_keyCodeNames[145] = "ScrLock";
			_keyCodeNames[186] = ";";
			_keyCodeNames[187] = "=";
			_keyCodeNames[188] = ",";
			_keyCodeNames[189] = "-";
			_keyCodeNames[190] = ".";
			_keyCodeNames[191] = "/ ?";
			_keyCodeNames[192] = "` ~";
			_keyCodeNames[219] = "[";
			_keyCodeNames[220] = "\ |";
			_keyCodeNames[221] = "]";
			_keyCodeNames[222] = "' \"";
			
		//public static function get keyCodeNames():Array {
			//return _keyCodeNames;
		//}
		
		public static function getNameOfKey(keyCode:int):String {
			return _keyCodeNames[keyCode];
		}
	}

}