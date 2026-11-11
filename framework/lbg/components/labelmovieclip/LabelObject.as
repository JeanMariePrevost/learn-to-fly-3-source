package lbg.components.labelmovieclip 
{
	/**
	 * ...
	 * @author 
	 */
	public class LabelObject extends Object
	{
		public var name:String;
		public var frame:int;
		public var action:String = "";
		
		public function LabelObject(label:String, frame:uint, action:String) 
		{
			this.name = label;
			this.frame = frame;
			this.action = action;
		}
		
		public static function createNullLabelObject():LabelObject {
			var l:LabelObject = new LabelObject("", 1, LabelMovieClip.ACTION_PLAY);
			return l;
		}
	}

}