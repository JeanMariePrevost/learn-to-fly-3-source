package src.gui 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.VectorUtils;
	import src.ScreenManager;
	import src.UiScaler;
	import src.audio.Sfx;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	import src.gui.decorators.TweenPos;
	import src.Main;
	import src.shop.ShopTooltip;
	import src.system.GameState;
	import src.system.Global;
	import src.system.ProfileState;
	import src.system.SaveLoadModule;
	
	/**
	 * ...
	 * @author light_bringer777
	 */
	public class LoadGameMenu extends MovieClip 
	{
		public var btnBack:SimpleButton;
		
		public var slot1:LoadGameMenuSlot;
		public var slot2:LoadGameMenuSlot;
		public var slot3:LoadGameMenuSlot;
		public var slot4:LoadGameMenuSlot;
		public var slot5:LoadGameMenuSlot;
		public var slot6:LoadGameMenuSlot;
		
		public var delete1:MovieClip;
		public var delete2:MovieClip;
		public var delete3:MovieClip;
		public var delete4:MovieClip;
		public var delete5:MovieClip;
		public var delete6:MovieClip;
		
		
		protected var _slots:Vector.<LoadGameMenuSlot> = new Vector.<LoadGameMenuSlot>();
		
		protected var _controller:MainMenuController;
		
		protected var _decoBack:MouseBounce2;
		//protected var _decoLoad:MouseBounce2;
		
		
		
		protected var _buttonClicked:Object;
		
		public function LoadGameMenu(control:MainMenuController) 
		{
			super();
			
			_controller = control;
			
			TweenPos.tweenToCurrentPosition(this, new Point(0, 540), 30, 0, TweenPos.EASE_OUT_CUBIC);
			
			_decoBack = new MouseBounce2(btnBack);
			_decoBack.signalClickTarget.add(onLoadMenuClick);
			
			_slots.push(slot1);
			_slots.push(slot2);
			_slots.push(slot3);
			_slots.push(slot4);
			_slots.push(slot5);
			_slots.push(slot6);
			
			for (var i:int = 0; i < _slots.length; i++) {
				_slots[i].bounce.signalClickTarget.add(onLoadMenuClick);
				_slots[i].txtSlot.text = String(i + 1);
				_slots[i].updateFromState(ProfileState.instance.saveSlots[i]);
				_slots[i].deleteButton = this["delete" + (i + 1)];
				
				if (_slots[i].state.gameMode == "Empty") {
					DisplayObjectUtil.setColorMatrix(_slots[i].deleteButton, 0, -100, 20, -40);
				}else {
					_slots[i].deleteButtonBounce = new MouseBounce2(_slots[i].deleteButton, true);
					_slots[i].deleteButtonBounce.signalOverTarget.add(onDeleteOver);
					_slots[i].deleteButtonBounce.signalClickTarget.add(onDeleteClick);
				}
			}
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			UiScaler.addAbsolute(this, true);
		}
		
		protected function refreshScreen():void {
			for (var i:int = 0; i < _slots.length; i++) {
				_slots[i].txtSlot.text = String(i + 1);
				_slots[i].updateFromState(ProfileState.instance.saveSlots[i]);
				
				if (_slots[i].state.gameMode == "Empty") {
					DisplayObjectUtil.setColorMatrix(_slots[i].deleteButton, 0, -100, 20, -40);
					if (_slots[i].deleteButtonBounce) {
						_slots[i].deleteButtonBounce.destroy();
						_slots[i].deleteButtonBounce = null;
					}
				}else {
					DisplayObjectUtil.setColorMatrix(_slots[i].deleteButton, 0, 0, 0, 0);
					if (_slots[i].deleteButtonBounce == null) {
						_slots[i].deleteButtonBounce = new MouseBounce2(_slots[i].deleteButton, true);
						_slots[i].deleteButtonBounce.signalOverTarget.add(onDeleteOver);
						_slots[i].deleteButtonBounce.signalClickTarget.add(onDeleteClick);
					}
				}
			}
		}
		
		protected function onDeleteOver(target:DisplayObject):void 
		{
			ShopTooltip.showRed(target, "Delete save slot");
		}
		
		protected function onDeleteClick(target:DisplayObject):void 
		{
			for each(var s:LoadGameMenuSlot in _slots) {
				if (s.deleteButton == target) {
					var sb:ScreenBlurEffect = new ScreenBlurEffect();
					Main.dialogLayer.addChild(sb);
					var box:DeleteSaveDialog = new DeleteSaveDialog("Delete save slot?", "Are you sure you want to delete this save?", s.state, deleteSaveSlot, null, sb.deblurAndDestroy);
					Main.dialogLayer.addChild(box);
					return;
				}
			}
		}
		
		protected function deleteSaveSlot(gameState:GameState):void {
			for (var i:int = 0; i < ProfileState.instance.saveSlots.length; i++) {
				if (ProfileState.instance.saveSlots[i] == gameState) {
					var oldSave:GameState = ProfileState.instance.saveSlots[i];
					var emptySave:GameState = GameState.getEmptyInstance();
					ProfileState.instance.saveSlots[i] = emptySave;
					oldSave.destroy();
					var c:MainMenuController = _controller;
					destroy();
					c.gotoLoadGameMenu();
					return;
				}
			}
		}
		
		protected function onLoadMenuClick(target:DisplayObject):void 
		{
			Sfx.playButtonClick();
			_buttonClicked = target;
			
			trace("_buttonClicked:", _buttonClicked);
			
			closeMenu();
		}
		
		public function closeMenu():void {
			btnBack.removeEventListener(MouseEvent.CLICK, onLoadMenuClick);
			
			for each(var i:LoadGameMenuSlot in _slots) {
				i.removeEventListener(MouseEvent.CLICK, onLoadMenuClick);
			}
			
			btnBack.mouseEnabled = false;
			
			TweenPos.tweenFromCurrentPosition(this, new Point(0, 540), 30, 0, TweenPos.EASE_IN).finishedSignal.addOnce(finishMenu);
		}
		
		protected function finishMenu():void 
		{
			switch(_buttonClicked) {
					//_controller.gotoMainMenu();
					//break;
				case btnBack:
					_controller.gotoMainMenu();
					break;
				case slot1:
				case slot2:
				case slot3:
				case slot4:
				case slot5:
				case slot6:
					if ((_buttonClicked as LoadGameMenuSlot).state.gameMode == "Empty") {
						_controller.selectedSlotIndex = _slots.indexOf(_buttonClicked);
						_controller.gotoNewGameMenu();
					}else {
						loadGameFromSlot(_buttonClicked as LoadGameMenuSlot);
						Transition.transitionTo(MainMenuController.destroy, Main.gameToShop);
					}
					break;
				default:
					//throw new Error("LoadGameMenu finishMenu error - unknown user input...");
					Log.log("LoadGameMenu finishMenu error - unknown user input...");
					_controller.gotoMainMenu();
					break;
			}
			
			destroy();
		}
		
		protected function loadGameFromSlot(slot:LoadGameMenuSlot):void {
			ProfileState.instance.loadState(slot.state);
		}
		
		
		protected function finishNormalLoading():void {
			Main.returnToMainMenu();
		}
		
		////////////////////////////////////////
		
		
		public function destroy():void 
		{
			if(btnBack) btnBack.removeEventListener(MouseEvent.CLICK, onLoadMenuClick);
			
			if (_slots) {
				for each(var i:LoadGameMenuSlot in _slots) {
					i.removeEventListener(MouseEvent.CLICK, onLoadMenuClick);
					i.destroy();
				}
			}
			
			_slots = null;
			
			slot1 = null;
			slot2 = null;
			slot3 = null;
			slot4 = null;
			slot5 = null;
			slot6 = null;
			
			btnBack = null;
			
			_controller = null;
			
			if(_decoBack) _decoBack.destroy();
			//if(_decoLoad) _decoLoad.destroy();
			
			_decoBack = null;
			//_decoLoad = null;
			
			_buttonClicked = null;
			
			if (stage) parent.removeChild(this);
			while (numChildren) removeChildAt(0);
		}
		
	}

}