package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class UfoDebrisLayer 
	{
		protected const DEBRIS_COUNT:uint = 20;
		
		protected var _visual:Sprite = new Sprite();
		protected var _debris:Vector.<UfoDebris> = new Vector.<UfoDebris>();
		
		public function UfoDebrisLayer() 
		{
			super();
		}
		
		public function get visual():Sprite 
		{
			return _visual;
		}
		
		
		public function start():void {
			Main.unsafeTickSignal.add(tick);
			while (_debris.length < DEBRIS_COUNT) {
				var d:MovieClip = new UfoDebris();
				_debris.push(d);
				_visual.addChild(d);
			}
		}
		
		public function stop():void {
			Main.unsafeTickSignal.remove(tick);
			Main.unsafeTickSignal.add(tickFall);
		}
		
		protected function tick(delta:Number):void {
			for each(var d:UfoDebris in _debris) {
				d.tickUp(delta);
			}
		}
		
		protected function tickFall(delta:Number):void {
			var finished:Boolean = true;
			for each(var d:UfoDebris in _debris) {
				d.tickDown(delta);
				if (d.isFinished == false) {
					finished = false;
				}
			}
			
			if (finished) {
				destroy();
			}
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			Main.unsafeTickSignal.remove(tickFall);
			
			if (_visual) {
				while (_visual.numChildren >= 1) _visual.removeChildAt(0);
				if (_visual.stage) _visual.parent.removeChild(_visual);
			}
			
			_debris = null;
		}
		
		
	}

}