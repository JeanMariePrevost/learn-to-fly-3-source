package src.game.spacestage 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import src.UiScaler;
	import src.audio.Audio;
	import src.effects.LineTrail;
	import src.game.GameEngine;
	import src.game.GameMediator;
	import src.game.StatsOfTheDay;
	import src.gui.Cutscene;
	import src.gui.Transition;
	import src.Main;
	import src.MedalCheck;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class SpaceStage extends MovieClip 
	{
		protected static var _instance:SpaceStage;
		
		public var player:MovieClip;
		public var targetGravity:MovieClip;
		
		protected const GRAVITY:Number = 0.003;
		protected const EARTH_COLLISION_DISTANCE:Number = 1125;
		
		protected var _vx:Number;
		protected var _vy:Number;
		protected var _trail:LineTrail;
		protected var _outTime:Number = 0;//Time spent outside left/right bounds, failure
		protected var _winTime:Number = 0;//Time spent above stage, victory
		
		protected var _maxDistanceFromEarth:Number = 0;
		
		public function SpaceStage(singleton:Enforcer) 
		{
			player.alpha = 0;
			player.scaleX = player.scaleY = 0.7;
			
			_trail = LineTrail.newLineTrail();
			_trail.maxSegments = 250;
			_trail.fadeFromLength = 50;
			_trail.fadeInLength = 15;
			_trail.fadeInMinAlpha = 0.25;
			_trail.color = 0xFFFFFF;
			_trail.lineWidth = 1.5;
			_trail.baseAlpha = 0.5;
			_trail.minDistance = 1;
			addChild(_trail.visual);
			
			Audio.fadeAllAudio();
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			UiScaler.addAbsoluteManually(this, 360, -360);
		}
		
		protected function tick(delta:Number):void {
			delta *= 0.8;
			
			var gravAngle:Number = Trig.angleToObject(player, targetGravity);
			
			var gravVx:Number = Trig.vectorX(GRAVITY, gravAngle);
			var gravVy:Number = Trig.vectorY(GRAVITY, gravAngle);
			
			var distFromEarthCenter:Number = Math.sqrt(Math.pow(player.x - targetGravity.x, 2) + Math.pow(player.y - targetGravity.y, 2));
			var gravMult:Number = NumberUtils.interpolate2(0, 0.6, 1120, 1350, distFromEarthCenter, 1.5);
			var xFriction:Number = NumberUtils.interpolate2(0.015, 0, 1120, 1200, distFromEarthCenter, 0.3);
			var xRedzone:Number = NumberUtils.interpolate2(0, 0.02, 0, 2.5, Math.abs(_vx), 2);
			//trace("Dist:", distFromEarthCenter, "Grav:", gravMult);
			//trace("xFriction:", xFriction, "xRedzone:", xRedzone);
			
			gravMult = 1 - (gravMult * delta);
			xFriction = 1 - (xFriction * delta);
			xRedzone = 1 - (xRedzone * delta);
			
			_vx += (gravVx * gravMult) * delta;
			_vx *= xFriction;
			_vx *= xRedzone;
			_vy += (gravVy * gravMult) * delta;
			_vy *= xRedzone;
			
			player.x += _vx * delta;
			player.y += _vy * delta;
			
			//trace("vx:", _vx, "vy:", _vy);
			
			_trail.addSegment(player.x, player.y);
			_trail.fadeLine(0.0011);
			_trail.update();
			
			if (player.alpha < 1) {
				player.alpha += 0.01;
			}else {
				if (distFromEarthCenter <= EARTH_COLLISION_DISTANCE) {
					trace("Fell to earth, space stage failed.");
					failSpaceStage();
					return;
				}
			}
			
			_maxDistanceFromEarth = Math.max(_maxDistanceFromEarth, distFromEarthCenter);
			
			if (player.y <= -2) {
				_winTime += 1;
				
				if (_winTime >= 200) {
					trace("Victory!");
					
					succeedSpaceStage(_vy);
					return;
				}
			}else {
				if (player.x <= -10 || player.x >= 730) {
					_outTime+= 1;
					
					if (_outTime >= 300) {
						trace("Out of bounds, space stage failed.");
						failSpaceStage();
						return;
					}
				}
			}
			
			
		}
		
		protected function failSpaceStage():void {
			var dist:Number = _maxDistanceFromEarth - EARTH_COLLISION_DISTANCE;
			//trace("Extra distance:", dist);
			var distBonus:Number = NumberUtils.interpolate2(0, Global.spaceAltitude * 0.5, 0, 325, dist);
			//trace("Resulting bonus altitude:", distBonus);
			GameMediator.updatePlayerAltitude.dispatch(StatsOfTheDay.instance.maxAltitude + distBonus)
			GameEngine.instance.showResultsWithSnapshot();
			destroy();
		}
		
		protected function succeedSpaceStage(speedAtFinish:Number):void {
			Log.log("succeedSpaceStage(), speedAtFinish =", speedAtFinish);
			
			if (ProfileState.instance.currentGameState.gameMode == "Story Mode" && ProfileState.instance.currentGameState.gameCompleted.value == false) {
				switch(ProfileState.instance.currentGameState.storyModeSpaceLevel) {
					case Global.SPACE_ALTITUDE4:
						MedalCheck.checkChallengeStory1();
						MedalCheck.checkChallengeStory4();
						break;
					case Global.SPACE_ALTITUDE3:
						MedalCheck.checkChallengeStory1();
						break;
					case Global.SPACE_ALTITUDE2:
						MedalCheck.checkChallengeStory1();
						break;
					case Global.SPACE_ALTITUDE1:
						MedalCheck.checkChallengeStory1();
					default:
						break;
				}
				
				Cutscene.playEnding();
				destroy();
			}else {
				Log.log("succeedSpaceStage() Warning - Playing sandbox or already finished on this game");
				//Log.log("Game Mode;", ProfileState.instance.currentGameState.gameMode);
				//Log.log("Game Completed:", ProfileState.instance.currentGameState.gameCompleted.value);
				//Playing sandbox or already finished on this game
				
				if (speedAtFinish <= -2.5 && ProfileState.instance.currentGameState.gameMode == "Story Mode" && ProfileState.instance.currentGameState.moonDestroyed.value == false) {
					Cutscene.playMoonCrusher(failSpaceStage);
					destroy();
				}else {
					failSpaceStage();
				}
				
			}
			
		}
		
		static public function startSpaceStage(playerSpeed:Number = 40, playerDirection:Number = 0):SpaceStage {
			if (_instance) {
				destroy();
			}
			
			_instance = new SpaceStage(new Enforcer);
			
			trace("------------Space Stage------------");
			trace("Speed:", playerSpeed);
			trace("Angle:", playerDirection);
			
			playerSpeed *= 0.05;
			playerDirection += 4;
			
			playerDirection = NumberUtils.constrain(playerDirection, -165, -20);
			
			_instance._vx = Trig.vectorX(playerSpeed, playerDirection);
			_instance._vy = Trig.vectorY(playerSpeed, playerDirection);
			
			Main.unsafeTickSignal.add(_instance.tick);
			
			return _instance;
		}
		
		public static function destroy():void {
			if (_instance) {
				_instance.player = null;
				_instance.targetGravity = null;
				Main.unsafeTickSignal.remove(_instance.tick);
				
				while (_instance.numChildren >= 1) _instance.removeChildAt(0);
				if (_instance.parent) _instance.parent.removeChild(_instance);
			}
		}
		
	}

}

class Enforcer { }
