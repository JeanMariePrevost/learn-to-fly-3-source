/* InputManager grabs keyboard and mouse events sent to a specified object (generally the stage)
 * and turns them into higher logic "commands", e.g. "up", "down", "jump", "fire"....
 * 
 * How to use:
 * 
 * Create an InputManager object, pass it the target object (e.g. this.stage)
	* var inputManager:InputManager = new InputManager(this.stage)
 * 
 * Create the commands you want
	 * var jumpCommand = inputManager.createCommand([array of keycodes])
	 * var clickCommand = inputManager.createCommand(null, true)
	 * var wheelDownCommand = inputManager.createCommand(null, false, false, true)
 * 
 * And finally listen to the command signals
 * myCreatedCommand.signalCommandDown for when the command is fired
 * myCreatedCommand.signalCommandUp for when the command is completely released
 * of
 * myCreatedCommand.isDown to get a Boolean of the state of the command
 * 
	* myCreatedCommand.signalCommandDown.add(functionToCallOnCommandDown)
 * or
	 * if(myCreatedCommand.isDown) do cool stuff
 * 
 * You can also access basic, premade commands by getting the basicCommand object from the InputManager
 * myInputManager.basicCommand.metaUp.isDown would tell you is either "w", "q" or "arrowUp" are being pressed
 */


package lbg.inputmanager 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.*;
	import lbg.inputmanager.inputcommands.*;
	import org.osflash.signals.Signal;
	
	public class InputManager
	{
		protected var _basicCommands:BasicCommands;
		
		protected var _signalMasterReset:Signal = new Signal();//Triggered manually, every command respond to master signal, useful to reset commands
		protected var _signalKeyDown:Signal = new Signal(int);
		protected var _signalKeyUp:Signal = new Signal(int);
		protected var _signalMouseDown:Signal = new Signal();
		protected var _signalMouseUp:Signal = new Signal();
		protected var _signalWheelDown:Signal = new Signal(int);
		protected var _signalWheelUp:Signal = new Signal(int);
		
		protected var _keyCodesDown:Array = new Array();
		protected var _mouseDown:Boolean = false;
		
		public function InputManager(target:DisplayObjectContainer) 
		{
			target.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			target.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			target.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			target.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			target.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		public function createCommand(listenToKeyCodes:Array = null, listenToMouse:Boolean = false, listenToWheelUp:Boolean = false, listenToWheelDown:Boolean = false):InputCommand {
			var c:InputCommand = new InputCommand(this);
			for each (var i:int in listenToKeyCodes) {
				c.addKeyListener(i);
			}
			if (listenToMouse) c.addMouseListener();
			if (listenToWheelDown) c.addWheelDownListener();
			if (listenToWheelUp) c.addWheelUpListener();
			return c;
		}
		
		public function createAnyKeyCommand(listenToMouse:Boolean = false, listenToWheelUp:Boolean = false, listenToWheelDown:Boolean = false):InputCommand {
			var c:InputCommand = new AnyKeyCommand(this);
			if (listenToMouse) c.addMouseListener();
			if (listenToWheelDown) c.addWheelDownListener();
			if (listenToWheelUp) c.addWheelUpListener();
			return c;
		}
		
		/** Resets an InputCommand and add new listeners while keeping its signal and subscribers intact */
		public function changeCommandTriggers(command:InputCommand, listenToKeyCodes:Array = null, listenToMouse:Boolean = false, listenToWheelUp:Boolean = false, listenToWheelDown:Boolean = false):InputCommand {
			var c:InputCommand = command;
			
			c.removeAllKeyListeners();
			c.removeMouseListener();
			c.removeWheelDownListener();
			c.removeWheelUpListener();
			
			for each (var i:int in listenToKeyCodes) {
				c.addKeyListener(i);
			}
			if (listenToMouse) c.addMouseListener();
			if (listenToWheelDown) c.addWheelDownListener();
			if (listenToWheelUp) c.addWheelUpListener();
			return c;
		}
		
		/** Removes all triggers from commands and mark them as _isDown = false */
		public function resetEveryCommand():void {
			_signalMasterReset.dispatch();
		}
		
		public function isKeyDown(keyCode:int):Boolean {
			return _keyCodesDown[keyCode];
		}
		
		public function isAnyKeyDown():Boolean {
			for each (var i:Boolean in _keyCodesDown) {
				if (i) return true;
			}
			return false;
		}
		
		public function isMouseDown():Boolean {
			return _mouseDown;
		}
		
		protected function onKeyDown(e:KeyboardEvent):void {
			_keyCodesDown[e.keyCode] = true;
			_signalKeyDown.dispatch(e.keyCode);
		}
		
		protected function onKeyUp(e:KeyboardEvent):void {
			_keyCodesDown[e.keyCode] = false;
			_signalKeyUp.dispatch(e.keyCode);
		}
		
		protected function onMouseDown(e:MouseEvent):void {
			_mouseDown = true;
			_signalMouseDown.dispatch();
		}
		
		protected function onMouseUp(e:MouseEvent):void {
			_mouseDown = false;
			_signalMouseUp.dispatch();
		}
		
		protected function onMouseWheel(e:MouseEvent):void {
			//trace("Wheel changed");
			if (e.delta > 0) {
				_signalWheelDown.dispatch(e.delta);
			}else {
				_signalWheelUp.dispatch(e.delta);
			}
		}
		
		/** Signal(keycode:int) */
		public function get signalKeyUp():Signal 
		{
			return _signalKeyUp;
		}
		
		/** Signal(keycode:int) */
		public function get signalKeyDown():Signal 
		{
			return _signalKeyDown;
		}
		
		public function get signalMouseDown():Signal 
		{
			return _signalMouseDown;
		}
		
		public function get signalMouseUp():Signal 
		{
			return _signalMouseUp;
		}
		
		public function get basicCommands():BasicCommands {
			if (_basicCommands == null) _basicCommands = new BasicCommands(this);
			return _basicCommands;
		}
		
		/** Signal(delta:int) */
		public function get signalWheelDown():Signal 
		{
			return _signalWheelDown;
		}
		
		/** Signal(delta:int) */
		public function get signalWheelUp():Signal 
		{
			return _signalWheelUp;
		}
		
		public function get signalMasterReset():Signal 
		{
			return _signalMasterReset;
		}
		
	}

}