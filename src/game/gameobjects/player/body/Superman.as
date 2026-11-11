package src.game.gameobjects.player.body 
{
	import src.game.DeltaMovieClipWrapper;
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Superman extends SimpleBody 
	{
		protected var _wrapper:DeltaMovieClipWrapper;
		
		
		public function Superman(gameState:GameState) 
		{
			super(gameState);
			
			_wrapper = new DeltaMovieClipWrapper(_movieClip);
			
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (enableTicking && _movieClip.currentFrame <= 1) {
				_wrapper.gotoLabel("activeStart");
			}
			_wrapper.tick(delta);
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new SupermanVisual();
		}
		
	}

}