package src.game.gameobjects.player.boost 
{
	import flash.display.MovieClip;
	import lbg.compositetick.ICompositeLeaf;
	import src.game.GameCamera;
	import src.game.gameobjects.player.IGearWithFuel;
	import src.game.gameobjects.player.IGearWithMass;
	import src.game.gameobjects.player.IPlayerGear;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	/**
	 * ...
	 * @author 
	 */
	public class BoostController implements IPlayerGear, IGearWithMass
	{
		public var boosts:Vector.<AbstractBoost> = new Vector.<AbstractBoost>();
		//public var currentStage:int = 0;
		//public var previousStage:int = -1;
		
		protected var _player:Player;
		protected var _item:GameStateItem = null;// GameStateItem.createFrom("boostController", 0);
		
		
		public function BoostController(player:Player, ...boosts) 
		{
			_player = player;
			
			//If passing boosts
			for each(var i:AbstractBoost in boosts) {
				addBoost(i);
			}
		}
		
		public function addBoost(boost:AbstractBoost):void {
			boosts.push(boost);
			var offset:int = 0;
			
			if (boosts.length <= 2) offset = 1;
			boost.boostIndex = (boosts.indexOf(boost));
			
			for (var i:int = 0; i < boosts.length; i++) {
				boosts[boosts.length - 1 - i].setAnchor(_player.tLeftVector[i + offset].x, -_player.tLeftVector[i + offset].x, _player.tLeftVector[i + offset].rotation, 180-_player.tLeftVector[i + offset].rotation, _player.tLeftVector[i + offset].y);
			}
			
		}
		
		public function tick(delta:Number):void 
		{
			for each(var b:AbstractBoost in boosts) {
				b.tick(delta);
			}
		}
		
		public function isOutOfFuel():Boolean {
			for each(var b:IGearWithFuel in boosts) {
				if (!b.isOutOfFuel()) return false;
			}
			return true;
		}
		
		public function get isPreventingDayEnd():Boolean {
			for each(var b:AbstractBoost in boosts) {
				if (b.preventDayEnd) return true;
			}
			return false;
		}
		
		/* INTERFACE src.game.gameobjects.player.IPlayerGear */
		
		public function destroy():void 
		{
			for each(var i:AbstractBoost in boosts) {
				i.destroy();
			}
			boosts = null;
			_player = null;
			_item = null;
		}
		
		/* INTERFACE src.game.gameobjects.player.IGearWithMass */
		
		public function get weight():Number 
		{
			var mass:Number = 0;
			
			for each(var i:IGearWithMass in boosts) {
				//trace(i, "has mass of", (i as IGearWithMass).weight);
				mass += (i as IGearWithMass).weight;
			}
			
			return mass;
		}
		
		public function get item():GameStateItem 
		{
			return _item;
		}
		
	}

}