package src.game.hud 
{
	import flash.display.MovieClip;
	import lbg.debug.Log;
	import src.game.gameobjects.player.IPlayerGear;
	import src.game.gameobjects.player.IPlayerGearWithHud;
	import src.ItemIcon;
	
	/**
	 * ...
	 * @author 
	 */
	public class WeightHudSlot extends MovieClip 
	{
		public var icon:ItemIcon;
		public var bg:MovieClip;
		
		protected var _item:IPlayerGearWithHud;
		
		
		public function WeightHudSlot(item:IPlayerGearWithHud) 
		{
			_item = item;
			gotoAndStop(1);
			bg.gotoAndStop(1);
			
			icon.gotoIcon(_item.item.statSpecialIds);
			item.hudSignal.add(tickHud);
		}
		
		protected function tickHud(fuelRatio:Number):void 
		{
			var fuelFrame:int = bg.totalFrames - (bg.totalFrames * fuelRatio);
			bg.gotoAndStop(fuelFrame);
			
			//trace("fuelFrame:", fuelFrame, "bg.totalFrames:", bg.totalFrames);
			
			if (_item.item.id != "recurringBoost" && fuelFrame >= bg.totalFrames && currentFrame <= 1) {
				gotoAndPlay(2);
			}else if (currentFrame >= totalFrames) {
				stop();
				item.hudSignal.remove(tickHud);
			}
		}
		
		public function destroy():void {
			icon = null;
			bg = null;
			_item = null;
			if (stage) parent.removeChild(this);
		}
		
		public function get item():IPlayerGearWithHud 
		{
			return _item;
		}
		
	}

}