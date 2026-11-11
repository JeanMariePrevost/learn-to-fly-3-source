package src.shop {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import src.Main;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class QuickCopyIcon extends MovieClip 
	{
		protected var _p:Point = new Point();
		
		public function QuickCopyIcon() 
		{
			super();
			
			mouseEnabled = false;
			mouseChildren = false;
			
			filters = [new GlowFilter(0, 1, 3, 3, 2, 1)];
			
			hide();
			
			Main.unsafeTickSignal.add(tick);
			//Input.instance.basicCommands.shift.signalCommandDown.add(show);
			//Input.instance.basicCommands.shift.signalCommandUp.add(hide);
		}
		
		
		protected function tick(delta:Number):void {
			if (stage && parent) {
				_p.x = stage.mouseX;
				_p.y = stage.mouseY;
				_p = parent.globalToLocal(_p);
				x = _p.x;
				y = _p.y;
			}
			
			if (Input.instance.basicCommands.shift.isDown) {
				show();
			}else {
				hide();
			}
		}
		
		protected function show():void {
			visible = true;
		}
		
		protected function hide():void {
			visible = false;
		}
		
		public function destroy():void {
			_p = null;
			
			Main.unsafeTickSignal.remove(tick);
			Input.instance.basicCommands.shift.signalCommandDown.remove(show);
			Input.instance.basicCommands.shift.signalCommandUp.remove(hide);
			
			while (numChildren >= 1) removeChildAt(0);
			if (stage) parent.removeChild(this);
		}
		
	}

}