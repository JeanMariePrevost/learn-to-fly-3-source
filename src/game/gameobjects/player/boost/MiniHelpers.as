package src.game.gameobjects.player.boost 
{
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MiniHelpers extends SimpleBoost 
	{
		protected var _finished:Boolean = false;
		
		public function MiniHelpers(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			leftWrapper.gotoLabel("idleStart");
			rightWrapper.gotoLabel("idleStart");
			
		}
		
		
		override public function tick(delta:Number):void 
		{
			if(!_finished){
				if (fuel.value > 0) {
					playSound();
					leftWrapper.setToActive();
					rightWrapper.setToActive();
					applyThrust(delta);
					_preventDayEnd = true;
				}else {
					stopSound(600);
					leftWrapper.gotoLabel("deathStart");
					rightWrapper.gotoLabel("deathStart");
					_preventDayEnd = false;
					_finished = true;
				}
				
				_hudSignal.dispatch(fuel.value / maxFuel);
			}else {
				//Do nothing
			}
		}
		
		
	}

}