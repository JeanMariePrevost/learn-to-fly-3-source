package src.gui.menus 
{
	import flash.text.TextField;
	import lbg.components.MySimpleButton;
	
	/**
	 * ...
	 * @author 
	 */
	public class CutsceneReplayButton extends MySimpleButton 
	{
		public var txtLabel:TextField;
		
		public function CutsceneReplayButton() 
		{
			super();
			
		}
		
		override public function destroy():void 
		{
			txtLabel = null;
			super.destroy();
		}
		
	}

}