package src.shop 
{
	import com.hybrid.ui.ToolTip;
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import lbg.debug.Log;
	import lbg.utils.VectorUtils;
	/**
	 * ...
	 * @author 
	 */
	public class ShopTooltip 
	{
		protected static const ONLY_ALLOW_ONE_TOOLTIP:Boolean = true;//Hides all other tt when creating a new one
		protected static var _tooltips:Vector.<ToolTip> = new Vector.<ToolTip>();
		
		public static function hideAll():void {
			cleanDeadTooltips();
			
			for each(var tt:ToolTip in _tooltips) {
				tt.hide();
			}
		}
		
		public static function show(container:DisplayObject, title:String = "", message:String = ""):ToolTip {
			var tt:ToolTip = getNewTooltip();
			tt.bgAlpha = 1;
			tt.colors = [0xFFFFFF, 0x9C9C9C];
			
			tt.show(container, title, message);
			
			return tt;
		}
		
		public static function showGreen(container:DisplayObject, title:String = "", message:String = ""):ToolTip {
			var tt:ToolTip = getNewTooltip();
			tt.bgAlpha = 1;
			lastTooltip.colors = [0xAAFFAA, 0x4C9C4C];
			
			tt.show(container, title, message);
			
			return tt;
		}
		
		public static function showRed(container:DisplayObject, title:String = "", message:String = ""):ToolTip {
			var tt:ToolTip = getNewTooltip();
			tt.bgAlpha = 1;
			lastTooltip.colors = [0xFFDDCC, 0xBB4444];
			
			tt.show(container, title, message);
			
			return tt;
		}
		
		protected static function get lastTooltip():ToolTip {
			if (_tooltips == null || _tooltips.length <= 0) return null;
			
			var tt:ToolTip = _tooltips[0];
			
			if (tt == null) {
				tt = new ToolTip();
				tt.hook = true;
				tt.hookSize = 5;
				tt.cornerRadius = 5;
				tt.autoSize = true;
				tt.buffer = 5;
				tt.align = TextFormatAlign.CENTER;
				tt.titleFormat = new TextFormat(null,16, null, false, null,null,null,null,TextFormatAlign.CENTER);
				tt.contentFormat = new TextFormat(null,15, null, false, null,null,null,null,TextFormatAlign.CENTER);
			}
			
			return tt;
		}
		protected static function getNewTooltip():ToolTip {
			if (ONLY_ALLOW_ONE_TOOLTIP) hideAll();
			cleanDeadTooltips();
			
			var tt:ToolTip = new ToolTip();
			tt.hook = true;
			tt.hookSize = 5;
			tt.cornerRadius = 5;
			tt.autoSize = true;
			tt.buffer = 5;
			tt.align = TextFormatAlign.CENTER;
			tt.titleFormat = new TextFormat(null,16, null, false, null,null,null,null,TextFormatAlign.CENTER);
			tt.contentFormat = new TextFormat(null, 15, null, false, null, null, null, null, TextFormatAlign.CENTER);
			
			_tooltips.unshift(tt);
			
			return tt;
		}
		
		protected static function cleanDeadTooltips():void {
			var listCopy:Vector.<ToolTip> = _tooltips.concat();
			
			for each(var tt:ToolTip in listCopy) {
				if (tt.isOn == false && tt.parent == null) {
					VectorUtils.removeFromVector(_tooltips, tt);
				}
			}
		}
		
	}

}