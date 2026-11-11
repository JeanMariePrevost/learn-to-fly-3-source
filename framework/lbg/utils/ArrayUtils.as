package lbg.utils 
{
	/**
	 * ...
	 * @author 
	 */
	public class ArrayUtils 
	{
		/**
		 * Removes an element from specified array without making a copy
		 * @param	array Array to manipulate
		 * @param	element Element to remove
		 */
		public static function removeFromArray(array:Array, element:*):void {
			array.splice(array.indexOf(element), 1);
		}
		
		/** Returns a array with shuffled elements */
		public static function shuffleArray(array:Array):Array {
			var _length:Number = array.length;
			var mixed:Array = array.slice();
			var rand:Number;
			var i:int;
			var element:*;
			for (i = 0; i<_length; i++) {
				element = mixed[i];
				rand = Math.floor(Math.random() * (_length - 0.001));
				mixed[i] = mixed[rand];
				mixed[rand] = element;
			}
			return mixed;
		}
		
	}

}