package src.game.hud 
{
	import com.gskinner.geom.ColorMatrix;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import src.UiScaler;
	import src.game.hud.huds.*
	import src.gui.decorators.TweenPos;
	import src.gui.GuiSettings;
	
	/**
	 * Holds and add to display list the various customizable Hud components 
	 * @author 
	 */
	public class Hud extends Sprite 
	{
		protected static const HUD_OFFSET_AT_START:Number = 1000;//How far down to hide the huds
		protected static var _instance:Hud;
		
		protected var _list:HudComponentList;
		protected var _components:Vector.<HudComponent> = new Vector.<HudComponent>();
		protected var _shown:Boolean = false;
		
		public function Hud(hudComponentList:HudComponentList) 
		{
			super();
			
			if (_instance) {
				throw new Error("Hud Error - duplicate instance");
			}
			
			_instance = this;
			
			_list = hudComponentList;
			
			loadHudComponents();
			
			y = HUD_OFFSET_AT_START;
			
		}
		
		public function show():void {
			if (!_shown) {
				TweenPos.tweenFromCurrentPosition(this, new Point(0, -HUD_OFFSET_AT_START), 70, 0, TweenPos.EASE_OUT_QUINT);
				
				for each(var h:HudComponent in _components) {
					h.init();
				}
			}
		}
		
		protected function loadHudComponents():void {
			for (var i:int = 0; i < _list.length; i++) {
				var e:HudComponentEntry = _list.getEntry(i);
				var c:HudComponent = e.getNewInstanceOf();
				c.x = e.x;
				c.y = e.y;
				c.scaleX = c.scaleY = e.scale;
				c.rotation = e.rotation;
				addChild(c);
				_components.push(c);
			}
		}
		
		static public function get instance():Hud 
		{
			return _instance;
		}
		
		public function destroy():void {
			_instance = null;
			
			if (_components) {
				for each(var c:HudComponent in _components) c.destroy();
				_components.length = 0;
			}
			_components = null;
			
			_list = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}