package src.shop 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lbg.utils.DisplayObjectUtil;
	import src.gui.decorators.MouseBounce;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class SortButton extends MovieClip 
	{
		public static const EVENT_SORT_BY_PRICE:String = "price";
		public static const EVENT_SORT_BY_NAME:String = "name";
		public static const EVENT_SORT_BY_MAGIC:String = "magic";
		
		public function SortButton() 
		{
			gotoAndStop(1);
			
			switch(ProfileState.instance.shopSortMethod) {
				case SortButton.EVENT_SORT_BY_PRICE:
					gotoAndStop(1);
					break;
				case SortButton.EVENT_SORT_BY_NAME:
					gotoAndStop(2);
					break;
				case SortButton.EVENT_SORT_BY_MAGIC:
					gotoAndStop(3);
					break;
				default:
					gotoAndStop(1);
				break;
			}
			
			addEventListener(MouseEvent.ROLL_OVER, rollOver);
			addEventListener(MouseEvent.ROLL_OUT, rollOut);
			addEventListener(MouseEvent.CLICK, click);
		}
		
		private function click(e:MouseEvent):void 
		{
			switch(ProfileState.instance.shopSortMethod) {
				case EVENT_SORT_BY_PRICE:
					ProfileState.instance.shopSortMethod = EVENT_SORT_BY_NAME;
					gotoAndStop(2);
					break;
				case EVENT_SORT_BY_NAME:
					ProfileState.instance.shopSortMethod = EVENT_SORT_BY_MAGIC;
					gotoAndStop(3);
					break;
				case EVENT_SORT_BY_MAGIC:
					ProfileState.instance.shopSortMethod = EVENT_SORT_BY_PRICE;
					gotoAndStop(1);
					break;
				default:
					//Error
					ProfileState.instance.shopSortMethod = EVENT_SORT_BY_PRICE;
					gotoAndStop(1);
					break;
			}
			
			dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		private function rollOut(e:MouseEvent):void 
		{
			DisplayObjectUtil.setObjectTint(this, 0x00FF00, 0);
		}
		
		private function rollOver(e:MouseEvent):void 
		{
			DisplayObjectUtil.setObjectTint(this, 0x00FF00, 0.5);
		}
		
		public function destroy():void {
			removeEventListener(MouseEvent.ROLL_OVER, rollOver);
			removeEventListener(MouseEvent.ROLL_OUT, rollOut);
			removeEventListener(MouseEvent.CLICK, click);
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}