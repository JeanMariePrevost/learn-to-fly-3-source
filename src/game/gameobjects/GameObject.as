package src.game.gameobjects 
{
	import adobe.utils.CustomActions;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import lbg.compositetick.CompositeNode;
	import lbg.compositetick.ICompositeLeaf;
	import lbg.compositetick.ICompositeNode;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import nape.shape.ShapeList;
	import nape.space.Space;
	import src.game.PhysicsEngine;
	import src.system.Global;
	/**
	 * A GameObject is an object which holds a movieclip linked to a Nape Body
	 * On each tick, the movieclip is visually adjusted to the Nape Body
	 * @author 
	 */
	public class GameObject implements ICompositeNode, IGameObject
	{
		protected var _compositeNode:CompositeNode;
		protected var _body:Body;
		protected var _movieClip:MovieClip;
		protected var _objectBounds:GameObjectBounds;
		protected var _engine:PhysicsEngine;
		
		public function GameObject(shapes:ShapeList, visual:MovieClip, bodyType:BodyType = null) 
		{
			_compositeNode = new CompositeNode();
			
			createBody(shapes, bodyType);
			
			_objectBounds = new GameObjectBounds(this);
			_movieClip = visual;
			
		}
		
		public function createBody(shapes:ShapeList, bodyType:BodyType = null):void {
			if (bodyType == null) bodyType = BodyType.DYNAMIC;
			
			if (_body == null) {
				_body = new Body(bodyType);
				_body.shapes.merge(shapes);
				_body.align();
			}else {
				//Change shapes, disregard bodytype
				_body.shapes.clear();
				_body.shapes.merge(shapes);
				_body.align();
			}
		}
		
		public static function createWithDefaultRectShape(visual:MovieClip, sizeMult:Number = 1, bodyType:BodyType = null):GameObject {
			var shapeList:ShapeList = getDefaultRectShapeList(visual, sizeMult);
			return new GameObject(shapeList, visual, bodyType);
			
		}
		
		public static function getDefaultRectShapeList(visual:MovieClip, sizeMult:Number = 1):ShapeList {
			DisplayObjectUtil.centerRegistrationPoint(visual,true,true);
			
			var rect:Rectangle = visual.getRect(visual);
			
			var inflateMult:Number = (sizeMult - 1) / 2;
			rect.inflate(rect.width * inflateMult, rect.height * inflateMult);
			
			var shape:Shape =  new Polygon(Polygon.box(rect.width, rect.height));
			var shapeList:ShapeList = new ShapeList();
			shapeList.push(shape);
			
			return shapeList;
		}
		
		public function tick(delta:Number):void {
			updateVisual();
			_compositeNode.tick(delta);
		}
		
		protected function updateVisual():void {
			_movieClip.x = _body.position.x;
			_movieClip.y = _body.position.y;
			_movieClip.rotation = Trig.toDegrees(_body.rotation);
		}
		
		public function addSubscriber(obj:ICompositeLeaf):void {
			_compositeNode.addSubscriber(obj);
		}
		
		public function removeSubscriber(obj:ICompositeLeaf):void {
			_compositeNode.removeSubscriber(obj);
		}

		public function getBody():Body {
			return _body;
		}
		
		public function getMovieClip():MovieClip {
			return _movieClip;
		}
		
		public function setPhysicsEngine(engine:PhysicsEngine):void {
			_body.space = engine.space;
			engine.addSubscriber(this);
			_engine = engine;
		}
		
		public function getPositionX():Number {
			return _body.position.x;
		}
		
		public function getPositionY():Number {
			return _body.position.y;
		}
		
		public function setPosition(X:Number = NaN, Y:Number = NaN):void {
			if (isNaN(X)) X = _body.position.x;
			if (isNaN(Y)) Y = _body.position.y;
			_body.position = new Vec2(X, Y);
			updateVisual();
		}
		
		/**
		 * Move move object custom registration point (e.g. move "bottom" (0.5 leftToRight, 1 topToBottom) of object to (X,Y))
		 */
		public function setPositionFromPoint(X:Number = NaN, Y:Number = NaN, leftToRightPosition:Number = 0.5, topToBottomPosition:Number = 0.5):void {
			if (isNaN(X)) X = _body.position.x;
			if (isNaN(Y)) Y = _body.position.y;
			_objectBounds.setPositionFromAnchor(X, Y, leftToRightPosition, topToBottomPosition);
		}		
		
		public function applyForce(X:Number, Y:Number):void {
			_body.applyImpulse(new Vec2(X, Y));
		}
		
		public function applyAngleForce(force:Number, angle:Number):void {
			var vx:Number = Trig.vectorX(force, angle);
			var vy:Number = Trig.vectorY(force, angle);
			_body.applyImpulse(new Vec2(vx, vy));
		}
		
		/**
		 * Applies force at angle relative to body own rotation, so 0 = ahead
		 * @param	force
		 * @param	angle In degrees
		 * @param	accountForScaleFlip If true, rotation reversed by scaleX/scaleY will be accounted for
		 */
		public function applyRelativeAngleForce(force:Number, angle:Number = 0, fromPosition:Vec2 = null, accountForScaleFlip:Boolean = false):void {
			//trace("applyRelativeAngleForce:", force, angle);
			var thisRotation:Number = Trig.toDegrees(rotation);
			if (accountForScaleFlip) {
				if ((_movieClip.scaleX < 0 && _movieClip.scaleY >= 0) || (_movieClip.scaleX >= 0 && _movieClip.scaleY < 0)) {
					if (thisRotation < 0) {
						thisRotation = 180 + thisRotation;
					}else if (thisRotation > 0) {
						thisRotation = -180 + thisRotation;
					}else {
						//nothing, 0 = 0
					}
				}
			}
			
			var relAngle:Number = thisRotation + angle - 90;
			var vx:Number = Trig.vectorX(force, relAngle);
			var vy:Number = Trig.vectorY(force, relAngle);
			
			var adjustedPosition:Vec2;
			
			//Fix for loss of control at VERY high speeds
			//var vel:Number = Math.abs(_body.velocity.x) + Math.abs(_body.velocity.y);
			//var highSpeedOffset:Number = NumberUtils.interpolate2(0, -0.02, 18000, 80000, vel, 1);
			//var highSpeedAngleDragMult:Number = NumberUtils.interpolate2(0, 1, 18000, 80000, vel, 0.5);
			//var highSpeedAngleDrag:Number = highSpeedAngleDragMult * NumberUtils.interpolate2(1, 0.01, 0.1, 2, Math.abs(_body.angularVel), 0.5);
			//trace("Force on mass:", force/getBody().mass);
			//trace("vx:", vx, "vy:", vy);
			//trace("GameObject velocity:", vel.toFixed(1), "highSpeedOffset:", highSpeedOffset);
			
			
			var offsetMult:Number = Global.thrustOffsetMult;
			if (fromPosition != null && offsetMult != 0) {
				//fromPosition.x = fromPosition.x + Trig.vectorX(highSpeedOffset, relAngle);
				//fromPosition.y = fromPosition.y + Trig.vectorY(highSpeedOffset, relAngle);
				//fromPosition.y -= highSpeedOffset;
				
				
				
				adjustedPosition = Vec2.weak();
				//adjustedPosition.x = ((fromPosition.x + Trig.vectorX(highSpeedOffset, relAngle)) * offsetMult) + _body.position.x;
				//adjustedPosition.y = ((fromPosition.y  + Trig.vectorY(highSpeedOffset, relAngle)) * offsetMult) + _body.position.y;
				adjustedPosition.x = (fromPosition.x * offsetMult) + _body.position.x;
				adjustedPosition.y = (fromPosition.y * offsetMult) + _body.position.y;
			}
			
			//trace("_body.angularVel", _body.angularVel.toFixed(3), "highSpeedAngleDrag", highSpeedAngleDrag.toFixed(3));
			//trace("relAngle:", relAngle.toFixed(1), "adjustedPosition.y", adjustedPosition.y.toFixed(2), "highSpeedOffset:", highSpeedOffset.toFixed(3));
			_body.applyImpulse(new Vec2(vx, vy), adjustedPosition);
			//_body.angularVel *= highSpeedAngleDrag;
		}
		
		public function applyDrag(mult:Number):void {
			_body.velocity = _body.velocity.mul(mult);
		}
		
		/** Applies a rotation in angle regardless of mass/size of object	 */
		public function applyRotation(angle:Number):void {
			_body.angularVel += angle;
		}
		
		/** Applies a rotation force subject to elements like mass/size of object */
		public function applyTorque(torque:Number):void {
			_body.applyAngularImpulse(torque);
		}
		
		/** NAPE Body rotation, in rads */
		public function get rotation():Number {
			return _body.rotation;
		}
		
		public function set rotation(rad:Number):void {
			_body.rotation = rad;
			//return _body.rotation;
		}
		
		public function get bounds():GameObjectBounds {
			return _objectBounds;
		}
		
		public function destroy():void {
			if(_compositeNode) _compositeNode.destroy();
			_compositeNode = null;
			if (_body) {
				_body.space = null;
				if (_body.shapes) _body.shapes.clear();
			}
			_body = null;
			if (_movieClip) DisplayObjectUtil.removeAllChildFrom(_movieClip, true);
			_movieClip = null;
			if(_objectBounds) _objectBounds.destroy();
			_objectBounds = null;
			if (_engine) _engine.removeSubscriber(this);
			_engine = null;
		}

	}

}