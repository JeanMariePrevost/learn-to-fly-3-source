package src.game 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import lbg.anticheatengine.SafeNumber;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import nape.constraint.DistanceJoint;
	import nape.constraint.PivotJoint;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import src.game.gameobjects.GameObject;
	import src.game.gameobjects.player.Player;
	import src.game.gameobjects.ShapesData;
	import src.Main;
	import src.MedalCheck;
	import src.reg.Registry;
	import src.reg.RegistryEntry;
	import src.reg.Stat;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameEnginePayload extends GameEngine 
	{
		protected static var _instance:GameEnginePayload;
		
		public static var selectedPayload:RegistryEntry;//Hook for menus to select the payload weight
		
		protected const MAXIMUM_PAYLOAD_DISTANCE:Number = 1000;//Distance for a safety distance joint which works alongside the chain
		protected const MAXIMUM_PAYLOAD_DISTANCE2:Number = 1200;//Distance past which the payload is manually moved to prevent bugs
		protected const MAX_CHAIN_LENGTH:Number = 10;//Chain nodes at minimum payload
		protected const MIN_CHAIN_LENGTH:Number = 2;//Chain nodes at maximum payload
		
		protected var _payload:GameObject;
		protected var _chains:Vector.<GameObject> = new Vector.<GameObject>();
		
		public function GameEnginePayload() 
		{
			super();
			
		}
		
		override protected function setupGameEngine():void 
		{
			super.setupGameEngine();
			
			disableSpaceMinigame();
			setupPayload();
		}
		
		protected function disableSpaceMinigame():void {
			_spaceIndicator.destroy();
			_spaceIndicator = null;
		}
		
		protected function setupPayload(forceWeight:Number = NaN):void {
			GameMediator.updatePlayerDrag.add(onDrag);
			
			var payloadMass:Number;
			if (isNaN(forceWeight)) {
				payloadMass = selectedPayload.statWeight.valueAt(0);
				StatsOfTheDay.instance.currentPayload = selectedPayload.id;
			}else {
				payloadMass = forceWeight;
			}
			
			
			//Scale with player mass
			var unscaledPayloadMass:Number = payloadMass;
			var payloadTopPlayerMass:Number = NumberUtils.interpolate2(5, 90, 1, 150, payloadMass, 1.5, true);//At what player mass the payload weighs 100%
			var payloadMinRatio:Number = NumberUtils.interpolate2(0.5, 0.1, 1, 150, payloadMass, 1.5, true);//How much the mass can be reduced
			
			var playerMass:Number = player.getBody().mass;
			if (player.item.id == "superman") playerMass += 50;
			if (player.item.id == "captainSupporter") playerMass += 40;
			if (player.item.id == "rocketeer") playerMass += 25;
			
			var payloadMassRatio:Number = NumberUtils.interpolate2(payloadMinRatio, 1, 0, payloadTopPlayerMass, playerMass, 1, true);
			payloadMass *= payloadMassRatio;
			//trace("Payload real mass:", unscaledPayloadMass);
			//trace("Payload sclaed mass:", payloadMass);
			
			var payloadScale:Number = NumberUtils.interpolate2(0.2, 3, 5, 450, unscaledPayloadMass, 1.25);// * ((2 + payloadMassRatio) / 3);//This part downscales the payload a bit if the player is lighter
			
			
			_payload = new GameObject(ShapesData.getShapeListOf("payload", payloadScale), new src.game.Payload());
			_payload.getMovieClip().scaleX = _payload.getMovieClip().scaleY = payloadScale;
			_payload.getMovieClip().txtMass.text = unscaledPayloadMass.toFixed(0);
			_payload.setPositionFromPoint(_player.getPositionX(), _player.getPositionY(), 0.5, 1);
			_payload.setPhysicsEngine(_physicsEngine);
			_payload.getBody().cbTypes.add(Global.CB_TYPE_PARTICLE);
			_payload.getBody().setShapeFilters(new InteractionFilter(Global.COLLISION_GROUP_PARTICLE, Global.COLLISION_MASK_PARTICLE));
			_payload.getBody().mass = payloadMass;
			
			var chainLength:uint = Math.round(NumberUtils.interpolate2(MAX_CHAIN_LENGTH, MIN_CHAIN_LENGTH, 1, 250, payloadMass, 0.3));
			var chainScale:Number = NumberUtils.interpolate2(0.4, 3, 1, 250, payloadMass, 1.5);
			var chainLinkPosition:Number = 11 * chainScale;//How far from center the joint is on both sides
			
			for (var i:int = 0; i < chainLength; i++) {
				var c:GameObject = new GameObject(ShapesData.getShapeListOf("payloadChain", chainScale), new src.game.PayloadChain());
				c.getMovieClip().scaleX = c.getMovieClip().scaleY = chainScale;
				c.setPositionFromPoint(_player.getPositionX(), _player.getPositionY(), 0.5, 1);
				c.setPhysicsEngine(_physicsEngine);
				c.getBody().setShapeFilters(new InteractionFilter(Global.COLLISION_GROUP_CHAIN, Global.COLLISION_MASK_CHAIN));
				//c.getBody().mass = 0.002;
				//trace(c.getBody().mass);
				_chains.push(c);
			}
			
			var j:PivotJoint;
			
			for (var i:int = 1; i < chainLength; i++) {
				j = new PivotJoint(_chains[i - 1].getBody(), _chains[i].getBody(), new Vec2(0, -chainLinkPosition), new Vec2(0, chainLinkPosition));
				j.space = _physicsEngine.space;
				j.active = true;
				j.stiff = true;
				j.ignore = true;
				
			}
			
			j = new PivotJoint(_payload.getBody(), _chains[0].getBody(), new Vec2(0, -78 * payloadScale), new Vec2(0, chainLinkPosition));
			j.space = _physicsEngine.space;
			j.active = true;
			
			j = new PivotJoint(_chains[_chains.length - 1].getBody(), _player.getBody(), new Vec2(0, -chainLinkPosition), new Vec2(0, 0));
			j.space = _physicsEngine.space;
			j.active = true;
			
			//Maximum distance constraint
			var dj:DistanceJoint = new DistanceJoint(_player.getBody(), _payload.getBody(), new Vec2(), new Vec2(), 1, MAXIMUM_PAYLOAD_DISTANCE);
			dj.space = _physicsEngine.space;
			dj.active = true;
			
			_camera.addChildToMovingLayer(_payload.getMovieClip(), 1);
			
			for each (var chain:GameObject in _chains) {
				_camera.addChildToMovingLayer(chain.getMovieClip(), 1);
			}
			
			
			for (i = 0; i <= 100; i++) {
				_player.setPositionFromAnchor(0, _ground.groundLevel, Player.ANCHOR_BOTTOM);
				_physicsEngine.tick(4);
			}
			
			for (i = 0; i <= 100; i++) {
				_player.setPositionFromAnchor(0, _ground.groundLevel, Player.ANCHOR_BOTTOM);
				_physicsEngine.tick(1);
			}
			
			_player.setPositionFromAnchor(0, _ground.groundLevel, Player.ANCHOR_BOTTOM);
			_player.killMomentum();
			
			GameMediator.updatePlayerAltitude.add(onAltitude)
		}
		
		protected function onDrag(drag:Number):void {
			var d:Number = 1 - (1 - drag) * 0.5;
			_payload.applyDrag(drag);
		}
		
		protected function onAltitude(alt:Number):void 
		{
			if (alt > nextMilestoneAlt) {
				//Get milestone
				//Displays medal get instead of milestone if there is a medal to aquire
				if (selectedPayload.id == "payload1" && nextMilestoneLevel == 1 && ProfileState.instance.medals.payload <= 0) {
					//Payload medal 1
					MedalCheck.getMedal(Registry.getEntry("medalPayload"), 1);
				}else if (selectedPayload.id == "payload2" && nextMilestoneLevel == 2 && ProfileState.instance.medals.payload <= 1) {
					//Payload medal 2
					MedalCheck.getMedal(Registry.getEntry("medalPayload"), 2);
				}else if (selectedPayload.id == "payload3" && nextMilestoneLevel == 3 && ProfileState.instance.medals.payload <= 2) {
					//Payload medal 3
					MedalCheck.getMedal(Registry.getEntry("medalPayload"), 3);
				}else if (selectedPayload.id == "payload4" && nextMilestoneLevel == 4 && ProfileState.instance.medals.payload <= 3) {
					//Payload medal 4
					MedalCheck.getMedal(Registry.getEntry("medalPayload"), 4);
				}else if(nextMilestoneLevel<=4) {
					//No medal or already earned, display milestone popup
					Main.displayPayloadProgress(selectedPayload, nextMilestoneLevel);
				}
				
				
				if (ProfileState.instance.currentGameState.payloadTopAltitude1.value >= 200000
				&& ProfileState.instance.currentGameState.payloadTopAltitude2.value >= 200000
				&& ProfileState.instance.currentGameState.payloadTopAltitude3.value >= 200000
				&& ProfileState.instance.currentGameState.payloadTopAltitude4.value >= 200000) {
					MedalCheck.getMedal(Registry.getEntry("medalFreeMode"), 1);
				}
				
				//Update best altitude
				bestAltitudeSafeNumber.value = alt;
			}
		}
		
		protected function get nextMilestoneAlt():Number {
			return selectedPayload.statCost.valueAt(nextMilestoneLevel);
		}
		
		protected function get nextMilestoneLevel():uint {
			var bestAlt:Number = bestAltitudeSafeNumber.value;
			
			if (bestAlt < selectedPayload.statCost.valueAt(0)) {
				return 0;
			}else if (bestAlt < selectedPayload.statCost.valueAt(1)) {
				return 1;
			}else if (bestAlt < selectedPayload.statCost.valueAt(2)) {
				return 2;
			}else if (bestAlt < selectedPayload.statCost.valueAt(3)) {
				return 3;
			}else if (bestAlt < selectedPayload.statCost.valueAt(4)) {
				return 4;
			}else {
				//All milestones achieved
				return 5;
			}
		}
		
		protected function get bestAltitudeSafeNumber():SafeNumber {
			switch(selectedPayload.id) {
				default:
				case "payload1":
					return ProfileState.instance.currentGameState.payloadTopAltitude1;
					break;
				case "payload2":
					return ProfileState.instance.currentGameState.payloadTopAltitude2;
					break;
				case "payload3":
					return ProfileState.instance.currentGameState.payloadTopAltitude3;
					break;
				case "payload4":
					return ProfileState.instance.currentGameState.payloadTopAltitude4;
					break;
			}
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			//Conditionnal added because sandbox subclasses this class... hacky but eh
			if (_payload) {
				//Extra distance safety, useful for powerful launchers, prevents constraints from breaking
				var playerP:Point = new Point(_player.getPositionX(), _player.getPositionY());
				var payloadP:Point = new Point(_payload.getPositionX(), _payload.getPositionY());
				
				var distance:Number = Point.distance(playerP, payloadP);
				
				//trace("Payload distance:", distance);
				
				if (distance >= MAXIMUM_PAYLOAD_DISTANCE2) {
					var angle:Number = Trig.angleToObject(_player.getMovieClip(), _payload.getMovieClip());
					var X:Number = Trig.vectorX(MAXIMUM_PAYLOAD_DISTANCE2, angle);
					var Y:Number = Trig.vectorY(MAXIMUM_PAYLOAD_DISTANCE2, angle);
					_payload.setPosition(playerP.x + X, playerP.y + Y);
					
					//payloadP.x = playerP.x + X;
					//payloadP.y = playerP.x + Y;
					//var distance:Number = Point.distance(playerP, payloadP);
				}
			}
		}
		
		static public function get instance():GameEnginePayload 
		{
			//if (_instance == null) _instance = new GameEngine();
			return _instance;
		}
		
		static public function initInstance():GameEnginePayload 
		{
			if (_instance == null) {
				_instance = new GameEnginePayload();
				return _instance;
			}else {
				throw new Error("GameEngine.initInstance() Instance already exists");
				return _instance;
			}
		}
		
		public static function destroy():void {
			if (_instance) _instance.destroy();
		}
		
		override public function destroy():void 
		{
			_instance = null;
			
			selectedPayload = null;
			
			if (_payload) _payload.destroy();
			_payload = null;
			
			if (_chains) {
				for each(var o:GameObject in _chains) {
					o.destroy();
				}
				_chains.length = 0;
			}
			_chains = null;
		
			super.destroy();
		}
		
	}

}