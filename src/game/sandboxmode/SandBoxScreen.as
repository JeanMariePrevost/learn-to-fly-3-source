package src.game.sandboxmode {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import lbg.utils.NumberUtils;
	import src.ScreenManager;
	import src.UiScaler;
	import src.game.GameEngineSandbox;
	import src.gui.decorators.MouseBounce2;
	import src.gui.Transition;
	import src.Main;
	import src.shop.ShopTooltip;
	import src.system.Global;
	
	/**
	 * ...
	 * @author light_bringer777
	 */
	public class SandBoxScreen extends MovieClip 
	{
		protected static var _instance:SandBoxScreen;
		
		public var txtStagePower:TextField;
		public var txtStageFuel:TextField;
		public var txtBoostPower:TextField;
		public var txtBoostFuel:TextField;
		public var txtLaunchPower:TextField;
		public var txtTopSpeed:TextField;
		public var txtWeight:TextField;
		public var txtDrag:TextField;
		public var txtControl:TextField;
		public var txtGravity:TextField;
		public var txtWind:TextField;
		public var txtMoney:TextField;
		public var txtObstacle:TextField;
		public var txtObstacleWeight:TextField;
		public var txtSpace:TextField;
		public var txtPayload:TextField;
		public var txtDelta:TextField;
		
		public var bgTxt1:MovieClip;
		public var bgTxt2:MovieClip;
		public var bgPixels:MovieClip;
		public var bgPixels2:MovieClip;
		
		public var btnOk:SimpleButton;
		public var btnReset:SimpleButton;
		
		public var _okBounce:MouseBounce2;
		public var _resetBounce:MouseBounce2;
		
		protected var _matrixBg:MatrixBg;
		protected var _targetX:Number = 0;
		protected var _targetY:Number = 0;
		
		public function SandBoxScreen(singleton:Enforcer) 
		{
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			//_matrixBg = new MatrixBg();
			//addChildAt(_matrixBg, getChildIndex(bgPixels));
			
			txtStagePower.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtStageFuel.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtBoostPower.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtBoostFuel.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtLaunchPower.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtTopSpeed.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtWeight.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtDrag.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtControl.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtGravity.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtWind.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtMoney.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtObstacle.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtObstacleWeight.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtSpace.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtPayload.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			txtDelta.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			
			txtStagePower.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtStageFuel.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtBoostPower.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtBoostFuel.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtLaunchPower.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtTopSpeed.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtWeight.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtDrag.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtControl.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtGravity.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtWind.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtMoney.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtObstacle.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtObstacleWeight.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtSpace.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtPayload.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			txtDelta.addEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			
			_okBounce = new MouseBounce2(btnOk);
			_resetBounce = new MouseBounce2(btnReset);
			
			loadFromEngine();
			validateValues();
			
			btnOk.addEventListener(MouseEvent.CLICK, onOkClick)
			btnReset.addEventListener(MouseEvent.CLICK, resetClick);
			
			Main.guiTickSignal.add(tick);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			UiScaler.addAbsoluteManually(this, 360, -360);
		}
		
		private function onTxtChanged(e:FocusEvent):void 
		{
			validateValues();
		}
		
		private function onOkClick(e:MouseEvent):void 
		{
			//Save values to game engine hooks
			validateValues();
			GameEngineSandbox.boostFuel = Number(txtBoostFuel.text);
			GameEngineSandbox.boostPower = Number(txtBoostPower.text);
			GameEngineSandbox.control = Number(txtControl.text);
			GameEngineSandbox.deltaMult = Number(txtDelta.text);
			GameEngineSandbox.drag = Number(txtDrag.text);
			GameEngineSandbox.gravity = Number(txtGravity.text);
			GameEngineSandbox.launchPower = Number(txtLaunchPower.text);
			GameEngineSandbox.money = Number(txtMoney.text);
			GameEngineSandbox.obstacle = Number(txtObstacle.text);
			GameEngineSandbox.obstacleWeight = Number(txtObstacleWeight.text);
			GameEngineSandbox.payload = Number(txtPayload.text);
			GameEngineSandbox.spaceLevel = Number(txtSpace.text);
			GameEngineSandbox.stageFuel = Number(txtStageFuel.text);
			GameEngineSandbox.stagePower = Number(txtStagePower.text);
			GameEngineSandbox.topSpeed = Number(txtTopSpeed.text);
			GameEngineSandbox.weight = Number(txtWeight.text);
			GameEngineSandbox.wind = Number(txtWind.text);
			
			Transition.transitionTo(destroy, ScreenManager.loadShop);
		}
		
		protected function loadFromEngine():void {
			txtBoostFuel.text = fromEngineToString(GameEngineSandbox.boostFuel);
			txtBoostPower.text = fromEngineToString(GameEngineSandbox.boostPower);
			txtControl.text = fromEngineToString(GameEngineSandbox.control);
			txtDelta.text = fromEngineToString(GameEngineSandbox.deltaMult);
			txtDrag.text = fromEngineToString(GameEngineSandbox.drag);
			txtGravity.text = fromEngineToString(GameEngineSandbox.gravity);
			txtLaunchPower.text = fromEngineToString(GameEngineSandbox.launchPower);
			txtMoney.text = fromEngineToString(GameEngineSandbox.money);
			txtObstacle.text = fromEngineToString(GameEngineSandbox.obstacle);
			txtObstacleWeight.text = fromEngineToString(GameEngineSandbox.obstacleWeight);
			txtPayload.text = fromEngineToString(GameEngineSandbox.payload);
			txtSpace.text = fromEngineToString(GameEngineSandbox.spaceLevel);
			txtStageFuel.text = fromEngineToString(GameEngineSandbox.stageFuel);
			txtStagePower.text = fromEngineToString(GameEngineSandbox.stagePower);
			txtTopSpeed.text = fromEngineToString(GameEngineSandbox.topSpeed);
			txtWeight.text = fromEngineToString(GameEngineSandbox.weight);
			txtWind.text = fromEngineToString(GameEngineSandbox.wind);
		}
		
		protected function fromEngineToString(value:Number):String {
			if (value == 1) {
				return value.toFixed(1);
			}else {
				return String(value);
			}
		}
		
		private function resetClick(e:MouseEvent):void 
		{
			txtStagePower.text = "1.0";
			txtStageFuel.text = "1.0";
			txtBoostPower.text = "1.0";
			txtBoostFuel.text = "1.0";
			txtLaunchPower.text = "1.0";
			txtTopSpeed.text = "1.0";
			txtWeight.text = "1.0";
			txtDrag.text = "1.0";
			txtControl.text = "1.0";
			txtGravity.text = "1.0";
			txtWind.text = "1.0";
			txtMoney.text = "1.0";
			txtObstacle.text = "1.0";
			txtObstacleWeight.text = "1.0";
			txtSpace.text = "0";
			txtPayload.text = "0";
			txtDelta.text = "1.0";
		}
		
		protected function validateValues():void {
			//Reset NaNs
			if (isNaN(Number(txtStagePower.text))) txtStagePower.text = "1.0";
			if (isNaN(Number(txtStageFuel.text))) txtStageFuel.text = "1.0";
			if (isNaN(Number(txtBoostPower.text))) txtBoostPower.text = "1.0";
			if (isNaN(Number(txtBoostFuel.text))) txtBoostFuel.text = "1.0";
			if (isNaN(Number(txtLaunchPower.text))) txtLaunchPower.text = "1.0";
			if (isNaN(Number(txtTopSpeed.text))) txtTopSpeed.text = "1.0";
			if (isNaN(Number(txtWeight.text))) txtWeight.text = "1.0";
			if (isNaN(Number(txtDrag.text))) txtDrag.text = "1.0";
			if (isNaN(Number(txtControl.text))) txtControl.text = "1.0";
			if (isNaN(Number(txtGravity.text))) txtGravity.text = "1.0";
			if (isNaN(Number(txtWind.text))) txtWind.text = "1.0";
			if (isNaN(Number(txtMoney.text))) txtMoney.text = "1.0";
			if (isNaN(Number(txtObstacle.text))) txtObstacle.text = "1.0";
			if (isNaN(Number(txtObstacleWeight.text))) txtObstacleWeight.text = "1.0";
			if (isNaN(Number(txtSpace.text))) txtSpace.text = "0";
			if (isNaN(Number(txtPayload.text))) txtPayload.text = "0";
			if (isNaN(Number(txtDelta.text))) txtDelta.text = "1.0";
			
			//Constrain some values
			//Floor
			if (Number(txtStageFuel.text) <= 0) txtStageFuel.text = "0";
			if (Number(txtBoostFuel.text) <= 0) txtBoostFuel.text = "0";
			if (Number(txtTopSpeed.text) <= 0) txtTopSpeed.text = "0";
			if (Number(txtWeight.text) <= 0) txtWeight.text = "0.01";
			if (Number(txtWind.text) <= 0) txtWind.text = "0";
			if (Number(txtObstacle.text) <= 0) txtObstacle.text = "0";
			if (Number(txtObstacleWeight.text) <= 0) txtObstacleWeight.text = "0.01";
			if (Number(txtSpace.text) <= 0) txtSpace.text = "0";
			if (Number(txtDelta.text) <= 0.1) txtDelta.text = "0.1";
			
			//Ceiling
			if (Number(txtDelta.text) >= 20) txtDelta.text = "20";
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			_targetX = NumberUtils.interpolate2( -1, 1, 0, 720, e.stageX);
			_targetY = NumberUtils.interpolate2( -1, 1, 0, 540, e.stageY);
		}
		
		protected function tick(delta:Number):void {
			if (bgPixels) {
				bgPixels.x -= (bgPixels.x - (_targetX * 30)) * 0.04;
				bgPixels.y -= (bgPixels.y - (_targetY * 30)) * 0.04;
				bgPixels2.x -= (bgPixels2.x - (_targetX * 80) - 680) * 0.01;//Offset becaus eit's flipped and not centered at 0,0
				bgPixels2.y -= (bgPixels2.y - (_targetY * 80) - 472) * 0.01;
				bgTxt1.x -= (bgTxt1.x - (_targetX * 40)) * 0.02;
				bgTxt1.y -= (bgTxt1.y - (_targetY * 40)) * 0.02;
				bgTxt2.x -= (bgTxt2.x - (_targetX * 60)) * 0.06;
				bgTxt2.y -= (bgTxt2.y - (_targetY * 60)) * 0.06;
			}
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			var t:TextField = (e.target as TextField);
			
			if (t) {
				ShopTooltip.show(t, getTitle(t), getDesc(t));
			}
		}
		
		protected function getTitle(txt:TextField):String {
			switch(txt) {
				case txtStagePower:
					return "Multipler for stage thurst power";
				case txtStageFuel:
					return "Multiplier for stage fuel";
				case txtBoostPower:
					return "Multiplier for boost thrust power";
				case txtBoostFuel:
					return "Multiplier for boost fuel";
				case txtLaunchPower:
					return "Multiplier for launcher power";
				case txtTopSpeed:
					return "Multiplier for your top speed";
				case txtWeight:
					return "Multiplier for the weight of every item equipped";
				case txtDrag:
					return "Multiplier for drag and redzone";
				case txtControl:
					return "Multiplier for flight control";
				case txtGravity:
					return "Multiplier for gravity";
				case txtWind:
					return "Mutiplier for the strength of the wind";
				case txtMoney:
					return "Multiplier for cash earned at the end of the day";
				case txtObstacle:
					return "Multiplier for the amount of obstacles spawned";
				case txtObstacleWeight:
					return "Multiplier for the mass of obstacles";
				case txtSpace:
					return "Altitude at which the Story Mode space minigame triggers";
				case txtPayload:
					return "Weight of the payload you're carrying";
				case txtDelta:
					return "Alters the speed of the whole game";
				default:
					return "ERROR";
			}
		}
		
		protected function getDesc(txt:TextField):String {
			switch(txt) {
				case txtStagePower:
					return "0 to 20, very high values can crash the game and destroy the earth";
				case txtStageFuel:
					return "0 to 50, very high values can crash the game and \rmake you abort the day because who wants to fly for 17 hours?";
				case txtBoostPower:
					return "0 to 20, very high values can crash game";
				case txtBoostFuel:
					return "0 to 50, very high values can crash game";
				case txtLaunchPower:
					return "0 to 20, very high values can crash the game";
				case txtTopSpeed:
					return "0 to 10, very high values can crash the game and \rhave you arrested";
				case txtWeight:
					return "0.01 to 20, cannot be zero, very high values will \rmake you fat and can crash the game";
				case txtDrag:
					return "0 to 10, very high values will have you stuck in place, \rand eventually crash the game";
				case txtControl:
					return "0 to 5, very high value will have you spinning like mad, \rand can crash the game";
				case txtGravity:
					return "0.01 to 20, cannot be zero, very high values \rwill pin you to the ground and can crash the game";
				case txtWind:
					return "0 to 20, very high value will send you flying and \rcan crash the game";
				case txtMoney:
					return "0 to 100, very high values can crash the game and \rhave you sell your parents to slave traders";
				case txtObstacle:
					return "0 to 20, very high values can crash the game \rand burn your CPU";
				case txtObstacleWeight:
					return "0.01 to 20, cannot be zero, very high values can crash the game";
				case txtSpace:
					return "0 to disable, default is " + Global.spaceAltitude.toFixed();
				case txtPayload:
					return "0 to disable";
				case txtDelta:
					return "0.1 to 3, other values will alter reality and make you a banana or something, I dunno";
				default:
					return "ERROR";
			}
		}
		
		public static function get instance():SandBoxScreen {
			if (_instance == null) {
				_instance = new SandBoxScreen(new Enforcer());
			}
			
			return _instance;
		}
		
		public static function destroy():void {
			if (_instance) {
				_instance.destroy();
			}
		}
		
		public function destroy():void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			Main.guiTickSignal.remove(tick);
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			_instance = null;
			
			if (btnOk) btnOk.addEventListener(MouseEvent.CLICK, onOkClick)
			btnOk = null;
			
			if (btnReset) btnReset.addEventListener(MouseEvent.CLICK, resetClick);
			btnReset = null;
			
			
			if (txtStagePower) {
				txtStagePower.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtStageFuel.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtBoostPower.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtBoostFuel.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtLaunchPower.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtTopSpeed.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtWeight.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtDrag.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtControl.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtGravity.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtWind.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtMoney.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtObstacle.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtObstacleWeight.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtSpace.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtPayload.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				txtDelta.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				
				txtStagePower.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtStageFuel.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtBoostPower.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtBoostFuel.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtLaunchPower.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtTopSpeed.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtWeight.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtDrag.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtControl.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtGravity.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtWind.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtMoney.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtObstacle.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtObstacleWeight.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtSpace.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtPayload.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
				txtDelta.removeEventListener(FocusEvent.FOCUS_OUT, onTxtChanged);
			}
			
			bgTxt1 = null;
			bgTxt2 = null;
			bgPixels = null;
			bgPixels2 = null;
			
			if(_okBounce) _okBounce.destroy();
			_okBounce = null;
			
			if (_resetBounce) _resetBounce.destroy();
			_resetBounce = null;
			
			if (_matrixBg) _matrixBg.destroy();
		
			txtStagePower = null;
			txtStageFuel = null;
			txtBoostPower = null;
			txtBoostFuel = null;
			txtLaunchPower = null;
			txtTopSpeed = null;
			txtWeight = null;
			txtDrag = null;
			txtControl = null;
			txtGravity = null;
			txtWind = null;
			txtMoney = null;
			txtObstacle = null;
			txtObstacleWeight = null;
			txtSpace = null;
			txtPayload = null;
			txtDelta = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}

class Enforcer { }
