package src.game.gameobjects.player.stage 
{
	import lbg.compositetick.ICompositeLeaf;
	import src.game.GameCamera;
	import src.game.GameMediator;
	import src.game.gameobjects.player.IGearWithMass;
	import src.game.gameobjects.player.IPlayerGear;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	/**
	 * ...
	 * @author 
	 */
	public class StageController implements IPlayerGear, IGearWithMass
	{
		public var stages:Vector.<IStage> = new Vector.<IStage>();
		public var currentStage:int = 0;
		
		protected var _showOnHud:Boolean = false;
		protected var _player:Player;
		protected var _item:GameStateItem = null;// GameStateItem.createFrom("stageController", 0);
		protected var _stoppedByPlayer:Boolean = false;
		
		protected var _interStageDelayDuration:Number = 40;
		protected var _interStageDelayTime:Number = _interStageDelayDuration;
		
		
		public function StageController(player:Player, ...stages) 
		{
			_player = player;
			
			for each(var i:IStage in stages) {
				this.stages.push(i);
			}
		}
		
		public function addStage(stage:IStage):void {
			stages.push(stage);
		}
		
		/* INTERFACE lbg.compositetick.ICompositeLeaf */
		
		public function tick(delta:Number):void 
		{
			if (outOfStages) return;
			
			var s:IStage = stages[currentStage];
			
			if (s.hasStarted == false) {
				//InterStage Delay
				if (_interStageDelayTime < _interStageDelayDuration) {
					_interStageDelayTime += delta;
				}else {
					s.startStage();
				}
			}
			
			//Ticking every activated stage
			for (var i:int = 0; i <= currentStage; i++) {
				if (stages[i].hasStarted) {
					stages[i].tick(delta);
				}
			}
			
			if (s.isFinished) {
				GameMediator.stageFinished.dispatch(s);
				currentStage += 1;
				_interStageDelayTime = 0;
				_player.updateBodyMass();
			}
		}
		
		/* INTERFACE src.game.gameobjects.player.IPlayerGear */
		
		public function destroy():void 
		{
			for each(var i:IStage in stages) {
				i.destroy();
			}
			stages = null;
			_player = null;
			_item = null;
		}
		
		/* INTERFACE src.game.gameobjects.player.IGearWithMass */
		
		public function get weight():Number 
		{
			//if (outOfStages) return 0;
			
			var mass:Number = 0;
			
			for (var i:int = currentStage; i < stages.length; i++) {
				mass += stages[i].item.statWeight;
			}
			
			return mass;
		}
		
		public function get item():GameStateItem 
		{
			return _item;
		}
		
		public function get outOfStages():Boolean {
			return currentStage >= stages.length;
		}
		
		public function isOutOfFuel():Boolean {
			return true;
		}
		
		public function get isStoppedByPlayer():Boolean {
			//trace("isStoppedByPlayer");
			if (!outOfStages) {
				return stages[currentStage].isStoppedByPlayer;
			}else {
				return false;
			}
		}
		
	}

}