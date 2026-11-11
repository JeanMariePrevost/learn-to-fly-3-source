package src.game.gameobjects.player.body 
{
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Bullet extends SimpleBody 
	{
		
		public function Bullet(gameState:GameState) 
		{
			visualClass = BulletVisual1;
			
			super(gameState);
			
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new BulletVisual1();
		}
		
	}

}