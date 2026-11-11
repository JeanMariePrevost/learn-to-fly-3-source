package src.game 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import lbg.utils.Tools;
	import src.UiScaler;
	import src.gui.decorators.TweenPos;
	import src.Main;
	import src.system.Global;
	
	/**
	 * ...
	 * @author 
	 */
	public class FlightTimer extends MovieClip 
	{
		public var txtTime:TextField;
		
		protected var _timeElapsed:Number = 0;
		protected var _timeElapsedFlying:Number = 0;
		protected var _msPerDelta:Number = 16.666;
		
		protected var _flightStarted:Boolean = false;
		protected var _dayIsEnding:Boolean = false;
		
		public function FlightTimer() 
		{
			super();
			
			gotoAndStop(1);
			txtTime.text = "0:00";
			
			_msPerDelta = 1000 / Global.defaultFramerate; 
			
			GameMediator.playerLaunched.addOnce(flightStarted);
			Main.gameEngineTickSignal.add(tick);
			GameMediator.dayIsEnding.add(isDayEndingTick);
			GameMediator.finishDay.addOnce(dayIsOver);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);

			TweenPos.tweenToCurrentPosition(this, new Point(0, -100), 50, 0, TweenPos.EASE_OUT_CUBIC);
			
			//UiScaler.addAbsolute(this, true);
			UiScaler.addAbsolute(this, false, 720);
			//UiScaler.addAbsoluteManually(this, 200);
		}
		
		protected function flightStarted():void {
			_flightStarted = true;
		}
		
		protected function isDayEndingTick(val:Boolean):void {
			_dayIsEnding = val;
		}
		
		protected function dayIsOver():void {
			GameMediator.playerLaunched.remove(flightStarted);
			Main.gameEngineTickSignal.remove(tick);
			GameMediator.dayIsEnding.remove(isDayEndingTick);
			GameMediator.finishDay.remove(dayIsOver);
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			tick(0);
			
		}
		
		protected function tick(delta:Number):void 
		{
			if (_flightStarted) {
				if (_dayIsEnding == false) {
					gotoAndStop(1);
					_timeElapsedFlying += delta * _msPerDelta;
				}else {
					gotoAndStop(2);
				}
				_timeElapsed += delta * _msPerDelta;
			}
			
			StatsOfTheDay.instance.newFlightTime = _timeElapsedFlying;
			
			txtTime.text = Tools.millisecondsToTimeString2(_timeElapsedFlying, 1);
		}
		
		public function destroy():void {
			txtTime = null;
			
			GameMediator.playerLaunched.remove(flightStarted);
			Main.gameEngineTickSignal.remove(tick);
			GameMediator.dayIsEnding.remove(isDayEndingTick);
			GameMediator.finishDay.remove(dayIsOver);
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}