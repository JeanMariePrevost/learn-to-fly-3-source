package src.game.gameobjects.player.body 
{
	import flash.display.MovieClip;
	import lbg.utils.DisplayObjectUtil;
	import src.game.GameCamera;
	import src.game.GameMediator;
	import src.game.gameobjects.FallingObject;
	import src.game.gameobjects.IFallingObject;
	import src.game.PhysicsEngine;
	import src.reg.Registry;
	import src.system.GameState;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class EscapePod extends SimpleBody 
	{
		public var flap1:IFallingObject;
		public var flap2:IFallingObject;
		protected var _count:Number = 60;
		protected var _flapSeparationForce:Number = 1500;
		
		public function EscapePod(gameState:GameState) 
		{
			super(gameState);
			
		}
		
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (!enableTicking) return;
			
			if (isOutOfStages() && flap1 == null) {
				if (_count > 0) {
					_count-= delta;
				}else {
					//Flaps separate and fall off
					//Player is launched away
					var visual:EscapePodVisual = (_movieClip as EscapePodVisual);
					
					//visual.removeChild(visual.leftFlap);
					//visual.removeChild(visual.rightFlap);
					
					DisplayObjectUtil.changeContainer(visual.leftFlap, GameCamera.instance.getMovingLayer(1));
					DisplayObjectUtil.changeContainer(visual.rightFlap, GameCamera.instance.getMovingLayer(1));
					
					flap1 = FallingObject.getNewFallingObject(visual.leftFlap);
					flap2 = FallingObject.getNewFallingObject(visual.rightFlap);
					//flap1.useObjectPosition(_movieClip);
					//flap2.useObjectPosition(_movieClip);
					//GameCamera.instance.addChildToMovingLayer(flap1.getMovieClip());
					//GameCamera.instance.addChildToMovingLayer(flap2.getMovieClip());
					flap1.setPhysicsEngine(PhysicsEngine.instance);
					flap2.setPhysicsEngine(PhysicsEngine.instance);
					flap1.mimicBodyMomentum(_body, 0.5);
					flap2.mimicBodyMomentum(_body, 0.5);
					flap1.applyRelativeAngleForce(_flapSeparationForce, -60);
					flap2.applyRelativeAngleForce(_flapSeparationForce, 60);
					flap1.applyRotation(-2 -(Math.random() * 5));
					flap2.applyRotation(2 + (Math.random() * 5));
					
					GameMediator.addStageAtRuntime.dispatch(GameStateItem.createFrom("escapePodStage", item.level));
				}
			}
		}
		
		
		override protected function getVisual():BodyVisual 
		{
			return new EscapePodVisual();
		}
		
	}

}