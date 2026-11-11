package src.game.particles 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import nape.phys.BodyType;
	import src.game.GameCamera;
	import src.game.gameobjects.FallingObject;
	import src.game.gameobjects.IFallingObject;
	import src.game.PhysicsEngine;
	
	/**
	 * ...
	 * @author 
	 */
	public class SnowDebris extends MovieClip 
	{
		public var gameObject:IFallingObject;
		
		public function SnowDebris(scale:Number = 1) 
		{
			scaleX = scaleY = scale;
			rotation = Math.random() * 360;
			gotoAndStop(Math.ceil(Math.random() * totalFrames));
			GameCamera.instance.addChildToMovingLayer(this, 0);
			gameObject = FallingObject.getNewFallingObject(this);
			gameObject.setPhysicsEngine(PhysicsEngine.instance);
		}
		
	}

}