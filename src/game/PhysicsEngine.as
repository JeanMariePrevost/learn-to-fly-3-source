package src.game
{
	import lbg.compositetick.*;
	import lbg.utils.Trig;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.dynamics.CollisionArbiter;
	import nape.geom.Vec2;
	import nape.geom.Vec3;
	import nape.space.Space;
	import src.compound.CompoundNumber;
	import src.system.Global;
	/**
	 * ...
	 * @author 
	 */
	public class PhysicsEngine implements ICompositeNode
	{
		public static var instance:PhysicsEngine;
		
		//"__" vars will end up in Global class
		protected var _compositeNode:CompositeNode;
		protected var __gravity:Vec2 = new Vec2();
		protected var _space:Space;
		
		protected var _playerObstacleCollisionListener:InteractionListener;
		protected var _playerGroundCollisionListener:InteractionListener;
		
		public function PhysicsEngine() 
		{
			if (instance != null) {
				throw new Error("PhysicsEngine already exists");
			}
			refreshGravity();
			StatHooks.gravityMult.signalChange.add(refreshGravity);
			
			_compositeNode = new CompositeNode();
			_space = new Space(__gravity);
			instance = this;
			
			//trace("Gravity :", __gravity.y);
			
			_playerObstacleCollisionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, Global.CB_TYPE_PLAYER, Global.CB_TYPE_OBSTACLE, playerObstacleCollision);
			_space.listeners.add(_playerObstacleCollisionListener);
			
			_playerGroundCollisionListener = new InteractionListener(CbEvent.ONGOING, InteractionType.COLLISION, Global.CB_TYPE_PLAYER, Global.CB_TYPE_GROUND, playerGroundCollision);
			_space.listeners.add(_playerGroundCollisionListener);
		}
		
		protected function playerObstacleCollision(cb:InteractionCallback):void {
			GameMediator.playerImpactObstacle.dispatch(cb);
		}
		
		protected function playerGroundCollision(cb:InteractionCallback):void {
			GameMediator.playerHitsGround.dispatch(cb);
		}
		
		public function refreshGravity(cn:CompoundNumber = null):void {
			if(__gravity) __gravity.y = Global.baseGravity * StatHooks.gravityMult.value;
			if(_space) _space.gravity.y = Global.baseGravity * StatHooks.gravityMult.value;
			//trace("refreshGravity()", __gravity.y);
			//if(_space) trace("refreshGravity() (_space)", _space.gravity.y);
		}
		
		public function get space():Space 
		{
			return _space;
		}
		
		public function tick(delta:Number):void {
			var physAccuracy:Number = 12;
			for (var i:int = 0; i < physAccuracy; i++) {
				_space.step((delta * (1 / physAccuracy)) / 60);
			}
			_compositeNode.tick(delta);
		}
		
		public function addSubscriber(obj:ICompositeLeaf):void {
			_compositeNode.addSubscriber(obj);
		}
		
		public function removeSubscriber(obj:ICompositeLeaf):void {
			if(_compositeNode) _compositeNode.removeSubscriber(obj);
		}
		
		public function destroy():void {
			instance = null;
			
			_compositeNode.clearSubscribers();
			_compositeNode = null;
			__gravity = null;
			_space.clear();
			_space = null;
		}

		
		
	}

}