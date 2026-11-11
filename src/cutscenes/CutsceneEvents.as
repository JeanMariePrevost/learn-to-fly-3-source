package src.cutscenes 
{
	import cutscene.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import lbg.debug.Log;
	import sound.ending.MoonThud;
	import sound.ending.Weee;
	import sound.Explode2;
	import sound.Fire3;
	import sound.intro.*;
	import sound.menuintro.FLyBySound;
	import sound.menuintro.PunchSound;
	import sound.menuintro.RocketLaunch;
	import sound.menuintro.SteamReleaseSound;
	import sound.moonbreaker.PlanetCollision;
	import sound.moonbreaker.PlanetWhoosh;
	import sound.newgameintro.BoingSound;
	import sound.newgameintro.BookBang;
	import sound.newgameintro.BuildUpWhoosh;
	import sound.newgameintro.DoorBust;
	import sound.newgameintro.DummyCrash;
	import sound.newgameintro.KnockKnockKnock;
	import sound.newgameintro.PenguinStep;
	import sound.superman.HouseCrashSound;
	import sound.superman.LongWhoosh;
	import sound.superman.TimeTick;
	import sound.superman.TimeWhoosh;
	import src.audio.Audio;
	import src.audio.Music;
	import src.audio.MusicObject;
	import src.gui.Cutscene;
	import src.MedalCheck;
	import src.reg.Registry;
	import src.system.Global;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author 
	 */
	public class CutsceneEvents 
	{
		/** Used to bypass sounds and certain events when skipping */
		public var skipping:Boolean = false;
		
		/** if an event is before this number, it means it was already fired */
		protected var _lastTriggeredFrame:uint = 0;
		protected var _checkFunction:Function;
		protected var _disableMedalsBecausePlayedFromVCR:Boolean = false;
		
		public function CutsceneEvents(scene:MovieClip, playedFromVCR:Boolean = false) 
		{
			_disableMedalsBecausePlayedFromVCR = playedFromVCR;
			
			if (scene is cutscene.Ending) {
				_checkFunction = endingCheck;
			}else if (scene is cutscene.Intro) {
				_checkFunction = introCheck;
			}else if (scene is cutscene.MenuIntro) {
				_checkFunction = menuIntroCheck;
			}else if (scene is cutscene.MoonCrusher) {
				_checkFunction = moonCrusherCheck;
			}else if (scene is cutscene.NewGame) {
				_checkFunction = newGameIntroCheck;
			}else if (scene is cutscene.Superman) {
				_checkFunction = supermanCheck;
			}else if (scene is cutscene.Credits) {
				_checkFunction = creditsCheck;
			}else if (scene is cutscene.LBGIntro) {
				_checkFunction = lbgCheck;
			}
		}
		
		public function checkFrame(frame:uint):void 
		{
			if (_checkFunction) _checkFunction(frame);
		}
		
		protected function lbgCheck(frame:uint):void {
			
			if (skipping == false) {
				if (frame >= 1) {
					if (triggerEvent(1)) {
						Audio.playSound(cutscene.LBGDrums, this).volume = 1;
					}
				}
			}
		}
		
		protected function introCheck(frame:uint):void {
			
			if (skipping == false) {
				if (frame >= 10) {
					if (triggerEvent(10)) {
						Audio.playSound(WindSound, this).volume = 1.25;
					}
				}
				
				if (frame >= 200) {
					if (triggerEvent(200)) {
						Audio.playMusic(MusicShop5, 250).volume = 0.4;
					}
				}
				
				if (frame >= 211) {
					if (triggerEvent(211)) {
						Audio.playSound(KeyboardSounds, this);
					}
				}
				
				if (frame >= 398) {
					if (triggerEvent(398)) {
						Audio.playSound(MouseClick, this);
					}
				}
				
				if (frame >= 603) {
					if (triggerEvent(603)) {
						Audio.playSound(MouseClick, this);
					}
				}
				
				if (frame >= 674) {
					if (triggerEvent(674)) {
						Audio.playSound(MouseClick, this);
					}
				}
				
				if (frame >= 800) {
					if (triggerEvent(800)) {
						Audio.playSound(MouseClick, this);
					}
				}
				
				if (frame >= 1138) {
					if (triggerEvent(1138)) {
						Audio.playSound(TooFatHit, this);
					}
				}
				
				if (frame >= 1158) {
					if (triggerEvent(1158)) {
						Audio.fadeAllAudio();
						//Music.fadeOutAll();
					}
				}
				
				if (frame >= 1208) {
					if (triggerEvent(1208)) {
						Audio.playSound(ScreenHit, this);
					}
				}
				
				if (frame >= 1215) {
					if (triggerEvent(1215)) {
						Audio.playMusic(MusicRock2, 30).volume = 0.6;
					}
				}
				
				if (frame >= 1384) {
					if (triggerEvent(1384)) {
						Audio.playSound(ExplodeLongMix, this).volume = 0.6;
					}
				}
				
				if (frame >= 1400) {
					if (triggerEvent(1400)) {
						Audio.playSound(RocketWhoosh, this).volume = 0.6;
					}
				}
				
				if (frame >= 1585) {
					if (triggerEvent(1585)) {
						Audio.fadeAllAudio();
					}
				}
			}
		}
		
		protected function menuIntroCheck(frame:uint):void {
			
			if (skipping == false) {
				if (frame >= 35) {
					if (triggerEvent(35)) {
						Audio.playSound(RocketLaunch, this);
					}
				}
				
				if (frame >= 130) {
					if (triggerEvent(130)) {
						Audio.playSound(PunchSound, this);
					}
				}
				
				if (frame >= 214) {
					if (triggerEvent(214)) {
						Audio.playFadingSoundLoop(Fire3, this, 100);
					}
				}
				
				if (frame >= 463) {
					if (triggerEvent(463)) {
						Audio.fadeAllAudio
					}
				}
				
				if (frame >= 465) {
					if (triggerEvent(465)) {
						Audio.playSound(SteamReleaseSound, this);
					}
				}
				
				if (frame >= 470) {
					if (triggerEvent(470)) {
						Audio.getISoundRef(Fire3, this).fadeOut(600);
					}
				}
				
				if (frame >= 502) {
					if (triggerEvent(502)) {
						Audio.playSound(WindSound, this).volume = 1.3;
					}
				}
				
				if (frame >= 675) {
					if (triggerEvent(675)) {
						Audio.playFadingSound(FLyBySound, this, 300).fadeOutDuration = 1500;
					}
				}
				
				if (frame >= 790) {
					if (triggerEvent(790)) {
						Audio.fadeAllAudio();
					}
				}
			}
		}
		
		protected function newGameIntroCheck(frame:uint):void {
			
			if (skipping == false) {
				if (frame >= 1) {
					if (triggerEvent(1)) {
						Audio.playSound(WindSound, this);
					}
				}
				
				if (frame >= 110) {
					if (triggerEvent(110)) {
						var m:MusicObject =  Audio.playMusic(MusicBonusShop2, (600));
						m.volume = 0.65;
						m.fadeOutDuration = 3500;
					}
				}
				
				if (frame >= 403) {
					if (triggerEvent(403)) {
						Audio.playFadingSoundLoop(BoingSound, this, 1500);
					}
				}
				
				if (frame >= 755) {
					if (triggerEvent(755)) {
						Audio.getISoundRef(BoingSound, this).fadeOut(1000);
					}
				}
				
				if (frame >= 783) {
					if (triggerEvent(783)) {
						Audio.playSound(Explode2, this).volume = 0.6;
					}
				}
				
				if (frame >= 951) {
					if (triggerEvent(951)) {
						Audio.playSound(DummyCrash, this);
					}
				}
				
				if (frame >= 1052) {
					if (triggerEvent(1052)) {
						Audio.playSound(PenguinStep, this);
					}
				}
				
				if (frame >= 1075) {
					if (triggerEvent(1075)) {
						Audio.playSound(PenguinStep, this);
					}
				}
				
				if (frame >= 1094) {
					if (triggerEvent(1094)) {
						Audio.playSound(PenguinStep, this);
					}
				}
				
				if (frame >= 1123) {
					if (triggerEvent(1123)) {
						Audio.playSound(BookBang, this);
					}
				}
				
				if (frame >= 1247) {
					if (triggerEvent(1247)) {
						Audio.playSound(KnockKnockKnock, this).volume = 0.6;
					}
				}
				
				if (frame >= 1360) {
					if (triggerEvent(1360)) {
						Audio.fadeAllAudio();
					}
				}
				
				if (frame >= 1470) {
					if (triggerEvent(1470)) {
						Audio.playSound(BuildUpWhoosh, this);
					}
				}
				
				if (frame >= 1626) {
					if (triggerEvent(1626)) {
						Audio.playSound(DoorBust, this).volume = 0.5;
					}
				}
				
				if (frame >= 1637) {
					if (triggerEvent(1637)) {
						Audio.playFadingSoundLoop(PenguinStep, this, 300).volume = 0.5;
					}
				}
				
				if (frame >= 1709) {
					if (triggerEvent(1709)) {
						Audio.fadeAllAudio();
					}
				}
				
				
				
			}
		}
		
		protected function supermanCheck(frame:uint):void {
			if (skipping == false) {
				if (frame >= 2) {
					if (triggerEvent(2)) {
						Audio.destroyAllAudio();
						Audio.playSound(LongWhoosh, this).volume = 0.8;
						if(_disableMedalsBecausePlayedFromVCR == false) MedalCheck.checkChallengeClassic();
					}
				}
				
				if (frame >= 270) {
					if (triggerEvent(270)) {
						Audio.playSound(TimeTick, this).volume = 1.2;
					}
				}
				
				if (frame >= 335) {
					if (triggerEvent(335)) {
						Audio.playSound(TimeWhoosh, this).volume = 1;
					}
				}
				
				if (frame >= 395) {
					if (triggerEvent(395)) {
						Audio.playSound(WindSound, this);
					}
				}
				
				if (frame >= 468) {
					if (triggerEvent(468)) {
						Audio.playSound(KeyboardSounds, this);
					}
				}
				
				if (frame >= 561) {
					if (triggerEvent(561)) {
						Audio.playSound(HouseCrashSound, this);
					}
				}
				
			}
				
			if (frame >= 860) {
				if (triggerEvent(860)) {
					if(_disableMedalsBecausePlayedFromVCR == false) MedalCheck.getMedal(Registry.getEntry("medalClassicMode"), 1);
				}
			}
		}
		
		protected function endingCheck(frame:uint):void {
			if (skipping == false) {
				if (frame >= 2) {
					if (triggerEvent(2)) {
						Audio.playSound(PlanetCollision, this).volume = 1.2;
					}
				}
				
				if (frame >= 262) {
					if (triggerEvent(262)) {
						Audio.playSound(PlanetWhoosh, this).volume = 1;
					}
				}
				
				if (frame >= 503) {
					if (triggerEvent(503)) {
						Audio.playSound(MoonThud, this).volume = 1;
					}
				}
				
				if (frame >= 765) {
					if (triggerEvent(765)) {
						Audio.playSound(Weee, this).volume = 1;
					}
				}
			}
				
			if (frame >= 600) {
				if (triggerEvent(600)) {
					switch(ProfileState.instance.currentGameState.storyModeSpaceLevel) {
						case Global.SPACE_ALTITUDE4:
							if(_disableMedalsBecausePlayedFromVCR == false) MedalCheck.getMedal(Registry.getEntry("medalStoryMode4"), 1);
							break;
						case Global.SPACE_ALTITUDE3:
							if(_disableMedalsBecausePlayedFromVCR == false) MedalCheck.getMedal(Registry.getEntry("medalStoryMode3"), 1);
							break;
						case Global.SPACE_ALTITUDE2:
							if(_disableMedalsBecausePlayedFromVCR == false) MedalCheck.getMedal(Registry.getEntry("medalStoryMode2"), 1);
							break;
						case Global.SPACE_ALTITUDE1:
						default:
							if(_disableMedalsBecausePlayedFromVCR == false) MedalCheck.checkGameModeStory();
							break;
					}
				}
			}
		}
		
		protected function moonCrusherCheck(frame:uint):void {
			if (skipping == false) {
				if (frame >= 2) {
					if (triggerEvent(2)) {
						Audio.playSound(RocketWhoosh, this).volume = 0.5;
					}
				}
				
				if (frame >= 30) {
					if (triggerEvent(30)) {
						Audio.playSound(FLyBySound, this);
					}
				}
				
				if (frame >= 158) {
					if (triggerEvent(158)) {
						Audio.playSound(PlanetCollision, this).volume = 1.35;
					}
				}
				
				if (frame >= 258) {
					if (triggerEvent(258)) {
						Audio.playSound(PlanetWhoosh, this).volume = 0.7;
					}
				}
				
			}
				
			if (frame >= 445) {
				if (triggerEvent(445)) {
					ProfileState.instance.currentGameState.moonDestroyed.value = true;
					if(_disableMedalsBecausePlayedFromVCR == false) MedalCheck.checkMoonBreaker();
				}
			}
		}
		
		protected function creditsCheck(frame:uint):void {
			if (skipping == false) {
				if (frame >= 2) {
					if (triggerEvent(2)) {
						var loop1:MusicObject = Audio.playMusic(MusicPunk1, 0);
						loop1.loop = false;
						
						function playLoop2():void {
							if (skipping == false) {
								var loop2:MusicObject = Audio.playMusic(MusicPunk2, 0);
								loop2.loop = false;
								
								function playLoop3():void {
									if (skipping == false) Audio.playMusic(MusicPunk3, 0);
								}
								
								loop2.signalDestroyed.addOnce(playLoop3);
							}
						}
						
						loop1.signalDestroyed.addOnce(playLoop2);
					}
				}
			}
		}
		
		
		/** Returns true if the passed frame has not been reached yet */
		protected function triggerEvent(frame:uint):Boolean {
			if (frame > _lastTriggeredFrame) {
				_lastTriggeredFrame = frame;
				return true;
			}else {
				return false;
			}
		}
		
		public function destroy():void {
				_checkFunction = null;
		}
		
		
		
		
	}

}