package src.game 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import src.Main;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class SpaceIndicator extends MovieClip 
	{
		public var txtDistance:TextField;
		
		protected const TRIGGER_DISTANCE:Number = 15000;
		
		public function SpaceIndicator() 
		{
			super();
			
			alpha = 0;
			visible = false;
			
			if (ProfileState.instance.currentGameState.gameMode == "Story Mode"
			&& ProfileState.instance.currentGameState.gameCompleted.value == true
			&& ProfileState.instance.medals.moonBreaker >= 1) {
				//Can fly indefinitely because this story mode in completely cleared
			}else {
				GameMediator.updatePlayerAltitude.add(onAltChange);
			}
		}
		
		protected function onAltChange(alt:Number):void {
			if (alt >= Global.spaceAltitude - TRIGGER_DISTANCE) {
				//Show
				if (alpha < 1) {
					alpha += 0.015;
				}else {
					alpha = 1;
				}
				visible = true;
				txtDistance.text = Number(Global.spaceAltitude - alt).toFixed(0);
			}else {
				//Hide
				if (alpha > 0) {
					alpha -= 0.015;
				}else {
					alpha = 0;
					visible = false;
				}
			}
			
			if (alt >= Global.spaceAltitude) {
				//Finished
				GameEngine.instance.toSpaceMiniGame();
				destroy();
			}
			
		}
		
		public function destroy():void {
			GameMediator.updatePlayerAltitude.remove(onAltChange);
			
			txtDistance = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
	}

}