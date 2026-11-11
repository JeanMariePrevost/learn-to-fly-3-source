package src.cards 
{
	import lbg.anticheatengine.SafeString;
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	import lbg.utils.VectorUtils;
	import src.gui.menus.EndGameScreen;
	import src.system.Global;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author 
	 */
	public class CardOdds 
	{
		public var pickedCards:Vector.<String>;
		
		
		protected var _itemsLeft:int;
		protected var _omegasLeft:int;
		protected var _itemComp:Number;
		protected var _bpComp:Number;
		protected var _itemCards:int;
		protected var _bpCards:int;
		protected var _omegaCards:int;
		
		public static function getListOfPossibleItems():Vector.<String> {
			return new < String > ["elFuego",
		"hedgehog", "rocketeer", "superman", "volcano", "thunderbird", "bigBertha",
		"catapult", "orbital", "bazooka", "steamLauncher", "monsterTruck", "rcCopter",
		"solar", "sonicDrive", "torpedo", "multiJump", "propellerBoost", "recurringBoost",
		"rocketBoost", "steamBoost", "dubstepDrive", "balloonBoost", "extraFuel", "moneyTurbine", "negativeMass", "potatoStage", "spearhead"];
		}
		
		public static function get omegaItems():Vector.<String> {
			return new < String > ["omegaBalloon", "omegaBoosters",  "omegaBrick",  "omegaCoil", "omegaRocket", "omegaShuttle"];
		}
		
		public static function get HighOddsPack1():Vector.<String> {
			//Penguin Power
			return new < String > ["hedgehog", "rocketeer", "superman",  "balloonBoost",  "dubstepDrive", "catapult", "bazooka"];
		}
		
		public static function get HighOddsPack2():Vector.<String> {
			//Mechanic Madness
			return new < String > [ "bigBertha", "steamLauncher",  "propellerBoost", "rcCopter", "multiJump", "steamBoost"];
		}
		
		public static function get HighOddsPack3():Vector.<String> {
			//Rocket Science
			return new < String > ["monsterTruck", "rocketBoost",  "potatoStage",  "extraFuel",  "torpedo", "recurringBoost", "thunderbird"];
		}
		
		public static function get HighOddsPack4():Vector.<String> {
			//Knowledge is Power
			return new < String > ["elFuego", "volcano", "orbital", "solar",  "negativeMass", "sonicDrive", "moneyTurbine", "spearhead"];
		}
		
		public static function get normalItemsNotUnlocked():int {
			var v:Vector.<String> = getListOfPossibleItems();
			removeAlreadyOwnedItems(v);
			return v.length;
		}
		
		public static function get omegaItemsNotUnlocked():int {
			var v:Vector.<String> = omegaItems;
			removeAlreadyOwnedItems(v);
			return v.length;
		}
		
		public static function removeAlreadyOwnedItems(fromVector:Vector.<String>):void {
			for (var i:int = 0; i < ProfileState.instance.itemUnlockKeys.length; i++) {
				while (fromVector.indexOf(ProfileState.instance.itemUnlockKeys[i].value) >= 0) {
					trace("Player owns", ProfileState.instance.itemUnlockKeys[i].value);
					VectorUtils.removeFromVector(fromVector, ProfileState.instance.itemUnlockKeys[i].value);
				}
			}
		}
		
		/**
		 * Used to pick the cards of a booster pack
		 * @param	cardsCount Amount of cards in the pack
		 * @param	selectedPack Selected booster pack (1-4) (0 for default odds)
		 */
		public function CardOdds(cardsCount:int, selectedPack:int = 0)
		{
			
			//% of booster composition
			_itemsLeft = normalItemsNotUnlocked;
			_omegasLeft = omegaItemsNotUnlocked;
			_itemComp = NumberUtils.interpolate2(0.2, 0.75, 0, 18, _itemsLeft);
			_bpComp = NumberUtils.interpolate2(0.5, 0.2, 0, 18, _itemsLeft);
			
			//Randomize a bit
			_itemComp = _itemComp * NumberUtils.randomRange(0.8, 1.05);
			_bpComp = _bpComp * NumberUtils.randomRange(0.7, 1.1);
			
			
			_itemCards = Math.round(cardsCount * _itemComp);
			if (_itemsLeft >= 1) _itemCards = Math.max(1, _itemCards);//Always at least one item
			if (_itemsLeft <=0) _itemCards = 0;
			
			_bpCards = Math.max(1, Math.round(cardsCount * _bpComp));
			_omegaCards = NumberUtils.constrain(cardsCount - _itemCards - _bpCards, 0, Math.min(_omegasLeft, 2));
			
			trace("Booster pack composition:");
			trace("cardsCount:", cardsCount);
			trace("itemsLeft:", _itemsLeft);
			trace("omegasLeft:", _omegasLeft);
			trace("itemCards:", _itemComp, _itemCards);
			trace("bpCards:", _bpComp, _bpCards);
			trace("omegaCards:", _omegaCards);
			pickCards(_itemCards, _bpCards, _omegaCards, selectedPack);
		}
		
		protected function pickCards(itemCards:int, bpCards:int, omegaCards:int, selectedPack:int = 0):void {
			pickedCards = new Vector.<String>();
			
			pickItemCards(itemCards, selectedPack);
			pickBpCards(bpCards);
			pickOmegaCards(omegaCards);
			
			for (var i:int = 0; i <= 80; i++) {
				pickedCards.sort(VectorUtils.randomSort);
			}
			
			//Overfill with random BPs in case of errors, fills only the end
			pickBpCards(11);
		}
		
		protected function pickItemCards(count:int, selectedPack:int):void 
		{
			var possibleCards:Vector.<String> = getListOfPossibleItems();
			
			//Add pack odds of certain cards
			var extraPackOdds:Vector.<String>;
			switch(selectedPack) {
				case 1:
					extraPackOdds = HighOddsPack1.concat();
					break;
				case 2:
					extraPackOdds = HighOddsPack2.concat();
					break;
				case 3:
					extraPackOdds = HighOddsPack3.concat();
					break;
				case 4:
					extraPackOdds = HighOddsPack4.concat();
					break;
				case 0:
				default:
					extraPackOdds = new Vector.<String>;
					break;
			}
			
			for each(var extraOddsID:String in extraPackOdds) {
				for (var i:int = 0; i <= 6; i++) {
					possibleCards.push(extraOddsID);
				}
			}
			
			removeAlreadyOwnedItems(possibleCards);
			
			for (var i:int = 0; i <= 100; i++) {
				possibleCards = possibleCards.sort(VectorUtils.randomSort);
			}
			
			//pick new item cards
			for (i = 0; i < count; i++) {
				if (i < possibleCards.length) {
					while (pickedCards.indexOf(possibleCards[0]) >= 0) {
						//Remove from list if already picked
						possibleCards.shift();
						if (possibleCards.length <= 0) return;//No more items to earn
					}
					if (possibleCards.length <= 0) return;//No more items to earn
					pickedCards.push(possibleCards.shift());
				}
			}
		}
			
		
		
		protected function pickBpCards(count:int):void {
			var bpCardsList:Vector.<String>;
			
			if (count == 1) {
				bpCardsList = new < String > ["bp4", "bp5"];
			}else if (count <= 2) {
				bpCardsList = new < String > ["bp2", "bp3", "bp4", "bp5"];
			}else if (count <= 3) {
				bpCardsList = new < String > ["bp1", "bp2", "bp3", "bp4", "bp5"];
			}else {
				bpCardsList = new < String > ["bp1", "bp2", "bp2", "bp3", "bp3", "bp4", "bp5", "bp1", "bp2", "bp3", "bp3", "bp4", "bp5"];
				
				var betterCardsScore:Number = 0;
				betterCardsScore += ProfileState.instance.stats.totalGamesFinished;
				trace("pickBpCards() -> betterCardsScore:", betterCardsScore.toFixed());
				
				if (betterCardsScore <= 5) {
					bpCardsList.push("bp1", "bp1", "bp2", "bp2", "bp3", "bp3", "bp4", "bp5");
				}else if (betterCardsScore <= 10) {
					bpCardsList.push("bp1", "bp2", "bp2", "bp3", "bp3", "bp4", "bp5", "bp3", "bp4", "bp5", "bp3", "bp4", "bp5");
				}else if (betterCardsScore <= 20) {
					bpCardsList.push("bp2", "bp3", "bp3", "bp4", "bp4", "bp3", "bp4", "bp4", "bp3", "bp4", "bp5", "bp4", "bp5");
				}else if (betterCardsScore <= 35) {
					bpCardsList.push("bp3", "bp3", "bp4", "bp5", "bp4", "bp4", "bp5", "bp4", "bp4", "bp5", "bp4", "bp5", "bp4", "bp5");
				}else if (betterCardsScore <= 50) {
					bpCardsList.push("bp4", "bp5", "bp3", "bp4", "bp5", "bp3", "bp4", "bp4", "bp4", "bp4", "bp4", "bp5", "bp4", "bp5");
				}else {
					bpCardsList.push( "bp4", "bp4", "bp4", "bp4", "bp4", "bp5", "bp4", "bp5", "bp4", "bp5", "bp4", "bp5", "bp4", "bp5", "bp4", "bp5", "bp4", "bp5");
				}
			}
			
			for (var i:int = 0; i <= 20; i++) {
				bpCardsList = bpCardsList.sort(VectorUtils.randomSort);
			}
			
			//Pick BP cards
			for (i = 0; i < count; i++) {
				if (i < bpCardsList.length) {
					pickedCards.push(bpCardsList[i]);
				}else {
					Log.log("pickBpCards() ERROR - Not enough BP cards generated, index out of bounds");
					pickedCards.push("bp2")
				}
			}
		}
		
		protected function pickOmegaCards(count:int):void {
			var possibleCards:Vector.<String> = omegaItems;
			removeAlreadyOwnedItems(possibleCards);
			
			for (var i:int = 0; i <= 25; i++) {
				possibleCards = possibleCards.sort(VectorUtils.randomSort);
			}
			
			//pick new item cards
			for (i = 0; i < count; i++) {
				if (i < possibleCards.length) {
					while (pickedCards.indexOf(possibleCards[i]) >= 0) {
						//Remove from list if already picked
						possibleCards.shift();
						if (possibleCards.length <= 0) return;//No more items to earn
					}
					if (possibleCards.length <= 0) return;//No more items to earn
					pickedCards.push(possibleCards.shift());
				}
			}
		}
	}

}