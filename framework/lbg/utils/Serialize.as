package lbg.utils 
{
	import flash.utils.describeType;
	/**
	 * ...
	 * @author 
	 */
	public class Serialize 
	{
		protected static const SEPARATOR:String = ",";
		//protected static const BRACKET_OPEN:String = "{[";
		//protected static const BRACKET_CLOSE:String = "}]";
		protected static const ESCAPE_CODE_PREFIX:String = "&#";
		
		
		public static function toSeparatedString(data:Array):String {
			var escaped:Array = escapeChar(data);
			return escaped.join(SEPARATOR);
		}
		
		public static function separatedStringToArray(string:String):Array {
			var escaped:Array = string.split(SEPARATOR);
			var unescaped:Array = unescapeChar(escaped);
			return unescaped;
		}
		
		public static function escapeChar(dataToCheck:Array, chars:String = SEPARATOR):Array {
			var escaped:Array = dataToCheck.concat();
			var escapeCode:String  = escapeCodeOf(chars);
			for (var i:int = 0; i < escaped.length; i++ ) {
				if (escaped[i] is String) {
					var s:String = escaped[i];
					while (s.indexOf(chars) >= 0) {
						s = s.replace(chars, escapeCode);
					}
					escaped[i] = s;
				}
			}
			return escaped;
		}
		
		public static function unescapeChar(dataToCheck:Array, chars:String = SEPARATOR):Array {
			var unescaped:Array = dataToCheck.concat();
			var escapeCode:String  = escapeCodeOf(chars);
			for (var i:int = 0; i < unescaped.length; i++ ) {
				if (unescaped[i] is String) {
					var s:String = unescaped[i];
					while (s.indexOf(escapeCode) >= 0) {
						s = s.replace(escapeCode, chars);
					}
					unescaped[i] = s;
				}
			}
			return unescaped;
		}
		
		protected static function escapeCodeOf(chars:String):String {
			var escapeCode:String = "";
			for (var i:int = 0; i < chars.length; i++ ) {
				escapeCode = escapeCode + ESCAPE_CODE_PREFIX + chars.charCodeAt(i);
			}
			return escapeCode;
		}
		
		public static function compareProperties(a:Object, b:Object):Boolean {
			var p:*;
			for (p in a) {
				// Check if a and b have different values for p.
				if (a[p] != b[p]) {
					return false;
				}
			}
			for (p in b) {
				// Check if b has a value which a does not.
				if (!a[p]) {
					return false;
				}
			}
			return true;
		}
		
		public static function enumerateProperties(a:Object):String {
			var property:String;
			var array:Array = new Array();
			
			for (property in a) {
				trace("Property name:", property);
				array.push([property,String(a[property])]);
				//array.push([p,a[p].toString()]);
				//array.push([p,a[p]]);
			}
			
			array.sort();
			var str:String = "";
			for (var i:int = 0; i < array.length; i++) {
				str = str + array[i].join("");
			}
			//return array.join("");
			return str;
		}
		
		public static function listObjectVariables(o:Object):Array {
			var xml:XML = describeType(o);
			
			var array:Array = new Array();
			var propertyName:String;
			
			//trace("listObjectVariables()");
			//trace(xml);
			//trace(xml.variable);
			//trace(xml.variable.length());
			//trace("listObjectVariables()xml.variable.length = " + xml.variable.length());
			
			for (var i:int = 0; i < xml.variable.length(); i++) {
				propertyName = xml.variable[i].@name;
				array.push([propertyName, o[propertyName]]);
				//trace("listObjectVariables().propertyName =" + propertyName);
			}
			
			
			return array;
		}
		
	}

}