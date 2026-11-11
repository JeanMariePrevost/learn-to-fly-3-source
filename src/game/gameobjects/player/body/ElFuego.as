package src.game.gameobjects.player.body 
{
	import lbg.utils.NumberUtils;
	import src.compound.Mod;
	import src.game.StatHooks;
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ElFuego extends SimpleBody 
	{
		protected var fuel:Number;
		protected var power:Number;
		
		protected var _stagePowerMod:Mod = new Mod();
		
		public function ElFuego(gameState:GameState) 
		{
			super(gameState);
			
			fuel = item.statFuel;
			power = item.statPower;
			
			_stagePowerMod.mul = power;
			StatHooks.stagePowerMult.addMod(_stagePowerMod);
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new ElFuegoVisual();
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (power == 0 || !enableTicking) return;
			
			_movieClip.gotoAndStop(Math.ceil(NumberUtils.interpolate2(1, _movieClip.totalFrames, item.statFuel, 0, fuel)));
			
			if (fuel >= 1) {
				fuel -= delta;
				//_stagePowerMod.mul = power;
			}else {
				power = 0;
				_stagePowerMod.mul = 1;
				StatHooks.stagePowerMult.removeMod(_stagePowerMod);
			}
		}
		
	}

}