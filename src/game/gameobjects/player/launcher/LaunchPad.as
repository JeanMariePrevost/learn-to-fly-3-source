package src.game.gameobjects.player.launcher 
{
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author ...
	 */
	public class LaunchPad extends Coil 
	{
		protected var _countDown:Number = 70;
		
		public function LaunchPad(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			
			scaleX = scaleY = 3;
			
			//StatHooks.boostFuelMult.addMod2(item.statFuel - 1);
			StatHooks.stageFuelMult.addMod2(item.statFuel - 1);
			
			
			movePlayerOnTarget(tracer);
			
		}
		
		override public function tick(delta:Number):void {
			if (_player == null) return;
			
			_countDown -= delta;
			
			GameEngine.instance.addChildToMovingLayer(this, -2);
			movePlayerOnTarget(tracer);
			
			if (!_launched && _countDown <= 0) {
				_launched = true;
				//playSoundEffect();
				finalizeTakeoff();
				finalizeLauncher();
			}
		}
		
		override protected function applyPower():void {
			//Nothing
		}
		
	}

}