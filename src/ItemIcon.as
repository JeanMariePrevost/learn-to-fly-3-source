package src 
{
	import flash.display.MovieClip;
	import lbg.debug.Log;
	
	/**
	 * ...
	 * @author 
	 */
	public class ItemIcon extends MovieClip 
	{
		
		public function ItemIcon(id:String = null) 
		{
			super();
			
			gotoIcon(id);
			
		}
		
		public function gotoIcon(id:String):void {
			if (id == null) return;
			
			try {
				gotoAndStop(id);
			}catch (e:Error) {
				Log.log("Icon of id", "\"" + id + "\"", "not found in icons");
				gotoAndStop(1);
			}
		}
		
		public function setScale(scale:Number = 1):void {
			scaleX = scaleY = scale;
		}
		
		public function setSizeInPixels(size:Number = 100):void {
			var scale:Number = size / 100;
			setScale(scale);
		}
		
	}

}