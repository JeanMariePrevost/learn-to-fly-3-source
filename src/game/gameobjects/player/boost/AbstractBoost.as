package src.game.gameobjects.player.boost 
{
	import flash.geom.Point;
	import src.audio.Audio;
	import src.audio.ISound;
	import src.game.gameobjects.player.body.SimpleBody;
	import src.game.gameobjects.player.IPlayerGear;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	import src.system.Input;
	/**
	 * ...
	 * @author 
	 */
	public class AbstractBoost implements IPlayerGear 
	{
		public var boostIndex:Number = -1;//Set by the BoostController, used to trigger boosts one at a time with special commands
		
		protected var _item:GameStateItem;
		protected var _player:Player;
		
		protected var  _preventDayEnd:Boolean = false;//When set to true by the object, day end will be delayed (e.g. boost being used)
		
		protected var _sound:ISound;
		
		public function AbstractBoost(player:Player, item:GameStateItem) 
		{
			_item = item;
			_player = player;
		}
		
		
		public function setAnchor(leftX:Number, rightX:Number, leftRotation:Number, rightRotation:Number, Y:Number):void {
			
		}
		
		
		public function get preventDayEnd():Boolean 
		{
			return _preventDayEnd;
		}
		
		public function get singleBoostInputIsDown():Boolean {
			var isDown:Boolean = false;
			
			switch(boostIndex) {
				case 0:
					isDown = Input.boost1.isDown;
					break;
				case 1:
					isDown = Input.boost2.isDown;
					break;
				case 2:
					isDown = Input.boost3.isDown;
					break;
				case 3:
					isDown = Input.boost4.isDown;
					break;
				default:
					isDown = false;
					break;
			}
			
			//trace("boostIndex", boostIndex, isDown);
			
			return isDown;
		}
		
		/** Plays the stage sound if not already playing */
		protected function playSound(fadeInDuration:Number = NaN):void {
			//trace("playSound");
			if (_item == null) return;
			
			if (isNaN(fadeInDuration)) fadeInDuration = 300;
			
			if (_sound == null && _item.statSound1 != null) {
				//trace("New sound created!");
				_sound = Audio.playFadingSoundLoop(_item.statSound1, this, fadeInDuration);
				_sound.volume = _item.statSound1Volume;
			}
		}
		
		protected function stopSound(fadeOutDuration:Number = NaN):void {
			//trace("stopSound");
			if (_sound) {
				if (isNaN(fadeOutDuration)) fadeOutDuration = 300;
				//trace("Sound fading out!");
				_sound.fadeOut(fadeOutDuration);
				_sound = null;
			}
		}
		
		/* INTERFACE src.game.gameobjects.player.IPlayerGear */
		
		public function tick(delta:Number):void 
		{
			
		}
		
		/* INTERFACE src.game.gameobjects.player.IPlayerGear */
		
		public function get item():GameStateItem 
		{
			return _item;
		}
		
		public function destroy():void {
			_item = null;
			_player = null;
		}
		
		
	}

}