package src.gui.progress 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import src.system.GameState;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class MainScreen extends AbstractMainScreen 
	{
		public var progBest:ProgressPenguin;
		public var prog1:ProgressPenguin;
		public var prog2:ProgressPenguin;
		public var prog3:ProgressPenguin;
		public var prog4:ProgressPenguin;
		public var prog5:ProgressPenguin;
		public var prog6:ProgressPenguin;
		public var prog7:ProgressPenguin;
		
		public var progBars:Vector.<ProgressPenguin> = new Vector.<ProgressPenguin>();
		
		public var timer:Timer = new Timer(70, 0);
		
		protected var _progIterator:Number = -1;
		
		public function MainScreen() 
		{
			super();
			
			ProfileState.instance.currentGameState.fillEmptyDaysScores();
			
			if (ProfileState.instance.currentGameState.day.value <= 1) {
				gotoAndStop(2);
			}else {
				gotoAndStop(1);
			}
			
			progBars.push(prog1);
			progBars.push(prog2);
			progBars.push(prog3);
			progBars.push(prog4);
			progBars.push(prog5);
			progBars.push(prog6);
			progBars.push(prog7);
			
			//Only visible if enough days played to reach that point
			for (var i:int = 0; i < progBars.length; i++) {
				if (getDayValueForIndex(i) >= 0) {
					progBars[i].visible = true;
				}else {
					progBars[i].visible = false;	
				}
			}
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.reset();
			timer.start();
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			_progIterator += 1;
			
			var i:int = int(_progIterator);
			var progValue:Number = getDayValueForIndex(i);
			
			if (i >= 0 && i < progBars.length) {
				if (progValue >= 0) {
					progBars[i].init(progValue, getDayStringForIndex(i)); 
				}
			}
			
			if (_progIterator >= 8) {
				initBestScore();
				timer.stop();
				timer.reset();
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
		}
		
		private function initBestScore():void 
		{
			var bestScore:Number = -1;
			
			for (var i:int = 0; i < progBars.length; i++) {
				bestScore = Math.max(bestScore, getDayValueForIndex(i));
			}
			
			progBest.init(bestScore, "Best");
			
		}
		
		protected function getDayValueForIndex(index:Number):Number {
			var gs:GameState = ProfileState.instance.currentGameState;
			
			var len:Number = gs.previousDaysScores.length;
			var offset:Number = Math.max(0, 7 - len);
			var scoreIndex:Number = len - (7 - index) + offset;
			
			if (scoreIndex < 0 || scoreIndex >= gs.previousDaysScores.length) {
				//Out of bounds
				return -1;
			}else {
				return gs.previousDaysScores[scoreIndex];
			}
		}
		
		protected function getDayStringForIndex(index:Number):String {
			var gs:GameState = ProfileState.instance.currentGameState;
			
			var len:Number = gs.previousDaysScores.length;
			var offset:Number = Math.max(0, 7 - len);
			var scoreIndex:Number = len - (7 - index) + offset;
			
			if (scoreIndex < 0 || scoreIndex >= gs.previousDaysScores.length) {
				//Out of bounds
				return "";
			}else {
				return ((scoreIndex + 1) as Number).toFixed(0);
			}
		}
		
		override public function destroy():void {
			if (progBest) progBest.destroy();
			if (prog1) prog1.destroy();
			if (prog2) prog2.destroy();
			if (prog3) prog3.destroy();
			if (prog4) prog4.destroy();
			if (prog5) prog5.destroy();
			if (prog6) prog6.destroy();
			if (prog7) prog7.destroy();
			
			progBest = null;
			prog1 = null;
			prog2 = null;
			prog3 = null;
			prog4 = null;
			prog5 = null;
			prog6 = null;
			prog7 = null;
			
			if (progBars) progBars.length = 0;
			progBars = null;
			
			if (timer) {
				timer.stop();
				timer.reset();
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
			timer = null;
			
			super.destroy();
		}
		
	}

}