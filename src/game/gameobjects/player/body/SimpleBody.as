package src.game.gameobjects.player.body 
{
	import flash.display.MovieClip;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import nape.shape.ShapeList;
	import src.effects.smoketrail.RainbowTrail;
	import src.game.GameCamera;
	import src.game.GameMediator;
	import src.game.gameobjects.GameObject;
	import src.game.gameobjects.player.Player;
	import src.game.gameobjects.ShapesData;
	import src.game.WindEngine;
	import src.system.GameState;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class SimpleBody extends Player
	{
		protected const DRAG_BUFFER_LENGTH:uint = 30;
		
		protected var visualClass:Class = BodyVisual;
		
		protected var _dragValues:Vector.<Number> = new Vector.<Number>();
		protected var _dragStat:Number = 0.009;
		protected var _redZoneDrag:Number = 0.035;
		protected var _maxRedZoneMultSoftCap:Number = 1;//Past this mult of redzone, its effect is greatly decreased
		protected var _airDensity:Number = 1;
		
		protected var _rainbowTrail:RainbowTrail;
		
		
		
		public function SimpleBody(gameState:GameState) 
		{
			_item = gameState.body
			var shapeList:ShapeList = getShapeList();
			//var shapeList:ShapeList = ShapesData.getShapeListOf(gameState.body.id);
			//var shapeList:ShapeList = ShapesData.getShapeListOf("emptyBody");
			var visual:BodyVisual = getVisual();
			//var visual:SimpleBodyVisual = new SimpleBodyVisual();
			super(shapeList, visual, gameState);
			
			penguin = visual.penguin;
			tTop = visual.tTop;
			tCenter = visual.tCenter;
			tBottom = visual.tBottom;
			tLeft1 = visual.tLeft1;
			tLeft2 = visual.tLeft2;
			tLeft3 = visual.tLeft3;
			tLeft4 = visual.tLeft4;
			tOffTop = visual.tOffTop;
			tOffCenter = visual.tOffCenter;
			tOffBottom = visual.tOffBottom;
			tLeftVector.push(tLeft1, tLeft2, tLeft3, tLeft4);
			
			GameMediator.updatePlayerAltitude.add(updateAirDensity);
			
			//Populate drag vector with default values for smooth starts
			for (var i:int = 0; i < DRAG_BUFFER_LENGTH; i++) {
				_dragValues.push(1 - _dragStat);
			}
			
			if (ProfileState.instance.cheatHugePlayer) {
				visual.scaleX = visual.scaleY = visual.scaleX * Global.HUGE_PLAYER_CHEAT_MULT;
			}
			
		}
		
		protected function getShapeList(id:String = null):ShapeList {
			var scale:Number = 1;
			if (ProfileState.instance.cheatHugePlayer) {
				scale = Global.HUGE_PLAYER_CHEAT_MULT;
			}
			
			if (id == null) id = item.id;
			
			return ShapesData.getShapeListOf(id, scale)
		}
		
		/** Override this to set the visual */
		protected function getVisual():BodyVisual {
			return new SimpleBodyVisual();
		}
		
		override public function tick(delta:Number):void {
			if(enableTicking){
				if (WindEngine.wind != 0) {
					var rotationMult:Number = Math.cos(_body.rotation);
					//trace("Wind rotation mult:", rotationMult);
					_body.angularVel += WindEngine.wind * rotationMult * 0.02 * _windTorqueFromMass;
					applyForce(WindEngine.wind * _body.mass * Global.powerPerMassUnit * 0.5 * _windPushFromMass, 0);
				}
				
				tickDrag(delta);
				
				if (ProfileState.instance.cheatNyanCat) {
					if (_rainbowTrail == null) {
						_rainbowTrail = new RainbowTrail(0);
						//_rainbowTrail.quality = 2;
						_rainbowTrail.alpha = 1;
						_rainbowTrail.fadeInLength = 10;
						_rainbowTrail.fadeInAlpha = 0.1;
						_rainbowTrail.fadeInPower = 0.7;
						_rainbowTrail.fadeOutLegnth = 20;
						_rainbowTrail.pushForce = 25;
						_rainbowTrail.pushForceDrag = 0.96;
						_rainbowTrail.spreadForce = 12;
						_rainbowTrail.spreadForceDrag = 0.8;
						_rainbowTrail.fadePerTick = 0.012;
						_rainbowTrail.maxSegments = 140;
						_rainbowTrail.lineWidth = 30;
						GameCamera.instance.addChildToMovingLayerRelativeTo(_rainbowTrail.visual, getMovieClip(), -1);
					}
					_rainbowTrail.addSegment(getMovieClip().x, getMovieClip().y, getMovieClip().rotation + 90);
				}
			}
			
			super.tick(delta);
		}
		
		protected function tickDrag(delta:Number):void {
			//REDZONE / MAX SPEED
			var top:Number = topSpeed;
			var trueDrag:Number = 0;
			
			if (speed <= top) {
				trueDrag = NumberUtils.interpolate2(_dragStat / 2, _dragStat, 0, top, speed, 1.5);
			}else {
				var overSpeedLimit:Number = NumberUtils.interpolate2(4, 30, 5, 60, top, 2);
				var overSpeed:Number = speed - top;
				var redZoneRatio = overSpeed / top;
				
				if (redZoneRatio >= _maxRedZoneMultSoftCap) {
					var overRatio:Number = redZoneRatio - _maxRedZoneMultSoftCap;
					redZoneRatio = _maxRedZoneMultSoftCap + (overRatio * 0.1);
				}
				
				var redZone:Number = _redZoneDrag * redZoneRatio;
				trueDrag = _dragStat + redZone;
				//trace("Speed:", speed, "Ratio:", (overSpeed / top), "  RedZone:", _redZoneDrag);
			}
			
			//Apply air density mult
			trueDrag *= _airDensity;
			
			addDragValue(1 - trueDrag);
			
			//Quick hack to quickly fill buffer when delta too high
			var bufferDeltaCount:Number = delta;
			while (bufferDeltaCount >= 1.4) {
				addDragValue(1 - trueDrag);
				bufferDeltaCount -= 1;
			}
			
			GameMediator.updatePlayerDrag.dispatch(currentDrag);
			
			
			var expDelta:Number = 1;
			if (delta > 1) {
				expDelta = Math.pow(delta, 1.042);//Increse delta effect to fix different behaviors when sped up/down
			}else if (delta < 1) {
				expDelta = NumberUtils.interpolate(delta, 0.1, 0.04);//Increse delta effect to fix different behaviors when sped up/down
			}
			//expDelta = 1;
			
			var drag:Number = 1 - ((1 - currentDrag) * expDelta);
			
			
			//Reduce drag when going downward
			var downwardDragReductionMult:Number = 0.1;
			//trace("speedAngle:", speedAngle);
			if (speedAngle >= 0 && speedAngle <= 180) {
				var angleDiff:Number = Math.abs(speedAngle - 90);
				downwardDragReductionMult = NumberUtils.interpolate2(downwardDragReductionMult, 1, 0, 90, angleDiff, 1, true);
				drag = 1 - ((1 - drag) * downwardDragReductionMult);
				//trace("downwardDragReductionMult:", downwardDragReductionMult);
			}
			
			//trace("SimpleBody -> drag ->", drag.toFixed(4));
			applyDrag(drag);
		}
		
		protected function updateAirDensity(altitude:Number):void {
			if (altitude <= Global.spaceAltitude * 0.75) {
				_airDensity = NumberUtils.interpolate2(1, 0.9, 0, Global.spaceAltitude * 0.75, altitude, 1);
			}else if (altitude <= Global.spaceAltitude * 0.95) {
				_airDensity = NumberUtils.interpolate2(0.9, 0.8, Global.spaceAltitude * 0.75, Global.spaceAltitude * 0.95, altitude, 1);
			}else {
				_airDensity = NumberUtils.interpolate2(0.8, 0.5, Global.spaceAltitude * 0.95, Global.spaceAltitude, altitude, 1);
			}
		}
		
		protected function addDragValue(value:Number):void {
			_dragValues.push(value);
			while (_dragValues.length > DRAG_BUFFER_LENGTH) {
				_dragValues.shift();
			}
		}
		
		/* Returns a buffered drag value for smoother gameplay */
		public function get currentDrag():Number {
			if (_dragValues.length <= 0) {
				throw new Error("SimpleBody - currentDrag - _dragValues is empty");
				return (1 - _dragStat);
			}
			
			var total:Number = 0;
			for each(var i:Number in _dragValues) {
				total += i;
			}
			var average:Number = total / _dragValues.length;
			
			//trace("Average drag is:", average);
			return average;
		}
		
		
		override public function destroy():void 
		{
			visualClass = null;
			
			if (_dragValues) _dragValues.length = 0;
			_dragValues = null;
			
			if (_rainbowTrail) _rainbowTrail.destroy();
			_rainbowTrail = null;
			
			super.destroy();
		}
	}

}