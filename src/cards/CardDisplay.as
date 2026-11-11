package src.cards 
{
	import lbg.debug.Log;
	import src.gui.menus.EndGameScreen;
	import src.shop.medals.MedalDisplay;
	import src.system.ContentUnlocking;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class CardDisplay extends MedalDisplay 
	{
		
		public function CardDisplay() 
		{
			super();
			
		}
		
		override protected function buildMedalList():void 
		{
			var itemsVector:Vector.<String> = CardOdds.getListOfPossibleItems();
			var items:Array = new Array();
			for each(var s:String in itemsVector) {
				items.push(s);
			}
			
			items.sort();
			
			for each(s in items) {
				addItemCard(s);
			}
			
			addBpCard("bp1");
			addBpCard("bp2");
			addBpCard("bp3");
			addBpCard("bp4");
			addBpCard("bp5");
			
			
			addOmegaCard("omegaBalloon", ProfileState.instance.stats.omegaBalloonCardsEarned)
			addOmegaCard("omegaBoosters", ProfileState.instance.stats.omegaBoostersCardsEarned)
			addOmegaCard("omegaBrick", ProfileState.instance.stats.omegaBrickCardsEarned)
			addOmegaCard("omegaCoil", ProfileState.instance.stats.omegaCoilCardsEarned)
			addOmegaCard("omegaRocket", ProfileState.instance.stats.omegaRocketCardsEarned)
			addOmegaCard("omegaShuttle", ProfileState.instance.stats.omegaShuttleCardsEarned)
		}
		
		protected function addItemCard(id):void {
			var unlockStatus:int = 0;
			
			if (ContentUnlocking.IdIsUnlocked(id)) {
				unlockStatus = 3;
			}
			
			addMedal(id, 1, unlockStatus);
		}
		
		protected function addBpCard(id:String):void {
			var unlockStatus:int = 0;
			
			if (ProfileState.instance.stats[id + "CardsEarned"] >=1) {
				unlockStatus = 3;
			}
			
			addMedal(id, ProfileState.instance.stats[id + "CardsEarned"], unlockStatus);
		}
		
		protected function addOmegaCard(id:String, progress:int):void {
			Log.log("addOmegaCard:", id, progress);
			addMedal(id, ProfileState.instance.stats[id + "CardsEarned"], progress);
		}
		
		override protected function addMedal(id:String, frame:int, unlockedStatus:int, clickFunction:Function = null):void 
		{
			var medal:CardButton = new CardButton(id, frame, unlockedStatus, clickFunction);
			medal.overSignal.add(overSignal.dispatch);
			medal.outSignal.add(outSignal.dispatch);
			_medalList.push(medal);
		}
		
		override protected function addMedalsToDisplay():void 
		{
			var i:int = 0;
			var column:int = 0;
			
			while (i < _medalList.length) {
				
				for (var row:int = 0; row <= 1; row++) {
					if (i < _medalList.length) {
						_sprite.addChild(_medalList[i].visual);
						//_medalList[i].visual.scaleX = _medalList[i].visual.scaleY = 1.15;
						_medalList[i].visual.x = column * COLUMN_WIDTH * 1.4;
						_medalList[i].visual.y = row * ROW_HEIGHT * 1.86;
						i += 1;
					}else {
						return;
					}
				}
				
				column += 1;
			}
			
			//_sprite.cacheAsBitmap = true;
		}
		
	}

}