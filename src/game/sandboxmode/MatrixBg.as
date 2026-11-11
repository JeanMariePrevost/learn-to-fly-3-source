package src.game.sandboxmode 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lbg.utils.NumberUtils;
	import lbg.utils.VectorUtils;
	import src.Main;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class MatrixBg extends Sprite 
	{
		
		protected var _duration:Number = 90;
		protected var _time:Number = 0;
		
		protected var _chains:Vector.<MatrixBgChain> = new Vector.<MatrixBgChain>();
		
		public function MatrixBg() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			Main.unsafeTickSignal.add(tick);
		}
		
		protected function tick(delta:Number):void {
			if(ProfileState.instance.optionSmoke == "Off") return;
			
			if (_time >= _duration) {
				_time = 0;
				newChain();
			}else {
				_time += delta;
			}
		}
		
		protected function newChain():void {
			//trace("New chain!");
			var chain:MatrixBgChain = new MatrixBgChain();
			chain.x = NumberUtils.randomRange( -20, 740);
			chain.y = -40;
			addChild(chain);
			_chains.push(chain);
			chain.addEventListener("destroy", chainDestroyed);
		}
		
		private function chainDestroyed(e:Event):void 
		{
			var chain:MatrixBgChain = e.target as MatrixBgChain;
			chain.removeEventListener("destroy", chainDestroyed);
			VectorUtils.removeFromVector(_chains, chain);
		}
		
		public function destroy():void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			Main.unsafeTickSignal.remove(tick);
			
			if (_chains) {
				for each(var c:MatrixBgChain in _chains) {
					c.destroy();
				}
				_chains.length = 0;
			}
			_chains = null;
			
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}