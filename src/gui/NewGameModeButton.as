package src.gui 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import lbg.components.MySimpleButton;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	
	/**
	 * ...
	 * @author 
	 */
	public class NewGameModeButton extends MySimpleButton 
	{
		public var mc:MovieClip;
		
		public var bounce:MouseBounce2;
		
		public function NewGameModeButton() 
		{
			super();
			
			
			bounce = new MouseBounce2(this);
		}
		
		public function disableDeco():void {
			if (bounce == null) return;
			
			bounce.destroy();
			bounce = null;
		}
		
		override public function destroy():void 
		{
			mc = null;
			disableDeco();
			super.destroy();
		}
		
	}

}