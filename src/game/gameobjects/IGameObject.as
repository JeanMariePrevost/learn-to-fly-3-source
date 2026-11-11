package src.game.gameobjects 
{
	import flash.display.MovieClip;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.ShapeList;
	import src.game.PhysicsEngine;
	
	/**
	 * ...
	 * @author 
	 */
	public interface IGameObject 
	{
		function createBody(shapes:ShapeList, bodyType:BodyType = null):void
		function getBody():Body		
		function getMovieClip():MovieClip		
		function setPhysicsEngine(engine:PhysicsEngine):void		
		function getPositionX():Number
		function getPositionY():Number
		function setPosition(X:Number = NaN, Y:Number = NaN):void
		function setPositionFromPoint(X:Number = NaN, Y:Number = NaN, leftToRightPosition:Number = 0.5, topToBottomPosition:Number = 0.5):void
		function get rotation():Number
		function set rotation(rad:Number):void
		function get bounds():GameObjectBounds
		
		function tick(delta:Number):void
		function applyForce(X:Number, Y:Number):void
		function applyAngleForce(force:Number, angle:Number):void
		function applyRelativeAngleForce(force:Number, angle:Number = 0, fromPosition:Vec2 = null, accountForScaleFlip:Boolean = false):void
		function applyDrag(mult:Number):void
		function applyRotation(angles:Number):void
		function applyTorque(torque:Number):void
		function destroy():void
	}
	
}