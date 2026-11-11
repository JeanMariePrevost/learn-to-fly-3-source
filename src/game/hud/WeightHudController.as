package src.game.hud 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.VectorUtils;
	import src.game.GameMediator;
	import src.game.gameobjects.player.body.SimpleBody;
	import src.game.gameobjects.player.boost.AbstractBoost;
	import src.game.gameobjects.player.boost.BoostController;
	import src.game.gameobjects.player.IPlayerGear;
	import src.game.gameobjects.player.IPlayerGearWithHud;
	import src.game.gameobjects.player.stage.IStage;
	import src.game.gameobjects.player.stage.StageController;
	import src.system.GameState;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class WeightHudController extends Sprite 
	{
		public const SLOT_OFFEST_Y:Number = -4; //Adjust the Weight slots position
		
		public var weightHUD:HudWeight;
		
		public var slots:Vector.<WeightHudSlot> = new Vector.<WeightHudSlot>();
		
		public function WeightHudController(boosts:BoostController, stages:StageController) 
		{
			for each (var item:* in boosts.boosts) {
				if (item is IPlayerGearWithHud) {
					addItem(item);
				}
			}
			
			for each (item in stages.stages) {
				if (item is IPlayerGearWithHud) {
					addItem(item);
				}
			}
			
			GameMediator.createdStageAtRuntime.add(addItem);//Allows adding items any time via signal
		}
		
		protected function arrangeSlots():void {
			for (var i:int = 0; i < slots.length; i++) {
				slots[i].y = weightHUD.y - (i * (slots[i].bg.height - 0.5)) + SLOT_OFFEST_Y;
			}
		}
		
		public function removeItem(item:IPlayerGearWithHud):void {
			for each(var s:WeightHudSlot in slots) {
				if (s.item == item) {
					removeChild(s);
					VectorUtils.removeFromVector(slots, s);
					s.destroy();
					break;
				}
			}
			arrangeSlots();
		}
		
		public function addItem(item:IPlayerGearWithHud):void {
			var s:WeightHudSlot = new WeightHudSlot(item);
			slots.push(s);
			addChild(s);
			arrangeSlots();
		}
		
		public function destroy():void {
			if (weightHUD) weightHUD.destroy();
			weightHUD = null;
			
			if (slots) {
				for each(var i:WeightHudSlot in slots) i.destroy();
				slots.length = 0;
			}
			slots = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}