package src.spaceinvader 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import lbg.compositetick.DeltaTimer;
	import lbg.utils.DisplayObjectUtil;
	import src.Main;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.Music;
	import src.audio.Sfx;
	import src.gui.Transition;
	import src.gui.decorators.MouseBounce2;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class SpaceInvader extends MovieClip 
	{
		protected static var _instance:SpaceInvader;
		
		public var btnPower:MovieClip;
		public var introScreen:Intro;
		public var gameScreen:GameScreen;
		public var gameOverScreen:GameOver;
		public var screenContainer:MovieClip;
		
		protected var _bouncePower:MouseBounce2;
		
		public function SpaceInvader() 
		{
			_instance = this;
			super();
			
			Main.instance.muteButtonToTop();
			
			Main.unsafeTickSignal.add(tick);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			stage.frameRate = 16;
			
			_bouncePower = new MouseBounce2(btnPower, true, null, true);
			_bouncePower.colorWhenOver = DisplayObjectUtil.getColorMatrix(0, 10, 15, 10);
			_bouncePower.scaleMod = 0.2;
			_bouncePower.durationIn = 4;
			_bouncePower.durationOut = 7;
			_bouncePower.signalClickTarget.add(onClickExit);
			
			startIntro();
			
			UiScaler.addAbsoluteManually(this, 360, -360);
		}
		
		protected function onClickExit(target:DisplayObject):void {
			Transition.transitionTo(ScreenManager.unloadSpaceInvader, ScreenManager.unloadAllScreens, ScreenManager.loadMainMenu);
		}
		
		protected function onAnyKey():void {
			if (introScreen && introScreen.currentLabel == "end") {
				while (introScreen.numChildren >= 1) introScreen.removeChildAt(0);
				if (introScreen.parent) introScreen.parent.removeChild(introScreen);
				introScreen = null;
				
				Sfx.playInvaderStart();
				Music.destroyAll();
				
				startGame();
				Input.instance.basicCommands.anyKey.signalCommandDown.remove(onAnyKey);
			}
			
		}
		
		protected function tick(DeltaTimer:Number):void {
			
			
		}
		
		public function startIntro(skipIntro:Boolean = false):void {
			Main.instance.muteButtonToTop();
			introScreen = new src.spaceinvader.Intro();
			//introScreen.x = 25;
			//introScreen.y = 37;
			screenContainer.addChild(introScreen);
			
			if (skipIntro) introScreen.gotoAndStop("title");
			Input.instance.basicCommands.anyKey.signalCommandDown.add(onAnyKey);
		}
		
		public function startGame():void {
			Main.instance.muteButtonToTop();
			gameScreen = new GameScreen();
			gameScreen.x = 42;
			gameScreen.y = 48;
			screenContainer.addChild(gameScreen);
		}
		
		public function gameOver(score:Number, highscore:Number):void {
			Main.instance.muteButtonToTop();
			//trace("gameOver()");
			Sfx.playInvaderGameOver();
			gameOverScreen = new GameOver(score, highscore);
			screenContainer.addChild(gameOverScreen);
		}
		
		static public function get instance():SpaceInvader 
		{
			if (_instance == null) _instance = new SpaceInvader();
			
			return _instance;
		}
		
		static public function destroy():void 
		{
			if (_instance) _instance.destroy();
		}
		
		public function destroy():void {
			_instance = null;
			
			Main.unsafeTickSignal.add(tick);
			Input.instance.basicCommands.anyKey.signalCommandDown.remove(onAnyKey);
			
			btnPower = null;
			if (introScreen) introScreen.destroy();
			introScreen = null;
			if (gameScreen) gameScreen.destroy();
			gameScreen = null;
			if (gameOverScreen) gameOverScreen.destroy();
			gameOverScreen = null;
			screenContainer = null;
			if (_bouncePower) _bouncePower.destroy();
			_bouncePower = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		
		}
		
	}

}