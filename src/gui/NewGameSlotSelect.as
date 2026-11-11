package src.gui 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import lbg.utils.DisplayObjectUtil;
	import src.ScreenManager;
	import src.audio.Sfx;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	import src.gui.decorators.TweenPos;
	import src.Main;
	import src.system.GameState;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author light_bringer777
	 */
	public class NewGameSlotSelect extends MovieClip 
	{
		public var btnBack:SimpleButton;
		
		public var slot1:LoadGameMenuSlot;
		public var slot2:LoadGameMenuSlot;
		public var slot3:LoadGameMenuSlot;
		public var slot4:LoadGameMenuSlot;
		public var slot5:LoadGameMenuSlot;
		public var slot6:LoadGameMenuSlot;
		
		
		protected var _slots:Vector.<LoadGameMenuSlot> = new Vector.<LoadGameMenuSlot>();
		
		protected var _controller:MainMenuController;
		
		protected var _decoBack:MouseBounce2;
		
		protected var _buttonClicked:Object;
		protected var _selectedSlot:LoadGameMenuSlot;
		
		public function NewGameSlotSelect(control:MainMenuController) 
		{
			super();
			
			_controller = control;
			
			TweenPos.tweenToCurrentPosition(this, new Point(0, 540), 30, 0, TweenPos.EASE_OUT_CUBIC);
			
			_decoBack = new MouseBounce2(btnBack);
			
			_decoBack.signalClickTarget.add(onSlotSelectClick);
			
			
			_slots.push(slot1);
			_slots.push(slot2);
			_slots.push(slot3);
			_slots.push(slot4);
			_slots.push(slot5);
			_slots.push(slot6);
			
			for (var i:int = 0; i < _slots.length; i++) {
				_slots[i].bounce.signalClickTarget.add(onSlotSelectClick);
				_slots[i].txtSlot.text = String(i + 1);
				_slots[i].updateFromState(ProfileState.instance.saveSlots[i]);
				_slots[i].filters = [new GlowFilter(0, 1, 7, 7, 12, 1)];
			}
		}
		
		protected function onSlotSelectClick(target:DisplayObject):void 
		{
			Sfx.playButtonClick();
			_buttonClicked = target;
			if (target is LoadGameMenuSlot) {
				selectSlot();
			}else {
				closeMenu();
			}
		}
		
		public function closeMenu():void {
			btnBack.removeEventListener(MouseEvent.CLICK, onSlotSelectClick);
			
			for each(var i:LoadGameMenuSlot in _slots) {
				i.removeEventListener(MouseEvent.CLICK, onSlotSelectClick);
			}
			
			btnBack.mouseEnabled = false;
			
			TweenPos.tweenFromCurrentPosition(this, new Point(0, 540), 30, 0, TweenPos.EASE_IN).finishedSignal.addOnce(finishMenu);
		}
		
		protected function finishMenu():void 
		{
			switch(_buttonClicked) {
				case btnBack:
					_controller.gotoMainMenu();
					break;
				case slot1:
				case slot2:
				case slot3:
				case slot4:
				case slot5:
				case slot6:
					startGameAtSlot();
					break;
				default:
					throw new Error("LoadGameMenu finishMenu error - unknown user input...");
					break;
			}
			
			destroy();
		}
		
		protected function selectSlot():void {
			if ((_buttonClicked as LoadGameMenuSlot).isEmpty) {
				selectSlot2();
			}else {
				//Slot occupied
				var blur:ScreenBlurEffect = _controller.addScreenBlur();
				var box:QuestionBox = _controller.addQuestionBox2("Overwrite?", "Starting a game in this slot will overwrite this save. Continue?", selectSlot2, null, blur.deblurAndDestroy);
			}
		}
		
		protected function selectSlot2():void {
			_selectedSlot = (_buttonClicked as LoadGameMenuSlot);
			if (_selectedSlot == null) {
				throw new Error("NewGameSlotSelect selectSlot2() ERROR: _selectedSlot is null");
			}else {
				ProfileState.instance.stats.totalGamesStarted += 1;
				closeMenu();
			}
		}
		
		protected function startGameAtSlot():void {
			var index:int = ProfileState.instance.saveSlots.indexOf(_selectedSlot.state);
			ProfileState.instance.saveSlots[index] = GameState.getDebugInstance();
			ProfileState.instance.saveSlots[index].gameMode = _controller.selectedNewGameMode;
			ProfileState.instance.saveSlots[index].storyModeSpaceLevel = _controller.storyModeGoal;
			ProfileState.instance.loadState(ProfileState.instance.saveSlots[index]);
			
			if (_controller.selectedNewGameMode == "Story Mode") {
				Cutscene.playNewGameIntro();
				MainMenuController.destroy();
			}else {
				Transition.transitionTo(MainMenuController.destroy, Main.gameToShop);
			}
			
		}
		
		public function destroy():void 
		{
			if(btnBack) btnBack.removeEventListener(MouseEvent.CLICK, onSlotSelectClick);
			
			for each(var i:LoadGameMenuSlot in _slots) {
				i.removeEventListener(MouseEvent.CLICK, onSlotSelectClick);
				i.destroy();
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
			
			_decoBack = null;
			
			_buttonClicked = null;
			
			if (stage) parent.removeChild(this);
			while (numChildren) removeChildAt(0);
		}
		
	}

}