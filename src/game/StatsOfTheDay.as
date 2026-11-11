package src.game 
{
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import lbg.debug.Log;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import nape.callbacks.InteractionCallback;
	import nape.phys.Body;
	import nape.phys.Interactor;
	import src.Main;
	import src.MedalCheck;
	import src.reg.Registry;
	import src.reg.RegistryEntry;
	import src.system.ProfileState;
	import src.system.ProfileStateStats;
	/**
	 * Holds the highest stats of a day
	 * @author 
	 */
	public class StatsOfTheDay 
	{
		protected static var _instance:StatsOfTheDay;
		
		public var currentPayload:String = "";//"" for none, "payloadX" for payloads (like their registry IDs)
		
		public var newFlightTime:Number = 0;
		
		protected const TIME_BEFORE_SPEED_MEDAL_CHECK:Number = 1000;//in ms
		protected const STABLE_SPEED_FRAMES_SPEED_MEDAL_CHECK:Number = 3;
		
		protected var _maxAltitude:Number = 0;
		protected var _maxSpeed:Number = 0;
		protected var _maxDistanceLeft:Number = 0;
		protected var _maxDistanceRight:Number = 0;
		
		protected var _previousSpeed:Number = 0;//Used for speed medal check, player speed has to not be decreasing
		protected var _speedNotDroppingCount:Number = 0;//Counts for how many frame speed has been maintained, need a minimum to trigger medal
		
		//protected var _maxSpeedAdjustingTime:Number = 0;
		protected var _maxSpeedAdjustingDuration:Number = 100;//How long a certain speed must be maintained for it to completely register as max speed, prevents REALLY high value with say, SonisBurts
		
		protected var _startOfDayTime:Number;
		protected var _finalDayTime:Number = 0;
		protected var _obstaclesHitList:Vector.<Interactor> = new Vector.<Interactor>();
		
		
		
		
		public function StatsOfTheDay(singleton:Enforcer) 
		{
			if (_instance) _instance.destroy();
			_instance = this;
			GameMediator.updatePlayerAltitude.add(updateAltitude);
			GameMediator.updatePlayerSpeed.add(updateSpeed);
			GameMediator.updatePlayerPosition.add(updatePosition);
			GameMediator.playerImpactObstacle.add(onObstacleHit);
			
			GameMediator.gameResumedWithDuration.add(onGameResume);
			
			newFlightTime = 0;
			
			_startOfDayTime = getTimer();
			
			//_medalTimer = new Timer(500, 0);
			//_medalTimer.addEventListener(TimerEvent.TIMER, onMedalTimer);
		}
		
		/** Currently only used to freeze elapsed time once day is over */
		public function stopCurrentDayStats():void {
			_finalDayTime = timeElapsed;
		}
		
		
		private function onGameResume(pauseDurationInMilliseconds:Number):void 
		{
			trace("Start of day was:", _startOfDayTime);
			_startOfDayTime += pauseDurationInMilliseconds;
			trace("Start of day is now:", _startOfDayTime);
		}
		
		private function updatePosition(x:Number, y:Number):void 
		{
			//trace("Player position:", x, y, _maxAltitude);
			if (x > _maxDistanceRight)_maxDistanceRight = x;
			if (x < _maxDistanceLeft)_maxDistanceLeft = x;
			
			MedalCheck.checkHorizontalDistance(Math.max(Math.abs(_maxDistanceLeft), _maxDistanceRight));
		}
		
		private function updateSpeed(speed:Number, angle:Number):void 
		{
			if (ProfileState.instance.currentGameState.launcher.id == "emptyLauncher" || ProfileState.instance.currentGameState.launcher.id == "launchPad") {
				//No need for special bypass
				_speedNotDroppingCount = Math.max(1200, _speedNotDroppingCount);
				_speedNotDroppingCount += Main.instance.lastDelta;
				updateMaxSpeed(speed);
			}else if (getTimer() - _startOfDayTime >= TIME_BEFORE_SPEED_MEDAL_CHECK) {
				if (speed >= (_previousSpeed * 0.99999)) {
					//trace(speed.toFixed(4), _previousSpeed.toFixed(4));
					_speedNotDroppingCount += Main.instance.lastDelta;
					//trace("StatsOfTheDay.updateSpeed -> _speedNotDroppingCount =", _speedNotDroppingCount.toFixed(2)); 
					
					if (_speedNotDroppingCount >= STABLE_SPEED_FRAMES_SPEED_MEDAL_CHECK) {
						//Speed has been stable enough, not launcher based
						updateMaxSpeed(speed);
					}else {
						//Speed comes from launcher, take only a fraction of it
						updateMaxSpeed(speed * 0.1 * Math.min(1, Main.instance.lastDelta));
					}
				}else {
					var timeSinceStartOfDay:Number = getTimer() - _startOfDayTime;
					var decreaseSpeed:Number = NumberUtils.interpolate2(0.05, 0.001, 0, 10000, timeSinceStartOfDay, 0.5);
					_speedNotDroppingCount -= Main.instance.lastDelta * decreaseSpeed;
					_speedNotDroppingCount = Math.max(_speedNotDroppingCount, 0);
					//_maxSpeedAdjustingTime = 0;
					//trace("Speed dropping...");
				}
			}
			
			_previousSpeed = speed;
		}
		
		/**Function to handle updating max speed */
		protected function updateMaxSpeed(speed:Number):void {
			if (speed > _maxSpeed) {
				//_maxSpeedAdjustingTime += Main.instance.lastDelta;
				//_maxSpeedAdjustingTime = Math.min(_maxSpeedAdjustingTime, _maxSpeedAdjustingDuration);
				//var max:Number = Easing.easeLinear(_maxSpeedAdjustingTime, 0, speed, _maxSpeedAdjustingDuration);
				//_maxSpeed = Math.max(max, _maxSpeed);
				
				var maxChangeInOneFrame:Number = NumberUtils.interpolate2(0, 50, 0, 1500, _speedNotDroppingCount, 1.4) * Main.instance.lastDelta;
				
				if (Main.instance.lastDelta <= 0.95) {
					maxChangeInOneFrame *= NumberUtils.interpolate2(0.95, 0.5, 0.95, 0.45, Main.instance.lastDelta);
				}
				
				_maxSpeed = Math.min(speed, _maxSpeed + maxChangeInOneFrame);
				
				MedalCheck.checkSpeed(_maxSpeed);
				//trace("max:", max);
				//trace("_maxSpeed:", _maxSpeed);
				
				//trace("updateMaxSpeed", speed, _maxSpeed);
			}
		}
		
		private function updateAltitude(alt:Number):void 
		{
			if (alt > _maxAltitude)_maxAltitude = alt;
			MedalCheck.checkAltitude(alt);
			MedalCheck.checkBasicBody(alt);
			MedalCheck.checkStagesOnly(alt);
			
			//Added duration check here for lack of a better trigger
			MedalCheck.checkFlightTime(newFlightTime * 0.001);
		}
		
		private function onObstacleHit(cb:InteractionCallback):void {
			if (_obstaclesHitList.indexOf(cb.int1) < 0) {
				_obstaclesHitList.push(cb.int1);
			}
			
			if (_obstaclesHitList.indexOf(cb.int2) < 0) {
				_obstaclesHitList.push(cb.int2);
			}
			
			MedalCheck.checkObstaclesHit(ProfileState.instance.stats.totalObstaclesHit);
		}
		
		public function get maxAltitude():Number 
		{
			return _maxAltitude;
		}
		
		public function get maxSpeed():Number 
		{
			return _maxSpeed;
		}
		
		public function get maxDistanceLeft():Number 
		{
			return _maxDistanceLeft;
		}
		
		public function get maxDistanceRight():Number 
		{
			return _maxDistanceRight;
		}
		
		//** In ms */
		public function get timeElapsed():Number {
			if (_finalDayTime != 0) {
				return _finalDayTime;
			}else {
				return getTimer() - _startOfDayTime;
			}
		}
		
		public function get obstaclesHit():Number {
			return Math.max(0, _obstaclesHitList.length - 1);
		}
		
		static public function get instance():StatsOfTheDay 
		{
			init();
			return _instance;
		}
		
		static public function init():void {
			if (_instance == null) {
				_instance = new StatsOfTheDay(new Enforcer());
			}
		}
		
		/** Add to cumulative stats and update best stats that have been beaten */
		public function updateProfileStats():void {
			var stats:ProfileStateStats = ProfileState.instance.stats;
			stats.bestDays = Math.max(stats.bestDays, ProfileState.instance.currentGameState.day.value);
			MedalCheck.checkDays(stats.totalDays);
			
			
			
			
			
			if (ProfileState.instance.currentGameState.gameMode == "Sandbox") return;//No other stats on sandbox
			
			stats.bestAltitude = Math.max(stats.bestAltitude, _maxAltitude);
			if (ProfileState.instance.currentGameState.launcher.id == "emptyLauncher") {
				stats.bestAltitudeStageOnly = Math.max(stats.bestAltitudeStageOnly, _maxAltitude);
			}
			if (ProfileState.instance.currentGameState.body.id == "emptyBody") {
				stats.bestAltitudeNoBody = Math.max(stats.bestAltitudeNoBody, _maxAltitude);
			}
			stats.bestCash = Math.max(stats.bestCash, ProfileState.instance.currentGameState.cash.value);
			stats.bestFlightTime = Math.max(stats.bestFlightTime, newFlightTime);
			stats.bestHorizontalDistance = Math.max(stats.bestHorizontalDistance, Math.abs(_maxDistanceLeft), _maxDistanceRight);
			stats.bestObstaclesHit = Math.max(stats.bestObstaclesHit, obstaclesHit);
			stats.bestSpeed = Math.max(stats.bestSpeed, _maxSpeed);
			
			stats.totalAltitude += _maxAltitude;
			stats.totalFlightTime += newFlightTime;
			stats.totalHorizontalDistance += Math.max(Math.abs(_maxDistanceLeft), _maxDistanceRight);
			stats.totalObstaclesHit += obstaclesHit;
			
			MedalCheck.checkAltitudeTotal(stats.totalAltitude);
			MedalCheck.checkCashTotal(stats.totalCash);
			MedalCheck.checkFlightTimeTotal(stats.totalFlightTime);
		}
		
		public function destroy():void {
			_instance = null;
			
			GameMediator.updatePlayerAltitude.remove(updateAltitude);
			GameMediator.updatePlayerSpeed.remove(updateSpeed);
			GameMediator.updatePlayerPosition.remove(updatePosition);
			GameMediator.playerImpactObstacle.remove(onObstacleHit);
			GameMediator.gameResumedWithDuration.remove(onGameResume);
			
			if(_obstaclesHitList) _obstaclesHitList.length = 0;
			_obstaclesHitList = null;
		}
		
	}

}


class Enforcer { }
