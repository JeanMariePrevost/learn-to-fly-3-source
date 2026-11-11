package src.game 
{
	import flash.display.DisplayObjectContainer;
	import lbg.debug.Log;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameEngineSandbox extends GameEnginePayload 
	{
		protected static var _instance:GameEngineSandbox;
		
		public static var stagePower:Number = 1;
		public static var stageFuel:Number = 1;
		public static var boostPower:Number = 1;
		public static var boostFuel:Number = 1;
		public static var launchPower:Number = 1;
		public static var topSpeed:Number = 1;
		public static var weight:Number = 1;
		public static var drag:Number = 1;
		public static var control:Number = 1;
		public static var gravity:Number = 1;
		public static var wind:Number = 1;
		public static var money:Number = 1;
		public static var obstacle:Number = 1;
		public static var obstacleWeight:Number = 1;
		public static var spaceLevel:Number = 0;
		public static var payload:Number = 0;
		public static var deltaMult:Number = 1;
			
		public function GameEngineSandbox() 
		{
			super();
			
		}
		
		override protected function disableSpaceMinigame():void 
		{
			if (spaceLevel <= 0) {
				super.disableSpaceMinigame();
			}
		}
		
		override protected function setupPayload(forceWeight:Number = NaN):void 
		{
			if (payload > 0) {
				super.setupPayload(payload);
			}
		}
		
		override protected function initStatHooks():void 
		{
			super.initStatHooks();
			
			//Apply all sandbox settings
			StatHooks.boostFuelMult.base = boostFuel;
			StatHooks.boostPowerMult.base = boostPower;
			StatHooks.dragMult.base = drag;
			StatHooks.gravityMult.base = gravity;
			StatHooks.launchPowerMult.base = launchPower;
			StatHooks.moneyMult.base = money;
			StatHooks.obstacleMassMult.base = obstacleWeight;
			StatHooks.obstaclesMult.base = obstacle;
			StatHooks.rudderMult.base = control;
			StatHooks.stageFuelMult.base = stageFuel;
			StatHooks.stagePowerMult.base = stagePower;
			StatHooks.topSpeedMult.base = topSpeed;
			StatHooks.weightMult.base = weight;
			StatHooks.windEffectMult.base = wind;
			
			Log.log("Sandbox mode settings:");
			Log.log("Boost Fuel:", StatHooks.boostFuelMult.base);
			Log.log("Boost Power:", StatHooks.boostPowerMult.base);
			Log.log("Drag:", StatHooks.dragMult.base);
			Log.log("Gravity:", StatHooks.gravityMult.base);
			Log.log("Launch Power:", StatHooks.launchPowerMult.base);
			Log.log("Money:", StatHooks.moneyMult.base);
			Log.log("Obstacle Mass:", StatHooks.obstacleMassMult.base);
			Log.log("Obstacle Spawn:", StatHooks.obstaclesMult.base);
			Log.log("Rudder:", StatHooks.rudderMult.base);
			Log.log("Stage Fuel:", StatHooks.stageFuelMult.base);
			Log.log("Stage Power:", StatHooks.stagePowerMult.base);
			Log.log("Top Speed:", StatHooks.topSpeedMult.base);
			Log.log("Weight:", StatHooks.weightMult.base);
			Log.log("Wind:", StatHooks.windEffectMult.base);
			
			
		}
		
		override protected function onAltitude(alt:Number):void 
		{
			//No milestones in sandbox mode
			//super.onAltitude(alt);
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta * GameEngineSandbox.deltaMult);
		}
		
		static public function get instance():GameEngineSandbox 
		{
			//if (_instance == null) _instance = new GameEngine();
			return _instance;
		}
		
		static public function initInstance():GameEngineSandbox 
		{
			if (_instance == null) {
				_instance = new GameEngineSandbox();
				return _instance;
			}else {
				throw new Error("GameEngine.initInstance() Instance already exists");
				return _instance;
			}
		}
		
		public static function destroy():void {
			if (_instance) _instance.destroy();
		}
		
		override public function destroy():void 
		{
			_instance = null;
			super.destroy();
		}
		
	}

}