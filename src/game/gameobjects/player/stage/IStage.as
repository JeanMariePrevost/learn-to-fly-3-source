package src.game.gameobjects.player.stage 
{
	import src.game.gameobjects.player.IPlayerGear;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IStage extends IPlayerGear
	{
		function get isFinished():Boolean;
		function startStage():void;
		function get isStoppedByPlayer():Boolean;
		function get hasStarted():Boolean;
		
		//function tick(delta:Number):void;
		//function get item():GameStateItem;
		//function destroy():void;
	}
	
}