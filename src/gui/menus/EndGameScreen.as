package src.gui.menus 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import lbg.anticheatengine.SafeString;
	import lbg.debug.Log;
	import lbg.utils.ArrayUtils;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import lbg.utils.VectorUtils;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.Audio;
	import src.audio.Music;
	import src.audio.Sfx;
	import src.cards.CardOdds;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	import src.gui.decorators.TweenPos;
	import src.gui.Transition;
	import src.Main;
	import src.shop.ShopTooltip;
	import src.system.Global;
	import src.system.Input;
	import src.system.ProfileState;
	import src.system.SaveLoadModule;
	
	/**
	 * ...
	 * @author 
	 */
	public class EndGameScreen extends MovieClip 
	{
		protected static var _instance:EndGameScreen;
		
		public var light1:MovieClip;
		public var light2:MovieClip;
		
		public var congrats:MovieClip;
		public var pack1:MovieClip;
		public var pack2:MovieClip;
		public var pack3:MovieClip;
		public var pack4:MovieClip;
		public var txtDays:TextField;
		public var txtSelect:TextField;
		public var txtInfo:TextField;
		
		public var btnOk:MovieClip;
		
		protected var _packs:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		protected var _bounce1:MouseBounce2;
		protected var _bounce2:MouseBounce2;
		protected var _bounce3:MouseBounce2;
		protected var _bounce4:MouseBounce2;
		
		protected var _bounceOk:MouseBounce2;
		
		protected var _light1Target:Number;
		protected var _light2Target:Number;
		
		protected var _selectedPack:MovieClip;
		protected var _packBrightness:Number = 0;
		
		protected var _cards:Vector.<EndGameCard> = new Vector.<EndGameCard>();
		
		
		
		public function EndGameScreen(instantiateThisThroughStaticMethodInstance:Number = 0) 
		{
			init();
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			UiScaler.addAbsoluteManually(this, 360, -360);
		}
		
		protected function init():void {
			Audio.destroyAllAudio();
			Audio.playMusic(MusicCalm3, 1500).volume = 0.85;
			
			light1.rotation = -37;
			light2.rotation = -141;
			
			pack1.gotoAndStop(1);
			pack2.gotoAndStop(2);
			pack3.gotoAndStop(3);
			pack4.gotoAndStop(4);
			
			pack1.myHitArea.visible = false;
			pack2.myHitArea.visible = false;
			pack3.myHitArea.visible = false;
			pack4.myHitArea.visible = false;
			
			_packs.push(pack1, pack2, pack3, pack4);
			
			_bounce1 = new MouseBounce2(pack1, false, pack1.myHitArea, false);
			_bounce2 = new MouseBounce2(pack2, false, pack2.myHitArea, false);
			_bounce3 = new MouseBounce2(pack3, false, pack3.myHitArea, false);
			_bounce4 = new MouseBounce2(pack4, false, pack4.myHitArea, false);
			
			//_bounce1 = new MouseBounce2(pack1, false, null, false);
			//_bounce2 = new MouseBounce2(pack2, false, null, false);
			//_bounce3 = new MouseBounce2(pack3, false, null, false);
			//_bounce4 = new MouseBounce2(pack4, false, null, false);
			
			_bounce1.useObjectShape = false;
			_bounce2.useObjectShape = false;
			_bounce3.useObjectShape = false;
			_bounce4.useObjectShape = false;
			
			_bounce1.signalOverTarget.add(function():void {	ShopTooltip.show(pack1, "Higher chances of anything penguin-related!", "...whatever that means...") } );
			_bounce2.signalOverTarget.add(function():void { ShopTooltip.show(pack2, "Higher chances of mechanical items!", "...whatever that means...") } );
			_bounce3.signalOverTarget.add(function():void { ShopTooltip.show(pack3, "Higher chances of rockets!", "...well at least this one makes sense...") } );
			_bounce4.signalOverTarget.add(function():void { ShopTooltip.show(pack4, "Higher chances of complicated stuff!", "...whatever that means...") } );
			
			
			pack1.y += 500;
			pack2.y += 500;
			pack3.y += 500;
			pack4.y += 500;
			
			txtDays.text = "You completed " + ProfileState.instance.currentGameState.gameMode + " in " + ProfileState.instance.currentGameState.day.value.toFixed(0) + " days!";
			
			txtSelect.visible = false;
			
			TweenPos.tweenToCurrentPosition(congrats, new Point(0, -400), 60, 0, TweenPos.EASE_OUT_CUBIC);
			TweenPos.tweenToCurrentPosition(txtDays, new Point(0, -400), 60, 0, TweenPos.EASE_OUT_CUBIC);
			TweenPos.tweenToCurrentPosition(txtInfo, new Point(0, -400), 60, 0, TweenPos.EASE_OUT_CUBIC);
			TweenPos.tweenToCurrentPosition(btnOk, new Point(0, -400), 60, 0, TweenPos.EASE_OUT_CUBIC);
			
			
			Main.unsafeTickSignal.add(tick);
			
			_bounceOk = new MouseBounce2(btnOk);
			_bounceOk.signalClickTarget.add(showBoosters);
			Input.readyAbort.signalCommandDown.add(showBoosters2);
			
		}
		
		protected function showBoosters2():void {
			showBoosters(btnOk);
		}
		
		protected function showBoosters(target:DisplayObject):void {
			_bounceOk.signalClickTarget.remove(showBoosters);
			Input.readyAbort.signalCommandDown.remove(showBoosters2);
			
			TweenPos.tweenFromCurrentPosition(txtInfo, new Point(0, -600), 60, 0, TweenPos.EASE_OUT_CUBIC);
			TweenPos.tweenFromCurrentPosition(btnOk, new Point(0, -600), 60, 0, TweenPos.EASE_OUT_CUBIC);
			
			txtSelect.visible = true;
			
			TweenPos.tweenFromCurrentPosition(pack1, new Point(0, -480), 60, 40, TweenPos.EASE_OUT_CUBIC);
			TweenPos.tweenFromCurrentPosition(pack2, new Point(0, -480), 60, 50, TweenPos.EASE_OUT_CUBIC);
			TweenPos.tweenFromCurrentPosition(pack3, new Point(0, -480), 60, 60, TweenPos.EASE_OUT_CUBIC);
			TweenPos.tweenFromCurrentPosition(pack4, new Point(0, -480), 60, 70, TweenPos.EASE_OUT_CUBIC).finishedSignal.addOnce(introFinished);
			TweenPos.tweenToCurrentPosition(txtSelect, new Point(0, 300), 60, 80, TweenPos.EASE_OUT_CUBIC);
		}
		
		protected function introFinished():void {
			if (pack1 && _bounce1) {
				_bounce1.signalClickTarget.add(clickPack1);
				_bounce2.signalClickTarget.add(clickPack2);
				_bounce3.signalClickTarget.add(clickPack3);
				_bounce4.signalClickTarget.add(clickPack4);
				//pack1.addEventListener(MouseEvent.CLICK, clickPack1);
				//pack2.addEventListener(MouseEvent.CLICK, clickPack2);
				//pack3.addEventListener(MouseEvent.CLICK, clickPack3);
				//pack4.addEventListener(MouseEvent.CLICK, clickPack4);
			}
		}
		
		private function clickPack1(target:DisplayObject):void 
		{
			Sfx.playPickBooster();
			selectPack(pack1);
		}
		
		private function clickPack2(target:DisplayObject):void 
		{
			Sfx.playPickBooster();
			selectPack(pack2);
		}
		
		private function clickPack3(target:DisplayObject):void 
		{
			Sfx.playPickBooster();
			selectPack(pack3);
		}
		
		private function clickPack4(target:DisplayObject):void 
		{
			Sfx.playPickBooster();
			selectPack(pack4);
		}
		
		protected function selectPack(pack:MovieClip):void {
			_bounce1.signalClickTarget.remove(clickPack1);
			_bounce2.signalClickTarget.remove(clickPack2);
			_bounce3.signalClickTarget.remove(clickPack3);
			_bounce4.signalClickTarget.remove(clickPack4);
			//pack1.removeEventListener(MouseEvent.CLICK, clickPack1);
			//pack2.removeEventListener(MouseEvent.CLICK, clickPack2);
			//pack3.removeEventListener(MouseEvent.CLICK, clickPack3);
			//pack4.removeEventListener(MouseEvent.CLICK, clickPack4);
			
			_selectedPack = pack;
			
			for each(var p:MovieClip in _packs) {
				if (p == pack) {
					TweenPos.tweenFromCurrentPosition2(p, new Point(360, 300), 60, 20, TweenPos.EASE_OUT_CUBIC).finishedSignal.addOnce(selectFinished);
				}else {
					TweenPos.tweenFromCurrentPosition(p, new Point(0, 550), 60, 0, TweenPos.EASE_BOUNCE);
				}
			}
			
			if(txtSelect) TweenPos.tweenFromCurrentPosition(txtSelect, new Point(0, 300), 50, 0);
			
			_bounce1.destroy();
			_bounce2.destroy();
			_bounce3.destroy();
			_bounce4.destroy();
			
			_bounce1 = null;
			_bounce2 = null;
			_bounce3 = null;
			_bounce4 = null;
		}
		
		protected function selectFinished():void {
			Sfx.playOpenBooster().volume = 1.15;
			_packBrightness = 0;
			for each(var p:MovieClip in _packs) {
				if (p != _selectedPack) p.visible = false;
			}
			Main.unsafeTickSignal.add(tickBrightness);
		}
		
		protected function tickBrightness(delta:Number):void {
			if (_packBrightness < 1) {
				_packBrightness += 0.04;
				DisplayObjectUtil.setObjectTint(_selectedPack, 0xFFFFFF, _packBrightness);
			}else {
				Main.unsafeTickSignal.remove(tickBrightness);
				TweenPos.tweenFromCurrentPosition(_selectedPack, new Point(0, 500), 60, 0, TweenPos.EASE_OUT_CUBIC);
				txtSelect.text = "Click anywhere to continue";
				TweenPos.tweenFromCurrentPosition(txtSelect, new Point(0, -300), 80, 0);
				switch(ProfileState.instance.currentGameState.gameMode) {
					case "Story Mode":
						if (ProfileState.instance.currentGameState.storyModeSpaceLevel <= Global.SPACE_ALTITUDE1) {
							generateCards(5);
						}else if (ProfileState.instance.currentGameState.storyModeSpaceLevel <= Global.SPACE_ALTITUDE2) {
							generateCards(6);
						}else if (ProfileState.instance.currentGameState.storyModeSpaceLevel <= Global.SPACE_ALTITUDE3) {
							generateCards(7);
						}else if (ProfileState.instance.currentGameState.storyModeSpaceLevel <= Global.SPACE_ALTITUDE4) {
							generateCards(10);
						}else {
							Log.log("EndGameScreen.tickBrightness() Error: couldn't identify story mode level");
							generateCards(5);
						}
						break;
					case "Payload Mode":
						generateCards(6);
						break;
					case "Classic Mode":
						generateCards(5);
						break;
					case "Sandbox":
						generateCards(1);
						break;
					default:
						generateCards(5);
						break;
				}
			}
		}
		
		protected function generateCards(cardAmount:int):void {
			Log.log("EndGameScreen.generateCards()");
			var packIndex:int = 0;
			if (_selectedPack == pack1) {
				packIndex = 1;
			}else if (_selectedPack == pack2) {
				packIndex = 2;
			}else if (_selectedPack == pack3) {
				packIndex = 3;
			}else if (_selectedPack == pack4) {
				packIndex = 4;
			}else {
				//Wut?
			}
			
			var cardOdds:CardOdds = getCardOddsObject(cardAmount, packIndex);
			
			var cardDistance:Number = 136;//Used for card placement on screen
			var cardCenter:Number = 720 / 2;
			var cardStartX:Number = cardCenter - ((Math.min(5, cardAmount) - 1) * (cardDistance / 2));//First row
			var cardStartX2:Number = cardCenter - ((cardAmount - 6) * (cardDistance / 2));//Second row
			
			for (var i:int = 0; i < cardAmount; i++) {
				var card:EndGameCard = new EndGameCard(_selectedPack, cardOdds.pickedCards[i]);
				_cards.push(card);
				applyCardEffect(card);
				card.filters = [new GlowFilter(0xFFFFFF, 1, 6, 6, 2, 1), new GlowFilter(0xFFFFAA, 1, 8, 8, 2, 1)];
				
				if (cardAmount <= 5) {
					//Single row
					TweenPos.tweenFromCurrentPosition2(card, new Point(cardStartX + (cardDistance * i), getYPos(0)), 60, 30, TweenPos.EASE_OUT_CUBIC).finishedSignal.addOnce(cardSpreadFinished);
				}else {
					//2 rows
					card.scaleX = card.scaleY = 0.85;
					if (i <= 4) {
						//First row
						TweenPos.tweenFromCurrentPosition2(card, new Point(cardStartX + (cardDistance * i), getYPos(1)), 60, 30, TweenPos.EASE_OUT_CUBIC).finishedSignal.addOnce(cardSpreadFinished);
					}else {
						//Second row
						TweenPos.tweenFromCurrentPosition2(card, new Point(cardStartX2 + (cardDistance * (i - 5)), getYPos(2)), 60, 30, TweenPos.EASE_OUT_CUBIC).finishedSignal.addOnce(cardSpreadFinished);
					}
				}
			}
			
			
			
			if (cardAmount >= 6) {
				TweenPos.tweenFromCurrentPosition(congrats, new Point(0, -300), 60, 0, TweenPos.EASE_IN_OUT);
				TweenPos.tweenFromCurrentPosition(txtDays, new Point(0, -300), 60, 0, TweenPos.EASE_IN_OUT);
			}
			
			ProfileState.instance.refreshOmegaItems();
			ProfileState.instance.stats.boosterPacksOpened += 1;
			markGameAsCompleted();
		}
		
		protected function markGameAsCompleted():void {
			//Bonuses have been applied to ProfileState, mark the GameState as completed
			if (ProfileState.instance.currentGameState.gameCompleted.value == false) {
				ProfileState.instance.stats.totalGamesFinished += 1;
			}
			ProfileState.instance.currentGameState.gameCompleted.value = true;
		}
		
		protected function getYPos(row:int = 0):Number {
			switch(row) {
				case 0:
					return 285;
				case 1:
					return 150;
				case 2:
					return 390;
				default:
					return 285;
			}
		}
		
		protected function getCardOddsObject(cardAmount:int, packIndex:int):CardOdds {
			return new CardOdds(cardAmount, packIndex);
		}
		
		protected function applyCardEffect(card:EndGameCard):void {
			var id:String = card.id;
			if (id == "omegaBalloon") {
				ProfileState.instance.stats.omegaBalloonCardsEarned += 1;
				if (ProfileState.instance.stats.omegaBalloonCardsEarned >= 3) ProfileState.instance.addUnlockKey("omegaBalloon");
			}else if (id == "omegaBoosters") {
				ProfileState.instance.stats.omegaBoostersCardsEarned +=1;
				if (ProfileState.instance.stats.omegaBoostersCardsEarned >= 3) ProfileState.instance.addUnlockKey("omegaBoosters");
			}else if (id == "omegaBrick") {
				ProfileState.instance.stats.omegaBrickCardsEarned += 1;
				if (ProfileState.instance.stats.omegaBrickCardsEarned >= 3) ProfileState.instance.addUnlockKey("omegaBrick");
			}else if (id == "omegaCoil") {
				ProfileState.instance.stats.omegaCoilCardsEarned += 1;
				if (ProfileState.instance.stats.omegaCoilCardsEarned >= 3) ProfileState.instance.addUnlockKey("omegaCoil");
			}else if (id == "omegaRocket") {
				ProfileState.instance.stats.omegaRocketCardsEarned += 1;
				if (ProfileState.instance.stats.omegaRocketCardsEarned >= 3) ProfileState.instance.addUnlockKey("omegaRocket");
			}else if (id == "omegaShuttle") {
				ProfileState.instance.stats.omegaShuttleCardsEarned += 1;
				if (ProfileState.instance.stats.omegaShuttleCardsEarned >= 3) ProfileState.instance.addUnlockKey("omegaShuttle");
			}else if (id == "bp1") {
				ProfileState.earnBonusPoints(25);
				ProfileState.instance.stats.bp1CardsEarned += 1;
			}else if (id == "bp2") {
				ProfileState.earnBonusPoints(50);
				ProfileState.instance.stats.bp2CardsEarned += 1;
			}else if (id == "bp3") {
				ProfileState.earnBonusPoints(100);
				ProfileState.instance.stats.bp3CardsEarned += 1;
			}else if (id == "bp4") {
				ProfileState.earnBonusPoints(150);
				ProfileState.instance.stats.bp4CardsEarned += 1;
			}else if (id == "bp5") {
				ProfileState.earnBonusPoints(250);
				ProfileState.instance.stats.bp5CardsEarned += 1;
			}else {
				ProfileState.instance.addUnlockKey(id);
			}
		}
		
		protected function cardSpreadFinished():void {
			stage.addEventListener(MouseEvent.CLICK, onFinalClick);
		}
		
		protected function onFinalClick(e:MouseEvent):void 
		{
			
			Main.saveGame();
			
			if (ProfileState.instance.modeUnlockedPayload == false) {
				ProfileState.instance.modeUnlockedPayload = true;
				Transition.transitionTo(ScreenManager.unloadEndGameScreen, ScreenManager.loadBigUnlockPayload);
			}else if (ProfileState.instance.modeUnlockedClassic == false) {
				ProfileState.instance.modeUnlockedClassic = true;
				Transition.transitionTo(ScreenManager.unloadEndGameScreen, ScreenManager.loadBigUnlockClassic);
			}else if (ProfileState.instance.modeUnlockedSandbox == false) {
				ProfileState.instance.modeUnlockedSandbox = true;
				Transition.transitionTo(ScreenManager.unloadEndGameScreen, ScreenManager.loadBigUnlockSandbox);
			}else {
				Transition.transitionTo(ScreenManager.unloadEndGameScreen, ScreenManager.loadMainMenu);
			}
		}
		
		protected function tick(delta:Number):void 
		{
			_light1Target = Trig.angleTo(light1.x, light1.y, mouseX, mouseY);
			_light2Target = Trig.angleTo(light2.x, light2.y, mouseX, mouseY);
			
			light1.rotation += (_light1Target - light1.rotation) * 0.03;
			light2.rotation += (_light2Target - light2.rotation) * 0.03;
		}
		
		
		static public function get instance():EndGameScreen 
		{
			if (_instance == null) {
				_instance = new EndGameScreen();
			}
			return _instance;
		}
		
		public static function destroy():void {
			if (_instance) _instance.destroy();
		}
		
		public function destroy():void {
			_instance = null;
			
			Audio.fadeAllAudio();
			
			Input.readyAbort.signalCommandDown.remove(showBoosters2);
			
			if(stage) stage.removeEventListener(MouseEvent.CLICK, onFinalClick);
			//if(pack1) pack1.removeEventListener(MouseEvent.CLICK, clickPack1);
			//if(pack2) pack2.removeEventListener(MouseEvent.CLICK, clickPack2);
			//if(pack3) pack3.removeEventListener(MouseEvent.CLICK, clickPack3);
			//if(pack4) pack4.removeEventListener(MouseEvent.CLICK, clickPack4);
			
			Main.unsafeTickSignal.remove(tick);
			Main.unsafeTickSignal.remove(tickBrightness);
			
			
			if(_bounce1) _bounce1.destroy();
			if(_bounce2) _bounce2.destroy();
			if(_bounce3) _bounce3.destroy();
			if(_bounce4) _bounce4.destroy();
			if(_bounceOk) _bounceOk.destroy();
			
			_bounce1 = null;
			_bounce2 = null;
			_bounce3 = null;
			_bounce4 = null;
			_bounceOk = null;
			
			light1 = null;
			light2 = null;
			congrats = null;
			pack1 = null;
			pack2 = null;
			pack3 = null;
			pack4 = null;
			txtDays = null;
			txtSelect = null;
			txtInfo = null;
			btnOk = null;
			
			if (_packs) _packs.length = 0;
			_packs = null;
			
			_selectedPack = null;
			
			if (_cards) {
				for each(var c:EndGameCard in _cards) {
					c.destroy();
				}
				_cards.length = 0;
			}
			_cards = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}