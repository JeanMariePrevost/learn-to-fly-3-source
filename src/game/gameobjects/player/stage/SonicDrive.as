package src.game.gameobjects.player.stage 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import src.audio.Audio;
	import src.compound.TimedMod;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameCamera;
	import src.game.gameobjects.FallingObject;
	import src.game.gameobjects.player.Player;
	import src.game.PhysicsEngine;
	import src.game.StatHooks;
	import src.Main;
	import src.system.GameStateItem;
	import org.osflash.signals.Signal;
	import src.game.gameobjects.player.IPlayerGearWithHud;
	import src.system.Input;
	/**
	 * ...
	 * @author 
	 */
	public class SonicDrive extends AbstractStage
	{
		protected var _visual:MovieClip;
		protected var _wrapper:DeltaMovieClipWrapper;
		
		public function SonicDrive(player:Player, item:GameStateItem) 
		{
			super(player, item);
		}
		
		override public function startStage():void 
		{
			super.startStage();
			_visual = new (_item.statVisualClass)();
			_wrapper = new DeltaMovieClipWrapper(_visual, "initStart");
			
			_player.getMovieClip().addChildAt(_visual, 0);//Add child BEHIND body
			//_player.getMovieClip().addChild(_visual);//Add child BEHIND body
			_visual.x = _player.tBottom.x;
			_visual.y = _player.tBottom.y;
		}
		
		override public function tick(delta:Number):void 
		{
			if (fuel > 0) {
				if(_wrapper.currentState != "init" && _wrapper.currentState != "off" && Input.metaDown.isDown == false) _wrapper.setToOn();
				if (_wrapper.currentState == "active") {
					Audio.playSound(_item.statSound1, this).volume = _item.statSound1Volume;
					applyPower(delta);
					substractFuel(delta);
					_wrapper.setToOff();
				}
			}else if(_wrapper.currentState != "off"){
				//Out of fuel
				if (!_isFinished) {
					doDeath();
				}else {
					//Nothing
				}
			}
		}
		
		override protected function applyPower(delta:Number, forceThrustRelativeAngle:Number = NaN):void {
			super.applyPower(delta);
			
			//Reduce drag for limited time
			var dragBuff:TimedMod = new TimedMod(0, 0.25, 50, Main.unsafeTickSignal);
			StatHooks.dragMult.addMod(dragBuff);
		}
		
		protected function doDeath():void {
			_isFinished = true;
			_wrapper.setToDeath();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_visual = null;
			if(_wrapper) _wrapper.destroy();
			_wrapper = null;
		}
		
		
	}

}