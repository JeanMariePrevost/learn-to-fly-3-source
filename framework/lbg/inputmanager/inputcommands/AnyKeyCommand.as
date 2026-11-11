package lbg.inputmanager.inputcommands 
{
	import lbg.inputmanager.InputManager;
	
	/**
	 * ...
	 * @author 
	 */
	public class AnyKeyCommand extends InputCommand 
	{
		
		public function AnyKeyCommand(inputManager:InputManager) 
		{
			super(inputManager);
			
			//Add key listeners by default
			_inputManager.signalKeyDown.add(onKeyDown);
			_inputManager.signalKeyUp.add(onKeyUp);
			
		}
		
		override public function onKeyDown(keyCode:int):void {
			//Any key triggers command
			doCommandDown(keyCode);
		}
		
		override protected function onKeyUp(keyCode:int):void {
			doCommandUp(keyCode);
		}
	}

}