package src.customization 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import lbg.anticheatengine.SafeString;
	import lbg.utils.DisplayObjectUtil;
	import org.osflash.signals.Signal;
	import src.audio.Audio;
	import src.audio.FadingSoundObject;
	import src.audio.Music;
	import src.audio.MusicEntry;
	import src.gui.decorators.MouseBounce2;
	import src.gui.MessageBox;
	import src.gui.QuestionBox;
	import src.gui.ScreenBlurEffect;
	import src.Main;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class MusicSlot extends MovieClip 
	{
		public var icon:MovieClip;
		public var highlight:MovieClip;
		public var txtTitle:TextField;
		public var enablePreview:Boolean = true;
		public var signalPurchaseOver:Signal = new Signal(MusicSlot);
		
		public var bounce:MouseBounce2;
		
		protected var _entry:MusicEntry;
		
		protected var _preview:FadingSoundObject;
		
		protected var _owned:Boolean = false;
		
		public function MusicSlot() 
		{
			super();
			
			txtTitle.text = "???";
			highlight.visible = false;
			
			bounce = new MouseBounce2(this);
			bounce.scaleMod = 0.08;
			
			bounce.signalOverTarget.add(onOver)
			bounce.signalOutTarget.add(onOut)
		}
		
		protected function onOut(target:DisplayObject):void 
		{
			if (enablePreview) {
				stopAudio();
			}
			checkIfOwned();
		}
		
		public function stopAudio():void {
			if (_preview) _preview.fadeOut();
		}
		
		protected function onOver(target:DisplayObject):void 
		{
			if (parent) {
				parent.addChild(this);
			}
			//trace("Over", this);
			DisplayObjectUtil.setColorMatrix(this, 0, 0, 20, 0);
			
			if (enablePreview) {
				if (_entry.track3) {
					_preview = Audio.playMusic(_entry.track3, 800);
				}else if (_entry.track2) {
					_preview = Audio.playMusic(_entry.track2, 800);
				}else if (_entry.track1) {
					_preview = Audio.playMusic(_entry.track1, 800);
				}
			}
		}
		
		public function buyTrack():void {
			if (ProfileState.instance.bonusPoints.value >= _entry.cost) {
				var b:ScreenBlurEffect = new ScreenBlurEffect();
				b.enableBlur = false;
				b.tintMult = 0.8;
				b.zoomMult = 1;
				Main.mainLayer.addChild(b);
				var qb:QuestionBox = new QuestionBox("Buy track?", "Do you want to buy this track for\r" + _entry.cost + " BP?", buyTrack2, cancelBuy,b.deblurAndDestroy);
				Main.mainLayer.addChild(qb);
			}else {
				Main.displayMessage("Not enough Bonus Points");
				//var mb:MessageBox = new MessageBox("Not enough BP", "You need " + _entry.cost + " BP to buy this track.", null, b.deblurAndDestroy);
				//Main.mainLayer.addChild(mb);
			}
		}
		
		protected function buyTrack2():void {
			ProfileState.spendBonusPoints(_entry.cost);
			ProfileState.instance.addMusicUnlockKey(_entry.track1AsString);
			if (_preview) _preview.fadeOut();
			signalPurchaseOver.dispatch(this);
			checkIfOwned();
		}
		
		protected function cancelBuy():void {
			if (_preview) _preview.fadeOut();
			signalPurchaseOver.dispatch(this);
		}
		
		
		public function setEntry(entry:MusicEntry):void {
			if (entry == null) {
				setEmpty();
				return;
			}
			
			_entry = entry;
			
			gotoAndStop(entry.slotFrame);
			
			if (track1 == null) {
				setEmpty();
			}else {
				if (track2 == "null") {
					icon.gotoAndStop(1);
				}else if (track3 == "null") {
					icon.gotoAndStop(2);
				}else {
					icon.gotoAndStop(3);
				}
			}
			
			txtTitle.text = entry.title;
			
			checkIfOwned();
		}
		
		public function checkIfOwned():void {
			for each(var ss:SafeString in ProfileState.instance.musicBoughtKeys) {
				if (ss.value == _entry.track1AsString) {
					//trace("Player owns:", _entry.track1AsString);
					enable();
					return;
				}
			}
			
			//Not owned
			//trace("Player lacks:", _entry.track1AsString);
			setLocked();
		}
		
		/** For empty slots in sets of 3 */
		public function setEmpty():void {
			DisplayObjectUtil.setColorMatrix(this, 0, -100, -20, 0);
			icon.visible = false;
			txtTitle.text = "";
			if (bounce) bounce.enabled = false;
			_owned = false;
		}
		
		/** FOr not-purchased items */
		public function setLocked():void {
			DisplayObjectUtil.setColorMatrix(this, 0, -100, -20, 0);
			icon.visible = true;
			if(bounce) bounce.enabled = true;
			_owned = false;
		}
		
		public function enable():void {
			DisplayObjectUtil.setColorMatrix(this);
			icon.visible = true;
			if(bounce) bounce.enabled = true;
			_owned = true;
		}
		
		public function get track1():String {
			if (_entry) {
				return _entry.track1AsString;
			}else {
				return null;
			}
		}
		
		public function get track2():String {
			if (_entry) {
				return _entry.track2AsString;
			}else {
				return null;
			}
		}
		
		public function get track3():String {
			if (_entry) {
				return _entry.track3AsString;
			}else {
				return null;
			}
		}
		
		public function get owned():Boolean 
		{
			return _owned;
		}
		
		public function get entry():MusicEntry 
		{
			return _entry;
		}
		
		public function destroy():void {
			icon = null;
			highlight = null;
			txtTitle = null;
			if (signalPurchaseOver) signalPurchaseOver.removeAll();
			signalPurchaseOver = null;
			if (bounce) {
				bounce.signalOverTarget.remove(onOver)
				bounce.signalOutTarget.remove(onOut)
				bounce.destroy();
			}
			bounce = null;
			_entry = null;
			
			if (_preview) _preview.destroy();
			_preview = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
			
		}
	}

}