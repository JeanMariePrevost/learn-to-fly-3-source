package src.gui 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import lbg.anticheatengine.SafeString;
	import lbg.utils.NumberUtils;
	import lbg.utils.Tools;
	import src.ScreenManager;
	import src.UiScaler;
	import src.cards.CardOdds;
	import src.gui.menus.EndGameScreen;
	import src.Main;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ProfileStatsScreen extends MovieClip 
	{
		protected static var _instance:ProfileStatsScreen;
		
		public var groupLeft:MovieClip;
		public var groupCenter:MovieClip;
		public var groupRight:MovieClip;
		
		public var txtAlt:TextField;
		public var txtSpeed:TextField;
		public var txtDur:TextField;
		public var txtDays:TextField;
		public var txtCash:TextField;
		public var txtHit:TextField;
		public var txtDist:TextField;
		
		public var txtTotalAlt:TextField;
		public var txtTotalDur:TextField;
		public var txtTotalDays:TextField;
		public var txtTotalCash:TextField;
		public var txtTotalHit:TextField;
		public var txtTotalDist:TextField;
		
		public var txtTotalItems:TextField;
		public var txtTotalUpgrades:TextField;
		public var txtTotalGamesStarted:TextField;
		public var txtTotalGamesFinished:TextField;
		public var txtTotalPlayTime:TextField;
		public var txtCards:TextField;
		public var txtCustom:TextField;
		
		public var btnBack:SimpleButton;
		
		public function ProfileStatsScreen() 
		{
			txtAlt = groupLeft.txtAlt;
			txtSpeed = groupLeft.txtSpeed;
			txtDur = groupLeft.txtDur;
			txtDays = groupLeft.txtDays;
			txtCash = groupLeft.txtCash;
			txtHit = groupLeft.txtHit;
			txtDist = groupLeft.txtDist;
			
			txtTotalAlt = groupRight.txtTotalAlt;
			txtTotalDur = groupRight.txtTotalDur;
			txtTotalDays = groupRight.txtTotalDays;
			txtTotalCash = groupRight.txtTotalCash;
			txtTotalHit = groupRight.txtTotalHit;
			txtTotalDist = groupRight.txtTotalDist;
			
			txtTotalItems = groupCenter.txtTotalItems;
			txtTotalUpgrades = groupCenter.txtTotalUpgrades;
			txtTotalGamesStarted = groupCenter.txtTotalGamesStarted;
			txtTotalGamesFinished = groupCenter.txtTotalGamesFinished;
			txtTotalPlayTime = groupCenter.txtTotalPlayTime;
			txtCards = groupCenter.txtCards;
			txtCustom = groupCenter.txtCustom;
			
			btnBack = groupCenter.btnBack;
			
			updateTexts();
			
			Main.instance.secondsTimer.addEventListener(TimerEvent.TIMER, onTimer);
			
			btnBack.addEventListener(MouseEvent.CLICK, onBackClick);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			UiScaler.addAbsolute(groupLeft, true);
			UiScaler.addAbsolute(groupCenter, true);
			UiScaler.addAbsolute(groupRight, true);
		}
		
		private function onBackClick(e:MouseEvent):void 
		{
			Transition.transitionTo(destroy, ScreenManager.loadMainMenu);
			destroy();
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			updateTexts();
		}
		
		protected function updateTexts():void {
			if (txtAlt == null || txtTotalAlt == null || txtTotalItems == null) {
				Main.instance.secondsTimer.removeEventListener(TimerEvent.TIMER, onTimer);
				return;
			}
			
			var p:ProfileState = ProfileState.instance;
			txtAlt.text = NumberUtils.numberDelimiter(p.stats.bestAltitude);
			txtSpeed.text = NumberUtils.numberDelimiter(p.stats.bestSpeed);
			txtDur.text = Tools.millisecondsToTimeString(p.stats.bestFlightTime);
			txtDays.text = NumberUtils.numberDelimiter(p.stats.bestDays);
			txtCash.text = "$ " + NumberUtils.numberDelimiter(p.stats.bestCash);
			txtHit.text = NumberUtils.numberDelimiter(p.stats.bestObstaclesHit);
			txtDist.text = NumberUtils.numberDelimiter(p.stats.bestHorizontalDistance);
			
			txtTotalAlt.text = NumberUtils.numberDelimiter(p.stats.totalAltitude);
			txtTotalDur.text = Tools.millisecondsToTimeString(p.stats.totalFlightTime);
			txtTotalDays.text = NumberUtils.numberDelimiter(p.stats.totalDays);
			txtTotalCash.text = "$ " + NumberUtils.numberDelimiter(p.stats.totalCash);
			txtTotalHit.text = NumberUtils.numberDelimiter(p.stats.totalObstaclesHit);
			txtTotalDist.text = NumberUtils.numberDelimiter(p.stats.totalHorizontalDistance);
			
			txtTotalItems.text = NumberUtils.numberDelimiter(p.stats.totalFrequentBuyer);
			txtTotalUpgrades.text = NumberUtils.numberDelimiter(p.stats.totalItemUpgrades);
			txtTotalGamesStarted.text = NumberUtils.numberDelimiter(p.stats.totalGamesStarted);
			txtTotalGamesFinished.text = NumberUtils.numberDelimiter(p.stats.totalGamesFinished);
			txtTotalPlayTime.text = Tools.millisecondsToTimeString(p.stats.totalPlayTime * 1000);
			
			
			txtCards.text = ProfileState.instance.stats.getOwnedCards().toFixed() + " / " + ProfileState.instance.stats.getTotalPossibleCards().toFixed();
			
		}
		
		public static function destroy():void {
			if (_instance) _instance.destroy();
		}
		
		static public function get instance():ProfileStatsScreen 
		{
			if (_instance == null) {
				_instance = new ProfileStatsScreen();
			}
			return _instance;
		}
		
		public function destroy():void {
			Main.instance.secondsTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			
			_instance = null;
			
			if (btnBack) btnBack.removeEventListener(MouseEvent.CLICK, onBackClick);
			btnBack = null;
			
			txtAlt = null;
			txtSpeed = null;
			txtDur = null;
			txtDays = null;
			txtCash = null;
			txtHit = null;
			txtDist = null;
			
			txtTotalAlt = null;
			txtTotalDur = null;
			txtTotalDays = null;
			txtTotalCash = null;
			txtTotalHit = null;
			txtTotalDist = null;
			
			txtTotalItems = null;
			txtTotalUpgrades = null;
			txtTotalGamesStarted = null;
			txtTotalGamesFinished = null;
			txtTotalPlayTime = null;
			txtCards = null;
			txtCustom = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}