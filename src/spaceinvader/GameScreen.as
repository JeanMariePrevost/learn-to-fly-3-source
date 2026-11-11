package src.spaceinvader 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import lbg.collisiondetection.CollisionDetection;
	import lbg.utils.NumberUtils;
	import lbg.utils.VectorUtils;
	import src.Main;
	import src.audio.Music;
	import src.audio.Sfx;
	import src.gui.DialogBox;
	import src.gui.MessageBox;

	import src.system.Global;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameScreen extends MovieClip 
	{
		public static const ENEMY_PER_ROW:Number = 6;
		public static const NUMBER_OF_ROWS:Number = 5;
		public static const X_SPACING:Number = 78;
		public static const Y_SPACING:Number = 48;
		
		public static const X_OFFSET:Number = 80;
		public static const Y_OFFSET:Number = 32;
		public static const X_NOTCH_SIZE:Number = 17;
		public static const Y_NOTCH_SIZE:Number = 20;
		public static const LEFT_LIMIT:Number = 87;
		public static const RIGHT_LIMIT:Number = 570;
		public static const DOWN_LIMIT:Number = 338;
		public static const BASE_TICKS_PER_NOTCH:Number = 15;
		
		public static var instance:GameScreen;
		
		
		public var badGuysContainer:MovieClip;
		public var livesMeter:MovieClip;
		public var player:Player;
		public var fort1:Fort;
		public var fort2:Fort;
		public var fort3:Fort;
		public var fort4:Fort;
		public var txtScore:TextField;
		public var txtLevel:TextField;
		
		public var baddies:Vector.<BadGuy> = new Vector.<BadGuy>();
		
		public var notchTicks:Number = 0;
		public var xNotch:Number = 0;
		public var yNotch:Number = 0;
		public var goingRight:Boolean = true;
		public var ticksPerNotch:Number = BASE_TICKS_PER_NOTCH;
		
		public var score:Number = 0;
		public var wavesCleared:Number = 0;
		
		protected var _restartTime:Number;
		protected const TIME_BETWEEN_WAVES:Number = 50;
		
		public function GameScreen() 
		{
			instance = this;
			super();
			
			livesMeter.gotoAndStop(1);
			
			_restartTime = 30;
			
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			Music.playInvaderGame();
			Main.unsafeTickSignal.add(tick);
		}
		
		protected function startNewWave():void {
			trace("startNewWave()");
			notchTicks = 0;
			xNotch = 0;
			yNotch = 0;
			goingRight = true;
			ticksPerNotch = Math.max(2, BASE_TICKS_PER_NOTCH - (wavesCleared * 2));
			
			for each(var b:BadGuy in baddies) {
				b.destroy();
			}
			
			baddies.length = 0;
			
			for (var row:Number = 0; row < NUMBER_OF_ROWS; row++) {
				for (var col:Number = 0; col < ENEMY_PER_ROW; col++) {
					baddies.push(new BadGuy(row, col));
				}
			}
			
			for each(b in baddies) {
				badGuysContainer.addChild(b);
			}
		}
		
		protected function tick(delta:Number):void {
			if (!stage) {
				trace("GameScreen.tick() ERROR - No stage");
				destroy();
				return;
			}
			
			notchTicks++;
			if (notchTicks >= ticksPerNotch) {
				notchTicks = 0;
				if (goingRight) {
					if (rightMostBadGuyPos >= RIGHT_LIMIT) {
						//switch
						if (lowestBadGuyPos < DOWN_LIMIT) yNotch += 1;
						goingRight = false;
					}else {
						xNotch += 1;
					}
				}else {
					if (leftMostBadGuyPos <= LEFT_LIMIT) {
						//switch
						if (lowestBadGuyPos < DOWN_LIMIT) yNotch += 1;
						goingRight = true;
					}else {
						xNotch -= 1;
					}
				}
			}
			
			for each(var b:BadGuy in baddies) {
				b.x = X_OFFSET + (xNotch * X_NOTCH_SIZE) + (b.col * X_SPACING);
				b.y = Y_OFFSET + (yNotch * Y_NOTCH_SIZE) + (b.row * Y_SPACING);
			}
			
			txtScore.text = score.toFixed(0);
			txtLevel.text = wavesCleared.toFixed(0);
			
			if (baddies.length <= 0) {
				if (_restartTime >= TIME_BETWEEN_WAVES) {
					_restartTime--;
					Sfx.playInvaderWin();
				}
				
				_restartTime--;
				trace("No enemies alive...", _restartTime);
				
				if (_restartTime <= 0) {
					//Start a new wave
					wavesCleared += 1;
					startNewWave();
				}
			}
			
		}
		
		public function get leftMostBadGuyPos():Number {
			var pos:Number = 720;
			for each(var b:BadGuy in baddies) {
				if (b.x < pos) pos = b.x;
			}
			
			return pos;
		}
		
		public function get rightMostBadGuyPos():Number {
			var pos:Number = 0;
			for each(var b:BadGuy in baddies) {
				if (b.x > pos) pos = b.x;
			}
			
			return pos;
		}
		
		public function get lowestBadGuyPos():Number {
			var pos:Number = 0;
			for each(var b:BadGuy in baddies) {
				if (b.y > pos) pos = b.y;
			}
			
			return pos;
		}
		
		public function checkCollisions(bullet:Bullet):void {
			if (fort1.checkCollision(bullet)) return;
			if (fort2.checkCollision(bullet)) return;
			if (fort3.checkCollision(bullet)) return;
			if (fort4.checkCollision(bullet)) return;
			
			if (bullet.vy <= 0) {
				//Player bullet, hittest enemies
				for each(var b:BadGuy in baddies) {
					if (CollisionDetection.checkForCollision(b, bullet, false, 255, Main.instance.transform.concatenatedMatrix)) {
						Sfx.playInvaderEnemyHit();
						score += 5 + (wavesCleared * 5);
						VectorUtils.removeFromVector(baddies, b);
						trace(baddies.length.toFixed(), "enemies left");
						bullet.destroy();
						b.destroy();
						_restartTime = TIME_BETWEEN_WAVES;
						return;
					}
				}
			}else {
				//Ennemy bullet, hittest player
				if (CollisionDetection.checkForCollision(player, bullet, false, 255, Main.instance.transform.concatenatedMatrix)) {
					Sfx.playInvaderPlayerHit();
					bullet.destroy();
					livesMeter.gotoAndStop(livesMeter.currentFrame + 1);
					//livesMeter.nextFrame();
					//trace("hit!", livesMeter.currentFrame);
					if (livesMeter.currentFrame >= livesMeter.totalFrames) {
						//GAME OVER
						Music.destroyAll();
						Main.unsafeTickSignal.remove(tick);
						ProfileState.instance.dodoInvaderHighscore = Math.max(score, ProfileState.instance.dodoInvaderHighscore);
						ProfileState.instance.dodoInvaderHighscoreForSteam = Math.max(score, ProfileState.instance.dodoInvaderHighscoreForSteam);
						SpaceInvader.instance.gameOver(score, ProfileState.instance.dodoInvaderHighscore);
						if (ProfileState.instance.dodoInvaderHighscoreRewardGiven == false && ProfileState.instance.dodoInvaderHighscore > Global.DODO_INVADER_BASIC_SCORE) {
							//Default highscore beaten, give small reward
							ProfileState.instance.dodoInvaderHighscoreRewardGiven = true;
							var msg:MessageBox = new MessageBox("Congratulations!", "You beat the highscore\non Dodo Invader\nYou get 100 Bonus Points!");
							msg.scaleX = msg.scaleY = 1.3;
							Main.dialogLayer.addChild(msg);
							ProfileState.earnBonusPoints(100);

						}
						destroy();
						return;
					}
					return;
				}
			}
		}
		
		public function destroy():void {
			trace("Destroying GameScreen...");
			Main.unsafeTickSignal.remove(tick);
			
			instance = null;
			livesMeter = null;
			if (player) player.destroy();
			player = null;
			
			if(fort1) fort1.destroy();
			if(fort2) fort2.destroy();
			if(fort3) fort3.destroy();
			if(fort4) fort4.destroy();
			
			fort1 = null;
			fort2 = null;
			fort3 = null;
			fort4 = null;
			
			txtScore = null;
			
			if (baddies) {
				for each(var b:BadGuy in baddies) {
					b.destroy();
				}
				baddies.length = 0;
			}
			
			baddies = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}