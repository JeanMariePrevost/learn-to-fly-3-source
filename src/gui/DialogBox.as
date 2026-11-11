package src.gui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	
	/**
	 * ...
	 * @author 
	 */
	public class DialogBox extends Sprite 
	{
		public var style:MovieClip;
		
		
		public function DialogBox() 
		{
			super();
			
			style.gotoAndStop(4);//Default style
			
			
			setScale(scaleX, scaleY);//Adjust style size if scale modified from inside Flash IDE
		}
		
		public function setPositionFromStage(xNorm:Number = 0.5, yNorm:Number = 0.5, fromCenter:Boolean = true):void {
			if (!stage) {
				throw new Error("MessageBox setPositionRatio error - no stage property...");
				return;
			}
			
			var X:Number = stage.stageWidth * xNorm;
			var Y:Number = stage.stageHeight * yNorm;
			
			setPosition(X, Y, fromCenter);
		}
		
		public function setPosition(X:Number = NaN, Y:Number = NaN, fromCenter:Boolean = true):void {
			//trace("setPosition", X, Y);
			if (fromCenter) {
				var bounds:Rectangle = getBounds(parent);
				X -= (bounds.width + bounds.x) * 0.5;
				Y -= (bounds.height + bounds.y) * 0.5;
			}
			
			if (!isNaN(X)) {
				x = X;
			}
			
			if (!isNaN(Y)) {
				y = Y;
			}
		}
		
		public function setScale(X:Number, Y:Number):void {
			scaleX = X;
			style.scaleX = 1 / scaleX;
			
			scaleY = Y;
			style.scaleY = 1 / scaleY;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			style.scaleY = 1 / scaleY;
		}
		
		public function destroy():void {
			style = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
		
		
	}

}