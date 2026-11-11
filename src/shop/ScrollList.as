package src.shop 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	import src.audio.Sfx;
	import src.Main;
	import src.reg.*;
	import src.system.ContentUnlocking;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ScrollList extends MovieClip 
	{
		/** Signal(RegistryEntry) */
		public var signalBuyItem:Signal = new Signal(RegistryEntry);
		/** Signal(RegistryEntry) */
		public var signalMouseOver:Signal = new Signal(RegistryEntry);
		/** Signal(RegistryEntry) */
		public var signalMouseOut:Signal = new Signal(RegistryEntry);
		
		protected const NODE_SPACING:Number = 60;
		protected const NODE_SCALE:Number = 1.1;
		protected const LIST_MASK_HEIGHT:Number = 356;//458;
		protected const SCROLL_SPEED:Number = 4;
		protected const SCROLL_DRAG:Number = 0.8;
		protected const SCROLL_FROM_KEY_SPEED_MULT:Number = 0.25;
		
		protected var _nodeList:Vector.<ScrollListNode> = new Vector.<ScrollListNode>();
		protected var _scrollBar:ScrollBar = new ScrollBar();
		protected var _container:Sprite = new Sprite();
		protected var _listMask:Sprite = new Sprite();
		
		protected var _minScroll:Number = 0;
		protected var _maxScroll:Number = -100;//Negative value since y<0 when scrolling container "up", calculated on list creation
		protected var _scrollVy:Number = 0;
		
		protected var _sortFunction:Function;
		protected var _lastLoadedType:String;
		
		protected var _buyTimer:Number = 0;//Simply hack to prevent mashing mouse and buying same item over and over, losing money
		
		
		public function ScrollList(listMask:DisplayObjectContainer) 
		{
			addChild(_container);
			addChild(_scrollBar);
			_scrollBar.x = 252;
			_container.mask = listMask;
			
			Input.instance.basicCommands.mouseWheelDown.signalCommandDown.add(scrollUp);
			Input.instance.basicCommands.mouseWheelUp.signalCommandDown.add(scrollDown);
			Main.unsafeTickSignal.add(tick);
			
			_scrollBar.signalScroll.add(forceScrollPosition);
			
			updateSortMethod(null);
		}
		
		protected function tick(delta:Number):void 
		{
			if (Input.metaDown.isDown) {
				scrollDown(SCROLL_FROM_KEY_SPEED_MULT);
			}else if (Input.instance.basicCommands.metaUp.isDown) {
				scrollUp(SCROLL_FROM_KEY_SPEED_MULT);
			}
			
			if (_scrollVy == 0) {
				return;
			}
			
			_container.y += _scrollVy;
			_scrollVy *= SCROLL_DRAG;
			
			if (Math.abs(_scrollVy) <= 0.1) {
				_scrollVy = 0;
			}
			
			//Scroll limits
			if (_container.y >= _minScroll) {
				//Top reached
				_container.y = _minScroll;
				_scrollVy = 0;
			}else if (_container.y <= _maxScroll) {
				//Bottom reached
				_container.y = _maxScroll;
				_scrollVy = 0;
			}
			
			_scrollBar.updateSliderPos(NumberUtils.interpolate2(0, 1, _minScroll, _maxScroll, _container.y, 1));
		}
		
		protected function scrollUp(mult:Number = 2.1):void 
		{
			_scrollVy += SCROLL_SPEED * mult;
		}
		
		protected function scrollDown(mult:Number = 2.1):void 
		{
			_scrollVy -= SCROLL_SPEED * mult;
		}
		
		protected function forceScrollPosition(norm:Number):void {
			_container.y = NumberUtils.interpolate(_minScroll, _maxScroll, norm);
		}
		
		protected function resetScrollPosition():void {
			forceScrollPosition(0);
			_scrollBar.updateSliderPos(0);
		}
		
		
		public function loadItemList(type:String):void {
			_lastLoadedType = type;
			clearList();
			var entryList:Vector.<RegistryEntry> = Registry.getEntriesOfType(type);
			
			//Filtering of locked items
			entryList = ContentUnlocking.filterLockedItemsOut(entryList);
			
			var sortedList = entryList.sort(_sortFunction);
			
			for (var i:int = 0; i < sortedList.length; i++) {
				var newNode:ScrollListNode = new ScrollListNode(sortedList[i]);
				newNode.scaleX = newNode.scaleY = NODE_SCALE;
				newNode.signalBuyItem.add(buyItemTriggered);
				newNode.signalMouseOver.add(signalMouseOver.dispatch);
				newNode.signalMouseOut.add(signalMouseOut.dispatch);
				_nodeList.push(newNode);
				_container.addChild(newNode);
				newNode.y = i * NODE_SPACING;
			}
			
			
			_maxScroll = -(_nodeList.length * NODE_SPACING - LIST_MASK_HEIGHT);
			if (_maxScroll >= 0) {
				//Nothing to scroll, list is shorter than display space
				_maxScroll = 0;
				_scrollBar.visible = false;
			}else {
				_scrollBar.visible = true;
			}
		}
		
		/** Used only to pass the signal from nodes up */
		protected function buyItemTriggered(entry:RegistryEntry):void {
			if (Math.abs(getTimer() - _buyTimer) >= 1000) {
				Sfx.playCash();
				signalBuyItem.dispatch(entry);
			}
			
			_buyTimer = getTimer();
		}
		
		protected function clearList():void {
			for each(var i:ScrollListNode in _nodeList) {
				i.destroy();
			}
			//signalBuyItem.removeAll();
			_nodeList = new Vector.<ScrollListNode>();
			
			resetScrollPosition();
		}
		
		
		protected function sortByIndex(x:RegistryEntry, y:RegistryEntry):Number {
			if (x.index < y.index) {
				return -1;
			}else if (x.index > y.index) {
				return 1;
			}else {
				return 0;
			}
		}
		
		protected function sortByPrice(x:RegistryEntry, y:RegistryEntry):Number {
			if (x.statCost.valueAt(0) < y.statCost.valueAt(0)) {
				return -1;
			}else if (x.statCost.valueAt(0) > y.statCost.valueAt(0)) {
				return 1;
			}else {
				return 0;
			}
		}
		
		protected function sortByName(x:RegistryEntry, y:RegistryEntry):Number {
			if (x.name < y.name) {
				return -1;
			}else if (x.name > y.name) {
				return 1;
			}else {
				return 0;
			}
		}
		
		public function updateSortMethod(e:Event):void {
			var previousMethod:Function = _sortFunction;
			
			switch(ProfileState.instance.shopSortMethod) {
				case SortButton.EVENT_SORT_BY_PRICE:
					_sortFunction = sortByPrice;
					break;
				case SortButton.EVENT_SORT_BY_NAME:
					_sortFunction = sortByName;
					break;
				case SortButton.EVENT_SORT_BY_MAGIC:
					_sortFunction = sortByIndex;
					break;
				default:
					_sortFunction = sortByPrice;
					break;
			}
			
			if (_sortFunction != previousMethod) {
				clearList();
				loadItemList(_lastLoadedType);
			}
		}
		
		
		public function destroy():void {
			Input.instance.basicCommands.mouseWheelDown.signalCommandDown.remove(scrollUp);
			Input.instance.basicCommands.mouseWheelUp.signalCommandDown.remove(scrollDown);
			Main.unsafeTickSignal.remove(tick);
			_scrollBar.signalScroll.remove(forceScrollPosition);
			
			if(signalBuyItem) signalBuyItem.removeAll();
			if(signalMouseOver) signalMouseOver.removeAll();
			if(signalMouseOut) signalMouseOut.removeAll();
			
			signalBuyItem = null;
			signalMouseOver = null;
			signalMouseOut = null;
			
			for each(var node:ScrollListNode in _nodeList) {
				node.destroy();
			}
			_scrollBar.destroy();
			_scrollBar = null;
			
			_nodeList = null;
			_container = null;
			_scrollBar = null;
			_listMask = null;
			
			_sortFunction = null;
			
			if (stage) parent.removeChild(this);
			while (numChildren >= 1) removeChildAt(0);

		}
		
	}

}