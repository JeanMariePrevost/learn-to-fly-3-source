package src.gui 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author 
	 */
	public class OptionsSlider extends MovieClip 
	{
		public var fill:MovieClip;
		
		protected var _changeSignal:Signal = new Signal(Number);
		protected var _norm:Number = 1;
		
		public function OptionsSlider() 
		{
			super();
			fill.gotoAndStop(fill.totalFrames);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		
		public function get value():Number {
			return _norm;
		}
		
		public function set value(value:Number):void {
			_norm = value;
			fill.gotoAndStop(Math.round(NumberUtils.interpolate(1, fill.totalFrames, _norm)));
		}
		
		protected function onDown(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			onMove(e);//Refresh once already
		}
		
		protected function onUp(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		protected function onMove(e:MouseEvent):void 
		{
			var p:Point = new Point(e.stageX, e.stageY);
			p = fill.globalToLocal(p);
			
			_norm = NumberUtils.constrain(p.x / fill.width);
			
			fill.gotoAndStop(Math.round(NumberUtils.interpolate(1, fill.totalFrames, _norm)));
			
			_changeSignal.dispatch(_norm);
		}
		
		public function get changeSignal():Signal 
		{
			return _changeSignal;
		}
		
		public function destroy():void {
			fill = null;
			if(_changeSignal) _changeSignal.removeAll();
			_changeSignal = null;
			
			if (stage) parent.removeChild(this);
			while (numChildren) removeChildAt(0);
		}
		
		
		
		
		
	}

}