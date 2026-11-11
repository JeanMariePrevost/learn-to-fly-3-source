package src.game.gameobjects.player.boost 
{
	import src.compound.Mod;
	import src.game.gameobjects.player.Player;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class NegativeMass extends Brick 
	{
		protected var _weightMod:Mod;
		
		public function NegativeMass(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			_weightMod = StatHooks.weightMult.addMod2(0, _item.statPower);
		}
		
	}

}