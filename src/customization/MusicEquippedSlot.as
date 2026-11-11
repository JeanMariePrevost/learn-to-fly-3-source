package src.customization 
{
	import flash.display.DisplayObject;
	import lbg.utils.DisplayObjectUtil;
	import src.audio.Audio;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author 
	 */
	public class MusicEquippedSlot extends MusicSlot 
	{
		protected var _trackNumber:uint;
		protected var _checkIfSelectedFunction:Function;
		
		public function MusicEquippedSlot() 
		{
			super();
			
		}
		
		override protected function onOut(target:DisplayObject):void 
		{
			if (_preview) _preview.fadeOut();
			super.onOut(target);
		}
		
		override protected function onOver(target:DisplayObject):void 
		{
			if (isEmpty)  return;
			
			if (parent) {
				parent.addChild(this);
			}
			
			DisplayObjectUtil.setColorMatrix(this, 0, 0, 20, 0);
			
			if (_trackNumber == 3) {
				_preview = Audio.playMusic(_entry.track3, 800);
			}else if (_trackNumber == 2) {
				_preview = Audio.playMusic(_entry.track2, 800);
			}else if (_trackNumber == 1) {
				_preview = Audio.playMusic(_entry.track1, 800);
			}
		}
		
		/**
		 * Mark this slot as a shop music slot
		 * @param	track track 1,2 or 3
		 */
		public function setAsShopSlot(track:uint):void {
			_trackNumber = track;
			_checkIfSelectedFunction = checkIfCurrentShopTrack;
			txtTitle.text = _entry.title + " - " + track.toFixed();
			checkIfOwned();
		}
		
		/**
		 * Mark this slot as a bonus shop music slot
		 * @param	track track 1,2 or 3
		 */
		public function setAsBonusShopSlot(track:uint):void {
			_trackNumber = track;
			_checkIfSelectedFunction = checkIfCurrentBonusShopTrack;
			txtTitle.text = _entry.title + " - " + track.toFixed();
			checkIfOwned();
		}
		
		/**
		 * Mark this slot as a game music slot
		 * @param	track track 1,2 or 3
		 */
		public function setAsGameSlot(track:uint):void {
			_trackNumber = track;
			_checkIfSelectedFunction = checkIfCurrentGameTrack;
			txtTitle.text = _entry.title + " - " + track.toFixed();
			checkIfOwned();
		}
		
		/** checkIfOwned becomes "check if this is the track equiped" for equiped slots */
		override public function checkIfOwned():void 
		{
			if (_checkIfSelectedFunction) _checkIfSelectedFunction();
			
			if (isEmpty) {
				//trace("Slot", _entry.title, _trackNumber, "is empty");
				setEmpty();
			}
		}
		
		public function get isEmpty():Boolean {
			return (slotTrackName == "null");
		}
		
		protected function checkIfCurrentShopTrack():void {
			if (ProfileState.instance.musicShop == slotTrackName) {
				//Is selected track
				enable();
			}else {
				setLocked();
			}
		}
		
		protected function checkIfCurrentBonusShopTrack():void {
			if (ProfileState.instance.musicBonusShop == slotTrackName) {
				//Is selected track
				enable();
			}else {
				setLocked();
			}
		}
		
		protected function checkIfCurrentGameTrack():void {
			//All 3 are always selected
			enable();
		}
		
		/** Returns the string of the track linked to this slot in particular */
		public function get slotTrackName():String {
			switch(_trackNumber) {
				default:
				case 1:
					return _entry.track1AsString;
				case 2:
					return _entry.track2AsString;
				case 3:
					return _entry.track3AsString;
			}
		}
		
		override public function destroy():void {
			_checkIfSelectedFunction = null;
			super.destroy();
		}
		
	}

}