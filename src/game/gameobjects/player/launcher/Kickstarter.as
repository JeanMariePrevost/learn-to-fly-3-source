package src.game.gameobjects.player.launcher 
{
	import lbg.utils.NumberUtils;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class Kickstarter extends Catapult 
	{
		
		public function Kickstarter(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			
		}
		
		
		override protected function launchPlayer():void 
		{
			movePlayerOnTarget(tCatapult);
			var power:Number = launcherBasePower;
			var powerAtWeight:Number = powerAtCurrentWeight;
			var crankPowerMult:Number = NumberUtils.interpolate2(0.1, 1, 0, CRANK_TO_FULL_POWER, _catapultCrankTotal, 2, true);
			power *= crankPowerMult;
			
			_player.getMovieClip().visible = true;
			
			//trace("Catapult crank:", crankPowerMult, "Power:", power, "PowerAtWeight:", powerAtWeight);
			
			//_player.applyThrust(power * powerAtWeight);
			
			applyLauncherThrust(power * powerAtCurrentWeight, 45, true);
		}
	}

}