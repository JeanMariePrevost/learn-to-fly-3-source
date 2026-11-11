package src.game.gameobjects.player.stage 
{
	import nape.geom.Vec2;
	import org.osflash.signals.Signal;
	import src.audio.Audio;
	import src.audio.ISound;
	import src.compound.CompoundNumber;
	import src.game.gameobjects.player.IPlayerGearWithHud;
	import src.game.gameobjects.player.Player;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	/**
	 * ...
	 * @author 
	 */
	public class AbstractStage implements IStage, IPlayerGearWithHud 
	{
		public var maxFuel:Number;
		public var fuel:Number;
		public var power:Number;
		
		protected var _isFinished:Boolean = false;//Used as a flag for the stage controller to move on to the next stage
		
		protected var _item:GameStateItem;
		protected var _player:Player;
		protected var _hudSignal:Signal = new Signal(Number);
		
		protected var _thrustOffsetVec2:Vec2 = new Vec2(0, 0);//Makes the force a push (<0) or a pull (>0), making you sway off or stabilize
		protected var _thrustRelativeAngle:Number = 0;
		
		protected var _isStoppedByPlayer:Boolean = false;
		protected var _hasStarted:Boolean = false;
		
		protected var _sound:ISound;
		
		public function AbstractStage(player:Player, item:GameStateItem) 
		{
			_player = player;
			_item = item;
			
			power = item.statPower;
			maxFuel = fuel = _item.statFuel * StatHooks.stageFuelMult.value;
			StatHooks.stageFuelMult.signalChange.add(refreshMaxFuel);
			//trace("maxFuel:", maxFuel);
		}
		
		protected function refreshMaxFuel(stageFuelMult:CompoundNumber):void {
			if (_item && stageFuelMult) {
				//trace("Fuel was:", maxFuel, fuel);
				var fuelRatio:Number = fuel / maxFuel;
				maxFuel = _item.statFuel * stageFuelMult.value;
				fuel = maxFuel * fuelRatio;
				//trace("Fuel is now:", maxFuel, fuel);
			}
		}
		
		protected function applyPower(delta:Number, forceThrustRelativeAngle:Number = NaN):void {
			//trace(StatHooks.stagePowerMult.value);
			var p:Number = power * delta * _item.getPowerAtWeightMult(_player.getBody().mass) * StatHooks.stagePowerMult.value;
			
			//trace("//Stage thrust debug//////////////////////////////")
			//trace("Base power:", power, "  stagePowerMult:", StatHooks.stagePowerMult.value, "  Power At Weight:", _item.getPowerAtWeightMult(_player.getBody().mass));
			//trace("Stage thrust:", p, "Mass:", _player.getBody().mass);
			
			if (isNaN(forceThrustRelativeAngle)) {
				_player.applyThrust(p, _thrustRelativeAngle, _thrustOffsetVec2);
			}else {
				_player.applyThrust(p, forceThrustRelativeAngle, _thrustOffsetVec2);
			}
		}
		
		protected function substractFuel(delta:Number):void {
			fuel -= delta;
			_hudSignal.dispatch(fuel / maxFuel);
		}
		
		/** Plays the stage sound if not already playing */
		protected function playSound(fadeInDuration:Number = NaN):void {
			//trace("playSound");
			if (_item == null) return;
			
			if (isNaN(fadeInDuration)) fadeInDuration = 300;
			
			if (_sound == null && _item.statSound1 != null) {
				//trace("New sound created!");
				_sound = Audio.playFadingSoundLoop(_item.statSound1, this, fadeInDuration);
				_sound.volume = _item.statSound1Volume;
			}
		}
		
		protected function stopSound(fadeOutDuration:Number = NaN):void {
			//trace("stopSound");
			if (_sound) {
				if (isNaN(fadeOutDuration)) fadeOutDuration = 300;
				//trace("Sound fading out!");
				_sound.fadeOut(fadeOutDuration);
				_sound = null;
			}
		}
		
		/* INTERFACE src.game.gameobjects.player.stage.IStage */
		
		public function get isFinished():Boolean 
		{
			return _isFinished;
		}
		
		public function startStage():void 
		{
			_hasStarted = true;
		}
		
		public function get hasStarted():Boolean 
		{
			return _hasStarted;
		}
		
		public function get item():GameStateItem 
		{
			return _item;
		}
		
		public function tick(delta:Number):void 
		{
			
		}
		
		/* INTERFACE src.game.gameobjects.player.IPlayerGearWithHud */
		
		public function get hudSignal():Signal 
		{
			return _hudSignal;
		}
		
		public function destroy():void 
		{
			_isFinished = true;
			_item = null;
			_player = null;
			if(_hudSignal) _hudSignal.removeAll();
			_hudSignal = null;
			if(_thrustOffsetVec2) _thrustOffsetVec2.dispose();
			_thrustOffsetVec2 = null;
		}
		
		/* INTERFACE src.game.gameobjects.player.stage.IStage */
		
		public function get isStoppedByPlayer():Boolean 
		{
			return _isStoppedByPlayer;
		}
		
	}

}