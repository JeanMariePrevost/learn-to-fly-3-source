package src.steamapi 
{
	/**
	 * ...
	 * @author 
	 */
	public class SteamTransaction 
	{
		private var _orderID:String;
		private var _itemID:String;
		private var _transactionID:String;
		
		public function SteamTransaction(orderID:String = null, itemID:String = null, transactionID:String = null) 
		{
			if(orderID) _orderID = orderID;
			if(itemID) _itemID = itemID;
			if( transactionID) _transactionID = transactionID;
		}
		
		public function get orderID():String 
		{
			return _orderID;
		}
		
		public function get itemID():String 
		{
			return _itemID;
		}
		
		public function get transactionID():String 
		{
			return _transactionID;
		}
		
	}

}