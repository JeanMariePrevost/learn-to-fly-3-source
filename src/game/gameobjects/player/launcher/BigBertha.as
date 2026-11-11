package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import sound.Explode7;
	import src.UiScaler;
	import src.audio.Audio;
	import src.game.GameCamera;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.game.GameToolTip;
	import src.ItemIcon;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class BigBertha extends TiltCannon 
	{
		protected var _bubbles:MovieClip;
		
		public function BigBertha(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			
			
			_bubbles = new item.statVisualClass();
			_bubbles.stop();
			GameCamera.instance.addChildToFixedLayer(_bubbles, 5);
			UiScaler.addAbsolute(_bubbles, false, 360);
			
			GameToolTip.show("bigBertha");
			
			_wickLoop.destroy();
		}
		
		override protected function playSoundEffect():void 
		{
			Audio.playSound(Explode7);
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (_bubbles) {
				_bubbles.gotoAndStop(currentFrame);
				if (_cannonWrapper.currentLabel == "specialEnd") {
					_bubbles.parent.removeChild(_bubbles);
					_bubbles = null;
				}
			}
			
		}
		
	}

}