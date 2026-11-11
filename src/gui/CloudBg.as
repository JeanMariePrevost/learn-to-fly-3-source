package src.gui 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author 
	 */
	public class CloudBg extends Sprite 
	{
		public var clouds:Vector.<MenuClouds> = new Vector.<MenuClouds>();
		
		public function CloudBg() 
		{
			super();
			
			for (var i:int = 0; i < 15; i++) {
				var newCloud:MenuClouds = new MenuClouds();
				clouds.push(newCloud);
				addChild(newCloud);
			}
		}
		
		public function destroy():void {
			if (clouds) {
				for each(var c:MenuClouds in clouds) {
					c.destroy();
				}
				clouds.length = 0;
			}
			clouds = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}