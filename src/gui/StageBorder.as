package src.gui 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class StageBorder extends MovieClip 
	{
		public var top:MovieClip = new Square();
		public var bottom:MovieClip = new Square();
		public var left:MovieClip = new Square();
		public var right:MovieClip = new Square();
		
		protected const MARGIN:Number = 0;//Negative to squeeze borders inside screen, positive to push them out
		
		public function StageBorder() 
		{
			super();
			
			top.enabled = top.tabEnabled = top.tabChildren = top.mouseChildren = false;
			bottom.enabled = bottom.tabEnabled = bottom.tabChildren = bottom.mouseChildren = false;
			left.enabled = left.tabEnabled = left.tabChildren = left.mouseChildren = false;
			right.enabled = right.tabEnabled = right.tabChildren = right.mouseChildren = false;
			
			top.x = -2000;
			bottom.x = -2000;
			left.x = -2000;
			right.x = -2000;
			
			addChild(top);
			addChild(bottom);
			addChild(left);
			addChild(right);
			top.scaleX = 4;
			
			top.scaleX = top.scaleY = 20;
			bottom.scaleX = bottom.scaleY = 20;
			left.scaleX = left.scaleY = 20;
			right.scaleX = right.scaleY = 20;
			
		}
		
		public function update(height:Number, width:Number, aspectRatio:Number):void {
			DisplayObjectUtil.moveFromAnchor(top, 360, 0, 0.5, 1);
			DisplayObjectUtil.moveFromAnchor(bottom, 360, 540, 0.5, 0);
			DisplayObjectUtil.moveFromAnchor(left, 0, 270, 1, 0.5);
			DisplayObjectUtil.moveFromAnchor(right, Math.min(960, 540 * aspectRatio), 270, 0, 0.5);
			
			//Log.log("StageBorder.update() top:", top.getRect(Main.mainLayer.stage).bottom);
			//Log.log("StageBorder.update() bottom:", bottom.getRect(Main.mainLayer.stage).top);
			//Log.log("StageBorder.update() left:", left.getRect(Main.mainLayer.stage).right);
			//Log.log("StageBorder.update() right:", right.getRect(Main.mainLayer.stage).left);
			
			
			top.y -= MARGIN;
			bottom.y += MARGIN;
			left.x -= MARGIN;
			right.x += MARGIN;
		}
		
		
	}

}