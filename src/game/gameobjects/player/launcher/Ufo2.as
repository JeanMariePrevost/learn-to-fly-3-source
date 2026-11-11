package src.game.gameobjects.player.launcher 
{
	import com.gskinner.geom.ColorMatrix;
	import flash.filters.ColorMatrixFilter;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class Ufo2 extends Ufo 
	{
		
		public function Ufo2(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			
			var cm:ColorMatrix = new ColorMatrix();
			cm.adjustColor(0, 10, 20, -40);//Turn beam yellow
			//cm.adjustColor(-40, 30, 90, -105);//Turn beam red
			beam.filters = [new ColorMatrixFilter(cm)];
		}
		
	}

}