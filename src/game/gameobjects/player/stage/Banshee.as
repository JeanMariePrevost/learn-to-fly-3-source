package src.game.gameobjects.player.stage 
{
	import flash.display.MovieClip;
	import nape.geom.Vec2;
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
	public class Banshee extends AbstractStage  
	{
		protected var _visualLeft:MovieClip;
		protected var _visualRight:MovieClip;
		protected var _wrapperLeft:DeltaMovieClipWrapper;
		protected var _wrapperRight:DeltaMovieClipWrapper;
		protected var _fallingObjectLeft:FallingObject;
		protected var _fallingObjectRight:FallingObject;
		
		public function Banshee(player:Player, item:GameStateItem) 
		{
			super(player, item);
		}
		
		override public function startStage():void 
		{
			super.startStage();
			_visualLeft = new (_item.statVisualClass)();
			_visualRight = new (_item.statVisualClass)();
			
			_wrapperLeft = new DeltaMovieClipWrapper(_visualLeft, "initStart");
			_wrapperRight = new DeltaMovieClipWrapper(_visualRight, "initStart");
			
			addToDisplay();
			
			alignTo(_player.tOffCenter);
		}
		
		protected function addToDisplay():void {
			_player.getMovieClip().addChildAt(_visualLeft, 0);
			_player.getMovieClip().addChildAt(_visualRight, 0);
		}
		
		protected function alignTo(target:MovieClip):void {
			_visualRight.scaleX = -1;
			
			_visualLeft.x = target.x;
			_visualLeft.y = target.y;
			_visualLeft.rotation = target.rotation;
			_visualRight.x = -target.x;
			_visualRight.y = target.y;
			_visualRight.rotation = -target.rotation;
		}
		
		override public function tick(delta:Number):void 
		{
			
			_isStoppedByPlayer = false;
			
			if (fuel > 0) {
				if (Input.metaDown.isDown) {
					//Player manually pausing stage
					stopSound();
					_wrapperLeft.setToOff();
					_wrapperRight.setToOff();
					_isStoppedByPlayer = true;
				}else {
					//Stage working normally
					if (_wrapperLeft.currentState != "init") {
						playSound();
						_wrapperLeft.setToOn();
						_wrapperRight.setToOn();
					}
					
					if (_wrapperLeft.currentState == "on" || _wrapperLeft.currentState == "active") {
						playSound();
						applyPower(delta);
						substractFuel(delta);
					}
				}
			}else {
				//Out of fuel
				if (!_isFinished) {
					stopSound();
					doDeath();
				}
			}
		}
		
		protected function doDeath():void {
			_isFinished = true;
			_wrapperLeft.setToDeath().addOnce(destroy);
			_wrapperRight.setToDeath();
		}
		
		override protected function playSound(fadeInDuration:Number = NaN):void 
		{
			if (isNaN(fadeInDuration)) fadeInDuration = 600;
			super.playSound(fadeInDuration);
		}
		
		override protected function stopSound(fadeOutDuration:Number = NaN):void 
		{
			if (isNaN(fadeOutDuration)) fadeOutDuration = 400;
			super.stopSound(fadeOutDuration);
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			if(_visualLeft) _visualLeft.parent.removeChild(_visualLeft);
			_visualLeft = null;
			if(_visualLeft) _visualRight.parent.removeChild(_visualRight);
			_visualRight = null;
			if(_wrapperLeft) _wrapperLeft.destroy();
			_wrapperLeft = null;
			if(_wrapperRight) _wrapperRight.destroy();
			_wrapperRight = null;
		}
		
		
	}

}