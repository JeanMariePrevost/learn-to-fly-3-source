package src.game.gameobjects.environment 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import lbg.compositetick.ICompositeLeaf;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import src.game.GameEngine;
	import src.game.GameMediator;
	import src.game.PhysicsEngine;
	
	/**
	 * ...
	 * @author 
	 */
	public class Ground extends Sprite
	{
		protected const NODES_COUNT:uint = 5;
		protected const CENTER_NODE:uint = 2;//Counting from index 0, so -1 what you'd normally think
		protected const NODE_WIDTH:uint = 2000;
		
		protected var _nodes:Vector.<GroundNode> = new Vector.<GroundNode>();
		
		public function Ground(physicsEngine:PhysicsEngine) 
		{
			for (var i:int = 0; i < NODES_COUNT; i++) {
				var newNode:GroundNode = new GroundNode(physicsEngine);
				_nodes.push(newNode);
				addChild(newNode.getMovieClip());
			}
			
			positionNodes();
			
			GameMediator.updatePlayerPosition.add(onPlayerPosition);
		}
		
		protected function onPlayerPosition(playerX:Number, playerY:Number):void {
			
			for (var i:int = 0; i <= 5; i++) {
				checkNodes(playerX);
				
				var maxRight:Number = Number.MIN_VALUE;
				var maxLeft:Number = Number.MAX_VALUE;
				
				for each(var n:GroundNode in _nodes) {
					if (n.bounds.right > maxRight) maxRight = n.bounds.right;
					if (n.bounds.left < maxLeft) maxLeft = n.bounds.right;
				}
				
				if (playerX >= maxLeft || playerX <= maxRight) {
					break;
				}
			}
			
			if (i >= 2) {
				Log.log("checkNodes() took", (i + 1), "passes because of lag and speed");
			}
			
			GameMediator.updatePlayerAltitude.dispatch(-(playerY - groundLevel));
		}
		
		/** Returns tru if player ended up above the center node */
		protected function checkNodes(playerX:Number, recursiveCheck:int = 0):Boolean {
			if (recursiveCheck >= NODES_COUNT) {
				//Log.log("Ground.checkNodes() ERROR - went through every node and still adjusting, recursion went mad!");
				return false;
			}
			
			var currentNode:Number = -1;
			for (var i:int = 0; i < _nodes.length; i++) {
				if (playerX <= _nodes[i].bounds.right) {
					//Player is above this node
					currentNode = i;
					break;
				}
			}
			
			var nodeOffset:Number = currentNode - CENTER_NODE;
			
			if (nodeOffset == 0) {
				//No changes
				return true;
			}else {
				offsetNodes(nodeOffset);
				checkNodes(playerX, recursiveCheck + 1);
			}
			
			return false;
		}
		
		protected function offsetNodes(byValue:int):void {
			if (byValue > 0) {
				//Player moved right
				_nodes.push(_nodes.shift());
			}else if (byValue < 0) {
				//Player moved left
				_nodes.unshift(_nodes.pop());
			}
			
			positionNodes();
		}
		
		protected function positionNodes():void {
			for (var i:int = 0; i < _nodes.length; i++) {
				_nodes[i].setPosition(_nodes[CENTER_NODE].getPositionX() + ((i - CENTER_NODE) * NODE_WIDTH));
			}
		}
		
		public function get groundLevel():Number {
			return _nodes[CENTER_NODE].bounds.top;
		}
		
		public function set groundLevel(value:Number):void {
			for each(var i:GroundNode in _nodes) {
				i.setPositionFromPoint(i.bounds.centerX, value, 0.5, 0);
			}
		}
		
		public function destroy():void {
			GameMediator.updatePlayerPosition.remove(onPlayerPosition);
			
			if (_nodes) {
				for each(var n:GroundNode in _nodes) n.destroy();
				_nodes.length = 0;
			}
			_nodes = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}