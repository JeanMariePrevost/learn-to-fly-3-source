package src.game.gameobjects.player.stage 
{
	import flash.display.MovieClip;
	import nape.geom.Vec2;
	import src.audio.Audio;
	import src.audio.ISound;
	import src.game.DeltaMovieClipWrapper;
	import src.game.gameobjects.FallingObject;
	import src.game.gameobjects.player.Player;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	import org.osflash.signals.Signal;
	import src.game.gameobjects.player.IPlayerGearWithHud;
	import src.system.Input;
	/**
	 * ...
	 * @author 
	 */
	public class SimpleStage extends AbstractStage  
	{
		protected var _visual:MovieClip;
		protected var _wrapper:DeltaMovieClipWrapper;
		
		public function SimpleStage(player:Player, item:GameStateItem) 
		{
			super(player, item);
		}
		
		override public function startStage():void 
		{
			super.startStage();
			_visual = new (_item.statVisualClass)();
			_wrapper = new DeltaMovieClipWrapper(_visual, "initStart");
			
			_player.getMovieClip().addChildAt(_visual, 0);//Add child BEHIND body
			_visual.x = _player.tCenter.x;
			_visual.y = _player.tCenter.y;
		}
		
		override public function tick(delta:Number):void 
		{
			_isStoppedByPlayer = false;
			if (fuel > 0) {
				if (Input.metaDown.isDown) {
					//Player manually pausing stage
					_wrapper.setToOff();
					_isStoppedByPlayer = true;
					stopSound();
				}else {
					//Stage working normally
					playSound();
					if(_wrapper.currentState != "init") _wrapper.setToOn();
					if (_wrapper.currentState == "on" || _wrapper.currentState == "active") {
						applyPower(delta);
						substractFuel(delta);
					}
				}
			}else {
				//Out of fuel
				if (!_isFinished) {
					stopSound();
					doDeath();
				}else {
					//Nothing
				}
			}
		}
		
		
		protected function doDeath():void {
			_isFinished = true;
			_wrapper.setToDeath().addOnce(deathAnimOver);
		}
		
		/** Hook to clear the visual from stage once its anim is over */
		protected function deathAnimOver():void {
			if (_visual) {
				if (_visual.stage) _visual.parent.removeChild(_visual);
				while (_visual.numChildren >= 1) _visual.removeChildAt(0);
			}
			
			_visual = null;
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_visual = null;
			if(_wrapper) _wrapper.destroy();
			_wrapper = null;
			
			if (_visual) {
				if (_visual.stage) _visual.parent.removeChild(_visual);
				while (_visual.numChildren >= 1) _visual.removeChildAt(0);
			}
			_visual = null;
		}
		
		
	}

}