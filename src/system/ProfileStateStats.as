package src.system 
{
	import flash.net.registerClassAlias;
	import src.cards.CardOdds;
	/**
	 * ...
	 * @author 
	 */
	public class ProfileStateStats 
	{
		public var bestSpeed:int = 0;
		public var bestAltitude:int = 0;
		public var bestAltitudeStageOnly:int = 0;
		public var bestAltitudeNoBody:int = 0;
		public var bestFlightTime:int = 0;
		public var bestCash:int = 0;
		public var bestDays:int = 0;
		public var bestObstaclesHit:int = 0;
		public var bestHorizontalDistance:int = 0;
		
		public var totalAltitude:Number = 0;
		public var totalFlightTime:Number = 0;
		public var totalCash:Number = 0;
		public var totalBonusPoints:Number = 0;
		public var totalRarePoints:Number = 0;
		public var totalDays:Number = 0;
		public var totalObstaclesHit:int = 0;
		public var totalHorizontalDistance:Number = 0;
		public var totalFrequentBuyer:int = 0;
		public var totalItemUpgrades:int = 0;
		
		/** Total play time in seconds */
		public var totalPlayTime:Number = 0;
		
		public var totalSandboxDays:Number = 0;
		
		public var totalGamesStarted:int = 0;
		public var totalGamesFinished:int = 0;
		
		
		public var boosterPacksOpened:int = 0;
		public var bp1CardsEarned:int = 0;
		public var bp2CardsEarned:int = 0;
		public var bp3CardsEarned:int = 0;
		public var bp4CardsEarned:int = 0;
		public var bp5CardsEarned:int = 0;
		
		
		
		public var omegaCoilCardsEarned:int = 0;//0-3
		public var omegaBoostersCardsEarned:int = 0;//0-3
		public var omegaBrickCardsEarned:int = 0;//0-3
		public var omegaBalloonCardsEarned:int = 0;//0-3
		public var omegaRocketCardsEarned:int = 0;//0-3
		public var omegaShuttleCardsEarned:int = 0;//0-3
		
		
		public function ProfileStateStats() 
		{
			registerClassAlias("ProfileStateStats", ProfileStateStats);
		}
		
		public function getTotalPossibleCards():Number {
			var totalItems:Number = CardOdds.getListOfPossibleItems().length;
			
			totalItems += 5;//5 BP cards
			totalItems += 6;//6 Omegas
			
			return totalItems;
		}
		
		public function getOwnedCards():Number {
			//Omegas count only as 1 when fully unlocked
			var possibleItems:Vector.<String> = CardOdds.getListOfPossibleItems();
			var ownedItems:Number = 0;
			for each(var s:String in possibleItems) {
				if (ProfileState.instance.hasItemUnlockKey(s)) ownedItems += 1;
			}
			
			if (bp1CardsEarned >= 1) ownedItems += 1;
			if (bp2CardsEarned >= 1) ownedItems += 1;
			if (bp3CardsEarned >= 1) ownedItems += 1;
			if (bp4CardsEarned >= 1) ownedItems += 1;
			if (bp5CardsEarned >= 1) ownedItems += 1;
			
			if (omegaBalloonCardsEarned >= 3) ownedItems += 1;
			if (omegaBoostersCardsEarned >= 3) ownedItems += 1;
			if (omegaBrickCardsEarned >= 3) ownedItems += 1;
			if (omegaCoilCardsEarned >= 3) ownedItems += 1;
			if (omegaRocketCardsEarned >= 3) ownedItems += 1;
			if (omegaShuttleCardsEarned >= 3) ownedItems += 1;
			
			
			
			return ownedItems;
		}
		
		public function fixBrokenStats():void {
			if (bestSpeed <= 0) bestSpeed = 0;
			if (bestAltitude <= 0) bestAltitude = 0;
			if (bestAltitudeStageOnly <= 0) bestAltitudeStageOnly = 0;
			if (bestAltitudeNoBody <= 0) bestAltitudeNoBody = 0;
			if (bestFlightTime <= 0) bestFlightTime = 0;
			if (bestDays <= 0) bestDays = 0;
			if (bestObstaclesHit <= 0) bestObstaclesHit = 0;
			
			//if (bestHorizontalDistance <= 0) bestHorizontalDistance = 0;
			
			if (totalAltitude <= 0) totalAltitude = 0;
			if (totalFlightTime <= 0) totalFlightTime = 0;
			if (totalBonusPoints <= 0) totalBonusPoints = 0;
			if (totalObstaclesHit <= 0) totalObstaclesHit = 0;
			//if (totalHorizontalDistance <= 0) totalHorizontalDistance = 0;
			if (totalFrequentBuyer <= 0) totalFrequentBuyer = 0;
			if (totalItemUpgrades <= 0) totalItemUpgrades = 0;
			
			if (totalPlayTime <= 0) totalPlayTime = 0;
			if (totalSandboxDays <= 0) totalSandboxDays = 0;
			if (totalGamesStarted <= 0) totalGamesStarted = 0;
			if (totalGamesFinished <= 0) totalGamesFinished = 0;
		}
		
	}

}