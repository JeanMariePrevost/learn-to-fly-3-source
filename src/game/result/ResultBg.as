package src.game.result 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author 
	 */
	public class ResultBg extends MovieClip 
	{
		protected var _mask:Sprite = new Sprite();
		protected var _maskHeight:Number = 0;//Simply stores the mask height
		
		public function ResultBg() 
		{
			super();
			addChild(_mask);
			mask = _mask;
			
		}
		
		public function setHeight(height:Number):void {
			if (height < 0) height = 0;
			_maskHeight = height;
			_mask.graphics.clear();
			_mask.graphics.beginFill(0x000000, 1);
			_mask.graphics.drawRect( -360, 0, 720, height);
			_mask.graphics.endFill();
		}
		
		public function getHeight():Number {
			return _maskHeight;
		}
		
		public function getBottom():Number {
			return y + _maskHeight;
		}
		
		public function destroy():void {
			removeChild(_mask);
			_mask = null;
			if (stage) parent.removeChild(this);
		}
		
	}

}