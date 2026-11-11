package src.game.gameobjects.player 
{
	import com.hurlant.crypto.symmetric.CBCMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import lbg.debug.Log;
	import lbg.utils.*;
	import nape.callbacks.InteractionCallback;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.shape.*;
	import src.compound.CompoundNumber;
	import src.compound.TimedMod;
	import src.game.DragWind;
	import src.game.GameCamera;
	import src.game.GameEngine;
	import src.game.GameMediator;
	import src.game.gameobjects.GameObject;
	import src.game.gameobjects.player.body.SimpleBody;
	import src.game.gameobjects.player.boost.BoostController;
	import src.game.gameobjects.player.rudder.SimpleRudder;
	import src.game.gameobjects.player.stage.IStage;
	import src.game.gameobjects.player.stage.StageController;
	import src.game.StatHooks;
	import src.ItemIcon;
	import src.Main;
	import src.Penguin;
	import src.system.*;
	
	/**
	 * Player now IS the body, or the "abstract" body class
	 * @author 
	 */
	public class Player extends GameObject implements IPlayerGear//, IGearWithMass
	{
		public static const ANCHOR_TOP:String = "top";
		public static const ANCHOR_CENTER:String = "center";
		public static const ANCHOR_BOTTOM:String = "bottom";
		
		public var penguin:Penguin;
		public var tTop:MovieClip;
		public var tCenter:MovieClip;
		public var tBottom:MovieClip;
		
		public var tLeft1:MovieClip;
		public var tLeft2:MovieClip;
		public var tLeft3:MovieClip;
		public var tLeft4:MovieClip;
		
		public var tOffTop:MovieClip;
		public var tOffCenter:MovieClip;
		public var tOffBottom:MovieClip;
		
		
		public var tLeftVector:Vector.<MovieClip> = new Vector.<MovieClip>();
		public var dayEndTicks:Number = 0;
		public var dayEndTicksTotal:Number = 0;//Count that never drops, used to decrease the recovery over time to prevent abusing it
		public var dayEndTicksV:Number = 0;
		public var groundHitTickCount:Number = 0;//Number of frames spend touching the ground
		public var groundHitTimer:Number = 0;//Hold time of last impact with ground for dayendticks
		public var groundHitTimeTolerance:Number = 400;//If last impact within tolerance, dayendtick
		
		public var enableTicking:Boolean = false;
		
		public var playerBaseSpriteSize:Number;//Used to get body-only sizxe for stuff like DragWind and Shields
		
		protected var _item:GameStateItem;
		
		protected var _gearList:Vector.<IPlayerGear> = new Vector.<IPlayerGear>();
		protected var _lastPos:Point = new Point();
		protected var _lastSpeed:Number = 0;//Speed is now computed once per tick only and cached here
		protected var _windTorqueFromMass:Number = 1;//Mult of the effect of the wind based on player mass
		protected var _windPushFromMass:Number = 1;//Mult of the effect of the wind based on player mass
		
		protected var _obstacleCollisionRotationDrag:CompoundNumber = new CompoundNumber(1);//Used to reduces player loss of control at collision with obstacles
		protected var _dragWind:DragWind;
		
		protected var _rotationLastTick:Number = 0;
		
		public function Player(shapeList:ShapeList, visual:MovieClip, gameState:GameState) 
		{
			super(shapeList, visual);
			
			_body.cbTypes.add(Global.CB_TYPE_PLAYER);
			_body.setShapeFilters(new InteractionFilter(Global.COLLISION_GROUP_PLAYER, Global.COLLISION_MASK_PLAYER));
			
			_item = gameState.body;
			
			updateBodyMass();
			applyColorCustmotixation();
			
			var rect:Rectangle = _movieClip.getRect(_movieClip.parent);
			playerBaseSpriteSize = Math.max(rect.width, rect.height);
			
			_dragWind = new DragWind(this);
			_movieClip.addChild(_dragWind);
			
			GameMediator.addStageAtRuntime.add(addStageAtRuntime);
			GameMediator.playerImpactObstacle.add(onObstacleCollision);
			GameMediator.playerHitsGround.add(onGroundCollision);
			StatHooks.weightMult.signalChange.add(updateBodyMass);
			StatHooks.invisWeightMult.signalChange.add(updateBodyMass);
		}
		
		protected function applyColorCustmotixation():void {
			var hue:Number = -180 + (360 * ProfileState.instance.customizationData.shipHue);
			var brightness:Number = -100 + (200 * ProfileState.instance.customizationData.shipBrightness);
			var saturation:Number = -100 + (200 * ProfileState.instance.customizationData.shipSaturation);
			var contrast:Number = -100 + (200 * ProfileState.instance.customizationData.shipContrast);
			
			DisplayObjectUtil.setColorMatrix(getMovieClip(), hue, saturation, brightness, contrast);
		}
		
		protected function addStageAtRuntime(item:GameStateItem):void 
		{
			//trace("Adding item to player...");
			for each(var g:IPlayerGear in _gearList) {
				if (g is StageController) {
					var newStage:IStage = new (item.statGameClass)(this, item);
					(g as StageController).addStage(newStage);
					//trace("Item ADDED!");
					GameMediator.createdStageAtRuntime.dispatch(newStage);
					break;
				}
			}
		}
		
		protected function onObstacleCollision(cb:InteractionCallback):void {
			_obstacleCollisionRotationDrag.addMod(new TimedMod(0, 0.9, 10, Main.unsafeTickSignal));
			//trace("Added drag TimedMod from collision.");
		}
		
		protected function onGroundCollision(cb:InteractionCallback):void {
			//trace("onGroundCOllision()");
			groundHitTimer = getTimer();
		}
		
		override public function tick(delta:Number):void {
			//Has to come last
			_lastPos.x = _movieClip.x;
			_lastPos.y = _movieClip.y;
			super.tick(delta);
			
			refreshSpeedValue(delta);
			
			//enableTicking has to be true for player controls and gears to work
			//This is used to prevent ticking while a launcher has control
			if(enableTicking){
				for each(var i:IPlayerGear in _gearList) {
					i.tick(delta);
				}
				GameMediator.updatePlayerMove.dispatch((_movieClip.x - _lastPos.x), (_movieClip.y - _lastPos.y));
				GameMediator.updatePlayerSpeed.dispatch(speed, getSpeedAngle());
				//trace("Player speed:", speed);
				GameMediator.updatePlayerPosition.dispatch(_movieClip.x, _movieClip.y);
				
				checkAndCountDayEndTick(delta);
			}
			
			//Reduce angularVel when collision occur
			_body.angularVel *= _obstacleCollisionRotationDrag.value;
			
			var vel:Number = Math.abs(_body.velocity.x) + Math.abs(_body.velocity.y);
			var highSpeedAngleDrag:Number = NumberUtils.interpolate2(1, 0.5, 18000, 150000, vel, 0.5);
			var highSpeedAngleRestriction:Number = NumberUtils.interpolate2(0, 0.25, 18000, 150000, vel, 0.5);
			_body.rotation = NumberUtils.interpolate(_body.rotation, _rotationLastTick, highSpeedAngleRestriction);
			_body.angularVel *= highSpeedAngleDrag;
			//trace("_rotationLastTick", _rotationLastTick.toFixed(2), "->", _body.rotation.toFixed(2));
			_rotationLastTick = _body.rotation;
			
			//if (_obstacleCollisionRotationDrag.value != 1) trace("RotationDrag:", _obstacleCollisionRotationDrag.value);
			
			
			preventPassingThroughGround();
		}
		
		protected function preventPassingThroughGround():void {
			if (getPositionY() >= (GameEngine.instance.ground.groundLevel + 100)) {
				setPosition(NaN, GameEngine.instance.ground.groundLevel - 100);
				killMomentum();
			}
		}
		
		public function addGearItem(item:IPlayerGear):void {
			if (_gearList.indexOf(item) >= 0) return;
			
			_gearList.push(item);
			updateBodyMass();
		}
		
		public function updateBodyMass(cn:CompoundNumber = null):void {
			var massMult:Number = 1;
			var invisMassMult:Number = 1;
			if (StatHooks.weightMult) massMult = StatHooks.weightMult.value;
			if (StatHooks.invisWeightMult) invisMassMult = StatHooks.invisWeightMult.value;
			
			
			var mass:Number = getBodyMass();
			
			for each(var i:IPlayerGear in _gearList) {
				if (i is IGearWithMass) {
					//trace(i, "has mass of", (i as IGearWithMass).weight);
					mass += (i as IGearWithMass).weight;
				}
			}
			
			mass *= massMult;
			
			mass = Math.max(1, mass); // Mass can never go below 1
			
			var displayMass:Number = mass;
			
			mass *= invisMassMult;
			mass = Math.max(1, mass); // Mass can never go below 1
			
			_body.mass = mass;
			if (_body.gravMass != 0) {
				//Don't change if currently set to zero by launcher
				_body.gravMass = mass;
			}
			
			_windTorqueFromMass = NumberUtils.interpolate2(1.25, 0.15, 3, 140, mass, 0.3);
			_windPushFromMass = NumberUtils.interpolate2(1.25, 0.15, 3, 140, mass, 0.3);
			
			//Log.log("Total mass =", mass, "  Wind effect mult:", _windTorqueFromMass);
			
			GameMediator.playerWeightChange.dispatch(displayMass);
		}
		
		protected function getBodyMass():Number {
			return _item.statWeight;
		}
		
		public function dragTorque(mult:Number):void {
			_body.angularVel *= mult;
		}
		
		override public function applyDrag(mult:Number):void 
		{
			var drag: Number = 1 - ((1 - mult) * StatHooks.dragMult.value);
			//trace("Player drag:", drag);
			
			super.applyDrag(drag);
		}
		
		/**
		 * Every thrust from boosts/stages should be applied here
		 * @param	powerMult Normalized value where >1 lifts the player
		 * @param	fromPosition Position offset from the center-mass of the player, making the force off-center if not (0,0)
		 */
		public function applyThrust(powerMult:Number, relativeAngle:Number = 0, fromPosition:Vec2 = null):void {
			//trace("Applying thrust:", powerMult * Global.powerPerMassUnit * _body.mass, relativeAngle);
			
			applyRelativeAngleForce(powerMult * Global.powerPerMassUnit * _body.mass, relativeAngle, fromPosition);
		}
		
		public function killMomentum():void {
			_body.velocity.x = 0;
			_body.velocity.y = 0;
		}
		
		/** The player speed */
		public function get speed():Number {
			return _lastSpeed
		}
		
		/** The player top speed */
		public function get topSpeed():Number {
			return Math.round((_item.statTopSpeed + StatHooks.topSpeedFlat.value) * StatHooks.topSpeedMult.value);
		}
		
		/** The direction of player movement, in degrees */
		public function get speedAngle():Number {
			return getSpeedAngle();
		}
		
		protected function refreshSpeedValue(delta:Number):void {
			_lastSpeed = NumberUtils.distanceBetween(_lastPos.x, _lastPos.y, _movieClip.x, _movieClip.y) / delta;
		}
		
		protected function getSpeedAngle():Number {
			return Trig.angleTo(_lastPos.x, _lastPos.y, _movieClip.x, _movieClip.y);
		}
		
		public function setPositionFromAnchor(X:Number, Y:Number, anchor:String = ANCHOR_CENTER):void {
			var a:MovieClip = anchorFromString(anchor);
			
			if (a != null) {
				var vx:Number = Trig.vectorX(a.x, _movieClip.rotation);
				vx += Trig.vectorX(a.y, _movieClip.rotation + 90);
				var vy:Number = Trig.vectorY(a.y, _movieClip.rotation + 90);
				vy += Trig.vectorY(a.x, _movieClip.rotation);
				
				//trace("X:", a.x, vx, rotation);
				//trace("Y:", a.y, vy, rotation);
			}else {
				var vx:Number = 0;
				var vy:Number = 0;
				Log.log("ERROR: No anchor could be found on player for name:", ANCHOR_CENTER);
			}
			
			
			setPosition(X - vx, Y - vy);
		}
		
		/* INTERFACE src.game.gameobjects.player.IPlayerGear */
		
		public function get item():GameStateItem 
		{
			return _item;
		}
		
		protected function anchorFromString(anchor:String):MovieClip {
			switch(anchor) {
				case ANCHOR_TOP:
					return tTop;
				case ANCHOR_CENTER:
					return tCenter;
				case ANCHOR_BOTTOM:
					return tBottom;
				default:
					throw new Error("Invalid anchor string");
					return tCenter;
			}
		}
		
		protected function checkAndCountDayEndTick(delta:Number):Number {
			
			//Ticks from touching the ground, increases with time, slowly decays
			if (isTouchingGround) {
				groundHitTickCount += delta;
			}else {
				//Slowly decay
				groundHitTickCount = Math.max(groundHitTickCount - delta * 0.015, 0);
			}
			
			var movingTheRightWay:Boolean;
			if (ProfileState.instance.currentGameState.gameMode == "Classic Mode") {
				//movingTheRightWay = (Math.abs(_lastPos.x - _movieClip.x) >= 2)
				movingTheRightWay = (_lastPos.x - _movieClip.x <= -2);
				//movingTheRightWay = true;
			}else {
				movingTheRightWay = ((_lastPos.y - _movieClip.y) >= 1)
			}
			
			//trace("movingTheRightWay = ", movingTheRightWay, _lastPos.y - _movieClip.y);
			var playerIsFlying:Boolean = true;
			if (isTouchingGround) playerIsFlying = false;
			if ((isOutOfStages() || stageIsStoppedByPlayer) && !isUsingBoost() && (movingTheRightWay == false || speed <=1.5)) playerIsFlying = false
			GameMediator.dayIsEnding.dispatch(playerIsFlying == false);
			
			if (ProfileState.instance.optionEndDayAuto) {
				//Regular day end
				if ((isOutOfStages() || stageIsStoppedByPlayer) && !isUsingBoost() && (movingTheRightWay == false || speed <=1.5)) {
					//Out of stage AND falling or almost at a halt
					//trace("dayEndTicksV", dayEndTicksV, "from:", isOutOfStages(), stageIsStoppedByPlayer);
					dayEndTicksV  = Math.min(1, dayEndTicksV + (0.01 * delta));
					if (isTouchingGround) {
						//The longer you've spent on the ground in the past few seconds, the stronger the dayend effect of touching the ground
						var groundV:Number = NumberUtils.interpolate2(0, 0.15, 100, 1000, groundHitTickCount, 1.1);
						dayEndTicksV  = Math.min(1, dayEndTicksV + groundV);
					}
				}else {
					if (isTouchingGround) {
						//The longer you've spent on the ground in te past few seconds, the stronger the dayend effect of touching the ground
						var groundV:Number = NumberUtils.interpolate2(0, 0.15, 100, 1000, groundHitTickCount, 1.1);
						dayEndTicksV  = Math.min(1, dayEndTicksV + groundV);
					}else {
						//Gained altitude or have fuel, reset count
						var recoveryMult:Number = NumberUtils.interpolate2(1, 0.05, 0, 1500, dayEndTicksTotal, 0.8);
						if (dayEndTicksV > 0) dayEndTicksV *= NumberUtils.interpolate2(0.5, 0.999, 1, 0, recoveryMult);
						dayEndTicksV = Math.max( -1, dayEndTicksV - (0.02 * recoveryMult));
					}
				}
			}else {
				//Ground only day end
					if (isTouchingGround) {
						//The longer you've spent on the ground in te past few seconds, the stronger the dayend effect of touching the ground
						var groundV:Number = NumberUtils.interpolate2(0, 0.15, 0, 600, groundHitTickCount, 0.6);
						dayEndTicksV  = Math.min(2, groundV * 4);
					}else {
						//Gained altitude or have fuel, reset count
						var recoveryMult:Number = NumberUtils.interpolate2(1, 0.05, 0, 1500, dayEndTicksTotal, 0.8);
						if (dayEndTicksV > 0) dayEndTicksV *= NumberUtils.interpolate2(0.5, 0.999, 1, 0, recoveryMult);
						dayEndTicksV = Math.max( -1, dayEndTicksV - (0.02 * recoveryMult));
					}
			}
			
			
			dayEndTicks = Math.max(0, dayEndTicks + (delta * dayEndTicksV));
			if ((delta * dayEndTicksV) > 0) {
				dayEndTicksTotal += (delta * dayEndTicksV);
			}
			
			//DEBUG! day never ends
			//dayEndTicks = 0;
			//dayEndTicksTotal = 0;
			//dayEndTicksV = 0;
			
			return dayEndTicksV;
		}
		
		public function get isTouchingGround():Boolean {
			return (getTimer() - groundHitTimer) <= groundHitTimeTolerance;
		}
		
		public function isOutOfStages():Boolean {
			var controller:StageController;
			
			for each(var i:IPlayerGear in _gearList) {
				if (i is StageController) {
					controller = (i as StageController);
					break;
				}
			}
			
			if (controller == null) {
				//No stages
				return true;
			}else if (controller.outOfStages) {
				//Out of stages
				return true;
			}else {
				//Stages left
				return false;
			}
			
		}
		
		protected function isUsingBoost():Boolean {
			var controller:BoostController;
			
			for each(var i:IPlayerGear in _gearList) {
				if (i is BoostController) {
					controller = (i as BoostController);
					break;
				}
			}
			
			if (controller == null) {
				//No boosts
				return false;
			}else if (controller.isPreventingDayEnd) {
				//Boosts are preventing end of day
				return true;
			}else {
				return false;
			}
			return false;
		}
		
		protected function get stageIsStoppedByPlayer():Boolean {
			var controller:StageController;
			
			for each(var i:IPlayerGear in _gearList) {
				if (i is StageController) {
					controller = (i as StageController);
					break;
				}
			}
			
			if (controller == null) {
				//No boosts
				return false;
			}else {
				return controller.isStoppedByPlayer;
			}
		}
		
		public function get rudder():SimpleRudder {
			for each(var i:IPlayerGear in _gearList) {
				if (i is SimpleRudder) {
					return i as SimpleRudder;
				}
			}
			
			return null;
		}
		
		override public function destroy():void {
			StatHooks.invisWeightMult.signalChange.remove(updateBodyMass);
			StatHooks.weightMult.signalChange.remove(updateBodyMass);
			GameMediator.addStageAtRuntime.remove(addStageAtRuntime);
			GameMediator.playerImpactObstacle.remove(onObstacleCollision);
			
			tTop = null;
			tCenter = null;
			tBottom = null;
			tLeft1 = null;
			tLeft2 = null;
			tLeft3 = null;
			tLeft4 = null;
			tOffTop = null;
			tOffCenter = null;
			tOffBottom = null;
			
			if (tLeftVector) tLeftVector.length = 0;
			tLeftVector = null;
			
			_item = null;
			
			if (penguin) penguin.destroy();
			penguin = null;
			
			if (_gearList) {
				for each(var i:IPlayerGear in _gearList) {
					i.destroy();
				}
				_gearList.length = 0;
			}
			_gearList = null;
			_lastPos = null;
			
			if (_obstacleCollisionRotationDrag) _obstacleCollisionRotationDrag.destroy();
			_obstacleCollisionRotationDrag = null;
			
			if (_dragWind) _dragWind.destroy();
			_dragWind = null;
			
			if (_movieClip.stage) DisplayObjectUtil.removeAllChildFrom(_movieClip, true);
			
			super.destroy();
		}
	}

}