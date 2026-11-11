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
	public class ExtraFuel extends Brick 
	{
		protected var _stageFuelMod:Mod;
		protected var _boostFuelMod:Mod;
		
		public function ExtraFuel(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			_stageFuelMod = StatHooks.stageFuelMult.addMod2(_item.statPower);
			_boostFuelMod = StatHooks.boostFuelMult.addMod2(_item.statPower);
		}
		
		override public function destroy():void 
		{
			if (_stageFuelMod) _stageFuelMod.destroy();
			_stageFuelMod = null;
			
			if (_boostFuelMod) _boostFuelMod.destroy();
			_boostFuelMod = null;
			
			super.destroy();
		}
		
	}

}