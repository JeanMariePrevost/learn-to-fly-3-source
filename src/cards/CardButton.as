package src.cards 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import lbg.utils.DisplayObjectUtil;
	import src.gui.decorators.MouseBounce2;
	import src.gui.decorators.NullMouseBounce2;
	import src.shop.medals.MedalButton;
	import src.system.ContentUnlocking;
	
	/**
	 * ...
	 * @author 
	 */
	public class CardButton extends MedalButton 
	{
		public var amountIfBpCard:int = 0;
		public var progressIfOmega:int = 0;
		
		
		public function CardButton(id:String, frame:int, unlockedStatus:int, clickFunction:Function=null) 
		{
			super(id, frame, unlockedStatus, clickFunction);
		}
		
		
		/**
		 * @param	frame Actually used to show how MANY cards were obtained for this class
		 * @param	unlockedStatus 0 = not, 3 = full, 1-2 = 1-2 3rds (for omegas)
		 */
		override protected function init(id:String, frame:int, unlockedStatus:int, clickFunction:Function = null):void 
		{
			_visual = new CardVisual();
			
			if (unlockedStatus == 3) {
				_isUnlocked = true;
				_visual.gotoAndStop(id);
			}else if (unlockedStatus <= 0){
				_isUnlocked = false;
				if (id.indexOf("omega") >= 0) {
					visual.gotoAndStop("notEarnedOmega");
				}else {
					visual.gotoAndStop("notEarned");
				}
			}else {
				//In progress
				progressIfOmega = unlockedStatus;
				_visual.gotoAndStop(id);
				_isUnlocked = true;
				(_visual as CardVisual).setOmegaProgress(unlockedStatus);
			}
			
			(_visual as CardVisual).removeChild((_visual as CardVisual).hitzone);
			
			if (id == "bp1" || id == "bp2" || id == "bp3" || id == "bp4" || id == "bp5") {
				amountIfBpCard = frame;
			}
			
			_visual.filters = [new GlowFilter(0x000000, 0.8, 15, 15, 1.1, 1, true), new GlowFilter(0x000000, 1, 3.5, 3.5, 7, 1), new DropShadowFilter(16, 60, 0, 0.2, 5, 5, 1, 1)];
			
			_bounce = new MouseBounce2(_visual, false, _visual.hitzone2);
			//_bounce.useObjectShape = true;
			//_bounce.mask = _visual.hitzone;
			_bounce.scaleMod = 0.1;
			
			_bounce.signalOverTarget.add(mouseOver);
			_bounce.signalOutTarget.add(mouseOut);
			
			_clickFunction = clickFunction;
			if (_clickFunction != null) {
				_bounce.signalClickTarget.add(_clickFunction);
			}
			
			_visual.addEventListener(Event.ENTER_FRAME, forceBounceCheck);
			
			var rec:Rectangle = _visual.getBounds(_visual.parent);
		}
		
		override protected function mouseOver(target:DisplayObject):void {
			overSignal.dispatch(this);
			if (_isUnlocked) {
				DisplayObjectUtil.setObjectTint(_visual, 0xFFFFFF, 0.1);
			}else {
				DisplayObjectUtil.setObjectTint(_visual, 0xFFFFFF, 0.1);
			}
		}
		
		override protected function mouseOut(target:DisplayObject):void {
			outSignal.dispatch(this);
			if (_isUnlocked) {
				DisplayObjectUtil.setObjectTint(_visual, 0, 0);
			}else {
				DisplayObjectUtil.setObjectTint(_visual, 0, 0);
			}
		}
		
	}

}