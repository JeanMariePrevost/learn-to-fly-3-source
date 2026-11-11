package src.system
{
	import lbg.anticheatengine.SafeBoolean;
	import lbg.anticheatengine.SafeNumber;
	import lbg.utils.NumberUtils;
	import lbg.utils.Tools;
	import nape.callbacks.CbType;
	import src.game.GameEngineSandbox;
	import src.Main;
	/**
	 * ...
	 * @author 
	 */
	public final class Global 
	{
		//DEBUG CONSTANTS
		public static var traceDictionaryVerification:Boolean = false;
		public static var debugModeOn:SafeBoolean = new SafeBoolean(false);
		public static function get traceGameInitLog():Boolean {
			//return (Main.instance.loaderInfo.loaderURL.indexOf("file:///") < 0);
			return true;
		}
		
		
		/** Pauses the game and opens the log on error. */
		public static var haltOnError:Boolean = false;
		public static var logVisibleOnStartup:Boolean = false;
		
		//GENERAL
		public static var defaultFramerate:int = 65;
		
		public static const LEVEL_1_MEDAL_REWARD:int = 10;
		public static const LEVEL_2_MEDAL_REWARD:int = 20;
		public static const LEVEL_3_MEDAL_REWARD:int = 50;
		public static const LEVEL_4_MEDAL_REWARD:int = 100;
		public static const LEVEL_5_MEDAL_REWARD:int = 250;
		public static const LEVEL_6_MEDAL_REWARD:int = 400;
		public static const LEVEL_7_MEDAL_REWARD:int = 600;
		public static const LEVEL_8_MEDAL_REWARD:int = 1000;
		
		public static const BONUS_ITEM_OVERLEVEL_COST_START:int = 100;
		public static const BONUS_ITEM_OVERLEVEL_COST_END:int = 300;
		
		public static const STEERING_POWER_MULT:Number = 2;//Adjusts control as a whole
		
		public static const DODO_INVADER_BASIC_SCORE:Number = 1500;//Highscore which you get a reward for beating
		
		
		//CHEATS
		public static const OBSTACLE_TIMES_10_VALUE:Number = 6;
		public static const OBSTACLE_TIMES_100_VALUE:Number = 50;
		public static const GRAVITY_TIMES_2_VALUE:Number = 3;
		public static const GRAVITY_TIMES_10_VALUE:Number = 10;
		public static const HUGE_OBSTACLES_CHEAT_MULT:Number = 3;
		public static const HEAVY_OBSTACLES_CHEAT_MULT:Number = 10;
		public static const HUGE_PLAYER_CHEAT_MULT:Number = 2.5;
		public static const DODO_CHEAT_OBSTACLES_WEIGHT_MULT:Number = 1.5;
		
		
		
		//SHOP
		public static const OVER_LEVELS:uint = 30;//Number of max over-level
		public static const MEGA_LEVELS:uint = 100;//Number of final mega level
		
		//GAME
		protected static var _classicModeGoal:Number = 500000;//Distance to complete classic mode
		public static var SPACE_ALTITUDE1:Number = 200000;//Altitude to reach space, in pixels
		public static var SPACE_ALTITUDE2:Number = 500000;//These are the other goals available in story mode
		public static var SPACE_ALTITUDE3:Number = 1000000;
		public static var SPACE_ALTITUDE4:Number = 4000000;
		public static var ticksToEndDay:Number = 150;//Number of tick * delta it takes when out of stages and falling before results show up
		public static var powerPerMassUnit:Number = 4.15;// 2.5;// 5.1;//Power required to lift 1 unit of mass from the ground
		public static var baseGravity:Number = 250;
		public static var baseObstacleMassMult:Number = 0.9;
		public static var baseObstacleSpeedMult:Number = 0.5;
		public static var thrustOffsetMult:Number = 0;//How much the thrust is set far off the center-of-mass of the player, causing change in controls when thrusting
		
		
		//VISUAl
		public static var enableParticles:Boolean = true;
		public static var optionsMotionBlur:uint = 1;//0 off, 1 vertical-only, 2 directional
		
		/**
		 * Returns a scaled value for a given X, used for rewards
		 * @param	X The reference value, e.g. skill 'level'
		 * @param	base Flat amount to add to every value
		 * @param	linear Simple linear mult of lever (e.g. 2 for (X=5) -> 10, 3 for (X=5) -> 15)
		 * @param	power Power to apply on X
		 * @param	powerMult Mult to apply on X before applying power
		 * @param	expBase Base to apply power X to
		 */
		public static function yForX(X:Number, base:Number = 0, linear:Number = 1, power:Number = 0, powerMult:Number = 0, expBase:Number = 0, floor:Boolean = true):Number {
				var val:Number = X * linear;
				if (power != 0 && powerMult != 0) {
					val += Math.pow(X * powerMult, power);
				}
				if (expBase != 0) {
					val += Math.pow(expBase, X);
				}
				val += base;
				if (floor) {
					return Math.floor(val);
				}else {
					return val;
				}
		}
		
		//Reward functions
		public static function rewardForAltitude(altitude:Number):Number {
			var baseValueTweak:Number = 60;//Great for fine-tuning the 1st day results
			
			var reward:Number = yForX(altitude + baseValueTweak, 0, 0.009, 1.6, 0.001, 0, false);
			
			return reward;
			//return Math.pow((altitude + baseValueTweak) * 0.0035, 1.2);
		}
		
		public static function rewardForDistance(altitude:Number):Number {
			var baseValueTweak:Number = 60;//Great for fine-tuning the 1st day results
			//var reward:Number = Math.pow((altitude + baseValueTweak) * 0.0042, 1.35);
			
			var reward:Number = yForX(altitude + baseValueTweak, 0, 0.009, 1.6, 0.001, 0, false);
			
			return reward;
			//return Math.pow((altitude + baseValueTweak) * 0.0035, 1.2);
		}
		
		public static function rewardForDuration(duration:Number, altitudeCash:Number):Number {
			var baseValueTweak:Number = -4250;//Very low duration yields nothing
			duration = Math.max(duration + baseValueTweak, 0);
			
			var reward:Number = 0;
			
			if (duration <= 40000) {
				reward = NumberUtils.interpolate2(0, 500, 0, 40000, duration, 1.3);
			}else {
				reward = 500 + ((duration - 40000) / 30);
			}
			
			var altitudeShare:Number = NumberUtils.interpolate2(0, 0.35, 0, 240000, duration, 0.6);
			
			reward *= 1 - altitudeShare;
			
			reward += altitudeCash * altitudeShare;
			
			reward = NumberUtils.progressiveCap(reward, 3500, 100, 0.01, 0.05);
			
			return reward;
		}
		
		public static function rewardForSpeed(maxSpeed:Number, altitudeCash:Number, durationCash:Number):Number {
			maxSpeed = Math.max(maxSpeed - 4.5, 0);
			maxSpeed *= 0.7;
			var reward:Number = yForX(maxSpeed, 0, 1, 2.7, 0.17, 0, false);
			
			reward *= 0.7;
			reward += altitudeCash * NumberUtils.interpolate2(0, 0.2, 0, 50, maxSpeed, 0.6);
			reward += durationCash * NumberUtils.interpolate2(0, 0.1, 0, 50, maxSpeed, 0.6);
			
			//softcap
			reward = NumberUtils.progressiveCap2(reward, 1000, 100, 50000, 0.01, 0.05);
			
			return reward;
		}
		
		//GameLayer
		public static var minimumScale:Number = 0.25;
		
		//Sky
		public static const SKY_MAX_FRAME:int = 500;
		
		//Obstacles
		public static const COLLISION_GROUP_PLAYER:int = Tools.binaryToInt("11001");
		public static const COLLISION_MASK_PLAYER:int = Tools.binaryToInt("11001");
		public static const COLLISION_GROUP_OBSTACLE:int = Tools.binaryToInt("00001");
		public static const COLLISION_MASK_OBSTACLE:int = Tools.binaryToInt("00001");
		public static const COLLISION_GROUP_PARTICLE:int = Tools.binaryToInt("00010");
		public static const COLLISION_MASK_PARTICLE:int = Tools.binaryToInt("00010");
		public static const COLLISION_GROUP_CHAIN:int = Tools.binaryToInt("00001");
		public static const COLLISION_MASK_CHAIN:int = Tools.binaryToInt("00000");
		public static const COLLISION_GROUP_GROUND:int = Tools.binaryToInt("11111");
		public static const COLLISION_MASK_GROUND:int = Tools.binaryToInt("11111");
		
		
		public static const CB_TYPE_PLAYER:CbType = new CbType();
		public static const CB_TYPE_OBSTACLE:CbType = new CbType();
		public static const CB_TYPE_PARTICLE:CbType = new CbType();
		public static const CB_TYPE_GROUND:CbType = new CbType();
		
		
		public function Global(enforcer:Enforcer) 
		{
			//Cannot be instantiated
		}
		
		static public function get spaceAltitude():Number 
		{
			if (ProfileState.instance.currentGameState.gameMode == "Sandbox") {
				if (GameEngineSandbox.spaceLevel <= 0) {
					return SPACE_ALTITUDE1;//Return default, but disable space indicator in GameEngineSanbox
				}else {
					return GameEngineSandbox.spaceLevel;
				}
			}else if (ProfileState.instance.currentGameState.gameMode == "Story Mode") {
				var spaceAlt:Number = ProfileState.instance.currentGameState.storyModeSpaceLevel;
				var spaceAlt:Number = NumberUtils.constrain(spaceAlt, SPACE_ALTITUDE1, SPACE_ALTITUDE4);
				return spaceAlt;
			}else {
				return SPACE_ALTITUDE1;
			}
		}
		
		static public function get classicModeGoal():Number 
		{
			return _classicModeGoal;
		}
		
		
	}

}

class Enforcer{}