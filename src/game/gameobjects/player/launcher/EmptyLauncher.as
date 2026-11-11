package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import lbg.compositetick.ICompositeLeaf;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.Main;
	import src.system.GameStateItem;
	/**
	 * ...
	 * @author 
	 */
	public class EmptyLauncher extends AbstractLauncher
	{
		protected var _countDown:Number = 60;
		
		public function EmptyLauncher(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
		}
		
		override public function tick(delta:Number):void 
		{
			if (_countDown > 0) {
				_countDown--;
			}else {
				countDownOver();
			}
		}
		
		protected function countDownOver():void {
			//Overwrite for effect
			finalizeTakeoff();
		}
		

		
	}

}