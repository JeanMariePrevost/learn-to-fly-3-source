package src.shop.medals 
{
	import src.reg.RegistryEntry;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author 
	 */
	public class MedalProgressDump 
	{
		
		public function MedalProgressDump() 
		{
			
		}
		
		public static function getProgressStringOf(entry:RegistryEntry, level:int):String {
			var progress:String = getProgressOf(entry, level);
			
			var str:String = "";
			
			if (progress != "") {
				str = progress + " / " + entry.statCost.valueAt(level).toFixed();
			}
			
			return str;
		}
		
		protected static function getProgressOf(entry:RegistryEntry, level:int):String {
			switch(entry.id) {
				case "medalAltitude":
					return ProfileState.instance.stats.bestAltitude.toFixed();
					break;
			
				case "medalSpeed":
					return ProfileState.instance.stats.bestSpeed.toFixed();
					break;
					
				case "medalFlightTime":
					return (ProfileState.instance.stats.bestFlightTime / 1000).toFixed();
					break;
					
				case "medalCash":
					return ProfileState.instance.stats.bestCash.toFixed();
					break;
			
				case "medalHorizontalDistance":
					return ProfileState.instance.stats.bestHorizontalDistance.toFixed();
					break;
			
				case "medalDays":
					return ProfileState.instance.stats.totalDays.toFixed();
					break;
			
				case "medalItemUpgrades":
					if (level <= 1) {
						return "";
					}else {
						return "";
					}
					break;
			
				case "medalFrequentBuyer":
					return ProfileState.instance.stats.totalFrequentBuyer.toFixed();
					break;
			
				case "medalAltitudeTotal":
					return ProfileState.instance.stats.totalAltitude.toFixed();
					break;
			
				case "medalFlightTimeTotal":
					return (ProfileState.instance.stats.totalFlightTime / 1000).toFixed();
					break;
			
				case "medalCashTotal":
					return ProfileState.instance.stats.totalCash.toFixed();
					break;
			
				case "medalObstaclesHit":
					return ProfileState.instance.stats.totalObstaclesHit.toFixed();
					break;
			
				case "medalStagesOnly":
					return ProfileState.instance.stats.bestAltitudeStageOnly.toFixed();
					break;
			
				case "medalBasicBody":
					return ProfileState.instance.stats.bestAltitudeNoBody.toFixed();
					break;
			
				case "medalPayload":
					return "";
					break;
			
				case "medalStoryMode":
					return "";
					break;
				case "medalFreeMode":
					return "";
					break;
				case "medalClassicMode":
					return "";
					break;
				case "medalSandboxMode":
					return "";
					break;
			
			
				case "medalAroundTheWorld":
					return "";
					break;
				case "medalAllBonus":
					return "";
					break;
				case "medalMoonBreaker":
					return "";
					break;
				default:
					return "";
					break;
			}
		}
		
	}

}