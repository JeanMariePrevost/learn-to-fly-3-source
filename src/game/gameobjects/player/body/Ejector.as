package src.game.gameobjects.player.body 
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import lbg.utils.DisplayObjectUtil;
	import src.game.GameCamera;
	import src.game.gameobjects.FallingObject;
	import src.game.gameobjects.IFallingObject;
	import src.game.gameobjects.ShapesData;
	import src.game.PhysicsEngine;
	import src.system.GameState;
	
	/**
	 * ...
	 * @author 
	 */
	public class Ejector extends SimpleBody 
	{
		public var detachedObject:IFallingObject;
		protected var _count:Number = 60;
		
		public function Ejector(gameState:GameState) 
		{
			super(gameState);
			
			createBody(ShapesData.getShapeListOf(item.statSpecialIds));//Different shapes for each upgrade
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (!enableTicking) return;
			
			if (isOutOfStages() && detachedObject == null) {
				if (_count > 0) {
					_count-= delta;
				}else {
					//Seat and player separates
					//Seat becomes falling object
					//Player is launched away
					var seat:MovieClip = createFallingSeat();
					_movieClip.parent.addChild(seat);
					detachedObject = FallingObject.getNewFallingObject(seat);
					detachedObject.useObjectPosition(_movieClip);
					GameCamera.instance.addChildToMovingLayer(detachedObject.getMovieClip());
					detachedObject.mimicBodyMomentum(_body, 0.5);
					detachedObject.setPhysicsEngine(PhysicsEngine.instance);
					
					//leftWrapper.gotoLabel("deathStart");
					//rightWrapper.gotoLabel("deathStart");
					//leftWrapper.destroy();
					//rightWrapper.destroy();
					//DisplayObjectUtil.changeContainer(leftVisual, GameCamera.instance.getMovingLayer(1));
					//DisplayObjectUtil.changeContainer(rightVisual, GameCamera.instance.getMovingLayer(1));
					//_detachedObject1 = FallingObject.getNewFallingObject(leftVisual);
					//_detachedObject2 = FallingObject.getNewFallingObject(rightVisual);
					//_detachedObject1.mimicBodyMomentum(_player.getBody(), 0.6);
					//_detachedObject2.mimicBodyMomentum(_player.getBody(), 0.6);
					//_detachedObject1.setPhysicsEngine(PhysicsEngine.instance);
					//_detachedObject2.setPhysicsEngine(PhysicsEngine.instance);
					//
					////Small rotation jitter
					//_detachedObject1.applyRotation(NumberUtils.randomBoth(1));
					//_detachedObject2.applyRotation(NumberUtils.randomBoth(1));
					
					updateBodyMass();
					applyThrust(item.statPower);
					
					for (var i:int = 0; i < _movieClip.numChildren; i++) {
						if (_movieClip.getChildAt(i) is EjectorSeatEmpty1 || _movieClip.getChildAt(i) is EjectorSeatEmpty2 || _movieClip.getChildAt(i) is EjectorSeatEmpty3) {
							_movieClip.removeChildAt(i);
						}
					}
					
					createBody(ShapesData.getShapeListOf("emptyBody"));
				}
			}
		}
		
		override protected function getBodyMass():Number 
		{
			if (detachedObject == null) {
				return super.getBodyMass();
			}else {
				return 3;//Empty body weight
			}
		}
		
		protected function createFallingSeat():MovieClip {
			return new EjectorSeatEmpty1();
		}
		
		override protected function getVisual():BodyVisual 
		{
			return new EjectorVisual();
		}
		
	}

}