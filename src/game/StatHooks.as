package src.game 
{
	import src.compound.CompoundNumber;
	import src.compound.Mod;
	import src.reg.Registry;
	import src.system.GameState;
	import src.system.Global;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author 
	 */
	public class StatHooks 
	{
		protected static var _deltaTimeMult:CompoundNumber;
		
		protected static var _topSpeedFlat:CompoundNumber;
		protected static var _rudderFlat:CompoundNumber;
		
		protected static var _boostFuelMult:CompoundNumber;
		protected static var _boostPowerMult:CompoundNumber;
		protected static var _gravityMult:CompoundNumber;
		protected static var _launchPowerMult:CompoundNumber;
		protected static var _obstaclesMult:CompoundNumber;//Amount of obstacles
		protected static var _dragMult:CompoundNumber;
		protected static var _moneyMult:CompoundNumber;
		protected static var _moneyFlat:CompoundNumber;
		protected static var _stageFuelMult:CompoundNumber;
		protected static var _stagePowerMult:CompoundNumber;
		protected static var _topSpeedMult:CompoundNumber;
		protected static var _rudderMult:CompoundNumber;
		protected static var _weightMult:CompoundNumber;
		protected static var _invisWeightMult:CompoundNumber;
		protected static var _windEffectMult:CompoundNumber;
		
		protected static var _cameraZoomFloor:Number = 0;//Hook for launchers to set a min zoom value
		protected static var _cameraZoomCeil:Number = 0;//Hook for launchers to set a max zoom value, <0 disables it
		protected static var _cameraYOffset:CompoundNumber;
		
		protected static var _obstacleMassMult:CompoundNumber;
		protected static var _obstacleSpeedMult:CompoundNumber;
		
		public static function initHooks():void {
			destroy();
			
			_deltaTimeMult = new CompoundNumber(1);
			
			_topSpeedFlat = new CompoundNumber(0);
			_rudderFlat = new CompoundNumber(0);
			
			_boostFuelMult = new CompoundNumber(1);
			_boostPowerMult = new CompoundNumber(1);
			_gravityMult = new CompoundNumber(1);
			_launchPowerMult = new CompoundNumber(1);
			_obstaclesMult = new CompoundNumber(1);
			_dragMult = new CompoundNumber(1);
			_moneyMult = new CompoundNumber(1);
			_moneyFlat = new CompoundNumber(0);
			_stageFuelMult = new CompoundNumber(1);
			_stagePowerMult = new CompoundNumber(1);
			_topSpeedMult = new CompoundNumber(1);
			_rudderMult = new CompoundNumber(Global.STEERING_POWER_MULT);
			_weightMult = new CompoundNumber(1);
			_invisWeightMult = new CompoundNumber(1);
			_windEffectMult = new CompoundNumber(1);
			
			_cameraYOffset = new CompoundNumber(0);
			
			_obstacleMassMult = new CompoundNumber(Global.baseObstacleMassMult);
			_obstacleMassMult.addMod(new Mod(0, ProfileState.instance.bonusItems.bonusImpact.statPower));
			
			_obstacleSpeedMult = new CompoundNumber(Global.baseObstacleSpeedMult);
			
			//Bonus items effects
			_boostFuelMult.addMod(new Mod(0, ProfileState.instance.bonusItems.bonusBoostFuel.statPower));
			_boostPowerMult.addMod(new Mod(0, ProfileState.instance.bonusItems.bonusBoostPower.statPower));
			_topSpeedMult.addMod(new Mod(0, ProfileState.instance.bonusItems.bonusSpeed.statPower));
			_gravityMult.addMod(new Mod(0, ProfileState.instance.bonusItems.bonusGravity.statPower));
			_launchPowerMult.addMod(new Mod(0, ProfileState.instance.bonusItems.bonusLaunchPower.statPower));
			_obstaclesMult.addMod(new Mod(0, ProfileState.instance.bonusItems.bonusLessObstacles.statPower));
			_dragMult.addMod(new Mod(0, ProfileState.instance.bonusItems.bonusDrag.statPower));
			_moneyMult.addMod(new Mod(0, ProfileState.instance.bonusItems.bonusMoney.statPower));
			_stageFuelMult.addMod(new Mod(0, ProfileState.instance.bonusItems.bonusStageFuel.statPower));
			_stagePowerMult.addMod(new Mod(0, ProfileState.instance.bonusItems.bonusStagePower.statPower));
			
			////////////////////////////////////
			//Medals bonuses effects
			_dragMult.addMod2(0, Registry.getEntry("medalSpeed").statPower.valueAt(ProfileState.instance.medals.speed));
			_stagePowerMult.addMod2(0, Registry.getEntry("medalAltitude").statPower.valueAt(ProfileState.instance.medals.altitude));
			_stageFuelMult.addMod2(0, Registry.getEntry("medalFlightTime").statPower.valueAt(ProfileState.instance.medals.flightTime));
			_moneyMult.addMod2(0, Registry.getEntry("medalCash").statPower.valueAt(ProfileState.instance.medals.cash));
			_boostPowerMult.addMod2(0, Registry.getEntry("medalHorizontalDistance").statPower.valueAt(ProfileState.instance.medals.horizontalDistance));
			_launchPowerMult.addMod2(0, Registry.getEntry("medalDays").statPower.valueAt(ProfileState.instance.medals.days));
			_rudderMult.addMod2(0, Registry.getEntry("medalItemUpgrades").statPower.valueAt(ProfileState.instance.medals.itemUpgrades));
			_moneyMult.addMod2(0, Registry.getEntry("medalFrequentBuyer").statPower.valueAt(ProfileState.instance.medals.frequentBuyer));
			_boostPowerMult.addMod2(0, Registry.getEntry("medalAltitudeTotal").statPower.valueAt(ProfileState.instance.medals.altitudeTotal));
			_boostFuelMult.addMod2(0, Registry.getEntry("medalFlightTimeTotal").statPower.valueAt(ProfileState.instance.medals.flightTimeTotal));
			//_boostFuelMult.addMod2(0, Registry.getEntry("medalCashTotal").statPower.valueAt(ProfileState.instance.medals.cashTotal));//Special case, adds cash to new gamestates
			_obstacleMassMult.addMod2(0, Registry.getEntry("medalObstaclesHit").statPower.valueAt(ProfileState.instance.medals.obstaclesHit));
			_launchPowerMult.addMod2(0, Registry.getEntry("medalStagesOnly").statPower.valueAt(ProfileState.instance.medals.stagesOnly));
			_dragMult.addMod2(0, Registry.getEntry("medalBasicBody").statPower.valueAt(ProfileState.instance.medals.basicBody));
			_weightMult.addMod2(0, Registry.getEntry("medalPayload").statPower.valueAt(ProfileState.instance.medals.payload));
			
			/////////////////////////////////////////////////////////////////////////
			//Cheats
			if (ProfileState.instance.cheatObstaclesTimes10) {
				StatHooks.obstaclesMult.addMod2(0, Global.OBSTACLE_TIMES_10_VALUE);
			}else if (ProfileState.instance.cheatObstaclesTimes100) {
				StatHooks.obstaclesMult.addMod2(0, Global.OBSTACLE_TIMES_100_VALUE);
			}
			
			if (ProfileState.instance.cheatHeavyObstacles) _obstacleMassMult.addMod2(Global.HEAVY_OBSTACLES_CHEAT_MULT);
			
			if (ProfileState.instance.cheatDodos) _obstacleMassMult.addMod2(Global.DODO_CHEAT_OBSTACLES_WEIGHT_MULT);
			
			if (ProfileState.instance.cheatGravityTimes2) {
				StatHooks.gravityMult.addMod2(0, Global.GRAVITY_TIMES_2_VALUE);
			}else if (ProfileState.instance.cheatGravityTimes10) {
				StatHooks.gravityMult.addMod2(0, Global.GRAVITY_TIMES_10_VALUE);
			}
			
			
			
			
			//Game mode tweaks
			//Payload
			if (ProfileState.instance.currentGameState.gameMode == "Payload Mode") {
				_launchPowerMult.base = 1.5;
				_boostPowerMult.base = 1.2;
				_stagePowerMult.base = 1.3;
			}
		}
		
		static public function destroy():void {
			if (_topSpeedFlat)_topSpeedFlat.destroy();
			if (_rudderFlat)_rudderFlat.destroy();
			
			if (_boostFuelMult)_boostFuelMult.destroy();
			if(_boostPowerMult)_boostPowerMult.destroy();
			if(_deltaTimeMult)_deltaTimeMult.destroy();
			if(_gravityMult)_gravityMult.destroy();
			if(_launchPowerMult)_launchPowerMult.destroy();
			if(_obstaclesMult)_obstaclesMult.destroy();
			if(_dragMult)_dragMult.destroy();
			if(_moneyMult)_moneyMult.destroy();
			if(_moneyFlat)_moneyFlat.destroy();
			if(_stageFuelMult)_stageFuelMult.destroy();
			if(_stagePowerMult)_stagePowerMult.destroy();
			if(_topSpeedMult)_topSpeedMult.destroy();
			if(_rudderMult)_rudderMult.destroy();
			if(_weightMult)_weightMult.destroy();
			if(_invisWeightMult)_invisWeightMult.destroy();
			if(_windEffectMult)_windEffectMult.destroy();
			
			if(_cameraYOffset)_cameraYOffset.destroy();
			
			if(_obstacleMassMult)_obstacleMassMult.destroy();
			if (_obstacleSpeedMult)_obstacleSpeedMult.destroy();
			
			
			_deltaTimeMult = null;
			
			_topSpeedFlat = null;
			_rudderFlat = null;
			_boostFuelMult = null;
			_boostPowerMult = null;
			_gravityMult = null;
			_launchPowerMult = null;
			_obstaclesMult = null;
			_dragMult = null;
			_moneyMult = null;
			_moneyFlat = null;
			_stageFuelMult = null;
			_stagePowerMult = null;
			_topSpeedMult = null;
			_rudderMult = null;
			_weightMult = null;
			_invisWeightMult = null;
			_windEffectMult = null;
			
			_cameraYOffset = null;
			
			_obstacleMassMult = null;
			_obstacleSpeedMult = null;
			
			
		}
		
		static public function get boostFuelMult():CompoundNumber 
		{
			return _boostFuelMult;
		}
		
		static public function get boostPowerMult():CompoundNumber 
		{
			return _boostPowerMult;
		}
		
		static public function get deltaTimeMult():CompoundNumber 
		{
			return _deltaTimeMult;
		}
		
		static public function get gravityMult():CompoundNumber 
		{
			return _gravityMult;
		}
		
		static public function get launchPowerMult():CompoundNumber 
		{
			return _launchPowerMult;
		}
		
		static public function get obstaclesMult():CompoundNumber 
		{
			return _obstaclesMult;
		}
		
		static public function get dragMult():CompoundNumber 
		{
			return _dragMult;
		}
		
		static public function get moneyMult():CompoundNumber 
		{
			return _moneyMult;
		}
		
		static public function get moneyFlat():CompoundNumber 
		{
			return _moneyFlat;
		}
		
		static public function get stageFuelMult():CompoundNumber 
		{
			return _stageFuelMult;
		}
		
		static public function get stagePowerMult():CompoundNumber 
		{
			return _stagePowerMult;
		}
		
		static public function get topSpeedMult():CompoundNumber 
		{
			return _topSpeedMult;
		}
		
		static public function get rudderMult():CompoundNumber 
		{
			return _rudderMult;
		}
		
		static public function get weightMult():CompoundNumber 
		{
			return _weightMult;
		}
		
		/** Like weight mult, but doesn't show up in total weight */
		static public function get invisWeightMult():CompoundNumber 
		{
			return _invisWeightMult;
		}
		
		static public function get windEffectMult():CompoundNumber 
		{
			return _windEffectMult;
		}
		
		
		
		
		
		static public function get cameraZoomFloor():Number 
		{
			return _cameraZoomFloor;
		}
		
		static public function set cameraZoomFloor(value:Number):void 
		{
			_cameraZoomFloor = value;
			if (value > 0) GameCamera.instance.updateZoomLevel();//Refreshing zoom level so that setting a floor updates the camera zoom directly. Removing the floor however (to 0) does not, to keeps zooming smooth
		}
		
		static public function get cameraZoomCeil():Number 
		{
			return (_cameraZoomCeil > 0) ? _cameraZoomCeil:Number.MAX_VALUE;
		}
		
		static public function set cameraZoomCeil(value:Number):void 
		{
			_cameraZoomCeil = value;
			if (value > 0) GameCamera.instance.updateZoomLevel();//Refreshing zoom level so that setting a ceil updates the camera zoom directly.
		}
		
		static public function get cameraYOffset():CompoundNumber 
		{
			return _cameraYOffset;
		}
		
		static public function get obstacleMassMult():CompoundNumber 
		{
			return _obstacleMassMult;
		}
		
		static public function get obstacleSpeedMult():CompoundNumber 
		{
			return _obstacleSpeedMult;
		}
		
		static public function get topSpeedFlat():CompoundNumber 
		{
			return _topSpeedFlat;
		}
		
		static public function get rudderFlat():CompoundNumber 
		{
			return _rudderFlat;
		}
		
		
		
	}

}

