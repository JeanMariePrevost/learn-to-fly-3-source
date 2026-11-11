package src.game.gameobjects.player.boost 
{
	import src.compound.Mod;
	import src.game.DeltaMovieClipWrapper;
	import src.game.gameobjects.player.Player;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class Fins extends Brick 
	{
		protected var _windMod:Mod;
		protected var _speedMod:Mod;
		protected var _controlMod:Mod;
		protected var _controlMod2:Mod;
		
		protected const FLAT_TORQUE_BONUS:Number = 0.02;
		
		public function Fins(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			_windMod = StatHooks.windEffectMult.addMod2(0, _item.statPower);
			//_speedMod = StatHooks.topSpeedMult.addMod2(0, _item.statFuel);
			//_controlMod = StatHooks.rudderMult.addMod2(0, _item.statTorque);
			_speedMod = StatHooks.topSpeedFlat.addMod2(_item.statFuel, 0);
			_controlMod = StatHooks.rudderMult.addMod2(_item.statTorque, 0);
			_controlMod2 = StatHooks.rudderFlat.addMod2(Math.max(0, _item.statTorque - 1) * FLAT_TORQUE_BONUS, 0);
		}
		
		override protected function setupVisual():void {
			leftVisual = new _item.statVisualClass();
			leftWrapper = new DeltaMovieClipWrapper(leftVisual);
			_player.getMovieClip().addChildAt(leftVisual, 0);//Add child BEHIND body
			//_player.getMovieClip().addChild(leftVisual);//Add child IN FRONT OF body

			rightVisual = new _item.statVisualClass();
			rightVisual.scaleY = -1;//Flip around
			rightWrapper = new DeltaMovieClipWrapper(rightVisual);
			_player.getMovieClip().addChildAt(rightVisual, 0);//Add child BEHIND body
			//_player.getMovieClip().addChild(rightVisual);//Add child IN FRONT OF body
		}
		
		override public function destroy():void 
		{
			if (_windMod) _windMod.destroy();
			_windMod = null;
			
			if (_speedMod) _speedMod.destroy();
			_speedMod = null;
			
			if (_controlMod) _controlMod.destroy();
			_controlMod = null;
			
			if (_controlMod2) _controlMod2.destroy();
			_controlMod2 = null;
			
			super.destroy();
		}
		
	}

}