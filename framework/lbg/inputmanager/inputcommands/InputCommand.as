package lbg.inputmanager.inputcommands 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import lbg.inputmanager.InputManager;
	import lbg.utils.ArrayUtils;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author 
	 */
	public class InputCommand implements ICommandState
	{
		protected const MOUSE_KEYCODE:int = -3;
		protected const MOUSE_WHEEL_KEYCODE:int = -2;
		protected var _inputManager:InputManager;
		protected var _keyListeners:Array = new Array();
		protected var _mouseListenerUp:Boolean = false;
		protected var _mouseListenerDown:Boolean = false;
		protected var _commandIsDown:Boolean = false;
		protected var _currentTriggers:Array = new Array();
		
		protected var _signalCommandDown:Signal = new Signal();
		protected var _signalCommandDownWithKeyCode:Signal = new Signal(int);
		protected var _signalCommandUp:Signal = new Signal();
		protected var _signalCommandUpWithKeyCode:Signal = new Signal(int);
		
		public function get signalCommandDown():Signal 
		{
			return _signalCommandDown;
		}
		
		public function get signalCommandUp():Signal 
		{
			return _signalCommandUp;
		}
		
		public function get signalCommandDownWithKeyCode():Signal 
		{
			return _signalCommandDown;
		}
		
		public function get signalCommandUpWithKeyCode():Signal 
		{
			return _signalCommandUp;
		}
		
		public function get isDown():Boolean {
			return _commandIsDown;
		}
		
		public function InputCommand(inputManager:InputManager) 
		{
			_inputManager = inputManager;
			_inputManager.signalMasterReset.add(resetCommand);
		}
		
		public function addKeyListener(keyCode:int):void {
			if (_keyListeners.indexOf(keyCode) != -1) return;
			_keyListeners.push(keyCode);
			_inputManager.signalKeyDown.add(onKeyDown);
			_inputManager.signalKeyUp.add(onKeyUp);
		}
		
		public function removeAllKeyListeners():void {
			_keyListeners = new Array();
			_inputManager.signalKeyDown.remove(onKeyDown);
			_inputManager.signalKeyUp.remove(onKeyUp);
		}
		
		public function addMouseListener():void {
			_inputManager.signalMouseDown.add(onMouseDown);
			_inputManager.signalMouseUp.add(onMouseUp);
		}
		
		public function removeMouseListener():void {
			_inputManager.signalMouseDown.remove(onMouseDown);
			_inputManager.signalMouseUp.remove(onMouseUp);
		}
		
		public function addWheelUpListener():void {
			_inputManager.signalWheelUp.add(onWheel);
		}
		
		public function removeWheelUpListener():void {
			_inputManager.signalWheelUp.remove(onWheel);
		}
		
		public function addWheelDownListener():void {
			_inputManager.signalWheelDown.add(onWheel);
		}
		
		public function removeWheelDownListener():void {
			_inputManager.signalWheelDown.remove(onWheel);
		}
		
		//public function removeKeyListener(keyCode:int):void {
			//_keyListeners.splice(_keyListeners.indexOf(keyCode));
		//}
		//
		//public function removeMouseListener():void {
			//
		//}
		
		//Signal handlers
		public function onKeyDown(keyCode:int):void {
			for each(var i:int in _keyListeners) {
				if (i == keyCode) {
					doCommandDown(keyCode);
					return;
				}
			}
		}
		
		protected function onKeyUp(keyCode:int):void {
			for each(var i:int in _keyListeners) {
				if (i == keyCode) {
					doCommandUp(keyCode);
					return;
				}
			}
		}
		
		protected function onMouseDown():void {
			doCommandDown(MOUSE_KEYCODE);
		}
		
		protected function onMouseUp():void {
			doCommandUp(MOUSE_KEYCODE);
		}
		
		protected function onWheel(wheelDelta:int):void {
			doCommandDown(MOUSE_WHEEL_KEYCODE);
			doCommandUp(MOUSE_WHEEL_KEYCODE);
		}
		
		protected function doCommandDown(triggerCode:int):void {
			addTrigger(triggerCode);
			if (_commandIsDown == false) {
				//trace("Dispatching command signal DOWN");
				_commandIsDown = true;
				_signalCommandDown.dispatch();
			}
		}
		
		protected function doCommandUp(triggerCode:int):void {
			removeTrigger(triggerCode);
			_commandIsDown = checkTriggers();//Lifting a trigger while other down != command is up
			if (_commandIsDown == false) {
				//trace("Dispatching command signal UP");
				_signalCommandUp.dispatch();
			}
		}
		
		protected function resetCommand():void 
		{
			_currentTriggers = new Array();
			_commandIsDown = false;
		}
		
		protected function addTrigger(code:int):void {
			if (_currentTriggers.indexOf(code) == -1) _currentTriggers.push(code);
		}
		
		protected function removeTrigger(code:int):void {
			//if (_currentTriggers.indexOf(code) == -1) _currentTriggers.splice(_currentTriggers.indexOf(code));
			_currentTriggers.splice(_currentTriggers.indexOf(code),1 );
		}
		
		protected function checkTriggers():Boolean {
			return (_currentTriggers.length >= 1);
		}
		
		public function destroy():void 
		{
			_inputManager = null;
			_keyListeners = null;
			_currentTriggers = null;
			
			_signalCommandDown.removeAll();
			_signalCommandUp.removeAll();
			
			_signalCommandDown = null;
			_signalCommandUp = null;
		}
		
	}

}