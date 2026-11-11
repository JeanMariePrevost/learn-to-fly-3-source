package lbg.compositetick {
	import lbg.utils.Tools;
	import lbg.utils.VectorUtils;


	public class CompositeNode implements ICompositeNode{
		protected var _subscribers:Vector.<ICompositeLeaf>;//Stores this node's child
		
		public function CompositeNode() {
			clearSubscribers();
		}
		
		/**
		 * Add an node/leaf to the list of sbscribers who receive ticks
		 */
		public function addSubscriber(obj:ICompositeLeaf):void {
			if (_subscribers.indexOf(obj) >= 0) { return }; //
			_subscribers.push(obj);
		}
		
		/**
		 * Removes specified node/leaf from tick subscriber
		 */
		public function removeSubscriber(obj:ICompositeLeaf):void {
			VectorUtils.removeFromVector(_subscribers, obj);
		}
		
		/**
		 * Empties and start a new vector of subscribers
		 */
		public function clearSubscribers():void {
			_subscribers = new Vector.<ICompositeLeaf>();
		}
		
		public function contains(obj:ICompositeLeaf):Boolean {
			if (_subscribers.indexOf(obj) >= 0) {
				return true;
			}else {
				return false;
			}
		}
		
		/**
		 * Sends tick to all of this node's subscribers
		 * @param	delta 
		 */
		public function tick(delta:Number):void {
			for each(var i:ICompositeLeaf in subscribers) { i.tick(delta) };
		}
		
		public function destroy():void {
			clearSubscribers();
			_subscribers = null;
		}
		
		public function get subscribers():Vector.<ICompositeLeaf> 
		{
			return _subscribers;
		}
		
		
	}
}