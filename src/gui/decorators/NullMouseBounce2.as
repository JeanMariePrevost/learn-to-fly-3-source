package src.gui.decorators 
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NullMouseBounce2 extends MouseBounce2 
	{
		
		public function NullMouseBounce2(target:DisplayObject, useRollOverEvent:Boolean=false, useSeparateHitBox:DisplayObject=null) 
		{
			super(target, useRollOverEvent, useSeparateHitBox);
			
		}
		
		override protected function checkColorEffect():void 
		{
			
		}
		
		override public function checkMousePosition(forceAnimation:Boolean = false):void 
		{
			//super.checkMousePosition(forceAnimation);
		}
		
		override public function mouseHitsTarget():Boolean 
		{
			return false;
			//return super.mouseHitsTarget();
		}
		
		override protected function targetHasBrightnessFilter(filter:ColorMatrixFilter):Boolean 
		{
			return false; 
			//return super.targetHasBrightnessFilter(filter);
		}
		
		override protected function tick(delta:Number):void 
		{
			//super.tick(delta);
		}
		
	}

}