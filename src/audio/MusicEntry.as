package src.audio 
{
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author 
	 */
	public class MusicEntry 
	{
		public var title:String;
		
		public var track1:Class;
		public var track2:Class;
		public var track3:Class;
		
		public var slotFrame:uint;
		
		public var cost:Number;
		
		public function MusicEntry() 
		{
			
		}
		
		public function get track1AsString():String 
		{
			return getQualifiedClassName(track1);
		}
		
		public function get track2AsString():String 
		{
			return getQualifiedClassName(track2);
		}
		
		public function get track3AsString():String 
		{
			return getQualifiedClassName(track3);
		}
		
	}

}