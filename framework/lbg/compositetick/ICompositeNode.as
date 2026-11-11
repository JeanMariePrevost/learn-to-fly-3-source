package lbg.compositetick 
{
	
	/**
	 * ...
	 * @author 
	 */
	public interface ICompositeNode extends ICompositeLeaf
	{
		function addSubscriber(obj:ICompositeLeaf):void
		function removeSubscriber(obj:ICompositeLeaf):void 
		//function tick(delta:Number):void
		
		//function clearSubscribers():void
		//function contains(obj:iCompositeLeaf):Boolean
	}
	
}