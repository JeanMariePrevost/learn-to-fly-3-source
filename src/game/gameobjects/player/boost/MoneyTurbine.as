package src.game.gameobjects.player.boost 
{
	import lbg.utils.NumberUtils;
	import src.Main;
	import src.compound.Mod;
	import src.game.GameMediator;
	import src.game.gameobjects.player.Player;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class MoneyTurbine extends Brick 
	{
		protected const BASE_MONEY_MULT:Number = 0.0035;
		protected const FULL_POWER_SPEED:Number = 15;
		protected const UNDER_COST_BONUS:Number = 1.15;//If earned less than cost, earn slightly more
		protected const OVER_COST_DEBUFF:Number = 0.6;//If earned more than cost, earn slightly less, max at twice the cost
		protected const FIXED_DRAG:Number = 0.001;
		
		protected var _totalMovement:Number = 0;
		protected var _cashMod:Mod = new Mod();
		
		public function MoneyTurbine(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			GameMediator.updatePlayerSpeed.add(onPlayerSpeed);
			StatHooks.moneyFlat.addMod(_cashMod);
		}
		
		protected function onPlayerSpeed(speed:Number, angleInDegrees:Number):void {
			var change:Number = NumberUtils.interpolate2(speed * Main.instance.lastDelta * 0.25, speed * Main.instance.lastDelta, 0, FULL_POWER_SPEED, speed, 0.5, true);
			var cashEarned:Number = _totalMovement * BASE_MONEY_MULT * _item.statPower;
			if (cashEarned <= _item.statCost) {
				//Earned back less than cost, give bonus
				change *= NumberUtils.interpolate2(UNDER_COST_BONUS, 1, 0, _item.statCost, cashEarned, 0.85, true);
			}else {
				//Earned more than its cost, reduce gains slightly
				change *= NumberUtils.interpolate2(1, OVER_COST_DEBUFF, _item.statCost, _item.statCost*2, cashEarned, 1.2, true);
			}
			
			var drag:Number = 1 - (FIXED_DRAG * Main.instance.lastDelta);
			_player.applyDrag(drag);
			
			_totalMovement += change;
			cashEarned = _totalMovement * BASE_MONEY_MULT * _item.statPower;
			_cashMod.add = cashEarned;
			
			//trace("Money turbine:", cashEarned.toFixed(1), "total,", (change * BASE_MONEY_MULT * _item.statPower).toFixed(1), "now");
		}
		
	}

}