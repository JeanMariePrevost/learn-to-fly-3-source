package src.game.gameobjects 
{
	import flash.display.DisplayObject;
	import nape.phys.Body;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IFallingObject extends IGameObject
	{
		function useObjectPosition(obj:DisplayObject):void
		function mimicBodyMomentum(body:Body, mult:Number = 1, gravityMassMult:Number = 1):void
		
	}
	
}