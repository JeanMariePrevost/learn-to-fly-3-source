package src.game.gameobjects.player.boost 
{
	import src.game.GameMediator;
	import src.game.gameobjects.player.Player;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class SpinBooster extends SimpleBoost 
	{
		
		public function SpinBooster(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override protected function setupVisual():void 
		{
			leftVisual = new _item.statVisualClass();
			leftWrapper = new SpinBoosterMCWrapper(leftVisual, "initStart");
			_player.getMovieClip().addChildAt(leftVisual, 0);//Add child BEHIND body
			//_player.getMovieClip().addChild(leftVisual);//Add child IN FRONT OF body

			rightVisual = new _item.statVisualClass();
			rightVisual.scaleY = -1;//Flip around
			rightWrapper = new SpinBoosterMCWrapper(rightVisual, "initStart");
			_player.getMovieClip().addChildAt(rightVisual, 0);//Add child BEHIND body
			//_player.getMovieClip().addChild(rightVisual);//Add child IN FRONT OF body
		}
		
		override public function tick(delta:Number):void 
		{
			var fuelBeforeTick:Number = fuel.value;
			
			if (fuel.value <= 0) {
				stopSound();
				leftWrapper.setToDeath();
				rightWrapper.setToDeath();
			}else {
				var direction:Number = 0;//<0 left, >0 right
				
				if (ProfileState.instance.optionMouseControl >= 1) {
					//Mouse-controlled
					direction = GameMediator.mouseControlValue;
					//trace("Direction:", direction);
				}else {
					//Regular controls
					if (Input.metaLeft.isDown) {
						direction = -1;
					}else if (Input.metaRight.isDown) {
						direction = 1;
					}
				}
				
				if (direction <= -0.05) {
					playSound(50);
					_player.applyRotation(direction * power * _item.getPowerAtWeightMult(_player.getBody().mass) * StatHooks.rudderMult.value * delta);
					fuel.value -= delta * Math.abs(direction);
					if (leftWrapper.currentState != "off") {
						leftWrapper.gotoLabel("offStart");
						rightWrapper.gotoLabel("onStart");
					}
				}else if (direction >= 0.05) {
					playSound(50);
					_player.applyRotation(direction * power * _item.getPowerAtWeightMult(_player.getBody().mass) * StatHooks.rudderMult.value * delta);
					fuel.value -= delta * Math.abs(direction);
					if (leftWrapper.currentState != "on") {
						leftWrapper.gotoLabel("onStart");
						rightWrapper.gotoLabel("offStart");
					}
				}else {
					stopSound();
					leftWrapper.setToIdle();
					rightWrapper.setToIdle();
				}
				
			_hudSignal.dispatch(fuel.value / maxFuel);
			}
			
			if (fuelBeforeTick > 0 && fuel.value <= 0) {
				_player.updateBodyMass();
			}
			
		}
		
	}

}