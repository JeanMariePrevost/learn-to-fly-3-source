package src.game.gameobjects.player.stage 
{
	import src.game.gameobjects.player.body.SimpleBody;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	/**
	 * ...
	 * @author 
	 */
	public class WaitStage extends SimpleStage 
	{
		
		//public function WaitStage(player:Player, fuel:Number = 30) 
		public function WaitStage(player:Player, item:GameStateItem) 
		{
			super(player, item);
			//this.fuel = fuel;
			maxFuel = 50;
			fuel = maxFuel;
			power = 0;
		}
		
	}

}