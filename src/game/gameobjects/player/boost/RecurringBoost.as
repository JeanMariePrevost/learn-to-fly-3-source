package src.game.gameobjects.player.boost 
{
	import lbg.utils.NumberUtils;
	import src.game.DeltaMovieClipWrapper;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class RecurringBoost extends SimpleBoost 
	{
		protected const MIN_FUEL_TO_START:Number = 15;//Minimum fuel to start engine after running out
		protected var _fuelRegen:Number;
		protected var _ranOut:Boolean = false;
		
		protected var _totalFuelRefilled:Number = 0;//Counter used for refueling soft-cap
		
		public function RecurringBoost(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			_fuelRegen = _item.statSpecial;
		}
		
		override protected function setupVisual():void 
		{
			leftVisual = new _item.statVisualClass();
			leftWrapper = new DeltaMovieClipWrapper(leftVisual, "initStart");
			leftWrapper.useDeltaTime = false;
			_player.getMovieClip().addChild(leftVisual);

			rightVisual = new _item.statVisualClass();
			rightVisual.scaleY = -1;//Flip around
			rightWrapper = new DeltaMovieClipWrapper(rightVisual, "initStart");
			rightWrapper.useDeltaTime = false;
			_player.getMovieClip().addChild(rightVisual);
		}
		
		override public function tick(delta:Number):void 
		{
			if (fuel.value <= 3) {
				if (leftWrapper.currentState == "active") {
					stopSound();
					leftWrapper.setToIdle();
					rightWrapper.setToIdle();
				}
				//_isOn = false;
				_ranOut = true;
			}else if (!_ranOut) {
				//Has fuel & is ready
				if ((Input.metaBoost.isDown || singleBoostInputIsDown)) {
					playSound();
					leftWrapper.setToActive();
					rightWrapper.setToActive();
					applyThrust(delta);
					//_isOn = true;
				}else {
					if (leftWrapper.currentState == "active") {
						stopSound();
						leftWrapper.setToIdle();
						rightWrapper.setToIdle();
					}
					//_isOn = false;
				}
			}
			
			if (!(Input.metaBoost.isDown || singleBoostInputIsDown) || _ranOut) {
				regenFuel(delta);
			}
			
			if (_ranOut && fuel.value >= MIN_FUEL_TO_START) {
				_ranOut = false;
			}
			
			_hudSignal.dispatch(fuel.value / maxFuel);
			
		}
		
		protected function regenFuel(delta:Number):void {
			if (fuel.value >= maxFuel) return;
			
			_totalFuelRefilled += 1;
			if (_player.isOutOfStages()) _totalFuelRefilled += 3;//Much faster when OOS
			
			var fatigueRatio:Number = NumberUtils.interpolate2(1, 0.01, 0, _item.statTorque, _totalFuelRefilled, 1.5);
			fuel.value += _fuelRegen * delta * fatigueRatio;
			
			//var fatigueRatio:Number = Math.max(1, _totalFuelRefilled / _item.statTorque + 1);
			//fuel += _fuelRegen * delta / fatigueRatio;
			
			//trace("Fuel burned:", _totalFuelRefilled, " ratio:", fatigueRatio, " delta:", delta);
			//trace("Fuel regen:", _fuelRegen * delta / fatigueRatio);
		}
		
	}

}