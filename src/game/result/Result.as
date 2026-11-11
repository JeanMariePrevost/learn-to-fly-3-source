package src.game.result 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lbg.debug.Log;
	import lbg.utils.NumberUtils;
	import src.audio.Audio;
	import src.audio.Music;
	import src.game.GameEngine;
	import src.game.StatHooks;
	import src.game.StatsOfTheDay;
	import src.gui.Transition;
	import src.Main;
	import src.MedalCheck;
	import src.reg.Stat;
	import src.system.GameState;
	import src.system.GameStateItem;
	import src.system.Global;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Result extends Sprite 
	{
		public var dim:ResultScreenDim;
		public var resultScreen:ResultScreen;
		
		//Used only for balancing stats
		protected var _balanceScore:Number = 0;
		
		protected var _rewardsApplied:Boolean = false;
		
		public function Result(stats:StatsOfTheDay) 
		{
			Audio.fadeAllAudio();
			Music.playResultsMusic();
			
			dim = new ResultScreenDim();
			addChild(dim);
			
			resultScreen = new ResultScreen();
			addChild(resultScreen);
			
			stats.stopCurrentDayStats();
			
			
			//Slots hue
			var colorAltitude:Number = -12;
			var colorDuration:Number = 35;
			var colorSpeed:Number = 100;
			var colorBonusMoney:Number = -70;
			var colorInterest:Number = -105;
			var colorPayloadBonus:Number = -120;
			
			var gs:GameState = ProfileState.instance.currentGameState;
			
			//Calculate rewards
			var altitudeCash:Number;
			if (ProfileState.instance.currentGameState.gameMode == "Classic Mode") {
				gs.previousDaysScores.push(Math.max(Math.abs(stats.maxDistanceLeft), stats.maxDistanceRight));
				altitudeCash = Global.rewardForDistance(Math.max(Math.abs(stats.maxDistanceLeft), stats.maxDistanceRight));
			}else {
				gs.previousDaysScores.push(stats.maxAltitude);
				altitudeCash = Global.rewardForAltitude(stats.maxAltitude);
			}
			
			var durationCash:Number = Global.rewardForDuration(stats.newFlightTime, altitudeCash);
			var speedCash:Number = Global.rewardForSpeed(stats.maxSpeed, altitudeCash, durationCash);
			
			
			
			//GameState best
			gs.bestAltitude = Math.max(gs.bestAltitude, stats.maxAltitude);
			gs.bestDuration = Math.max(gs.bestDuration, stats.newFlightTime);
			gs.bestSpeed = Math.max(gs.bestSpeed, stats.maxSpeed);
			gs.classicTopDistance.value = Math.max(gs.classicTopDistance.value, Math.abs(stats.maxDistanceLeft), stats.maxDistanceRight);
			
			
			if (ProfileState.instance.currentGameState.gameMode == "Classic Mode") {
				//Replace altitude by distance
				resultScreen.addNode("Distance", altitudeCash, Math.max(Math.abs(stats.maxDistanceLeft), stats.maxDistanceRight) / gs.classicTopDistance.value, colorAltitude);
			}else {
				resultScreen.addNode("Altitude reached", altitudeCash, stats.maxAltitude / gs.bestAltitude, colorAltitude);
			}
			
			resultScreen.addNode("Air time", durationCash, stats.newFlightTime / gs.bestDuration, colorDuration);
			resultScreen.addNode("Max speed", speedCash, stats.maxSpeed / gs.bestSpeed, colorSpeed);
			
			if (StatHooks.moneyMult.value != 1 || StatHooks.moneyFlat.value != 0) {
				var bonusMoney:Number = StatHooks.moneyFlat.value;
				var totalBaseMoney:Number = altitudeCash + durationCash + speedCash;
				bonusMoney += Math.round((totalBaseMoney * StatHooks.moneyMult.value) - totalBaseMoney);
				Log.log("Result -> Special:", bonusMoney);
				if (bonusMoney != 0) {
					gs.bestBonusMoney = Math.max(gs.bestBonusMoney, bonusMoney);
					var node:Node = resultScreen.addNode("Bonus earnings", bonusMoney, bonusMoney / gs.bestBonusMoney, colorBonusMoney);
					node.setTextColor(0x444444);
				}
			}
			
			if (ProfileState.instance.bonusItems.bonusInterest.level >= 1) {
				var cash:Number = ProfileState.instance.currentGameState.cash.value;
				var interest:Number = ProfileState.instance.bonusItems.bonusInterest.statPower;
				var cap:Number = ProfileState.instance.bonusItems.bonusInterest.statFuel;
				var interestEarnings:Number = Math.round(Math.max(0, Math.min(cap, cash * interest)));
				Log.log("Result -> Interest:", "cash:", cash, "interest:", interest, "cap:", cap, "earnings:", interestEarnings);
				if (interestEarnings != 0) {
					gs.bestInterestEarnings = Math.max(gs.bestInterestEarnings, interestEarnings);
					var node:Node = resultScreen.addNode("Daily interest", interestEarnings, interestEarnings / gs.bestInterestEarnings, colorInterest);
					node.setTextColor(0x555555);
				}
			}
			
			
			///Playload bonus
			var payloadBonusRatio:Number = 0;
			switch(stats.currentPayload) {
				default:
					//Unknown payload, perhaps sandbox mode
					break;
				case "payload1":
					payloadBonusRatio = 0;
					break;
				case "payload2":
					payloadBonusRatio = 0.15;
					break;
				case "payload3":
					payloadBonusRatio = 0.5;
					break;
				case "payload4":
					payloadBonusRatio = 1;
					break;
			}
			
			if (payloadBonusRatio != 0) {
				var payloadBonus:Number = (altitudeCash + durationCash + speedCash) * payloadBonusRatio;
				gs.bestPayloadBonus = Math.max(gs.bestPayloadBonus, payloadBonus);
				Log.log("Result -> Payload bonus:", payloadBonus);
				if (payloadBonus != 0) {
					var node:Node = resultScreen.addNode("Payload Bonus", payloadBonus, payloadBonus / gs.bestPayloadBonus, colorPayloadBonus);
					node.setTextColor(0x666666);
				}
			}

			
			Log.log("Result -> Altitude:",stats.maxAltitude);
			Log.log("Result -> Duration:",stats.newFlightTime);
			Log.log("Result -> Max Speed:", stats.maxSpeed);
			
			if(gs.gameMode != "Sandbox") stats.updateProfileStats();
			
			ProfileState.instance.currentGameState.day.value += 1;
			
			Input.instance.basicCommands.anyKey.signalCommandDown.add(onKeyDown);
			addEventListener(Event.ADDED_TO_STAGE, added);
			
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			onKeyDown();
		}
		
		private function onKeyDown():void 
		{
			if (resultScreen.animationCompleted) {
				trace("onKeyDown() - Exit results");
				applyDailyRewards();
				Input.instance.basicCommands.anyKey.signalCommandDown.remove(onKeyDown);
				if(stage) stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				Transition.transitionTo(destroy, Main.gameToShop);
			}else {
				trace("onKeyDown() - Skip results anim");
				//Cut animation
				resultScreen.forceShowUp();
				dim.gotoAndStop("end");
			}
		}
		
		public function applyDailyRewards():void {
			if (_rewardsApplied != true) {
				ProfileState.instance.currentGameState.cash.value += resultScreen.getTotalCash();
				if (ProfileState.instance.currentGameState.gameMode == "Sandbox") {
					ProfileState.instance.stats.totalSandboxDays += 1;
					Log.log("Sandbox mode progress:", ProfileState.instance.stats.totalSandboxDays);
				}else {
					ProfileState.instance.stats.totalCash += resultScreen.getTotalCash();
				}
				ProfileState.instance.stats.totalDays += 1;
				ProfileState.earnBonusPoints(ProfileState.instance.bonusItems.bonusBpPerDay.statPower);
			}
		}
		
		public function destroy():void {
			if (resultScreen) resultScreen.destroy();
			resultScreen = null;
			if (dim) dim.destroy();
			dim = null;
			
			Input.instance.basicCommands.anyKey.signalCommandDown.remove(onKeyDown);
			
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}