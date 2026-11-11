package src.game.gameobjects.player.stage 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ShuttleReactor extends SimpleStage 
	{
		protected var _baseScale:Number = 1;
		
		public function ShuttleReactor(player:Player, item:GameStateItem) 
		{
			super(player, item);
			//_thrustOffsetVec2.y = -0.5;
			
		}
		
		override public function startStage():void 
		{
			super.startStage();
			
			_baseScale = _visual.fire.scaleX;
		}
		
		override protected function applyPower(delta:Number, forceThrustRelativeAngle:Number = NaN):void 
		{
			if(_visual.fire) _visual.fire.visible = true;
			super.applyPower(delta);
			if(_visual.fire) _visual.fire.scaleX = _baseScale + NumberUtils.randomBoth(0.1);
			if(_visual.fire) _visual.fire.scaleY = _baseScale + NumberUtils.randomBoth(0.25);
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			if (fuel > 0) {
				if (Input.metaDown.isDown) {
					//Player manually pausing stage
					if(_visual.fire) _visual.fire.visible = false;
					
				}
			}else {
				if (_visual) {
					if ("fire" in _visual)_visual.fire.visible = false;
				}
			}
		}
	}

}