package src.game.gameobjects.player.boost 
{
	import src.game.gameobjects.player.Player;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class CashDrive extends AuxiliaryRocket 
	{
		
		public function CashDrive(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			StatHooks.moneyMult.addMod2(0, item.statSpecial);
		}
		
	}

}