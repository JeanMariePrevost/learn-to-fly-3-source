package src.game.hud 
{
	import flash.net.registerClassAlias;
	import flash.utils.getDefinitionByName;
	import lbg.debug.Log;
	import src.reg.Registry;
	import src.reg.RegistryEntry;
	/**
	 * ...
	 * @author 
	 */
	public class HudComponentEntry 
	{
		public var id:String;
		public var classString:String;
		public var x:Number;
		public var y:Number;
		public var scale:Number;
		public var rotation:Number;
		
		public function HudComponentEntry() 
		{
			registerClassAlias("RegistryEntry", RegistryEntry);
		}
		
		public function getClassOf():Class {
			var c:Class;
			try {
				c =  getDefinitionByName(classString) as Class;
			}catch (e:Error) {
				Log.log("HudComponentEntry.getClassOf ERROR - couldn't get class for string", classString);
				return HudComponent;
			}
			
			return c;
		}
		
		public function getNewInstanceOf():HudComponent {
			var hud:HudComponent;
			try {
				hud =  new (getClassOf() as Class)();
			}catch (e:Error) {
				Log.log("HudComponentEntry.getNewInstanceOf ERROR - couldn't create instance for a HudComponent");
				return new HudComponent();
			}
			
			return hud;
		}
		
		public function get entry():RegistryEntry {
			return Registry.getEntry(id);
		}
		
		public static function cast(obj:Object):HudComponentEntry {
			var e:HudComponentEntry = new HudComponentEntry();
			
			e.id = obj.id;
			e.classString = obj.classString;
			e.x = obj.x;
			e.y = obj.y;
			e.scale = obj.scale;
			e.rotation = obj.rotation;
			
			return e;
		}
		
		
	}

}