package src 
{
	import lbg.utils.NumberUtils;
	import src.reg.Registry;
	import src.reg.RegistryEntry;
	import src.system.GameState;
	import src.system.GameStateBonusItems;
	import src.system.GameStateItem;
	import src.system.Medals;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author light_bringer777
	 */
	public class MedalCheck 
	{
		public static function get medals():Medals {
			return ProfileState.instance.medals;
		}
		
		/**
		 * Displays popup and unlocks medals
		 * @param	level The UNLOCKED level (e.g. unlocking lvl 1 means lvl = 1)
		 */ 
		public static function getMedal(entry:RegistryEntry, level:uint):void {
			if (level <= 0) {
				throw new Error("MedalCheck getMedal() ERROR - requesting an unlock on level 0");
			}
			
			if (ProfileState.instance.currentGameState.gameMode == "Sandbox") {
				//Only 1 medal available in sandbox mode, others are disabled
				switch(entry.id) {
					case "medalSandboxMode":
						if (ProfileState.instance.medals.sandboxMode < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.sandboxMode = level;
						}
						break;
					case "medalDays":
						if (ProfileState.instance.medals.days < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.days = level;
						}
						break;
					case "medalCompletionist":
						if (ProfileState.instance.medals.completionist < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.completionist = level;
						}
						break;
					case "medalCheater":
						if (ProfileState.instance.medals.cheater < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.cheater = level;
						}
						break;
					case "medalComeBack":
						if (ProfileState.instance.medals.comeback < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.comeback = level;
						}
						break;
					case "medalEasterEggs":
						if (ProfileState.instance.medals.easterEggs < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.easterEggs = level;
						}
						break;
				}
			}else {
				switch(entry.id) {
					case "medalSpeed":
						if (ProfileState.instance.medals.speed < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.speed = level;
						}
						break;
					case "medalAltitude":
						if (ProfileState.instance.medals.altitude < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.altitude = level;
						}
						break;
					case "medalInsaneAltitude":
						if (ProfileState.instance.medals.insaneAltitude < level) {
							Main.displayMedalGet(entry, 2);
							ProfileState.instance.medals.insaneAltitude = 2;
						}
						break;
					case "medalInsaneAltitude2":
						if (ProfileState.instance.medals.insaneAltitude2 < level) {
							Main.displayMedalGet(entry, 4);
							ProfileState.instance.medals.insaneAltitude2 = 4;
						}
						break;
					case "medalFlightTime":
						if (ProfileState.instance.medals.flightTime < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.flightTime = level;
						}
						break;
					case "medalCash":
						if (ProfileState.instance.medals.cash < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.cash = level;
						}
						break;
					case "medalHorizontalDistance":
						if (ProfileState.instance.medals.horizontalDistance < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.horizontalDistance = level;
						}
						break;
					case "medalDays":
						if (ProfileState.instance.medals.days < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.days = level;
						}
						break;
					case "medalItemUpgrades":
						if (ProfileState.instance.medals.itemUpgrades < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.itemUpgrades = level;
						}
						break;
					case "medalFrequentBuyer":
						if (ProfileState.instance.medals.frequentBuyer < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.frequentBuyer = level;
						}
						break;
					case "medalAltitudeTotal":
						if (ProfileState.instance.medals.altitudeTotal < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.altitudeTotal = level;
						}
						break;
					case "medalFlightTimeTotal":
						if (ProfileState.instance.medals.flightTimeTotal < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.flightTimeTotal = level;
						}
						break;
					case "medalCashTotal":
						if (ProfileState.instance.medals.cashTotal < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.cashTotal = level;
						}
						break;
					case "medalObstaclesHit":
						if (ProfileState.instance.medals.obstaclesHit < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.obstaclesHit = level;
						}
						break;
					case "medalStagesOnly":
						if (ProfileState.instance.medals.stagesOnly < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.stagesOnly = level;
						}
						break;
					case "medalBasicBody":
						if (ProfileState.instance.medals.basicBody < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.basicBody = level;
						}
						if (level >= 4) {
							ProfileState.instance.addUnlockKey("omegaPenguin");
						}
						break;
					case "medalPayload":
						if (ProfileState.instance.medals.payload < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.payload = level;
						}
						break;
					case "medalStoryMode":
						if (ProfileState.instance.medals.storyMode < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.storyMode = level;
						}
						break;
					case "medalStoryMode2":
						if (ProfileState.instance.medals.storyMode2 < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.storyMode2 = level;
						}
						break;
					case "medalStoryMode3":
						if (ProfileState.instance.medals.storyMode3 < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.storyMode3 = level;
						}
						break;
					case "medalStoryMode4":
						if (ProfileState.instance.medals.storyMode4 < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.storyMode4 = level;
						}
						break;
					case "medalFreeMode":
						if (ProfileState.instance.medals.payloadMode < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.payloadMode = level;
						}
						break;
					case "medalClassicMode":
						if (ProfileState.instance.medals.classicMode < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.classicMode = level;
						}
						break;
					case "medalSandboxMode":
						//Nothing, sandbox has a separate conditional
						break;
					case "medalAroundTheWorld":
						if (ProfileState.instance.medals.aroundTheWorld < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.aroundTheWorld = level;
						}
						break;
					case "medalAllBonus":
						if (ProfileState.instance.medals.allBonus < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.allBonus = level;
						}
						break;
					case "medalMoonBreaker":
						if (ProfileState.instance.medals.moonBreaker < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.moonBreaker = level;
						}
						break;
					case "medalChallengeStory1":
						if (ProfileState.instance.medals.challengeStory1 < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.challengeStory1 = level;
						}
						break;
					case "medalChallengeStory4":
						if (ProfileState.instance.medals.challengeStory4 < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.challengeStory4 = level;
						}
						break;
					case "medalSpeedrunner":
						if (ProfileState.instance.medals.speedRun < level) {
							Main.displayMedalGet(entry, 2);
							ProfileState.instance.medals.speedRun = 2;
						}
						break;
					case "medalSpeedrunner2":
						if (ProfileState.instance.medals.speedRun2 < level) {
							Main.displayMedalGet(entry, 4);
							ProfileState.instance.medals.speedRun2 = 4;
						}
						break;
					case "medalChallengePayload":
						if (ProfileState.instance.medals.challengePayload < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.challengePayload = level;
						}
						break;
					case "medalChallengeClassic":
						if (ProfileState.instance.medals.challengeClassic < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.challengeClassic = level;
						}
						break;
					case "medalCompletionist":
						if (ProfileState.instance.medals.completionist < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.completionist = level;
						}
						if (level >= 1) {
							ProfileState.instance.addUnlockKey("dodoBody");
						}
						break;
					case "medalCheater":
						if (ProfileState.instance.medals.cheater < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.cheater = level;
						}
						break;
					case "medalComeBack":
						if (ProfileState.instance.medals.comeback < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.comeback = level;
						}
						break;
					case "medalEasterEggs":
						if (ProfileState.instance.medals.easterEggs < level) {
							Main.displayMedalGet(entry, level - 1);
							ProfileState.instance.medals.easterEggs = level;
						}
						break;
					default:
						throw new Error("medalGet() ERROR - Can't identify the medal entry ID");
						break;
				}
			}
		}
		
		public static function checkSpeed(speed:Number):void {
			if (medals.speed >= 4) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalSpeed");
			var goal:Number = entry.statCost.valueAt(medals.speed);
			
			if (speed >= goal) {
				getMedal(entry, medals.speed + 1);
			}
		}
		
		public static function checkAltitude(altitude:Number):void {
			if (medals.altitude <= 3) {
				var entry:RegistryEntry = Registry.getEntry("medalAltitude");
				var goal:Number = entry.statCost.valueAt(medals.altitude);
				
				if (altitude >= goal) {
					getMedal(entry, medals.altitude + 1);
				}
			}
			
			if (medals.insaneAltitude < 1) {
				var entry:RegistryEntry = Registry.getEntry("medalInsaneAltitude");
				var goal:Number = entry.statCost.valueAt(medals.insaneAltitude);
				
				if (altitude >= goal) {
					getMedal(entry, 2);
				}
			}
			
			if (medals.insaneAltitude2 < 1) {
				var entry:RegistryEntry = Registry.getEntry("medalInsaneAltitude2");
				var goal:Number = entry.statCost.valueAt(medals.insaneAltitude2);
				
				if (altitude >= goal) {
					getMedal(entry, 4);
				}
			}
			
			
			
		}
		
		public static function checkAltitudeTotal(altitudeTotal:Number):void {
			if (medals.altitudeTotal >= 4) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalAltitudeTotal");
			var goal:Number = entry.statCost.valueAt(medals.altitudeTotal);
			
			if (altitudeTotal >= goal) {
				getMedal(entry, medals.altitudeTotal + 1);
			}
		}
		
		public static function checkFlightTime(flightTimeInSeconds:Number):void {
			if (medals.flightTime >= 4) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalFlightTime");
			var goal:Number = entry.statCost.valueAt(medals.flightTime);
			
			if (flightTimeInSeconds >= goal) {
				getMedal(entry, medals.flightTime + 1);
			}
		}
		
		public static function checkFlightTimeTotal(flightTimeTotalInMs:Number):void {
			if (medals.flightTimeTotal >= 4) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalFlightTimeTotal");
			var goal:Number = entry.statCost.valueAt(medals.flightTimeTotal) * 1000;
			
			if (flightTimeTotalInMs >= goal) {
				getMedal(entry, medals.flightTimeTotal + 1);
			}
		}
		
		public static function checkCash(cash:Number):void {
			if (medals.cash >= 4) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalCash");
			var goal:Number = entry.statCost.valueAt(medals.cash);
			
			if (cash >= goal) {
				getMedal(entry, medals.cash + 1);
			}
		}
		
		public static function checkCashTotal(cashTotal:Number):void {
			if (medals.cashTotal >= 4) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalCashTotal");
			var goal:Number = entry.statCost.valueAt(medals.cashTotal);
			
			if (cashTotal >= goal) {
				getMedal(entry, medals.cashTotal + 1);
			}
		}
		
		public static function checkDays(days:Number):void {
			if (medals.days >= 4) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalDays");
			var goal:Number = entry.statCost.valueAt(medals.days);
			
			if (days >= goal) {
				getMedal(entry, medals.days + 1);
			}
		}
		
		public static function checkComeBack(realLifeDays:Number):void {
			if (medals.comeback >= 4) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalComeBack");
			var goal:Number = entry.statCost.valueAt(medals.comeback);
			
			if (realLifeDays >= goal) {
				getMedal(entry, medals.comeback + 1);
			}
		}
		
		public static function checkCompletionist():void {
			if (medals.completionist >= 1) return;
			
			var entry:RegistryEntry = Registry.getEntry("medalCompletionist");
			
			if (getMedalsEarned() >= 82) {
				getMedal(entry, 1);
			}
		}
		
		public static function getMedalsEarned():int {
			var medalsEarned:int = 0;
			
			medalsEarned += NumberUtils.constrain(medals.speed, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.altitude, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.altitudeTotal, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.flightTime, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.flightTimeTotal, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.cash, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.cashTotal, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.days, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.obstaclesHit, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.horizontalDistance, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.frequentBuyer, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.stagesOnly, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.basicBody, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.payload, 0, 4);
			
			medalsEarned += NumberUtils.constrain(medals.storyMode, 0, 1);
			medalsEarned += NumberUtils.constrain(medals.storyMode2, 0, 1);
			medalsEarned += NumberUtils.constrain(medals.storyMode3, 0, 1);
			medalsEarned += NumberUtils.constrain(medals.storyMode4, 0, 1);
			
			medalsEarned += NumberUtils.constrain(medals.challengeStory1, 0, 1);
			medalsEarned += NumberUtils.constrain(medals.challengeStory4, 0, 1);
			medalsEarned += NumberUtils.constrain(medals.challengePayload, 0, 1);
			medalsEarned += NumberUtils.constrain(medals.challengeClassic, 0, 1);
			
			medalsEarned += NumberUtils.constrain(medals.payloadMode, 0, 1);
			medalsEarned += NumberUtils.constrain(medals.classicMode, 0, 1);
			medalsEarned += NumberUtils.constrain(medals.sandboxMode, 0, 1);
			
			medalsEarned += NumberUtils.constrain(medals.itemUpgrades, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.comeback, 0, 4);
			medalsEarned += NumberUtils.constrain(medals.easterEggs, 0, 1);
			medalsEarned += NumberUtils.constrain(medals.allBonus, 0, 1);
			medalsEarned += NumberUtils.constrain(medals.moonBreaker, 0, 1);
			
			medalsEarned += NumberUtils.constrain(medals.insaneAltitude, 0, 1);
			medalsEarned += NumberUtils.constrain(medals.insaneAltitude2, 0, 1);
			medalsEarned += NumberUtils.constrain(medals.speedRun, 0, 1);
			medalsEarned += NumberUtils.constrain(medals.speedRun2, 0, 1);
			
			return medalsEarned;
		}
		
		public static function checkCheater(cheatFlag:Boolean):void {
			if (medals.cheater >= 1) return;
			
			var entry:RegistryEntry = Registry.getEntry("medalCheater");
			
			if (cheatFlag) {
				getMedal(entry, medals.cheater + 1);
			}
		}
		
		public static function checkObstaclesHit(obstaclesHit:Number):void {
			if (medals.obstaclesHit >= 4) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalObstaclesHit");
			var goal:Number = entry.statCost.valueAt(medals.obstaclesHit);
			
			if (obstaclesHit >= goal) {
				getMedal(entry, medals.obstaclesHit + 1);
			}
		}
		
		public static function checkHorizontalDistance(horizontalDistance:Number):void {
			if (medals.horizontalDistance >= 4) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalHorizontalDistance");
			var goal:Number = entry.statCost.valueAt(medals.horizontalDistance);
			
			if (horizontalDistance >= goal) {
				getMedal(entry, medals.horizontalDistance + 1);
			}
		}
		
		public static function checkFrequentBuyer(itemsBought:Number):void {
			if (medals.frequentBuyer >= 4) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalFrequentBuyer");
			var goal:Number = entry.statCost.valueAt(medals.frequentBuyer);
			
			if (itemsBought >= goal) {
				getMedal(entry, medals.frequentBuyer + 1);
			}
		}
		
		public static function checkStagesOnly(stagesOnlyAltitude:Number):void {
			if (medals.stagesOnly >= 4) return;//Medal complete
			
			for each(var item:GameStateItem in ProfileState.instance.currentGameState.boosts) {
				if (item.locked == false) {
					if (item.id != "emptyBoost") return;
				}
			}
			
			if (ProfileState.instance.currentGameState.launcher.id == "emptyLauncher") {
				var entry:RegistryEntry = Registry.getEntry("medalStagesOnly");
				var goal:Number = entry.statCost.valueAt(medals.stagesOnly);
				
				if (stagesOnlyAltitude >= goal) {
					getMedal(entry, medals.stagesOnly + 1);
				}
			}
			
		}
		
		public static function checkBasicBody(basicBodyAltitude:Number):void {
			if (medals.basicBody >= 4) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalBasicBody");
			var goal:Number = entry.statCost.valueAt(medals.basicBody);
			
			if (ProfileState.instance.currentGameState.body.id == "emptyBody") {
				if (basicBodyAltitude >= goal) {
						getMedal(entry, medals.basicBody + 1);
				}
			}
		}
		
		public static function checkGameModeStory():void {
			if (medals.storyMode >= 1) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalStoryMode");
			getMedal(entry, medals.storyMode + 1);
		}
		
		public static function checkGameModePayload():void {
			if (medals.payloadMode >= 1) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalFreeMode");
			getMedal(entry, medals.payloadMode + 1);
		}
		
		public static function checkGameModeClassic():void {
			if (medals.classicMode >= 1) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalClassicMode");
			getMedal(entry, medals.classicMode + 1);
		}
		
		public static function checkGameModeSandbox():void {
			if (medals.sandboxMode >= 1) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalSandboxMode");
			
			if (ProfileState.instance.stats.totalSandboxDays >= entry.statPower.valueAt(0)) {
				getMedal(entry, 1);
			}
		}
		
		public static function checkItemUpgrades():void {
			if (medals.itemUpgrades >= 4) return;//Medal complete
			
			var game:GameState = ProfileState.instance.currentGameState;
			var entry:RegistryEntry = Registry.getEntry("medalItemUpgrades");
			var goal:Number = entry.statCost.valueAt(medals.itemUpgrades);
			
			var checkFunction:Function = checkIfItemMaxed;
			
			if (medals.itemUpgrades >= 3) {
				//Test for over 5 instead of maxed
				checkFunction = checkIfItemOver5;
			}
			
			var itemMaxed:Number = 0;
			var itemList:Vector.<GameStateItem> = new Vector.<GameStateItem>();
			
			itemList.push(game.body);
			itemList.push(game.launcher);
			itemList = itemList.concat(game.stages);
			itemList = itemList.concat(game.boosts);
			
			for each(var i:GameStateItem in itemList) {
				if (checkFunction(i)) itemMaxed += 1;
			}
			
			if (itemMaxed >= goal) {
				getMedal(entry, medals.itemUpgrades + 1);
			}
		}
		
		private static function checkIfItemMaxed(item:GameStateItem):Boolean {
			if (item.maxLevel > 0 && item.level >= item.maxLevel) {
				return true;
			}else {
				return false;
			}
		}
		
		private static function checkIfItemOver5(item:GameStateItem):Boolean {
			if (item.maxLevel > 0 && item.level >= item.maxLevel + 5) {
				return true;
			}else {
				return false;
			}
		}
		
		/** Check the buy all bonus medal */
		public static function checkAllBonus():void {
			//trace("checkAllBonus()");
			if (medals.allBonus >= 1) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalAllBonus");
			var b:GameStateBonusItems = ProfileState.instance.bonusItems;
			
			var minimumLevel:Number = 100;
			minimumLevel = Math.min(minimumLevel,
			b.bonusBetterStart.bonusUnlockedLevel,
			b.bonusBoostFuel.bonusUnlockedLevel,
			b.bonusBoostPower.bonusUnlockedLevel,
			b.bonusBpPerDay.bonusUnlockedLevel,
			b.bonusDrag.bonusUnlockedLevel,
			b.bonusGravity.bonusUnlockedLevel,
			b.bonusImpact.bonusUnlockedLevel,
			b.bonusInterest.bonusUnlockedLevel,
			b.bonusLaunchPower.bonusUnlockedLevel,
			b.bonusLessObstacles.bonusUnlockedLevel,
			b.bonusMoney.bonusUnlockedLevel,
			b.bonusOverBodiesAndLaunchers.bonusUnlockedLevel,
			b.bonusOverBoosts.bonusUnlockedLevel,
			b.bonusOverStages.bonusUnlockedLevel,
			b.bonusOver.bonusUnlockedLevel,
			b.bonusStageFuel.bonusUnlockedLevel,
			b.bonusStagePower.bonusUnlockedLevel,
			b.bonusSpeed.bonusUnlockedLevel,
			b.bonusWind.bonusUnlockedLevel);
			//b.bonusOmega.bonusUnlockedLevel,
			
			if (minimumLevel >= 1) {
				getMedal(entry, 3);
			}
		}
		
		public static function checkMoonBreaker():void {
			if (medals.moonBreaker >= 1) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalMoonBreaker");
			getMedal(entry, medals.moonBreaker + 1);
		}
		
		//public static function checkAroundTheWorld():void {
			//if (medals.aroundTheWorld >= 1) return;//Medal complete
			//
			//var entry:RegistryEntry = Registry.getEntry("medalAroundTheWorld");
			//getMedal(entry, medals.aroundTheWorld + 1);
		//}
		
		
		public static function checkEasterEgg():void {
			if (medals.easterEggs >= 1) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalEasterEggs");
			getMedal(entry, medals.easterEggs + 1);
		}
		
		public static function checkChallengeStory1():void {
			if (medals.challengeStory1 < 1) {
				var entry:RegistryEntry = Registry.getEntry("medalChallengeStory1");
				var goal:Number = entry.statCost.valueAt(medals.challengeStory1);
				
				if (ProfileState.instance.currentGameState.day.value <= goal) {
					getMedal(entry, medals.challengeStory1 + 1);
				}
			}
			
			if (medals.speedRun < 1) {
				var entry:RegistryEntry = Registry.getEntry("medalSpeedrunner");
				var goal:Number = entry.statCost.valueAt(medals.speedRun);
				
				if (ProfileState.instance.currentGameState.day.value <= goal) {
					getMedal(entry, 2);
				}
			}
			
		}
		
		public static function checkChallengeStory4():void {
			if (medals.challengeStory4 < 1) {
				var entry:RegistryEntry = Registry.getEntry("medalChallengeStory4");
				var goal:Number = entry.statCost.valueAt(medals.challengeStory4);
				
				if (ProfileState.instance.currentGameState.day.value <= goal) {
					getMedal(entry, 4);
				}
			}
			
			if (medals.speedRun2 < 1) {
				var entry:RegistryEntry = Registry.getEntry("medalSpeedrunner2");
				var goal:Number = entry.statCost.valueAt(medals.speedRun2);
				
				if (ProfileState.instance.currentGameState.day.value <= goal) {
					getMedal(entry, 4);
				}
			}
			
		}
		
		public static function checkChallengePayload():void {
			if (medals.challengePayload >= 1) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalChallengePayload");
			var goal:Number = entry.statCost.valueAt(medals.challengePayload);
			
			if (ProfileState.instance.currentGameState.day.value - 1 <= goal) {
				getMedal(entry, medals.challengePayload + 1);
			}
		}
		
		public static function checkChallengeClassic():void {
			if (medals.challengeClassic >= 1) return;//Medal complete
			
			var entry:RegistryEntry = Registry.getEntry("medalChallengeClassic");
			var goal:Number = entry.statCost.valueAt(medals.challengeClassic);
			
			if (ProfileState.instance.currentGameState.day.value <= goal) {
				getMedal(entry, medals.challengeClassic + 1);
			}
		}
		
		
	}

}