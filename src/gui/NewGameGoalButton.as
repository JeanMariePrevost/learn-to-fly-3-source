package src.gui 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import lbg.components.MySimpleButton;
	import lbg.utils.DisplayObjectUtil;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	
	/**
	 * ...
	 * @author 
	 */
	public class NewGameGoalButton extends MovieClip 
	{
		public var txtLabel:TextField;
		public var txtCards:TextField;
		
		public var bounce:MouseBounce2;
		
		public function NewGameGoalButton() 
		{
			super();
			
			
			bounce = new MouseBounce2(this);
			bounce.colorWhenOver = DisplayObjectUtil.getColorMatrix(0, 20, 30, 15);
			bounce.colorWhenDown = DisplayObjectUtil.getColorMatrix(0, -50, -20, -15);
		}
		
		public function disableDeco():void {
			if (bounce == null) return;
			
			bounce.destroy();
			bounce = null;
		}
		
		public function destroy():void 
		{
			txtLabel = null;
			txtCards = null;
			
			disableDeco();
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}