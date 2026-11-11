package src.gui 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import src.audio.Sfx;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.TweenPos;
	
	/**
	 * ...
	 * @author 
	 */
	public class WhySoLong extends MovieClip 
	{
		public var btnNext:SimpleButton;
		public var btnPrevious:SimpleButton;
		public var btnBack:SimpleButton;
		
		protected var _deco:Vector.<MouseBounce> = new Vector.<MouseBounce>();
		protected var _controller:MainMenuController;
		
		public function WhySoLong(control:MainMenuController) 
		{
			super();
			
			_controller = control;
			
			btnPreviousClick(null);//To init on frame 1 and all
			
			_deco.push(new MouseBounce(btnNext));
			_deco.push(new MouseBounce(btnPrevious));
			_deco.push(new MouseBounce(btnBack));
			
			TweenPos.tweenToCurrentPosition(this, new Point(0, 540), 30, 0, TweenPos.EASE_OUT_CUBIC);
			
			btnBack.addEventListener(MouseEvent.CLICK, btnBackClick);
			btnNext.addEventListener(MouseEvent.CLICK, btnNextClick);
			btnPrevious.addEventListener(MouseEvent.CLICK, btnPreviousClick);
			
		}
		
		private function btnBackClick(e:MouseEvent):void 
		{
			Sfx.playButtonClick();
			closeMenu();
		}
		
		private function btnNextClick(e:MouseEvent):void 
		{
			Sfx.playButtonClick();
			gotoAndStop(2);
			btnNext.visible = false;
			btnNext.mouseEnabled = false;
			btnPrevious.visible = true;
			btnPrevious.mouseEnabled = true;
			
		}
		
		private function btnPreviousClick(e:MouseEvent):void 
		{
			Sfx.playButtonClick();
			gotoAndStop(1);
			btnNext.visible = true;
			btnNext.mouseEnabled = true;
			btnPrevious.visible = false;
			btnPrevious.mouseEnabled = false;
		}
		
		public function closeMenu():void {
			TweenPos.tweenFromCurrentPosition(this, new Point(0, 540), 30, 0, TweenPos.EASE_IN).finishedSignal.addOnce(finishMenu);
		}
		
		protected function finishMenu():void {
			_controller.gotoExtras();
			destroy();
		}
		
		public function destroy():void 
		{
			for each(var i:MouseBounce in _deco) {
				i.destroy();
			}
			_deco = null;
			
			btnNext = null;
			btnPrevious = null;
			btnBack = null;
			
			_controller = null;
			
			if (stage) parent.removeChild(this);
			while (numChildren) removeChildAt(0);
		}
		
	}

}