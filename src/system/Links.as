package src.system 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	/**
	 * ...
	 * @author 
	 */
	public class Links 
	{
		public static function linkFacebook():void {
		}
		
		public static function linkLBG():void {
		}
		
		public static function linkSubreddit():void {
		}
		
		public static function linkEasterEgg1():void {
		}
		
		public static function linkEasterEgg2():void {
		}
		
		public static function linkEasterEgg3():void {
		}
		
		public static function linkEasterEgg4():void {
		}

		public static function rebuildRightClickMenu(stg:DisplayObjectContainer):void {
			var myMenu:ContextMenu = new ContextMenu();
			myMenu.hideBuiltInItems();
			
			stg.contextMenu = myMenu;
		}
		
		//Versions callabled from an event
		public static function linkFacebook2(e:Event):void {
			linkFacebook();
		}
		
		public static function linkLBG2(e:Event):void {
			linkLBG();
		}
		
		public static function linkSubreddit2(e:Event):void {
			linkSubreddit();
		}

	}
		
}