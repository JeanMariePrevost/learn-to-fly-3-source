package src.game.hud 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.net.registerClassAlias;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import src.game.hud.huds.*;
	import src.reg.Registry;
	import src.reg.RegistryEntry;
	/**
	 * ...
	 * @author 
	 */
	public class HudComponentList 
	{
		public var list:Array = new Array();
		
		public function HudComponentList() 
		{
			registerClassAlias("HudComponentList", HudComponentList);
			registerClassAlias("Number", HudComponentEntry);
			
			//trace("HudComponentList()", list);
		}
		
		public static function getDefaultList():HudComponentList {
			var list:HudComponentList = new HudComponentList();
			
			list.addComponent(Registry.getEntry("speedNeedle"), 572, 474, 1, 0);
			list.addComponent(Registry.getEntry("dragNeedle"), 695, 333, 1, 0);
			list.addComponent(Registry.getEntry("altitudeNeedle"), 679, 456, 1, 0);
			
			return list;
		}
		
		/**
		 * Add an entry to the list of Huds to display in game
		 * @param	hudClass
		 * @param	x
		 * @param	y
		 * @param	scale
		 */
		public function addComponent(hudEntry:RegistryEntry, x:Number, y:Number, scale:Number, rotation:Number):void {
			var e:HudComponentEntry = new HudComponentEntry();
			e.classString = getQualifiedClassName(hudEntry.gameClass.valueAt(0));
			e.id = hudEntry.id;
			e.x = x;
			e.y = y;
			e.scale = scale;
			e.rotation = rotation;
			list.push(e);
		}
		
		public function addFromMovieClip(movieClip:MovieClip, hudEntry:RegistryEntry):void {
			var e:HudComponentEntry = new HudComponentEntry();
			e.classString = getQualifiedClassName(hudEntry.gameClass.valueAt(0));
			e.id = hudEntry.id;
			e.x = movieClip.x;
			e.y = movieClip.y;
			e.scale = movieClip.scaleX;
			e.rotation = movieClip.rotation;
			list.push(e);
			//trace("addFromMovieClip()", list);
		}
		
		public function clearList():void {
			
			list.length = 0;
		}
		
		public function getEntry(index:uint):HudComponentEntry {
			//var e:HudComponentEntry = (list[index] as HudComponentEntry);
			var e:HudComponentEntry = HudComponentEntry.cast(list[index]);
			return e;
		}

		
		public function get length():int {
			return list.length;
		}
		
		public function destroy():void {
			if (list) list.length = 0;
			list = null;
			
		}
		
	}

}