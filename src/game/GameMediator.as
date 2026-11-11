package src.game 
{
	import lbg.utils.NumberUtils;
	import nape.callbacks.InteractionCallback;
	import org.osflash.signals.natives.base.SignalBitmap;
	import org.osflash.signals.Signal;
	import src.game.gameobjects.obstacles.Obstacle;
	import src.game.gameobjects.player.IPlayerGear;
	import src.game.gameobjects.player.IPlayerGearWithHud;
	import src.system.GameStateItem;
	/**
	 * ...
	 * @author 
	 */
	public class GameMediator 
	{
		public static var skyColor:uint = 0;
		
		protected static var _updatePlayerAltitude:Signal = new Signal(Number);//Comes from Ground
		/** altitude:Number */
		public static function get updatePlayerAltitude():Signal { return _updatePlayerAltitude }
		
		protected static var _playerLaunched:Signal = new Signal();
		public static function get playerLaunched():Signal { return _playerLaunched }
		
		protected static var _playerHitsGround:Signal = new Signal();//Comes from Ground
		/** No param */
		public static function get playerHitsGround():Signal { return _playerHitsGround }
		
		protected static var _updatePlayerDrag:Signal = new Signal(Number);
		/** dragMult:Number */
		public static function get updatePlayerDrag():Signal { return _updatePlayerDrag }
		
		protected static var _updatePlayerSpeed:Signal = new Signal(Number, Number);//speed, angle
		/** speed:Number, angleInDegrees:Number */ 
		public static function get updatePlayerSpeed():Signal { return _updatePlayerSpeed }
		
		protected static var _updatePlayerPosition:Signal = new Signal(Number, Number);//x, y
		/** x:Number, y:Number */
		public static function get updatePlayerPosition():Signal { return _updatePlayerPosition }
		
		protected static var _updatePlayerMove:Signal = new Signal(Number, Number);//x, y
		/** moveX:Number, moveY:Number */
		public static function get updatePlayerMove():Signal { return _updatePlayerMove }
		
		protected static var _finishDay:Signal = new Signal();
		public static function get finishDay():Signal { return _finishDay }
		
		protected static var _playerOutOfFuel:Signal = new Signal();
		public static function get playerOutOfFuel():Signal { return _playerOutOfFuel }
		
		/** If dayEndTicks are counting up*/
		protected static var _dayIsEnding:Signal = new Signal(Boolean);
		public static function get dayIsEnding():Signal { return _dayIsEnding }
		
		protected static var _stageFinished:Signal = new Signal(IPlayerGear);
		public static function get stageFinished():Signal { return _stageFinished }
		
		protected static var _modelPhaseTick:Signal = new Signal(Number);
		public static function get modelPhaseTick():Signal { return _modelPhaseTick }
		
		protected static var _fueledGearRegistration:Signal = new Signal(Signal);
		public static function get fueledGearRegistration():Signal { return _fueledGearRegistration }
		
		protected static var _addStageAtRuntime:Signal = new Signal(GameStateItem);//Dispatch to add a new stage at runtime
		public static function get addStageAtRuntime():Signal { return _addStageAtRuntime }
		
		protected static var _createdStageAtRuntime:Signal = new Signal(IPlayerGearWithHud);//Dispatched once the stage is created, for components who need the real object and not the item class
		public static function get createdStageAtRuntime():Signal { return _createdStageAtRuntime }
		
		protected static var _playerWeightChange:Signal = new Signal(Number);
		/** (weight:Number) Dispatches when player weight varies */
		public static function get playerWeightChange():Signal { return _playerWeightChange }
		
		protected static var _playerImpactObstacle:Signal = new Signal(InteractionCallback);
		/** (InteractionCallback) Dispatches when player hits an obstacle */
		public static function get playerImpactObstacle():Signal { return _playerImpactObstacle }
		
		protected static var _obstacleHit:Signal = new Signal(Obstacle);
		/** (Obstacle) Dispatches when player hits an obstacle */
		public static function get obstacleHit():Signal { return _obstacleHit }
		
		
		protected static var _gamePaused:Signal = new Signal();
		public static function get gamePaused():Signal { return _gamePaused }
		
		protected static var _gameResumed:Signal = new Signal();
		public static function get gameResumed():Signal { return _gameResumed }
		
		protected static var _gameResumedWithDuration:Signal = new Signal(Number);
		/** pausedDurationInMilliseconds:Number */
		public static function get gameResumedWithDuration():Signal { return _gameResumedWithDuration }
		
		
		
		/** -1 to 1, 0 being null, from player rotation */
		public static function changeMouseControlValue(value:Number):void {
			_mouseControlValue = NumberUtils.constrain(value, -1, 1);
			//trace("changeMouseControlValue() ->", _mouseControlValue);
		}
		protected static var _mouseControlValue:Number = 0;
		public static function get mouseControlValue():Number {
			return _mouseControlValue;
		}
		
		
		
		
		
		public static function removeAll():void {
			_updatePlayerAltitude.removeAll();
			_updatePlayerDrag.removeAll();
			_updatePlayerSpeed.removeAll();
			_updatePlayerPosition.removeAll();
			_updatePlayerMove.removeAll();
			_finishDay.removeAll();
			_playerOutOfFuel.removeAll();
			_stageFinished.removeAll();
			_modelPhaseTick.removeAll();
			_fueledGearRegistration.removeAll();
			_addStageAtRuntime.removeAll();
			_createdStageAtRuntime.removeAll();
			_playerWeightChange.removeAll();
			_playerImpactObstacle.removeAll();
			_gamePaused.removeAll();
			_gameResumed.removeAll();
			_gameResumedWithDuration.removeAll();
		}
		
		
	}

}
