package src.gui 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import lbg.debug.Log;
	import org.osflash.signals.Signal;
	import src.audio.Sfx;
	import src.gui.decorators.TweenPos;
	import src.Main;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class MainMenuTitle extends MovieClip 
	{
		public static var cheatUsedSignal:Signal = new Signal();
		
		protected const CHEAT_DURATION:Number = 120;
		protected var _cheatCount:Number = 0;//Used to unlock every mode right off the bat
		
		/** Used to keep track of whether hide() or show() was last called*/
		public var shown:Boolean = false;
		
		public function MainMenuTitle() 
		{
			super();
			
			//debug
			//Main.instance.sysButtonsHide();
			//x = 20;
			//y = 600;
			
			//Main.unsafeTickSignal.add(tick);
		}
		
		protected function tick(delta:Number):void {
			if (hitTestPoint(mouseX, mouseY) && Input.instance.isMouseDown()) {
				trace("Cheat tick", _cheatCount);
				_cheatCount += delta;
				if (ProfileState.instance.modeUnlockedClassic == false || ProfileState.instance.modeUnlockedPayload == false || ProfileState.instance.modeUnlockedSandbox == false) {
					if (_cheatCount >= CHEAT_DURATION) {
						Main.unsafeTickSignal.remove(tick);
						Main.displayMessage("Modes unlocked!");
						Sfx.playGetItem();
						ProfileState.instance.modeUnlockedClassic = true;
						ProfileState.instance.modeUnlockedPayload = true;
						ProfileState.instance.modeUnlockedSandbox = true;
						ProfileState.instance.tutorialBonusShop = true;
						ProfileState.instance.tutorialBuyLauncher = true;
						ProfileState.instance.tutorialStages = true;
						ProfileState.instance.tutorialBoosts = true;
						ProfileState.instance.tutorialBodies = true;
						ProfileState.instance.tutorialBuyUpgrade = true;
						ProfileState.instance.tutorialCustomization = true;
						ProfileState.instance.tutorialHUD = true;
						ProfileState.instance.tutorialMusic = true;
						_cheatCount = 0;
						cheatUsedSignal.dispatch();
					}
				}else {
					if (_cheatCount >= CHEAT_DURATION) {
						Main.unsafeTickSignal.remove(tick);
						Main.displayMessage("Already unlocked");
						Sfx.playMediumClick();
						ProfileState.instance.modeUnlockedClassic = true;
						ProfileState.instance.modeUnlockedPayload = true;
						ProfileState.instance.modeUnlockedSandbox = true;
						ProfileState.instance.tutorialBonusShop = true;
						ProfileState.instance.tutorialBuyLauncher = true;
						ProfileState.instance.tutorialStages = true;
						ProfileState.instance.tutorialBoosts = true;
						ProfileState.instance.tutorialBodies = true;
						ProfileState.instance.tutorialBuyUpgrade = true;
						ProfileState.instance.tutorialCustomization = true;
						ProfileState.instance.tutorialHUD = true;
						ProfileState.instance.tutorialMusic = true;
						_cheatCount = 0;
						cheatUsedSignal.dispatch();
					}
				}
			}else {
				_cheatCount = 0;
			}
		}
		
		public function show(instant:Boolean = false):void {
			//Log.log("MainMenuTitle.show()");
			
			shown = true;
			
			Main.unsafeTickSignal.add(tick);
			if (instant) {
				//Log.log("instant");
				x = 0;
				y = 0;
			}else {
				//Log.log("this:", this);
				TweenPos.tweenFromCurrentPosition2(this, new Point(0, 0), 50, 0, TweenPos.EASE_OUT_CUBIC, false)
				//y = 600;
				//TweenPos.tweenFromCurrentPosition2(this, new Point(0, 140), 120, 0, TweenPos.EASE_OUT_CUBIC, false)
			}
		}
		
		public function hide(instant:Boolean = false):void {
			//Log.log("MainMenuTitle.hide()");
			
			shown = false;
			
			Main.unsafeTickSignal.remove(tick);
			if (instant) {
				x = 0;
				y = -330;
			}else {
				//TweenPos.tweenFromCurrentPosition2(this, new Point(0, -330), 60, 0, TweenPos.EASE_IN_CUBIC, false);
				TweenPos.tweenFromCurrentPosition2(this, new Point(0, -330), 25, 0, TweenPos.EASE_IN_CUBIC, false);
			}
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			
			cheatUsedSignal.removeAll;
		}
		
	}

}