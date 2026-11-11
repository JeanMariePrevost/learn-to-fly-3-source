package src.system 
{
	import flash.net.registerClassAlias;
	/**
	 * ...
	 * @author 
	 */
	public class Medals 
	{
		public var speed:int = 0;
		public var altitude:int = 0;
		public var altitudeTotal:int = 0;
		public var flightTime:int = 0;
		public var flightTimeTotal:int = 0;
		public var cash:int = 0;
		public var cashTotal:int = 0;
		public var days:int = 0;
		public var obstaclesHit:int = 0;
		public var horizontalDistance:int = 0;
		public var frequentBuyer:int = 0;
		public var stagesOnly:int = 0;
		public var basicBody:int = 0;
		public var payload:int = 0;
		
		public var storyMode:int = 0;
		public var storyMode2:int = 0;
		public var storyMode3:int = 0;
		public var storyMode4:int = 0;
		
		public var payloadMode:int = 0;
		public var classicMode:int = 0;
		public var sandboxMode:int = 0;
		
		public var challengeStory1:int = 0;
		public var challengeStory4:int = 0;
		public var challengePayload:int = 0;
		public var challengeClassic:int = 0;
		
		
		public var itemUpgrades:int = 0;
		public var allBonus:int = 0;
		public var moonBreaker:int = 0;
		public var aroundTheWorld:int = 0;
		
		public var comeback:int = 0;
		public var easterEggs:int = 0;
		
		public var insaneAltitude:int = 0;
		public var insaneAltitude2:int = 0;
		public var speedRun:int = 0;
		public var speedRun2:int = 0;
		
		public var completionist:int = 0;
		public var cheater:int = 0;
		
		public function Medals() 
		{
			registerClassAlias("Medals", Medals);
		}
		
		/* Used for testing */
		public function haveAllMedalsUnlocked():void {
			speed = 4;
			altitude = 4;
			altitudeTotal = 4;
			flightTime = 4;
			flightTimeTotal = 4;
			cash = 4;
			cashTotal = 4;
			days = 4;
			obstaclesHit = 4;
			horizontalDistance = 4;
			frequentBuyer = 4;
			stagesOnly = 4;
			basicBody = 4;
			payload = 4;
			
			storyMode = 4;
			storyMode2 = 4;
			storyMode3 = 4;
			storyMode4 = 4;
			
			challengeStory1 = 1;
			challengeStory4 = 1;
			challengePayload = 1;
			challengeClassic = 1;
			
			payloadMode = 1;
			classicMode = 1;
			sandboxMode = 1;
			
			
			itemUpgrades = 4;
			allBonus = 1;
			moonBreaker = 1;
			aroundTheWorld = 1;
			
			comeback = 4;
			easterEggs = 1;
			
			completionist = 1;
			cheater = 1;
		}
		
	}

}