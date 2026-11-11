package src.game.gameobjects 
{
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	import nape.shape.ShapeList;
	import src.game.PhysicsEngine;
	import flash.display.MovieClip;
	import nape.phys.Body;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author 
	 */
	public class NullFallingObject implements IFallingObject 
	{
		protected var _visual:MovieClip;
		protected var _body:Body;
		
		public function NullFallingObject(visual:MovieClip, bodyType:BodyType=null) 
		{
			_visual = visual;
			_body = new Body();
			
			if (visual.stage) visual.parent.removeChild(visual);
		}
		
		/* INTERFACE src.game.gameobjects.IFallingObject */
		
		public function useObjectPosition(obj:DisplayObject):void 
		{
			
		}
		
		public function mimicBodyMomentum(body:Body, mult:Number = 1, gravityMassMult:Number = 1):void 
		{
			
		}
		
		public function createBody(shapes:ShapeList, bodyType:BodyType = null):void 
		{
			
		}
		
		public function getBody():Body 
		{
			return _body;
		}
		
		public function getMovieClip():MovieClip 
		{
			return _visual;
		}
		
		public function setPhysicsEngine(engine:PhysicsEngine):void 
		{
			
		}
		
		public function getPositionX():Number 
		{
			return 0;
		}
		
		public function getPositionY():Number 
		{
			return 0;
		}
		
		public function setPosition(X:Number = NaN, Y:Number = NaN):void 
		{
			
		}
		
		public function setPositionFromPoint(X:Number = NaN, Y:Number = NaN, leftToRightPosition:Number = 0.5, topToBottomPosition:Number = 0.5):void 
		{
			
		}
		
		public function get rotation():Number 
		{
			return 0;
		}
		
		public function set rotation(value:Number):void 
		{
			
		}
		
		public function get bounds():GameObjectBounds 
		{
			return null;
		}
		
		public function tick(delta:Number):void 
		{
			
		}
		
		public function applyForce(X:Number, Y:Number):void 
		{
			
		}
		
		public function applyAngleForce(force:Number, angle:Number):void 
		{
			
		}
		
		public function applyRelativeAngleForce(force:Number, angle:Number = 0, fromPosition:Vec2 = null, accountForScaleFlip:Boolean = false):void 
		{
			
		}
		
		public function applyDrag(mult:Number):void 
		{
			
		}
		
		public function applyRotation(angles:Number):void 
		{
			
		}
		
		public function applyTorque(torque:Number):void 
		{
			
		}
		
		public function destroy():void 
		{
			while (_visual.numChildren >= 1) _visual.removeChildAt(0);
			_visual = null;
			_body = null;
		}
		
	}

}