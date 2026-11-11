package src.game.gameobjects.player.body 
{
	import src.compound.Mod;
	import src.game.StatHooks;
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Hedgehog extends SimpleBody 
	{
		protected var _moneyMult:Mod;
		
		public function Hedgehog(gameState:GameState) 
		{
			super(gameState);
			
			_moneyMult = new Mod(0, _item.statSpecial);
			
			StatHooks.moneyMult.addMod(_moneyMult);
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new HedgehogVisual();
		}
		
	}

}