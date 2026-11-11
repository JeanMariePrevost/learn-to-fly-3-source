package lbg.utils 
{
	/**
	 * ...
	 * @author 
	 */
	public class VectorUtils 
	{
		/**
		 * Removes an element from specified vector without making a copy
		 * @param	vector Vector to manipulate
		 * @param	element Element to remove
		 */
		public static function removeFromVector(vector:Object, element:*):void {
			vector.splice(vector.indexOf(element), 1);
		}
		
		/** Use vector.sort(randomSort) to shuffle a vector */
		public static function randomSort(a:Object, b:Object):int {
			return Math.floor( Math.random() * 3 - 1 );
		}		
	}

}