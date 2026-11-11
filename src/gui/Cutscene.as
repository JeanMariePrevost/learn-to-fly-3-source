package src.gui 
{
	import cutscene.Ending;
	import cutscene.Intro;
	import cutscene.MenuIntro;
	import cutscene.MoonCrusher;
	import cutscene.NewGame;
	import cutscene.Superman;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.Audio;
	import src.cutscenes.CutsceneEvents;
	import src.game.GameMediator;
	import src.Main;
	import src.MedalCheck;
	import src.reg.Registry;
	import src.system.Global;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Cutscene extends Sprite 
	{
		/** Dispatches when the cutscene is over and stopped, Signal(Cutscene) */
		public var signalFinished:Signal = new Signal(Cutscene);
		
		protected var _cutscene:MovieClip;
		public var skipButton:SimpleButton = new src.gui.SkipButton();
		protected var _finishFunction:Function;
		protected var _finishFunctionParams:Array;
		protected var _cutsceneEvents:CutsceneEvents;
		
		
		public static function playLBGIntro():Cutscene {
			var scene:MovieClip = new cutscene.LBGIntro();
			var functionAfter:Function;
			functionAfter = ScreenManager.loadMainMenu;
			
			var cutsceneObject:Cutscene = new Cutscene(scene, functionAfter);
			Main.mainLayer.addChild(cutsceneObject);
			Main.mainLayer.stage.frameRate = Global.defaultFramerate;
			cutsceneObject.x = 720 * 0.5;
			cutsceneObject.y = 540 * 0.5;
			
			cutsceneObject.skipButton.visible = false;
			cutsceneObject.skipButton.x = 8000;
			
			cutsceneObject.addEventListener(MouseEvent.CLICK, cutsceneObject.endCutscene, false, 0, true);
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		public static function playMenuIntro():Cutscene {
			var scene:MovieClip = new MenuIntro();
			var cutsceneObject:Cutscene = new Cutscene(scene, Main.returnToMainMenu);
			Main.mainLayer.addChild(cutsceneObject);
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		
		
		public static function playIntro():Cutscene {
			var scene:MovieClip = new Intro();
			var cutsceneObject:Cutscene = new Cutscene(scene, playMenuIntro);
			Main.mainLayer.addChild(cutsceneObject);
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		public static function playEnding():Cutscene {
			ProfileState.instance.cutsceneViewedStoryEnding = true;
			var scene:MovieClip = new Ending();
			var cutsceneObject:Cutscene = new Cutscene(scene, Cutscene.playCreditsFromEndGame);
			Main.mainLayer.addChild(cutsceneObject);
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		public static function playMoonCrusher(failSpaceStageHook:Function):Cutscene {
			ProfileState.instance.cutsceneViewedMoonCrusher = true;
			var scene:MovieClip = new MoonCrusher();
			var cutsceneObject:Cutscene = new Cutscene(scene, failSpaceStageHook);
			Main.mainLayer.addChild(cutsceneObject);
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		public static function playNewGameIntro():Cutscene {
			var scene:MovieClip = new NewGame();
			var cutsceneObject:Cutscene = new Cutscene(scene, ScreenManager.loadShop);
			Main.mainLayer.addChild(cutsceneObject);
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		public static function playSuperman():Cutscene {
			ProfileState.instance.cutsceneViewedClassicEnding = true;
			var scene:MovieClip = new Superman();
			var cutsceneObject:Cutscene = new Cutscene(scene, ScreenManager.loadEndGameScreen);
			Main.mainLayer.addChild(cutsceneObject);
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//VCR
		
		public static function playIntroFromVCR():Cutscene {
			var scene:MovieClip = new Intro();
			var cutsceneObject:Cutscene = new Cutscene(scene, ScreenManager.loadVCR);
			Main.mainLayer.addChild(cutsceneObject);
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		public static function playEndingFromVCR():Cutscene {
			var scene:MovieClip = new Ending();
			var cutsceneObject:Cutscene = new Cutscene(scene, ScreenManager.loadVCR);
			Main.mainLayer.addChild(cutsceneObject);
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		public static function playMoonCrusherFromVCR():Cutscene {
			var scene:MovieClip = new MoonCrusher();
			var cutsceneObject:Cutscene = new Cutscene(scene, ScreenManager.loadVCR);
			Main.mainLayer.addChild(cutsceneObject);
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		public static function playNewGameIntroFromVCR():Cutscene {
			var scene:MovieClip = new NewGame();
			var cutsceneObject:Cutscene = new Cutscene(scene, ScreenManager.loadVCR);
			Main.mainLayer.addChild(cutsceneObject);
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		public static function playSupermanFromVCR():Cutscene {
			var scene:MovieClip = new Superman();
			var cutsceneObject:Cutscene = new Cutscene(scene, ScreenManager.loadVCR);
			Main.mainLayer.addChild(cutsceneObject);
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		public static function playCreditsFromVCR():Cutscene {
			var scene:MovieClip = new cutscene.Credits();
			var cutsceneObject:Cutscene = new Cutscene(scene, ScreenManager.loadVCR);
			Main.mainLayer.addChild(new CloudBg());
			Main.mainLayer.addChild(cutsceneObject);
			cutsceneObject.stage.frameRate = 40;
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		
		
		
		
		
		public static function playCreditsFromEndGame():Cutscene {
			var scene:MovieClip = new cutscene.Credits();
			var cutsceneObject:Cutscene = new Cutscene(scene, ScreenManager.loadEndGameScreen);
			Main.mainLayer.addChild(new CloudBg());
			Main.mainLayer.addChild(cutsceneObject);
			cutsceneObject.stage.frameRate = 40;
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		public static function playCreditsFromMenu():Cutscene {
			var scene:MovieClip = new cutscene.Credits();
			var cutsceneObject:Cutscene = new Cutscene(scene, Main.returnToMainMenu);
			Main.mainLayer.addChild(new CloudBg());
			Main.mainLayer.addChild(cutsceneObject);
			cutsceneObject.stage.frameRate = 40;
			Main.instance.muteButtonToTop();
			return cutsceneObject;
		}
		
		
		public function Cutscene(obj:MovieClip, finishFunction:Function = null, ... finishFunctionParams) 
		{
			_cutscene = obj;
			_finishFunction = finishFunction;
			_finishFunctionParams = finishFunctionParams;
			_cutsceneEvents = new CutsceneEvents(_cutscene, (finishFunction == ScreenManager.loadVCR));
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			Audio.destroyAllAudio();
			
			GameMediator.gamePaused.add(_cutscene.stop);
			GameMediator.gameResumed.add(_cutscene.play);
			
			Input.esc.signalCommandDown.addOnce(endCutscene);
			
			addChild(_cutscene);
			
			var buttonContainer:Sprite = new Sprite();
			buttonContainer.addChild(skipButton);
			Main.parentLayer.addChild(buttonContainer);
			Main.instance.muteButtonToTop();
			
			_cutscene.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			skipButton.addEventListener(MouseEvent.CLICK, onSkip);
			
			UiScaler.addAbsolute(_cutscene, false, 360);
			UiScaler.addAbsolute(buttonContainer, true);
			
			stage.frameRate = 24;
		}
		
		private function onSkip(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			if (_cutsceneEvents) _cutsceneEvents.skipping = true;
			Audio.destroyAllAudio();
			endCutscene();
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (_cutsceneEvents) _cutsceneEvents.checkFrame(_cutscene.currentFrame);
			
			if (_cutscene.currentFrame >= _cutscene.totalFrames - 1) {
				endCutscene();
			}
			
		}
		
		public function endCutscene(_:* = null):void {
			Transition.transitionTo(callFinishFunction, destroy);
			Input.esc.signalCommandDown.remove(endCutscene);
			
			if (_cutsceneEvents) _cutsceneEvents.skipping = true;
			
			if (stage) stage.frameRate = Global.defaultFramerate;
			
			
			if (_cutscene) {
				_cutscene.gotoAndStop(_cutscene.totalFrames);
				_cutscene.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				if (_cutsceneEvents) _cutsceneEvents.checkFrame(_cutscene.currentFrame);
			}
			
			
			if (skipButton) {
				if(skipButton.parent) skipButton.parent.removeChild(skipButton);
				skipButton.removeEventListener(MouseEvent.CLICK, onSkip);
			}
			
			if (signalFinished) {
				signalFinished.dispatch(this);
			}
		}
		
		public function callFinishFunction():void {
			if (_finishFunction) {
				if (_finishFunctionParams) {
					_finishFunction.apply(null, _finishFunctionParams);
				}else {
					_finishFunction();
				}
			}
			
		}
		
		public function destroy():void {
			if (_cutscene) {
				_cutscene.stop();
				_cutscene.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			_cutscene = null;
			
			_finishFunction = null;
			_finishFunctionParams = null;
			
			if (skipButton) skipButton.removeEventListener(MouseEvent.CLICK, onSkip);
			skipButton = null;
			
			if (signalFinished) signalFinished.removeAll();
			signalFinished = null;
			
			if (_cutsceneEvents) _cutsceneEvents.destroy();
			_cutsceneEvents = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}