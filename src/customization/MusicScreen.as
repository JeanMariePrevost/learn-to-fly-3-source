package src.customization 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.MusicList;
	import src.gui.decorators.MouseBounce2;
	import src.gui.QuestionBox;
	import src.gui.Transition;
	import src.Main;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class MusicScreen extends MovieClip 
	{
		protected static var _instance:MusicScreen;
		
		public var txtTitle:TextField;
		public var txtShop:TextField;
		public var txtBonusShop:TextField;
		public var txtFlight:TextField;
		public var txtTracks:TextField;
		
		public var slotCurrentShop1:MusicEquippedSlot;
		public var slotCurrentShop2:MusicEquippedSlot;
		public var slotCurrentShop3:MusicEquippedSlot;
		
		public var slotCurrentBonus1:MusicEquippedSlot;
		public var slotCurrentBonus2:MusicEquippedSlot;
		public var slotCurrentBonus3:MusicEquippedSlot;
		
		public var slotCurrentGame1:MusicEquippedSlot;
		public var slotCurrentGame2:MusicEquippedSlot;
		public var slotCurrentGame3:MusicEquippedSlot;
		
		public var slotShop1:MusicSlot;
		public var slotShop2:MusicSlot;
		public var slotShop3:MusicSlot;
		public var slotShop4:MusicSlot;
		public var slotShop5:MusicSlot;
		public var slotShop6:MusicSlot;
		
		public var slotBonus1:MusicSlot;
		public var slotBonus2:MusicSlot;
		public var slotBonus3:MusicSlot;
		
		public var slotMain:MusicSlot;
		public var slotRock:MusicSlot;
		public var slotHardWork:MusicSlot;
		public var slotSpace:MusicSlot;
		public var slotElectro:MusicSlot;
		public var slotSurf:MusicSlot;
		public var slotChill:MusicSlot;
		public var slotHyped:MusicSlot;
		public var slotLight:MusicSlot;
		public var slotRetro:MusicSlot;
		public var slotBeat:MusicSlot;
		public var slotEpic:MusicSlot;
		
		public var bg:MovieClip;
		public var txtBp:TextField;
		public var txtBpCost:TextField;
		
		public var btnOk:SimpleButton;
		public var btnCancel:SimpleButton;
		
		protected var _okBounce:MouseBounce2;
		protected var _cancelBounce:MouseBounce2;
		
		protected var _equipSlots:Vector.<MusicEquippedSlot> = new Vector.<MusicEquippedSlot>();
		protected var _buySlots:Vector.<MusicSlot> = new Vector.<MusicSlot>();
		
		protected var _selectedTrack:MusicSlot;
		protected var _selectedSlot:MusicEquippedSlot;
		protected var _trackShowingPrice:MusicSlot;
		
		protected var _initialMusicShop:String;
		protected var _initialMusicBonus:String;
		protected var _initialMusicGame1:String;
		protected var _initialMusicGame2:String;
		protected var _initialMusicGame3:String;
		
		public function MusicScreen(singleton:Enforcer) 
		{
			//Save current settings
			
			_initialMusicShop = ProfileState.instance.musicShop;
			_initialMusicBonus = ProfileState.instance.musicBonusShop;
			_initialMusicGame1 = ProfileState.instance.musicGame1;
			_initialMusicGame2 = ProfileState.instance.musicGame2;
			_initialMusicGame3 = ProfileState.instance.musicGame3;
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			Main.instance.sysButtonsHide();
			
			updateBp();
			
			_equipSlots.push(slotCurrentShop1);
			_equipSlots.push(slotCurrentShop2);
			_equipSlots.push(slotCurrentShop3);
			_equipSlots.push(slotCurrentBonus1);
			_equipSlots.push(slotCurrentBonus2);
			_equipSlots.push(slotCurrentBonus3);
			_equipSlots.push(slotCurrentGame1);
			_equipSlots.push(slotCurrentGame2);
			_equipSlots.push(slotCurrentGame3);
			
			_buySlots.push(slotShop1);
			_buySlots.push(slotShop2);
			_buySlots.push(slotShop3);
			_buySlots.push(slotShop4);
			_buySlots.push(slotShop5);
			_buySlots.push(slotShop6);
			_buySlots.push(slotBonus1);
			_buySlots.push(slotBonus2);
			_buySlots.push(slotBonus3);
			_buySlots.push(slotMain);
			_buySlots.push(slotRock);
			_buySlots.push(slotHardWork);
			_buySlots.push(slotSpace);
			_buySlots.push(slotElectro);
			_buySlots.push(slotSurf);
			_buySlots.push(slotChill);
			_buySlots.push(slotHyped);
			_buySlots.push(slotLight);
			_buySlots.push(slotRetro);
			_buySlots.push(slotBeat);
			_buySlots.push(slotEpic);
			
			slotCurrentShop1.setEntry(MusicList.getEntry(ProfileState.instance.musicShop));
			slotCurrentShop2.setEntry(MusicList.getEntry(ProfileState.instance.musicShop));
			slotCurrentShop3.setEntry(MusicList.getEntry(ProfileState.instance.musicShop));
			
			slotCurrentBonus1.setEntry(MusicList.getEntry(ProfileState.instance.musicBonusShop));
			slotCurrentBonus2.setEntry(MusicList.getEntry(ProfileState.instance.musicBonusShop));
			slotCurrentBonus3.setEntry(MusicList.getEntry(ProfileState.instance.musicBonusShop));
			
			slotCurrentGame1.setEntry(MusicList.getEntry(ProfileState.instance.musicGame1));
			slotCurrentGame2.setEntry(MusicList.getEntry(ProfileState.instance.musicGame1));
			slotCurrentGame3.setEntry(MusicList.getEntry(ProfileState.instance.musicGame1));
			
			slotCurrentShop1.setAsShopSlot(1);
			slotCurrentShop2.setAsShopSlot(2);
			slotCurrentShop3.setAsShopSlot(3);
			
			slotCurrentBonus1.setAsBonusShopSlot(1);
			slotCurrentBonus2.setAsBonusShopSlot(2);
			slotCurrentBonus3.setAsBonusShopSlot(3);
			
			slotCurrentGame1.setAsGameSlot(1);
			slotCurrentGame2.setAsGameSlot(2);
			slotCurrentGame3.setAsGameSlot(3);
			
			slotShop1.setEntry(MusicList.getEntry("MusicShop1"));
			slotShop2.setEntry(MusicList.getEntry("MusicShop2"));
			slotShop3.setEntry(MusicList.getEntry("MusicShop3"));
			slotShop4.setEntry(MusicList.getEntry("MusicShop4"));
			slotShop5.setEntry(MusicList.getEntry("MusicShop5"));
			slotShop6.setEntry(MusicList.getEntry("MusicShop6"));
			
			slotBonus1.setEntry(MusicList.getEntry("MusicBonusShop1"));
			slotBonus2.setEntry(MusicList.getEntry("MusicBonusShop2"));
			slotBonus3.setEntry(MusicList.getEntry("MusicBonusShop3"));
			
			slotMain.setEntry(MusicList.getEntry("MusicPunk1"));
			slotRock.setEntry(MusicList.getEntry("MusicRock1"));
			slotHardWork.setEntry(MusicList.getEntry("MusicHardWork1"));
			slotChill.setEntry(MusicList.getEntry("MusicChill1"));
			slotEpic.setEntry(MusicList.getEntry("MusicEpic1"));
			slotSurf.setEntry(MusicList.getEntry("MusicSurf1"));
			slotRetro.setEntry(MusicList.getEntry("MusicRetro1"));
			slotHyped.setEntry(MusicList.getEntry("MusicHype1"));
			slotSpace.setEntry(MusicList.getEntry("MusicSpace1"));
			slotElectro.setEntry(MusicList.getEntry("MusicElectro1"));
			slotLight.setEntry(MusicList.getEntry("MusicCalm1"));
			slotBeat.setEntry(MusicList.getEntry("MusicBeat1"));
			
			for each(var s:MusicEquippedSlot in _equipSlots) {
				s.bounce.signalClickTarget.add(onEquippedClick);
				s.signalPurchaseOver.add(enablePreviews);
			}
			
			for each(var ms:MusicSlot in _buySlots) {
				ms.bounce.signalClickTarget.add(onBuyClick);
				ms.bounce.signalOverTarget.add(onSlotOver);
				ms.bounce.signalOutTarget.add(onSlotOut);
				ms.signalPurchaseOver.add(enablePreviews);
			}
			
			_okBounce = new MouseBounce2(btnOk);
			_cancelBounce = new MouseBounce2(btnCancel);
			
			_okBounce.signalClickTarget.add(okClicked);
			_cancelBounce.signalClickTarget.add(cancelClicked);
			
			bg.addEventListener(MouseEvent.CLICK, onMouseUp)
			
			addUiScaling();
		}
		
		protected function addUiScaling():void {
			UiScaler.addAbsolute(slotCurrentShop1);
			UiScaler.addAbsolute(slotCurrentShop2);
			UiScaler.addAbsolute(slotCurrentShop3);
			UiScaler.addAbsolute(slotCurrentBonus1);
			UiScaler.addAbsolute(slotCurrentBonus2);
			UiScaler.addAbsolute(slotCurrentBonus3);
			UiScaler.addAbsolute(slotCurrentGame1);
			UiScaler.addAbsolute(slotCurrentGame2);
			UiScaler.addAbsolute(slotCurrentGame3);
			
			UiScaler.addAbsolute(slotShop1);
			UiScaler.addAbsolute(slotShop2);
			UiScaler.addAbsolute(slotShop3);
			UiScaler.addAbsolute(slotShop4);
			UiScaler.addAbsolute(slotShop5);
			UiScaler.addAbsolute(slotShop6);
			UiScaler.addAbsolute(slotBonus1);
			UiScaler.addAbsolute(slotBonus2);
			UiScaler.addAbsolute(slotBonus3);
			UiScaler.addAbsolute(slotMain);
			UiScaler.addAbsolute(slotRock);
			UiScaler.addAbsolute(slotHardWork);
			UiScaler.addAbsolute(slotSpace);
			UiScaler.addAbsolute(slotElectro);
			UiScaler.addAbsolute(slotSurf);
			UiScaler.addAbsolute(slotChill);
			UiScaler.addAbsolute(slotHyped);
			UiScaler.addAbsolute(slotLight);
			UiScaler.addAbsolute(slotRetro);
			UiScaler.addAbsolute(slotBeat);
			UiScaler.addAbsolute(slotEpic);
			
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(txtTitle), 360, -360);
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(txtShop), 120, -130);
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(txtBonusShop), 360, -360);
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(txtFlight), 600, -590);
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(txtTracks), 360, -360);
			
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(btnOk), btnOk.x, -btnOk.x);
			UiScaler.addAbsoluteManually(UiScaler.moveIntoNewSprite(btnCancel), btnCancel.x, -btnCancel.x);
			
		}
		
		protected function okClicked(target:DisplayObject):void {
			Transition.transitionTo(ScreenManager.unloadMusicScreen, ScreenManager.loadShop);
		}
		
		protected function cancelClicked(target:DisplayObject):void {
			ProfileState.instance.musicShop =_initialMusicShop = ProfileState.instance.musicShop;
			ProfileState.instance.musicBonusShop = _initialMusicBonus;
			ProfileState.instance.musicGame1 = _initialMusicGame1;
			ProfileState.instance.musicGame2 = _initialMusicGame2;
			ProfileState.instance.musicGame3 = _initialMusicGame3;
			
			Transition.transitionTo(ScreenManager.unloadMusicScreen, ScreenManager.loadShop);
		}
		
		public function updateBp(cost:Number = 0):void {
			txtBp.text = ProfileState.instance.bonusPoints.value.toFixed(0) + " BP";
			
			if (cost <= 0) {
				txtBpCost.text = "";
			}else {
				txtBpCost.text = "-" + cost.toFixed(0) + " BP";
			}
		}
		
		protected function equipTrack(track:MusicSlot, slot:MusicEquippedSlot):void {
			if (slot == slotCurrentShop1 || slot == slotCurrentShop2 || slot == slotCurrentShop3) {
				//Equip to shop
				slotCurrentShop1.setEntry(track.entry);
				slotCurrentShop2.setEntry(track.entry);
				slotCurrentShop3.setEntry(track.entry);
				ProfileState.instance.musicShop = track.entry.track1AsString;
			}else if (slot == slotCurrentBonus1 || slot == slotCurrentBonus2 || slot == slotCurrentBonus3) {
				//Equip to bonus
				slotCurrentBonus1.setEntry(track.entry);
				slotCurrentBonus2.setEntry(track.entry);
				slotCurrentBonus3.setEntry(track.entry);
				ProfileState.instance.musicBonusShop = track.entry.track1AsString;
			}else if (slot == slotCurrentGame1 || slot == slotCurrentGame2 || slot == slotCurrentGame3) {
				//Equip to game
				slotCurrentGame1.setEntry(track.entry);
				slotCurrentGame2.setEntry(track.entry);
				slotCurrentGame3.setEntry(track.entry);
				ProfileState.instance.musicGame1 = track.entry.track1AsString;
				ProfileState.instance.musicGame2 = track.entry.track2AsString;
				ProfileState.instance.musicGame3 = track.entry.track3AsString;
			}
			
			refreshEquipped();
		}
		
		protected function refreshEquipped():void {
			slotCurrentShop1.setAsShopSlot(1);
			slotCurrentShop2.setAsShopSlot(2);
			slotCurrentShop3.setAsShopSlot(3);
			
			slotCurrentBonus1.setAsBonusShopSlot(1);
			slotCurrentBonus2.setAsBonusShopSlot(2);
			slotCurrentBonus3.setAsBonusShopSlot(3);
			
			slotCurrentGame1.setAsGameSlot(1);
			slotCurrentGame2.setAsGameSlot(2);
			slotCurrentGame3.setAsGameSlot(3);
		}
		
		private function onBuyClick(target:DisplayObject):void 
		{
			removeHighlights();
			
			if (target is MusicSlot) {
				if ((target as MusicSlot).owned) {
					if (_selectedSlot) {
						//We are putting this track in a slot
						trace("Put", (target as MusicSlot), "in", _selectedSlot);
						equipTrack((target as MusicSlot), _selectedSlot);
						(target as MusicSlot).stopAudio();
						_selectedSlot.stopAudio();
						onMouseUp(null);
						
					}else {
						//We are selecting a track first
						(target as MusicSlot).highlight.visible = true;
						_selectedTrack = (target as MusicSlot);
						
						for each(var s:MusicEquippedSlot in _equipSlots) {
							s.highlight.visible = true;
						}
					}
					
				}else {
					//Slot not owned, prompt buy messages
					(target as MusicSlot).buyTrack();
					
					for each(var s:MusicEquippedSlot in _equipSlots) {
						s.enablePreview = false;
					}
					
					for each(var ms:MusicSlot in _buySlots) {
						ms.enablePreview = false;
					}
				}
			}
		}
		
		protected function onSlotOver(target:DisplayObject):void {
			//trace("Slot over!");
			if (target is MusicSlot) {
				var slot:MusicSlot = (target as MusicSlot);
				if (slot.owned == false) {
					_trackShowingPrice = slot;
					updateBp(slot.entry.cost);
				}
			}
		}
		
		protected function onSlotOut(target:DisplayObject):void {
			if (target is MusicSlot) {
				var slot:MusicSlot = (target as MusicSlot);
				if (slot == _trackShowingPrice) {
					updateBp();
				}
			}
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			_selectedTrack = null;
			_selectedSlot = null;
			
			removeHighlights();
			enablePreviews(null);
		}
		
		protected function removeHighlights():void {
			for each(var s:MusicEquippedSlot in _equipSlots) {
				s.highlight.visible = false;
			}
			
			for each(var ms:MusicSlot in _buySlots) {
				ms.highlight.visible = false;
			}
		}
		
		protected function onEquippedClick(target:DisplayObject):void 
		{
			//trace("onEquippedClick");
			removeHighlights();
			
			if (target is MusicEquippedSlot) {
				var slot:MusicEquippedSlot = (target as MusicEquippedSlot);
				if (_selectedTrack) {
					//We are setting a track in a slot
						trace("Put", _selectedTrack, "in", slot);
						equipTrack(_selectedTrack, slot);
						slot.stopAudio();
						_selectedTrack.stopAudio();
						onMouseUp(null);
					
				}else {
					//We are selescting a slot as track for the profile
					if (slot.isEmpty == false) {
						if (slot == slotCurrentShop1 || slot == slotCurrentShop2 || slot == slotCurrentShop3) {
							//Equip to shop
							ProfileState.instance.musicShop = slot.slotTrackName;
						}else if (slot == slotCurrentBonus1 || slot == slotCurrentBonus2 || slot == slotCurrentBonus3) {
							//Equip to bonus
							ProfileState.instance.musicBonusShop = slot.slotTrackName;
						}else if (slot == slotCurrentGame1 || slot == slotCurrentGame2 || slot == slotCurrentGame3) {
							//Equip to game
							ProfileState.instance.musicGame1 = slot.slotTrackName;
							ProfileState.instance.musicGame2 = slot.slotTrackName;
							ProfileState.instance.musicGame3 = slot.slotTrackName;
						}
						refreshEquipped();
					}
				}
			}
		}
		
		protected function enablePreviews(s:MusicSlot):void {
			updateBp();
			for each(var mes:MusicEquippedSlot in _equipSlots) {
				mes.enablePreview = true;
				mes.checkIfOwned();
			}
			
			for each(var ms:MusicSlot in _buySlots) {
				ms.enablePreview = true;
				mes.checkIfOwned();
			}
		}
		
		public static function get instance():MusicScreen {
			if (_instance == null) {
				_instance = new MusicScreen(new Enforcer());
			}
			
			return _instance;
		}
		
		public static function destroy():void {
			if (_instance) {
				_instance.destroy();
			}
		}
		
		public function destroy():void {
			_instance = null;
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			if (_equipSlots) {
				for each(var s:MusicEquippedSlot in _equipSlots) {
					s.destroy();
				}
				_equipSlots.length = 0;
			}
			_equipSlots = null;
			
			if (_buySlots) {
				for each(var ms:MusicSlot in _buySlots) {
					ms.destroy();
				}
				_buySlots.length = 0;
			}
			_buySlots = null;
			
			if (_okBounce) _okBounce.destroy();
			_okBounce = null;
			
			if (_cancelBounce) _cancelBounce.destroy();
			_cancelBounce = null;
			
			bg = null;
			txtBp = null;
			txtBpCost = null;
			btnOk = null;
			btnCancel = null;
			
			if (_selectedSlot)_selectedSlot.destroy();
			_selectedSlot = null;
			
			if (_selectedTrack)_selectedTrack.destroy();
			_selectedTrack = null;
			
			if (_trackShowingPrice)_trackShowingPrice.destroy();
			_trackShowingPrice = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}

class Enforcer { }
