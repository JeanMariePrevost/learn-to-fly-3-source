package src.game.gameobjects.player.boost 
{
	import flash.display.MovieClip;
	import src.game.DeltaMovieClipWrapper;
	import src.game.gameobjects.player.IGearWithMass;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class Brick extends AbstractBoost implements IGearWithMass 
	{
		//public var centerVisual:MovieClip;
		public var leftVisual:MovieClip;
		public var rightVisual:MovieClip;
		
		//public var centralWrapper:DeltaMovieClipWrapper;
		public var leftWrapper:DeltaMovieClipWrapper;
		public var rightWrapper:DeltaMovieClipWrapper;
		
		public function Brick(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			setupVisual();
		}
		
		protected function setupVisual():void {
			leftVisual = new _item.statVisualClass();
			leftWrapper = new DeltaMovieClipWrapper(leftVisual);
			//_player.getMovieClip().addChildAt(leftVisual, 0);//Add child BEHIND body
			_player.getMovieClip().addChild(leftVisual);//Add child IN FRONT OF body

			rightVisual = new _item.statVisualClass();
			rightVisual.scaleY = -1;//Flip around
			rightWrapper = new DeltaMovieClipWrapper(rightVisual);
			//_player.getMovieClip().addChildAt(rightVisual, 0);//Add child BEHIND body
			_player.getMovieClip().addChild(rightVisual);//Add child IN FRONT OF body
		}
		
		override public function setAnchor(leftX:Number, rightX:Number, leftRotation:Number, rightRotation:Number, Y:Number):void {
			if (leftVisual) {
				leftVisual.x = leftX;
				leftVisual.y = Y;
				leftVisual.rotation = leftRotation;
			}
			
			if (rightVisual) {
				rightVisual.x = rightX;
				rightVisual.y = Y;
				rightVisual.rotation = rightRotation;
			}
		}
		
		override public function tick(delta:Number):void 
		{
			
		}
		
		/* INTERFACE src.game.gameobjects.player.IGearWithMass */
		
		public function isOutOfFuel():Boolean 
		{
			return true;
		}
		
		public function get weight():Number 
		{
			return _item.statWeight;
		}
		
		
		override public function get preventDayEnd():Boolean 
		{
			return false;
		}
		
		override public function destroy():void 
		{
			leftVisual = null;
			rightVisual = null;
			
			if(leftWrapper) leftWrapper.destroy();
			leftWrapper = null;
			if(rightWrapper) rightWrapper.destroy();
			rightWrapper = null;
			
			super.destroy();
		}
	}

}