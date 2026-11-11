package src 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import lbg.utils.Trig;
	import src.audio.Sfx;
	import src.gui.decorators.TweenPos;
	import src.system.Global;
	import src.system.Links;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EasterPenguin extends MovieClip 
	{
		protected var _timer:Timer = new Timer(7500 + Math.random() * 3500, 1);
		
		public function EasterPenguin() 
		{
			super();
			
			
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(MouseEvent.CLICK, onEasterClick);
		}
		
		protected function randomizePosition():void {
			var r:Number = Math.random();
			
			if (r <= 0.25) {
				//Top
				x = 30 + Math.random() * 660;
				y = 0;
			}else if (r <= 0.50) {
				//Right
				x = 720;
				y = 30 + Math.random() * 480;
			}else if (r <= 0.75) {
				//Down
				x = 30 + Math.random() * 660;
				y = 540;
			}else {
				//Left
				x = 0;
				y = 30 + Math.random() * 480;
			}
			
			rotation = Trig.angleTo(x, y, 360, 270) + 90;
			
			var vx:Number = Trig.vectorX(80, rotation - 90);
			var vy:Number = Trig.vectorY(80, rotation - 90);
			
			x -= vx;
			y -= vy;
			
			var tween:TweenPos = TweenPos.tweenFromCurrentPosition(this, new Point(vx, vy), 25, 30 + Math.random() * 180, TweenPos.EASE_BACK);
			tween.finishedSignal.addOnce(startTimer);
		}
		
		protected function startTimer():void {
			if (_timer == null) {
				destroy();
				return;
			}
			
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer.stop();
			var vx:Number = -Trig.vectorX(80, rotation -90);
			var vy:Number = -Trig.vectorY(80, rotation -90);
			
			var tween:TweenPos = TweenPos.tweenFromCurrentPosition(this, new Point(vx, vy), 25, 0, TweenPos.EASE_OUT);
			tween.finishedSignal.addOnce(destroy);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			randomizePosition();
			
			if (x >= 60) UiScaler.addAbsolute(UiScaler.moveIntoNewSprite(this), false, x * 0.90);
		}
		
		private function onEasterClick(e:MouseEvent):void 
		{
			removeEventListener(MouseEvent.CLICK, onEasterClick);
			Sfx.playMedalSound();
			e.preventDefault();
			e.stopPropagation();
			e.stopImmediatePropagation();
			
			switch(ProfileState.instance.easterEggsFound) {
				case 0:
					ProfileState.instance.easterEggsFound += 1;
					Links.linkEasterEgg1();
					break;
				case 1:
					ProfileState.instance.easterEggsFound += 1;
					Links.linkEasterEgg2();
					break;
				case 2:
					ProfileState.instance.easterEggsFound += 1;
					Links.linkEasterEgg3();
					break;
				case 3:
					ProfileState.instance.easterEggsFound += 1;
					Links.linkEasterEgg4();
					MedalCheck.checkEasterEgg();
					break;
				case 4:
				default:
					ProfileState.earnBonusPoints(10);
					Main.displayMessage("Got 10 BP!");
					MedalCheck.checkEasterEgg();
					break;
				
			}
			
			var vx:Number = -Trig.vectorX(80, rotation -90);
			var vy:Number = -Trig.vectorY(80, rotation -90);
			
			var tween:TweenPos = TweenPos.tweenFromCurrentPosition(this, new Point(vx, vy), 25, 0, TweenPos.EASE_OUT);
			tween.finishedSignal.addOnce(destroy);
		}
		
		
		
		public function destroy():void {
			if (_timer) {
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				_timer.reset();
				_timer.stop();
				_timer = null;
			}
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(MouseEvent.CLICK, onEasterClick);
			
			if (parent) parent.removeChild(this);
			
		}
		
			
	}

}