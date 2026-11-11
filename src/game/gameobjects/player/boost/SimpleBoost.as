package src.game.gameobjects.player.boost 
{
	import flash.display.MovieClip;
	import lbg.anticheatengine.SafeNumber;
	import lbg.utils.Trig;
	import org.osflash.signals.Signal;
	import src.compound.CompoundNumber;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameMediator;
	import src.game.gameobjects.player.IGearWithFuel;
	import src.game.gameobjects.player.IGearWithMass;
	import src.game.gameobjects.player.IPlayerGearWithHud;
	import src.game.gameobjects.player.Player;
	import src.game.StatHooks;
	import src.ItemIcon;
	import src.system.GameStateItem;
	import src.system.Input;
	/**
	 * ...
	 * @author 
	 */
	public class SimpleBoost extends AbstractBoost implements IPlayerGearWithHud, IGearWithFuel, IGearWithMass
	{
		public var maxFuel:Number;
		public var fuel:SafeNumber=new SafeNumber();
		public var power:Number;
		
		//public var centerVisual:MovieClip;
		public var leftVisual:MovieClip;
		public var rightVisual:MovieClip;
		
		//public var centralWrapper:DeltaMovieClipWrapper;
		public var leftWrapper:DeltaMovieClipWrapper;
		public var rightWrapper:DeltaMovieClipWrapper;
		
		protected var _hudSignal:Signal = new Signal(Number);
		
		protected var _thrustOnlyIfActiveAnimation:Boolean = false;
		
		public function SimpleBoost(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			power = _item.statPower;
			maxFuel = fuel.value = _item.statFuel * StatHooks.boostFuelMult.value;
			StatHooks.boostFuelMult.signalChange.add(refreshMaxFuel);
			
			//trace("maxFuel:", maxFuel);
			
			setupVisual();
		}
		
		protected function refreshMaxFuel(boostFuelMult:CompoundNumber):void {
			//trace("Fuel was:", maxFuel, fuel);
			if (isNaN(fuel.value) || isNaN(maxFuel) || _item == null || boostFuelMult == null) {
				return;
			}
			
			var fuelRatio:Number = fuel.value / maxFuel;
			maxFuel = _item.statFuel * boostFuelMult.value;
			fuel.value = maxFuel * fuelRatio;
			//trace("Fuel is now:", maxFuel, fuel);
		}
		
		protected function setupVisual():void {
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
		
		override public function tick(delta:Number):void {
			var fuelBeforeTick:Number = fuel.value;
			
			if (fuel.value > 0 && (Input.metaBoost.isDown || singleBoostInputIsDown)) {
				applyThrust(delta);
				leftWrapper.setToOn();
				rightWrapper.setToOn();
				_preventDayEnd = true;
				playSound();
			}else {
				leftWrapper.setToOff();
				rightWrapper.setToOff();
				_preventDayEnd = false;
				stopSound();
			}
			
			_hudSignal.dispatch(fuel.value / maxFuel);
			
			if (fuelBeforeTick > 0 && fuel.value <= 0) {
				_player.updateBodyMass();
			}
		}
		
		protected function applyThrust(delta:Number):void {
				fuel.value -= delta;
				var thrust:Number = power * StatHooks.boostPowerMult.value * delta * _item.getPowerAtWeightMult(_player.getBody().mass);
				
				//trace("//Boost thrust debug//////////////////////////////")
				//trace("Base power:", power, "  Passive boostPowerMult:", StatHooks.boostPowerMult.value, "  Power At Weight:", _item.getPowerAtWeightMult(_player.getBody().mass));
				//trace("Boost thrust:", thrust);
				
				_player.applyThrust(thrust);
		}
		
		override public function setAnchor(leftX:Number, rightX:Number, leftRotation:Number, rightRotation:Number, Y:Number):void {
			if (leftVisual) {
				leftVisual.x = leftX;
				leftVisual.y = Y;
				leftVisual.rotation = leftRotation;
			}
			
			if (rightVisual) {
				rightVisual.x = rightX;
				rightVisual.y = Y;
				rightVisual.rotation = rightRotation;
			}
		}
		
		public function isOutOfFuel():Boolean {
			return (fuel.value == 0);
		}
		
		
		override public function get preventDayEnd():Boolean 
		{
			return _preventDayEnd;
		}
		/* INTERFACE src.game.gameobjects.player.IPlayerGearWithHud */
		
		public function get hudSignal():Signal 
		{
			return _hudSignal;
		}
		
		override public function destroy():void {
			leftVisual = null;
			rightVisual = null;
			
			if(leftWrapper) leftWrapper.destroy();
			leftWrapper = null;
			if(rightWrapper) rightWrapper.destroy();
			rightWrapper = null;
			
			_hudSignal.removeAll();
			_hudSignal = null;
			
			super.destroy();
		}
		
		/* INTERFACE src.game.gameobjects.player.IGearWithMass */
		
		public function get weight():Number 
		{
			if (fuel.value <= 0) {
				return 0;
			}else {
				return _item.statWeight;
			}
		}
		
	}

}