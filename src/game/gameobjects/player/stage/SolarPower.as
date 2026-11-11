package src.game.gameobjects.player.stage 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import lbg.utils.NumberUtils;
	import src.compound.CompoundNumber;
	import src.effects.smoketrail.SmokeTrail;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameCamera;
	import src.game.GameMediator;
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
	public class SolarPower extends AbstractStage implements IStage, IPlayerGearWithHud
	{
		protected var _trail:SmokeTrail;
		
		protected var _visual:MovieClip;
		protected var _visualTop:MovieClip;
		protected var _wrapper:DeltaMovieClipWrapper;
		protected var _wrapperTop:DeltaMovieClipWrapper;
		
		protected var _powerMultFromAlt:Number = 1;
		
		public function SolarPower(player:Player, item:GameStateItem) 
		{
			super(player, item);
		}
		
		/* INTERFACE src.game.gameobjects.player.stage.IStage */
		
		override public function startStage():void 
		{
			_hasStarted = true;
			
			_visual = new (_item.statVisualClass)();
			_visualTop = new (_item.statVisualClass2)();
			
			_wrapper = new DeltaMovieClipWrapper(_visual, "initStart");
			_wrapperTop = new DeltaMovieClipWrapper(_visualTop, "initStart");
			
			_player.getMovieClip().addChildAt(_visual, 0);//Add child BEHIND body
			_player.getMovieClip().addChildAt(_visualTop, 0);//Add child BEHIND body
			//_player.getMovieClip().addChild(_visual);
			//_player.getMovieClip().addChild(_visualTop);
			//_visual.x = _player.tBottom.x;
			_visual.y = _player.tBottom.y;
			_visualTop.x = _player.tTop.x;
			_visualTop.y = _player.tTop.y;
			
			GameMediator.updatePlayerAltitude.add(onAltitude);
		}
		
		private function onAltitude(alt:Number):void 
		{
			_powerMultFromAlt = NumberUtils.interpolate2(0.3, 1, 0, _item.statSpecial, alt);
		}
		
		override public function tick(delta:Number):void 
		{
			_isStoppedByPlayer = false;
			if (fuel > 0) {
				if (Input.metaDown.isDown) {
					//Player manually pausing stage
					stopSound();
					_wrapper.setToOff();
					_wrapperTop.setToOff();
					_isStoppedByPlayer = true;
				}else {
					//Stage working normally
					if (_wrapper.currentState != "init") {
						_wrapper.setToOn();
						_wrapperTop.setToOn();
					}
					if (_wrapper.currentState == "on" || _wrapper.currentState == "active") {
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
				}else {
					//Nothing
				}
			}
			
			//Trail
			if (_isFinished) return;
			
			if (_wrapper.currentState == "on" || _wrapper.currentState == "active") {
				createTrails();
				
				var p:Point = GameCamera.getPositionOnCamera(_visual.tBottom);
				_trail.addSegment(p.x, p.y, _player.getMovieClip().rotation + 90);
			}else {
				_trail = null;
			}
		}
		
		private function createTrails():void 
		{
			if (_trail == null) {
				_trail = SmokeTrail.newSmokeTrail();
				_trail.color = 0xFFFFFF;
				_trail.alpha = 0.8;
				_trail.fadeInLength = 6;
				_trail.fadeInAlpha = 0.3;
				_trail.fadeInPower = 0.7;
				_trail.fadeOutLegnth = 20;
				_trail.pushForce = 10;
				_trail.pushForceDrag = 0.95;
				_trail.spreadForce = 0.1;
				_trail.fadePerTick = 0.03;
				_trail.maxSegments = 70;
				_trail.lineWidth = 8;
				GameCamera.instance.addChildToMovingLayerRelativeTo(_trail.visual, _visual, -1);
			}
			
		}
		
		protected function doDeath():void {
			_isFinished = true;
			_wrapper.setToDeath();
			_wrapperTop.setToDeath();
		}
		
		
	}

}