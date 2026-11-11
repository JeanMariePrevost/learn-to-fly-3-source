package src.system 
{
	import flash.net.registerClassAlias;
	/**
	 * ...
	 * @author 
	 */
	public class GameStateBonusItems 
	{
		public var bonusMoney:GameStateItem = GameStateItem.createFrom("bonusMoney", 0);
		public var bonusInterest:GameStateItem = GameStateItem.createFrom("bonusInterest", 0);
		public var bonusStagePower:GameStateItem = GameStateItem.createFrom("bonusStagePower", 0);
		public var bonusBoostPower:GameStateItem = GameStateItem.createFrom("bonusBoostPower", 0);
		public var bonusStageFuel:GameStateItem = GameStateItem.createFrom("bonusStageFuel", 0);
		public var bonusBoostFuel:GameStateItem = GameStateItem.createFrom("bonusBoostFuel", 0);
		public var bonusImpact:GameStateItem = GameStateItem.createFrom("bonusImpact", 0);
		public var bonusBpPerDay:GameStateItem = GameStateItem.createFrom("bonusBpPerDay", 0);
		public var bonusLaunchPower:GameStateItem = GameStateItem.createFrom("bonusLaunchPower", 0);
		public var bonusWind:GameStateItem = GameStateItem.createFrom("bonusWind", 0);
		public var bonusDrag:GameStateItem = GameStateItem.createFrom("bonusDrag", 0);
		public var bonusLessObstacles:GameStateItem = GameStateItem.createFrom("bonusLessObstacles", 0);
		public var bonusBetterStart:GameStateItem = GameStateItem.createFrom("bonusBetterStart", 0);
		public var bonusSpeed:GameStateItem = GameStateItem.createFrom("bonusSpeed", 0);
		public var bonusGravity:GameStateItem = GameStateItem.createFrom("bonusGravity", 0);
		public var bonusOverBodiesAndLaunchers:GameStateItem = GameStateItem.createFrom("bonusOverBodiesAndLaunchers", 0);
		public var bonusOverStages:GameStateItem = GameStateItem.createFrom("bonusOverStages", 0);
		public var bonusOverBoosts:GameStateItem = GameStateItem.createFrom("bonusOverBoosts", 0);
		public var bonusOver:GameStateItem = GameStateItem.createFrom("bonusOver", 0);
		public var bonusVCR:GameStateItem = GameStateItem.createFrom("bonusVCR", 0);
		//public var bonusOmega:GameStateItem = GameStateItem.createFrom("bonusOmega", 0);
		//public var bonusRudder:GameStateItem = GameStateItem.createFrom("bonusRudder", 0);
		
		
		public function GameStateBonusItems() 
		{
			registerClassAlias("GameStateBonusItems", GameStateBonusItems);
		}
		
		public function destroy():void {
			bonusMoney.destroy();
			bonusInterest.destroy();
			bonusStagePower.destroy();
			bonusBoostPower.destroy();
			bonusStageFuel.destroy();
			bonusBoostFuel.destroy();
			bonusImpact.destroy();
			bonusBpPerDay.destroy();
			bonusLaunchPower.destroy();
			bonusWind.destroy();
			bonusDrag.destroy();
			bonusLessObstacles.destroy();
			bonusBetterStart.destroy();
			bonusGravity.destroy();
			bonusOverBodiesAndLaunchers.destroy();
			bonusOverStages.destroy();
			bonusOverBoosts.destroy();
			bonusOver.destroy();
			bonusVCR.destroy();
			//bonusOmega.destroy();
			
			bonusMoney = null;
			bonusInterest = null;
			bonusStagePower = null;
			bonusBoostPower = null;
			bonusStageFuel = null;
			bonusBoostFuel = null;
			bonusImpact = null;
			bonusBpPerDay = null;
			bonusLaunchPower = null;
			bonusWind = null;
			bonusDrag = null;
			bonusLessObstacles = null;
			bonusBetterStart = null;
			bonusGravity = null;
			bonusOverBodiesAndLaunchers = null;
			bonusOverStages = null;
			bonusOverBoosts = null;
			bonusOver = null;
			bonusVCR = null;
			//bonusOmega = null;
		}
		
	}

}