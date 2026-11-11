package src.cards 
{
	import flash.display.MovieClip;
	import lbg.utils.DisplayObjectUtil;
	import src.gui.menus.EndGameCard;
	
	/**
	 * ...
	 * @author 
	 */
	public class CardVisual extends MovieClip 
	{
		public var newItem:MovieClip;
		public var newFragment:MovieClip;
		public var omegaComplete:MovieClip;
		public var hitzone:MovieClip;
		public var hitzone2:MovieClip;
		public var omegaProgress:Number = 0;
		
		
		protected var _visual2:CardVisual;//Used for omegas
		
		public function CardVisual() 
		{
			stop();
			
			newItem.mouseEnabled = false;
			newItem.mouseChildren = false;
			newFragment.mouseEnabled = false;
			newFragment.mouseChildren = false;
			omegaComplete.mouseEnabled = false;
			omegaComplete.mouseChildren = false;
			
			hitzone2.visible = false;
			
			hidePopups();
			
		}
		
		public function hidePopups():void {
			newItem.visible = false;
			newFragment.visible = false;
			omegaComplete.visible = false;
			
			removeChild(newItem);
			removeChild(newFragment);
			removeChild(omegaComplete);
		}
		
		public function showNewItem():void {
			addChild(newItem);
			newItem.visible = true;
		}
		
		public function showNewFragment():void {
			addChild(newFragment);
			newFragment.visible = true;
		}
		
		public function showOmegaComplete():void {
			addChild(omegaComplete);
			omegaComplete.visible = true;
		}
		
		public function setOmegaProgress(progress:Number = NaN, showTextMc:Boolean = false) 
		{
			if (isNaN(progress) == false && progress >= 1) {
				omegaProgress = progress;
				_visual2 = new CardVisual();
				_visual2.gotoAndStop("notEarnedOmega");
				//_visual2.removeChild(_visual2.newItem);
				addChild(_visual2);
				var thirdSize:Number = (_visual2.hitzone.height / 3) * progress;
				_visual2.hitzone.y += thirdSize;
				_visual2.hitzone.height -= thirdSize;
				//var thirdWidth:Number = (_visual2.hitzone.width / 3) * progress;
				//_visual2.hitzone.x += thirdWidth;
				//_visual2.hitzone.width -= thirdWidth;
				_visual2.mask = _visual2.hitzone;
				DisplayObjectUtil.setColorMatrix(_visual2, 0, 0, -60, -20);
				
				if (showTextMc) {
					if (progress < 3) {
						newFragment.visible = true;
					}else {
						showOmegaComplete();
						omegaComplete.visible = true;
					}
				}
			}
		}
		
		public function destroy():void {
			newItem = null;
			newFragment = null;
			omegaComplete = null;
			hitzone = null;
			hitzone2 = null;
			if (_visual2) _visual2.destroy();
			_visual2 = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}