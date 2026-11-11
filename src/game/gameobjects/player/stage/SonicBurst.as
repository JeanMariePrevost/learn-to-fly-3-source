package src.game.gameobjects.player.stage 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.audio.Audio;
	import src.compound.TimedMod;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameCamera;
	import src.game.gameobjects.FallingObject;
	import src.game.gameobjects.IFallingObject;
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
	public class SonicBurst extends AbstractStage
	{
		protected var _visual:MovieClip;
		protected var _wrapper:DeltaMovieClipWrapper;
		protected var _fallingObjectLeft:IFallingObject;
		protected var _fallingObjectRight:IFallingObject;
		
		public function SonicBurst(player:Player, item:GameStateItem) 
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
				if (_wrapper.currentState != "init") {
					if (Input.metaDown.isDown == false) {
						_wrapper.setToOn();
						_isStoppedByPlayer = false;
					}else {
						_isStoppedByPlayer = true;
					}
				}
				if (_wrapper.currentState == "active") {
					applyPower(1);
					substractFuel(1);
				}
			}else {
				//Out of fuel
				if (!_isFinished) {
					Audio.playSound(_item.statSound1, this).volume = _item.statSound1Volume;
					doDeath();
				}else {
					//Nothing
				}
			}
		}
		
		override protected function applyPower(delta:Number, forceThrustRelativeAngle:Number = NaN):void {
			//Don't use delta hardly as much, fuel is mostly 1 tick
			delta = NumberUtils.interpolate(delta, 1, 0.6);
			
			
			super.applyPower(delta);
			
			//Reduce drag for limited time
			var dragBuff:TimedMod = new TimedMod(0, 0.25, 100, Main.unsafeTickSignal);
			StatHooks.dragMult.addMod(dragBuff);
		}
		
		protected function doDeath():void {
			if (_wrapper.currentState != "death" && _isFinished == false && _visual && _visual.parent) {
				//Do falling parts
				var partLeft:MovieClip = new (_item.statVisualClass2)();
				var partRight:MovieClip = new (_item.statVisualClass2)();
				
				_visual.addChild(partLeft);
				_visual.addChild(partRight);
				
				partRight.scaleX = -1;
				
				partLeft.x = -5;
				partLeft.y = -12;
				partRight.x = 5;
				partRight.y = -12;
				
				_fallingObjectLeft = FallingObject.createSimpleFallingObject(partLeft);
				_fallingObjectRight = FallingObject.createSimpleFallingObject(partRight);
				
				_fallingObjectLeft.applyRelativeAngleForce(120, -50, null, true);
				_fallingObjectRight.applyRelativeAngleForce(120, 50, null, true);
				
				_fallingObjectLeft.applyRotation( -(Math.random() * 10 + 5));
				_fallingObjectRight.applyRotation( (Math.random() * 10 + 5));
			}
			
			_isFinished = true;
			_wrapper.setToDeath();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_visual = null;
			if(_wrapper) _wrapper.destroy();
			_wrapper = null;
			_fallingObjectLeft = null;
			_fallingObjectRight = null;
		}
		
		
	}

}