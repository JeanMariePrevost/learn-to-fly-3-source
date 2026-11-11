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
	public class Propeller extends SimpleBoost 
	{
		
		public function Propeller(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override public function tick(delta:Number):void 
		{
			var fuelBeforeTick:Number = fuel.value;
			
			if (fuel.value <= 0) {
				leftWrapper.setToDeath();
				rightWrapper.setToDeath();
				_preventDayEnd = false;
			}else {
				if ((Input.metaBoost.isDown || singleBoostInputIsDown)) {
					if (leftWrapper.currentState == "active") {
						//Fully running
						applyThrust(delta);//Apply thrust normally
						_preventDayEnd = true;
					}else {
						leftWrapper.setToOn();
						rightWrapper.setToOn();
						fadeInThrust(delta);
						playSound(600);
					}
				}else {
					//Deactivate
					stopSound(600);
					_preventDayEnd = false;
					leftWrapper.setToOff();
					rightWrapper.setToOff();
					if (leftWrapper.currentState == "off") {
						fadeOutThrust(delta);
					}
				}
			}
			_hudSignal.dispatch(fuel.value / maxFuel);
			if (fuelBeforeTick > 0 && fuel.value <= 0) {
				_player.updateBodyMass();
			}
		}
		
		protected function fadeInThrust(delta:Number) {
			var mult:Number = NumberUtils.interpolate2(0, 1, leftWrapper.startFrame, leftWrapper.endFrame, leftWrapper.currentFrame, 3);
			applyThrust(delta * mult);
		}
		
		protected function fadeOutThrust(delta:Number) {
			var mult:Number = NumberUtils.interpolate2(1, 0, leftWrapper.startFrame, leftWrapper.endFrame, leftWrapper.currentFrame, 2);
			applyThrust(delta * mult);
		}
		
		override protected function setupVisual():void 
		{
			leftVisual = new _item.statVisualClass();
			leftWrapper = new DeltaMovieClipWrapper(leftVisual, "initStart");
			_player.getMovieClip().addChildAt(leftVisual, 0);//Add child BEHIND body

			rightVisual = new _item.statVisualClass();
			rightVisual.scaleY = -1;//Flip around
			rightWrapper = new DeltaMovieClipWrapper(rightVisual, "initStart");
			_player.getMovieClip().addChildAt(rightVisual, 0);//Add child BEHIND body
		}
	}

}