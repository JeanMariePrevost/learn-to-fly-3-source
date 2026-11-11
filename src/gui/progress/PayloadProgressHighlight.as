package src.gui.progress 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import lbg.utils.DisplayObjectUtil;
	import src.gui.decorators.MouseBounce2;
	
	/**
	 * ...
	 * @author 
	 */
	public class PayloadProgressHighlight extends MovieClip 
	{
		public var bounce:MouseBounce2;
		
		protected var _selected:Boolean = false;
		protected var _baseAlpha:Number = 0;
		
		public function PayloadProgressHighlight() 
		{
			super();
			
			
			selected = false;
			alpha = _baseAlpha;
		}
		
		public function initBounce(hitBox:MovieClip):void {
			bounce = new MouseBounce2(this, false, hitBox);
			bounce.scaleMod = 0;
			bounce.colorWhenOver = DisplayObjectUtil.getColorMatrix(0, 25, 15, 10);
			bounce.colorWhenDown = DisplayObjectUtil.getColorMatrix(0, 25, -10, 10);
			
			bounce.signalOverTarget.add(onOver);
			bounce.signalOutTarget.add(onOut);
		}
		
		protected function onOver(target:DisplayObject):void {
			alpha = _baseAlpha +0.3;
		}
		
		protected function onOut(target:DisplayObject):void {
			alpha = _baseAlpha;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			if (_selected) {
				_baseAlpha = 0.8;
			}else {
				_baseAlpha = 0;
			}
			
			alpha = _baseAlpha;
			
		}
		
	}

}