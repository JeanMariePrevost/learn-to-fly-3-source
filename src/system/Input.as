package src.system
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import lbg.inputmanager.inputcommands.ICommandState;
	import lbg.inputmanager.inputcommands.InputCommand;
	import lbg.inputmanager.InputManager;
	import lbg.mousewheeltrap.MouseWheelTrap;
	
	/**
	 * ...
	 * @author 
	 */
	public class Input extends InputManager 
	{
		public static var quickSave:InputCommand;
		public static var quickLoad:InputCommand;
		public static var F2:InputCommand;
		public static var F3:InputCommand;
		public static var F6:InputCommand;
		public static var F7:InputCommand;
		public static var F8:InputCommand;
		public static var metaBoost:InputCommand;
		public static var metaDown:InputCommand;
		public static var metaLeft:InputCommand;
		public static var metaRight:InputCommand;
		public static var boost1:InputCommand;
		public static var boost2:InputCommand;
		public static var boost3:InputCommand;
		public static var boost4:InputCommand;
		public static var readyAbort:InputCommand;
		public static var asterisk:InputCommand;
		public static var minus:InputCommand;
		public static var esc:InputCommand;
		
		protected static var _instance:InputManager;
		
		public function Input(stage:Stage, enforcer:Enforcer) 
		{
			super(stage);
			
			MouseWheelTrap.setup(stage);//Stops mousewheel from scrolling page when cursor above stage
		}
		
		public static function initInputInstance(stage:Stage):void {
				_instance = new Input(stage, new Enforcer());
				
				//Custom commands
				quickSave = _instance.createCommand();
				quickLoad = _instance.createCommand();
				
				F2 = _instance.createCommand();
				F3 = _instance.createCommand();
				F6 = _instance.createCommand();
				F7 = _instance.createCommand();
				F8 = _instance.createCommand();
				
				metaBoost = _instance.createCommand();
				metaDown = _instance.createCommand();
				metaLeft = _instance.createCommand();
				metaRight = _instance.createCommand();
				
				boost1 = _instance.createCommand();
				boost2 = _instance.createCommand();
				boost3 = _instance.createCommand();
				boost4 = _instance.createCommand();
				
				readyAbort = _instance.createCommand();
				
				asterisk = _instance.createCommand();
				minus = _instance.createCommand();
				
				esc = _instance.createCommand();
		}
		
		public static function updateControlsFromProfile(profile:ProfileState):void {
			updateDebugControls();
			
			////////////////////////////////////////
			//Game Controls
			//Defaults are hard-coded here
			
			//UP
			if (profile.controlsBoosts < 0) {
				metaBoost = _instance.changeCommandTriggers(metaBoost, [38, 87, 90], profile.controlsUseMouseBoost);
			}else {
				metaBoost = _instance.changeCommandTriggers(metaBoost, [profile.controlsBoosts]);
			}
			
			//DOWN
			if (profile.controlsBoosts < 0) {
				metaDown = _instance.changeCommandTriggers(metaDown, [40, 83]);
			}else {
				metaDown = _instance.changeCommandTriggers(metaDown, [profile.controlsBrake]);
			}
			
			//LEFT
			if (profile.controlsBoosts < 0) {
				metaLeft = _instance.changeCommandTriggers(metaLeft, [37, 65, 81]);
			}else {
				metaLeft = _instance.changeCommandTriggers(metaLeft, [profile.controlsTurnLeft]);
			}
			
			//RIGHT
			if (profile.controlsBoosts < 0) {
				metaRight = _instance.changeCommandTriggers(metaRight, [39, 68]);
			}else {
				metaRight = _instance.changeCommandTriggers(metaRight, [profile.controlsTurnRight]);
			}
			
			//BOOST1
			if (profile.controlsBoost1 < 0) {
				boost1 = _instance.changeCommandTriggers(boost1, [49]);
			}else {
				boost1 = _instance.changeCommandTriggers(boost1, [profile.controlsBoost1]);
			}
			
			//BOOST2
			if (profile.controlsBoost2 < 0) {
				boost2 = _instance.changeCommandTriggers(boost2, [50]);
			}else {
				boost2 = _instance.changeCommandTriggers(boost2, [profile.controlsBoost2]);
			}
			
			//BOOST3
			if (profile.controlsBoost3 < 0) {
				boost3 = _instance.changeCommandTriggers(boost3, [51]);
			}else {
				boost3 = _instance.changeCommandTriggers(boost3, [profile.controlsBoost3]);
			}
			
			//BOOST4
			if (profile.controlsBoost4 < 0) {
				boost4 = _instance.changeCommandTriggers(boost4, [52]);
			}else {
				boost4 = _instance.changeCommandTriggers(boost4, [profile.controlsBoost4]);
			}
			
			//READY ABORT
			if (profile.controlsReadyAbort < 0) {
				readyAbort = _instance.changeCommandTriggers(readyAbort, [13]);
			}else {
				readyAbort = _instance.changeCommandTriggers(readyAbort, [profile.controlsReadyAbort]);
			}
			
		}
		
		public static function updateDebugControls():void {
			////////////////////////////////////////
			//Debugging controls
			
			F2 = _instance.changeCommandTriggers(F2, [113]);
			F3 = _instance.changeCommandTriggers(F3, [114]);
			F6 = _instance.changeCommandTriggers(F6, [117]);
			F7 = _instance.changeCommandTriggers(F7, [118]);
			F8 = _instance.changeCommandTriggers(F8, [119]);
			
			asterisk = _instance.changeCommandTriggers(asterisk, [106]);
			minus = _instance.changeCommandTriggers(minus, [109]);
			
			esc = _instance.changeCommandTriggers(esc, [27]);
			
		}
		
		public static function get instance():InputManager {
			if (_instance == null) {
				throw new Error("Input not initiated");
				return null;
			}
			return _instance;
		}
		
	}

}

class Enforcer{}