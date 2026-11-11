package src.game
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import lbg.utils.NumberUtils;
	import src.system.Global;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameLayer extends Sprite 
	{
		
		public function GameLayer(displayObject:DisplayObjectContainer) 
		{
			displayObject.addChild(this);
		}
		
		public function setScale(scale:Number):void {
			if (scale < Global.minimumScale) scale = Global.minimumScale;
			scaleX = scaleY = scale;
			x = 0 + ((stage.stageWidth / 2) * (1 - scale));
			y = 0 + ((stage.stageHeight / 2) * (1 - scale));
		}
		
	}

}