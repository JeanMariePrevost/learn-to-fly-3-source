package src.shop.medals 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import lbg.utils.DisplayObjectUtil;
	import org.osflash.signals.Signal;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	import src.Main;
	import src.gui.decorators.NullMouseBounce2;
	import src.reg.Registry;
	import src.reg.RegistryEntry;
	/**
	 * ...
	 * @author 
	 */
	public class MedalButton 
	{
		public var overSignal:Signal = new Signal(MedalButton);
		public var outSignal:Signal = new Signal(MedalButton);
		
		protected var _id:String;
		protected var _visual:MovieClip;
		protected var _bounce:MouseBounce2;
		protected var _isUnlocked:Boolean;
		protected var _clickFunction:Function;
		
		public function MedalButton(id:String, frame:int, unlockedStatus:int, clickFunction:Function = null) 
		{
			_id = id;
			init(id, frame, unlockedStatus, clickFunction);
		}
		
		protected function init(id:String, frame:int, unlockedStatus:int, clickFunction:Function = null):void {
			_visual = new (entry.gameClass.valueAt(0))();
			_visual.gotoAndStop(frame);
			_visual.filters = [new GlowFilter(0x000000, 0.8, 15, 15, 1.1, 1, true), new GlowFilter(0x000000, 1, 3.5, 3.5, 7, 1), new DropShadowFilter(16, 60, 0, 0.2, 5, 5, 1, 1)];
			_visual.cacheAsBitmap = true;
			
			_bounce = new MouseBounce2(_visual);
			_bounce.scaleMod = 0.2;
			
			_bounce.signalOverTarget.add(mouseOver);
			_bounce.signalOutTarget.add(mouseOut);
			
			_clickFunction = clickFunction;
			if (_clickFunction != null) {
				_bounce.signalClickTarget.add(_clickFunction);
			}
			
			if (unlockedStatus < frame) {
				//Not earned
				_isUnlocked = false;
				var f:Array = _visual.filters;
				f.unshift(DisplayObjectUtil.getObjectSaturationFilter(0, 0));
				DisplayObjectUtil.setObjectTint(_visual, 0, 1);
				_visual.filters = f;
			}else {
				//Earned
				DisplayObjectUtil.setObjectTint(_visual, 0, 0);
				_isUnlocked = true;
			}
			
			_visual.addEventListener(Event.ENTER_FRAME, forceBounceCheck);
			
			var rec:Rectangle = _visual.getBounds(_visual.parent);
			//rec.inflate(5, 5);
			var hitArea:Sprite = new Sprite();
			_visual.addChild(hitArea);
			hitArea.graphics.beginFill(0, 0);
			hitArea.graphics.drawRect(rec.left, rec.top, rec.width, rec.height);
			hitArea.graphics.endFill();
			_visual.hitArea = hitArea;
		}
		
		protected function forceBounceCheck(e:Event):void {
			_bounce.checkMousePosition();
		}
		
		protected function mouseOver(target:DisplayObject):void {
			overSignal.dispatch(this);
			if (_isUnlocked) {
				DisplayObjectUtil.setObjectTint(_visual, 0xFFFFFF, 0.1);
			}else {
				DisplayObjectUtil.setObjectTint(_visual, 0, 0.95);
			}
		}
		
		protected function mouseOut(target:DisplayObject):void {
			outSignal.dispatch(this);
			if (_isUnlocked) {
				DisplayObjectUtil.setObjectTint(_visual, 0, 0);
			}else {
				DisplayObjectUtil.setObjectTint(_visual, 0, 1);
			}
		}
		
		public function get entry():RegistryEntry {
			return Registry.getEntry(_id);
		}
		
		public function get visual():MovieClip 
		{
			return _visual;
		}
		
		public function get isUnlocked():Boolean 
		{
			return _isUnlocked;
		}
		
		public function destroy():void {
			if(overSignal) overSignal.removeAll();
			overSignal = null;
			
			if(outSignal) outSignal.removeAll();
			outSignal = null;
			
			if (_bounce) _bounce.destroy();
			_bounce = null;
			
			_clickFunction = null;
			
			if (_visual) {
				_visual.removeEventListener(Event.ENTER_FRAME, forceBounceCheck);
				if (_visual.stage) _visual.parent.removeChild(_visual);
				while (_visual.numChildren >= 1) _visual.removeChildAt(0);
			}
			_visual = null;
		}
		
	}

}