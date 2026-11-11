package src.game.gameobjects.player.body 
{
	import src.compound.Mod;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameMediator;
	import src.game.gameobjects.player.IPlayerGear;
	import src.game.gameobjects.ShapesData;
	import src.game.StatHooks;
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Volcano extends SimpleBody 
	{
		protected var _inFirstStage:Boolean;
		protected var _power:Number;
		protected var _powerDrop:Number;
		protected var _wrapper:DeltaMovieClipWrapper;
		
		protected var _stagePowerMod:Mod = new Mod();
		
		public function Volcano(gameState:GameState) 
		{
			super(gameState);
			
			createBody(ShapesData.getShapeListOf(item.statSpecialIds));
			
			_inFirstStage = true;
			_power = item.statPower;
			_powerDrop = item.statSpecial;
			_wrapper = new DeltaMovieClipWrapper(_movieClip);
			
			StatHooks.stagePowerMult.addMod(_stagePowerMod);
			
			GameMediator.stageFinished.addOnce(stageFinished);
		}
		
		protected function stageFinished(stage:IPlayerGear):void 
		{
			//trace("Stage finished, volcano disabled...");
			_inFirstStage = false;
			if(_wrapper) _wrapper.setToIdle();
			if(_stagePowerMod) _stagePowerMod.mul = _powerDrop;
		}
		
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (enableTicking && _inFirstStage) {
				if (isOutOfStages()) {
					stageFinished(null);
					return;
				}
				_wrapper.setToActive();
				_stagePowerMod.mul = _power;
			}
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new VolcanoVisual();
		}
		
	}

}