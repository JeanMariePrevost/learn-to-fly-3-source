package src.game.gameobjects.player.stage 
{
	import lbg.components.NumberBuffer;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class SupermanStage extends SimpleStage 
	{
		protected const MANUAL_BREAK_FUEL_PENALTY_MULT:Number = 0.7;
		
		protected var smoothingDrag:NumberBuffer = new NumberBuffer(13, 1);
		protected var smoothingAccel:NumberBuffer = new NumberBuffer(19, 0);
		protected var fuelPenaltyDuration:Number = 250;
		protected var fuelPenaltyTime:Number = 0;
		
		
		public function SupermanStage(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			//Loop Number buffer adds in case of extreme delta
			var smoothingDelta:Number = delta;
			while (smoothingDelta >= 0.6) {
				smoothingDelta -= 1;
				var val:Number = (_isStoppedByPlayer) ? 0:1;
				smoothingDrag.add(val);
				smoothingAccel.add(val);
			}
			
			if (_isStoppedByPlayer) {
				fuelPenaltyTime += delta;
				fuelPenaltyTime = NumberUtils.constrain(fuelPenaltyTime, 0, fuelPenaltyDuration);
				var fuelPenalty:Number = Easing.easeOutCubic(fuelPenaltyTime, MANUAL_BREAK_FUEL_PENALTY_MULT, -MANUAL_BREAK_FUEL_PENALTY_MULT, fuelPenaltyDuration);
				substractFuel(delta * fuelPenalty);
			}else {
				fuelPenaltyTime = 0;
			}
			
			var specialDrag:Number = 1 - ((1 - _item.statSpecial) * smoothingDrag.value * delta);
			
			
			_player.applyDrag(specialDrag);
		}
		
		override protected function applyPower(delta:Number, forceThrustRelativeAngle:Number = NaN):void 
		{
			super.applyPower(delta * smoothingAccel.value);
		}
		
	}

}