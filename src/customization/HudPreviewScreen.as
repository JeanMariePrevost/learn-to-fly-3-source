package src.customization 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import lbg.utils.VectorUtils;
	import src.game.hud.HudComponentEntry;
	import src.game.hud.HudComponentList;
	import src.gui.MessageBar;
	import src.Main;
	import src.reg.Registry;
	import src.reg.RegistryEntry;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class HudPreviewScreen extends MovieClip 
	{
		public var square:MovieClip;
		public var txtCount:TextField;
		
		protected const DRAG_THRESHOLD:Number = 10;//Number of px to drag before moving is enabled, allows for easier selection
		protected const MIN_SCALE:Number = 0.5;
		protected const MAX_SCALE:Number = 2;
		protected const HISTORY_LENGTH:uint = 20;
		
		
		protected var _selected:HudDraggable;
		protected var _selectedOutline:HudDraggableOutline;
		protected var _thresholdMet:Boolean = false;
		protected var _clickGlobalCoords:Point = new Point();
		protected var _startingCoords:Point = new Point();//Used when moving an object to not have it dragged from the center all the time
		protected var _startingScale:Number;//Reference point when scaling an object
		protected var _startingRotation:Number;//Reference point when rotating an object
		
		protected var _firstKeyTimer:Timer = new Timer(200, 1);
		protected var _ongoingKeyTimer:Timer = new Timer(30, 0);
		
		protected var _hudElements:Vector.<HudDraggable> = new Vector.<HudDraggable>();
		
		protected var _history:Vector.<ByteArray> = new Vector.<ByteArray>();
		protected var _loadingState:Boolean = false;//Used to disable adding history while loading
		protected var _historyDirty:Boolean = false;//Used to flag if history has been changed, making the first ctrl-z skip the current state directly to the previous one
		
		public function HudPreviewScreen() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			txtCount.text = _hudElements.length.toFixed() + "/10";
			
			Input.instance.basicCommands.metaDown.signalCommandDown.add(downKeyDown);
			Input.instance.basicCommands.metaDown.signalCommandUp.add(keyUp);
			Input.instance.basicCommands.metaLeft.signalCommandDown.add(leftKeyDown);
			Input.instance.basicCommands.metaLeft.signalCommandUp.add(keyUp);
			Input.instance.basicCommands.metaRight.signalCommandDown.add(rightKeyDown);
			Input.instance.basicCommands.metaRight.signalCommandUp.add(keyUp);
			Input.instance.basicCommands.metaUp.signalCommandDown.add(upKeyDown);
			Input.instance.basicCommands.metaUp.signalCommandDown.add(upKeyDown);
			Input.instance.basicCommands.z.signalCommandUp.add(zKeyDown);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onHudPreviewClick);
			
			loadFromProfile();
		}
		
		protected function loadFromProfile():void {
			trace("loadFromProfile()");
			loadFromList(ProfileState.instance.hudComponentList);
		}
		
		public function loadFromList(list:HudComponentList):void {
			_loadingState = true;
			_historyDirty = false;
			
			if (_hudElements) {
				for each(var h:HudDraggable in _hudElements) {
					h.destroy();
				}
			}
			
			_hudElements.length = 0;
			
			for (var i:int = 0; i < list.length; i++ ) {
				var e:HudComponentEntry = list.getEntry(i);
				newHud(e.id);
				_selected.x = e.x;
				_selected.y = e.y;
				_selected.scaleX = e.scale;
				_selected.scaleY = e.scale;
				_selected.rotation = e.rotation;
				dropHud();
			}
			
			//Deselect item
			if (_selected) {
				DisplayObjectUtil.setObjectTint(_selected, 0xFFFFCC, 0);
			}
			_selected = null;
			if (_selectedOutline) _selectedOutline.destroy();
			_selectedOutline = null;
			
			_loadingState = false;
		}
		
		public function saveToProfile():void {
			ProfileState.instance.hudComponentList.clearList();
			
			for each(var hud:HudDraggable in _hudElements) {
				ProfileState.instance.hudComponentList.addFromMovieClip(hud, hud.hudEntry);
				Log.log(hud.hudEntry.gameClass.valueAt(0), hud.x, hud.y, hud.scaleX, hud.rotation);
			}
			
			//trace("saveToProfile() done");
		}
		
		protected function addHistoryState():void {
			if (_loadingState) return;
			
			
			_history.push(getState());
			
			while (_history.length > HISTORY_LENGTH) {
				_history.shift();
			}
			
			_historyDirty = true;
		}
		
		public function getState():ByteArray {
			var state:ByteArray = new ByteArray();
			
			var list:HudComponentList = new HudComponentList();
			
			for each(var hud:HudDraggable in _hudElements) {
				list.addFromMovieClip(hud, hud.hudEntry);
			}
			
			state.writeObject(list);
			state.position = 0;
			
			return state;
		}
		
		public function setState(state:ByteArray) {
			state.position = 0;
			var list:HudComponentList = (state.readObject() as HudComponentList);
			loadFromList(list);
		}
		
		private function onHudPreviewClick(e:MouseEvent):void 
		{
			//Deselect item
			if (_selected) {
				DisplayObjectUtil.setObjectTint(_selected, 0xFFFFCC, 0);
			}
			_selected = null;
			if (_selectedOutline) _selectedOutline.destroy();
			_selectedOutline = null;
		}
		
		private function downKeyDown():void 
		{
			moveDown();
			_firstKeyTimer.reset();
			_firstKeyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFirstKeyTimer);
			_firstKeyTimer.start();
		}
		
		private function leftKeyDown():void 
		{
			moveLeft();
			_firstKeyTimer.reset();
			_firstKeyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFirstKeyTimer);
			_firstKeyTimer.start();
		}
		
		private function rightKeyDown():void 
		{
			moveRight();
			_firstKeyTimer.reset();
			_firstKeyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFirstKeyTimer);
			_firstKeyTimer.start();
		}
		
		private function upKeyDown():void 
		{
			//Disregard is ctrl down because of ctrl-z command and azerty keyboard
			if (!Input.instance.basicCommands.ctrl.isDown) {
				moveUp();
				_firstKeyTimer.reset();
				_firstKeyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onFirstKeyTimer);
				_firstKeyTimer.start();
			}
		}
		
		private function zKeyDown():void 
		{
			if (Input.instance.basicCommands.ctrl.isDown) {
				//Ctrl-z
				trace("Returning one state behind, state", _history.length);
				
				if (_historyDirty) {
					_history.pop();//Skip current state
				}
				
				if (_history.length >= 1) {
					var state:ByteArray = _history.pop();
					if (_history.length <= 0) _history.push(state);//Keep first state
					state.position = 0;
					setState(state);
				}
				
				stage.focus = stage;
			}
		}
		
		private function keyUp():void 
		{
			if (!Input.instance.basicCommands.metaDown.isDown &&
			!Input.instance.basicCommands.metaLeft.isDown &&
			!Input.instance.basicCommands.metaRight.isDown &&
			!Input.instance.basicCommands.metaUp.isDown) {
				
				_firstKeyTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onFirstKeyTimer);
				_ongoingKeyTimer.removeEventListener(TimerEvent.TIMER, onOngoingTimer);
				
				_firstKeyTimer.stop();
				_firstKeyTimer.reset();
				_ongoingKeyTimer.stop();
				_ongoingKeyTimer.reset();
				//trace("Everythign reset!");
				
				addHistoryState();
			}
		}
		
		protected function onFirstKeyTimer(e:TimerEvent):void {
			_firstKeyTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onFirstKeyTimer);
			
			_ongoingKeyTimer.reset();
			_ongoingKeyTimer.addEventListener(TimerEvent.TIMER, onOngoingTimer);
			_ongoingKeyTimer.start();
		}
		
		protected function onOngoingTimer(e:TimerEvent):void {
			if (Input.instance.basicCommands.metaDown.isDown) {
				moveDown();
			}
			
			if (Input.instance.basicCommands.metaLeft.isDown) {
				moveLeft();
			}
			
			if (Input.instance.basicCommands.metaRight.isDown) {
				moveRight();
			}
			
			if (Input.instance.basicCommands.metaUp.isDown) {
				moveUp();
			}
			
			//if (_keyboardFunction) _keyboardFunction();
		}
		
		protected function moveDown():void {
			_selected.y += 1;
			moveOutline();
		}
		
		protected function moveLeft():void {
			_selected.x -= 1;
			moveOutline();
		}
		
		protected function moveRight():void {
			_selected.x += 1;
			moveOutline();
		}
		
		protected function moveUp():void {
			_selected.y -= 1;
			moveOutline();
		}
		
		public function newHud(registryId:String):void {
			if (_hudElements.length >= 10) {
				Main.displayMessage("HUD limit reached");
				return;
			}
			
			var hudEntry:RegistryEntry = Registry.getEntry(registryId);
			var hud:MovieClip = new (hudEntry.gameClass.valueAt(0) as Class)();
			selectItem(new HudDraggable(hud, hudEntry));
			var msk:Sprite = new Sprite();
			msk.graphics.beginFill(0, 1);
			msk.graphics.drawRect(0, 0, square.width, square.height);
			msk.graphics.endFill();
			addChild(msk);
			_selected.mask = msk;
			addChild(_selected);
			
			
			_clickGlobalCoords.x = _selected.mouseX;
			_clickGlobalCoords.y = _selected.mouseY;
			_clickGlobalCoords = _selected.localToGlobal(_clickGlobalCoords);
			_startingCoords.x = _selected.mouseX;
			_startingCoords.y = _selected.mouseY;
			_startingScale = 1;
			_startingRotation = 0;
			
			dragHud(_selected);
			_thresholdMet = true;
			updatePosition();
		}
		
		protected function selectItem(hud:HudDraggable):void {
			if (_selected) {
				DisplayObjectUtil.setObjectTint(_selected, 0xFFFFCC, 0);
			}
			_selected = hud;
			DisplayObjectUtil.setObjectTint(_selected, 0xFFFFCC, 0.2);
			
			if (_selected.parent == this) {
				removeChild(_selected);
				addChild(_selected);
			}
		}
		
		protected function clickExistingHud(hud:HudDraggable):void {
			
			_startingCoords.x = hud.x;
			_startingCoords.y = hud.y;
			_clickGlobalCoords.x = hud.mouseX;
			_clickGlobalCoords.y = hud.mouseY;
			_clickGlobalCoords = hud.localToGlobal(_clickGlobalCoords);
			_startingScale = hud.scaleX;
			_startingRotation = hud.rotation;
			
			if (Input.instance.basicCommands.ctrl.isDown) {
				scaleHud(hud);
			}else if (Input.instance.basicCommands.shift.isDown) {
				rotateHud(hud);
			}else {
				dragHud(hud);
			}
			
			updatePosition();
		}
		
		protected function dragHud(hud:HudDraggable):void {
			_thresholdMet = false;
			selectItem(hud);
			if (_selectedOutline) _selectedOutline.destroy();
			_selectedOutline = new HudDraggableOutline(_selected.hudMovieClip);
			addChild(_selectedOutline);
			moveOutline();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onDragMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onDragMove(e:MouseEvent):void 
		{
			updatePosition();
			e.updateAfterEvent();
		}
		
		protected function scaleHud(hud:HudDraggable):void {
			selectItem(hud);
			if (_selectedOutline) _selectedOutline.destroy();
			_selectedOutline = new HudDraggableOutline(_selected.hudMovieClip);
			addChild(_selectedOutline);
			moveOutline();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onScaleMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onScaleMove(e:MouseEvent):void {
			var zoomX:Number = e.stageX - _clickGlobalCoords.x;
			var zoomY:Number = _clickGlobalCoords.y - e.stageY;
			
			var scaleMod:Number = NumberUtils.interpolate2( -2, 2, -400, 400, zoomX + zoomY, 1);
			
			var scale:Number = NumberUtils.constrain(_startingScale + scaleMod, MIN_SCALE, MAX_SCALE);
			
			_selected.scaleX = _selected.scaleY = scale;
			moveOutline();
		}
		
		protected function rotateHud(hud:HudDraggable):void {
			selectItem(hud);
			if (_selectedOutline) _selectedOutline.destroy();
			_selectedOutline = new HudDraggableOutline(_selected.hudMovieClip);
			addChild(_selectedOutline);
			moveOutline();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onRotateMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onRotateMove(e:MouseEvent):void {
			var zoomX:Number = e.stageX - _clickGlobalCoords.x;
			var zoomY:Number = e.stageY - _clickGlobalCoords.y;
			
			var rotationMod:Number = (zoomX + zoomY) * 0.3;
			
			_selected.rotation = _startingRotation + rotationMod;
			moveOutline();
		}
		
		protected function moveOutline():void {
			if (_selectedOutline) {
				_selectedOutline.x = _selected.x;
				_selectedOutline.y = _selected.y;
				_selectedOutline.scaleX = _selected.scaleX;
				_selectedOutline.scaleY = _selected.scaleY;
				_selectedOutline.rotation = _selected.rotation;
			}
		}
		
		protected function updatePosition():void {
			var p:Point = new Point(_clickGlobalCoords.x, _clickGlobalCoords.y);
			p = globalToLocal(p);
			
			var moveX:Number = mouseX - p.x;
			var moveY:Number = mouseY - p.y;
			
			if (!_thresholdMet) {
				if (Math.abs(moveX) >= DRAG_THRESHOLD || Math.abs(moveY) >= DRAG_THRESHOLD) {
					_thresholdMet = true;
				}
			}
			
			if (_thresholdMet) {
				_selected.x = _startingCoords.x + moveX;
				_selected.y = _startingCoords.y + moveY;
				moveOutline();
			}
		}
		
		protected function onMouseUp(e:MouseEvent):void 
		{
			dropHud();
			
			//Trace huds
			//for each(var h:HudDraggable in _hudElements) {
				//trace(h.hudEntry.id, h.x, h.y, h.scaleX);
			//}
		}
		
		protected function dropHud():void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onRotateMove);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onScaleMove);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			var scale:Number = _selected.scaleX;
			
			//Reduce scale to delete huds mostly out of screen too
			_selected.scaleX *= 0.5;
			_selected.scaleY *= 0.5;
			
			if (_selected.hitTestObject(square)) {
				//Inside screen, add to list
				_selected.scaleX = _selected.scaleY = scale;//Restore scale
				addHudToList(_selected);
				_selectedOutline.setToWeakOutline();
			}else {
				//Outside screen, destroy
				if (_hudElements.indexOf(_selected) >= 0) {
					VectorUtils.removeFromVector(_hudElements, _selected);
				}
				_selectedOutline.destroy();
				_selected.destroy();
				refreshCount();
			}
			
			sortHudsByDepth();
			
			addHistoryState();
		}
		
		protected function sortHudsByDepth():void {
			_hudElements = _hudElements.sort(compareHudDepth);
		}
		
		protected function compareHudDepth(itemA:HudDraggable, itemB:HudDraggable):Number {
			if (itemA.parent.getChildIndex(itemA) < itemB.parent.getChildIndex(itemB)) return -1; //ITEM A is before ITEM B
			else if (itemA.parent.getChildIndex(itemA) > itemB.parent.getChildIndex(itemB)) return 1; //ITEM A is after ITEM B
			else return 0; //ITEM A and ITEM B have same date
		}	
		
		protected function addHudToList(hud:HudDraggable):void {
			if (_hudElements.indexOf(_selected) < 0) {
				_hudElements.push(_selected);
				_selected.mouseDownSignal.add(clickExistingHud);
			}
			refreshCount();
		}
		
		protected function refreshCount():void {
			txtCount.text = _hudElements.length.toFixed() + "/10";
		}
		
		
		public function destroy():void {
			Input.instance.basicCommands.metaDown.signalCommandDown.remove(downKeyDown);
			Input.instance.basicCommands.metaDown.signalCommandUp.remove(keyUp);
			Input.instance.basicCommands.metaLeft.signalCommandDown.remove(leftKeyDown);
			Input.instance.basicCommands.metaLeft.signalCommandUp.remove(keyUp);
			Input.instance.basicCommands.metaRight.signalCommandDown.remove(rightKeyDown);
			Input.instance.basicCommands.metaRight.signalCommandUp.remove(keyUp);
			Input.instance.basicCommands.metaUp.signalCommandDown.remove(upKeyDown);
			Input.instance.basicCommands.metaUp.signalCommandDown.remove(upKeyDown);
			Input.instance.basicCommands.z.signalCommandUp.remove(zKeyDown);
			
			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragMove);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onScaleMove);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onRotateMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(MouseEvent.MOUSE_DOWN, onHudPreviewClick);
			
			square = null;
			txtCount = null;
			
			if (_selected) _selected.destroy();
			_selected = null;
			
			if (_selectedOutline) _selectedOutline.destroy();
			_selectedOutline = null;
			
			_clickGlobalCoords = null;
			_startingCoords = null;
			
			if (_firstKeyTimer) {
				_firstKeyTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onFirstKeyTimer);
				_firstKeyTimer.stop();
			}
			_firstKeyTimer = null;
			
			if (_ongoingKeyTimer) {
				_ongoingKeyTimer.removeEventListener(TimerEvent.TIMER, onOngoingTimer);
				_ongoingKeyTimer.stop();
			}
			_ongoingKeyTimer = null;
			
			if (_hudElements) {
				for each(var h:HudDraggable in _hudElements) {
					h.destroy();
				}
				_hudElements.length = 0;
			}
			_hudElements = null;
			
			if (_history) {
				for each(var b:ByteArray in _history) {
					b.clear();
				}
				_history.length = 0;
			}
			_history = null;
			
			
		}
		
	}

}