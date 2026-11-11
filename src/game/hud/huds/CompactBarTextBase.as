package src.game.hud.huds 
{
	import flash.text.TextField;
	import src.game.hud.HudComponent;
	
	/**
	 * ...
	 * @author 
	 */
	public class CompactBarTextBase extends HudComponent 
	{
		public var txtName:TextField;
		public var txtValue:TextField;
		
		public function CompactBarTextBase() 
		{
			super();
			
		}
		
		override public function destroy():void 
		{
			txtName = null;
			txtValue = null;
			
			super.destroy();
		}
	}

}