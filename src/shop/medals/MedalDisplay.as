package src.shop.medals 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author 
	 */
	public class MedalDisplay 
	{
		public var overSignal:Signal = new Signal(MedalButton);
		public var outSignal:Signal = new Signal(MedalButton);
		
		protected static const ROW_HEIGHT:Number = 112;
		protected static const COLUMN_WIDTH:Number = 112;
		
		protected var _sprite:Sprite = new Sprite();
		protected var _medalList:Vector.<MedalButton> = new Vector.<MedalButton>();
		
		public function MedalDisplay() 
		{
			buildMedalList();
			addMedalsToDisplay();
		}
		
		protected function buildMedalList():void {
			addMedal("medalAltitude", 1, ProfileState.instance.medals.altitude);
			addMedal("medalAltitude", 2, ProfileState.instance.medals.altitude);
			addMedal("medalAltitude", 3, ProfileState.instance.medals.altitude);
			addMedal("medalAltitude", 4, ProfileState.instance.medals.altitude);
			
			addMedal("medalSpeed", 1, ProfileState.instance.medals.speed);
			addMedal("medalSpeed", 2, ProfileState.instance.medals.speed);
			addMedal("medalSpeed", 3, ProfileState.instance.medals.speed);
			addMedal("medalSpeed", 4, ProfileState.instance.medals.speed);
			
			addMedal("medalFlightTime", 1, ProfileState.instance.medals.flightTime);
			addMedal("medalFlightTime", 2, ProfileState.instance.medals.flightTime);
			addMedal("medalFlightTime", 3, ProfileState.instance.medals.flightTime);
			addMedal("medalFlightTime", 4, ProfileState.instance.medals.flightTime);
			
			addMedal("medalCash", 1, ProfileState.instance.medals.cash);
			addMedal("medalCash", 2, ProfileState.instance.medals.cash);
			addMedal("medalCash", 3, ProfileState.instance.medals.cash);
			addMedal("medalCash", 4, ProfileState.instance.medals.cash);
			
			addMedal("medalHorizontalDistance", 1, ProfileState.instance.medals.horizontalDistance);
			addMedal("medalHorizontalDistance", 2, ProfileState.instance.medals.horizontalDistance);
			addMedal("medalHorizontalDistance", 3, ProfileState.instance.medals.horizontalDistance);
			addMedal("medalHorizontalDistance", 4, ProfileState.instance.medals.horizontalDistance);
			
			addMedal("medalDays", 1, ProfileState.instance.medals.days);
			addMedal("medalDays", 2, ProfileState.instance.medals.days);
			addMedal("medalDays", 3, ProfileState.instance.medals.days);
			addMedal("medalDays", 4, ProfileState.instance.medals.days);
			
			addMedal("medalItemUpgrades", 1, ProfileState.instance.medals.itemUpgrades);
			addMedal("medalItemUpgrades", 2, ProfileState.instance.medals.itemUpgrades);
			addMedal("medalItemUpgrades", 3, ProfileState.instance.medals.itemUpgrades);
			addMedal("medalItemUpgrades", 4, ProfileState.instance.medals.itemUpgrades);
			
			addMedal("medalFrequentBuyer", 1, ProfileState.instance.medals.frequentBuyer);
			addMedal("medalFrequentBuyer", 2, ProfileState.instance.medals.frequentBuyer);
			addMedal("medalFrequentBuyer", 3, ProfileState.instance.medals.frequentBuyer);
			addMedal("medalFrequentBuyer", 4, ProfileState.instance.medals.frequentBuyer);
			
			addMedal("medalAltitudeTotal", 1, ProfileState.instance.medals.altitudeTotal);
			addMedal("medalAltitudeTotal", 2, ProfileState.instance.medals.altitudeTotal);
			addMedal("medalAltitudeTotal", 3, ProfileState.instance.medals.altitudeTotal);
			addMedal("medalAltitudeTotal", 4, ProfileState.instance.medals.altitudeTotal);
			
			addMedal("medalFlightTimeTotal", 1, ProfileState.instance.medals.flightTimeTotal);
			addMedal("medalFlightTimeTotal", 2, ProfileState.instance.medals.flightTimeTotal);
			addMedal("medalFlightTimeTotal", 3, ProfileState.instance.medals.flightTimeTotal);
			addMedal("medalFlightTimeTotal", 4, ProfileState.instance.medals.flightTimeTotal);
			
			addMedal("medalCashTotal", 1, ProfileState.instance.medals.cashTotal);
			addMedal("medalCashTotal", 2, ProfileState.instance.medals.cashTotal);
			addMedal("medalCashTotal", 3, ProfileState.instance.medals.cashTotal);
			addMedal("medalCashTotal", 4, ProfileState.instance.medals.cashTotal);
			
			addMedal("medalObstaclesHit", 1, ProfileState.instance.medals.obstaclesHit);
			addMedal("medalObstaclesHit", 2, ProfileState.instance.medals.obstaclesHit);
			addMedal("medalObstaclesHit", 3, ProfileState.instance.medals.obstaclesHit);
			addMedal("medalObstaclesHit", 4, ProfileState.instance.medals.obstaclesHit);
			
			addMedal("medalStagesOnly", 1, ProfileState.instance.medals.stagesOnly);
			addMedal("medalStagesOnly", 2, ProfileState.instance.medals.stagesOnly);
			addMedal("medalStagesOnly", 3, ProfileState.instance.medals.stagesOnly);
			addMedal("medalStagesOnly", 4, ProfileState.instance.medals.stagesOnly);
			
			addMedal("medalBasicBody", 1, ProfileState.instance.medals.basicBody);
			addMedal("medalBasicBody", 2, ProfileState.instance.medals.basicBody);
			addMedal("medalBasicBody", 3, ProfileState.instance.medals.basicBody);
			addMedal("medalBasicBody", 4, ProfileState.instance.medals.basicBody);
			
			addMedal("medalPayload", 1, ProfileState.instance.medals.payload);
			addMedal("medalPayload", 2, ProfileState.instance.medals.payload);
			addMedal("medalPayload", 3, ProfileState.instance.medals.payload);
			addMedal("medalPayload", 4, ProfileState.instance.medals.payload);
			
			
			addMedal("medalStoryMode", 1, ProfileState.instance.medals.storyMode);
			addMedal("medalStoryMode2", 1, ProfileState.instance.medals.storyMode2);
			addMedal("medalStoryMode3", 1, ProfileState.instance.medals.storyMode3);
			addMedal("medalStoryMode4", 1, ProfileState.instance.medals.storyMode4);
			
			addMedal("medalFreeMode", 2, (ProfileState.instance.medals.payloadMode > 0) ? 2:0);
			addMedal("medalClassicMode", 3, (ProfileState.instance.medals.classicMode > 0) ? 3:0);
			addMedal("medalSandboxMode", 4, (ProfileState.instance.medals.sandboxMode > 0) ? 4:0);
			addMedal("medalAllBonus", 1, ProfileState.instance.medals.allBonus);
			
			
			addMedal("medalChallengeStory1", 1, (ProfileState.instance.medals.challengeStory1 > 0) ? 1:0);
			addMedal("medalChallengeStory4", 1, (ProfileState.instance.medals.challengeStory4 > 0) ? 1:0);
			addMedal("medalChallengePayload", 1, (ProfileState.instance.medals.challengePayload > 0) ? 1:0);
			addMedal("medalChallengeClassic", 1, (ProfileState.instance.medals.challengeClassic > 0) ? 1:0);
			
			addMedal("medalComeBack", 1, ProfileState.instance.medals.comeback);
			addMedal("medalComeBack", 2, ProfileState.instance.medals.comeback);
			addMedal("medalComeBack", 3, ProfileState.instance.medals.comeback);
			addMedal("medalComeBack", 4, ProfileState.instance.medals.comeback);
			
			addMedal("medalInsaneAltitude", 1, ProfileState.instance.medals.insaneAltitude);
			addMedal("medalInsaneAltitude2", 3, ProfileState.instance.medals.insaneAltitude2);
			addMedal("medalSpeedrunner", 1, ProfileState.instance.medals.speedRun);
			addMedal("medalSpeedrunner2", 3, ProfileState.instance.medals.speedRun2);
			
			addMedal("medalMoonBreaker", 1, ProfileState.instance.medals.moonBreaker);
			addMedal("medalEasterEggs", 1, (ProfileState.instance.medals.easterEggs > 0) ? 1:0);
			addMedal("medalCompletionist", 1, (ProfileState.instance.medals.completionist > 0) ? 1:0);
			
			
			if(ProfileState.instance.medals.cheater>=1)	addMedal("medalCheater", 1, (ProfileState.instance.medals.cheater > 0) ? 1:0);
			
			
			//addMedal("medalAroundTheWorld", 1, ProfileState.instance.medals.aroundTheWorld);
			
		}
		
		protected function addMedalsToDisplay():void {
			var i:int = 0;
			var column:int = 0;
			
			while (i < _medalList.length) {
				
				for (var row:int = 0; row <= 3; row++) {
					if (i < _medalList.length) {
						_sprite.addChild(_medalList[i].visual);
						_medalList[i].visual.x = column * COLUMN_WIDTH;
						_medalList[i].visual.y = row * ROW_HEIGHT;
						i += 1;
					}else {
						return;
					}
				}
				
				column += 1;
			}
		}
		
		protected function addMedal(id:String, frame:int, unlockedStatus:int, clickFunction:Function = null):void {
			var medal:MedalButton = new MedalButton(id, frame, unlockedStatus, clickFunction);
			medal.overSignal.add(overSignal.dispatch);
			medal.outSignal.add(outSignal.dispatch);
			_medalList.push(medal);
		}
		
		public function refreshMedals():void {
			while (_medalList.length >= 1) {
				_medalList[0].destroy();
				_medalList.shift();
			}
			
			while (_sprite.numChildren >= 1) _sprite.removeChildAt(0);
			
			buildMedalList();
			addMedalsToDisplay();
		}
		
		public function get sprite():Sprite 
		{
			return _sprite;
		}
		
		public function destroy():void {
			if (overSignal) overSignal.removeAll();
			overSignal = null;
			
			if (outSignal) outSignal.removeAll();
			outSignal = null;
			
			_sprite = null;
			
			for each (var m:MedalButton in _medalList) {
				m.destroy();
			}
			
			_medalList = null;
		}
		
	}

}