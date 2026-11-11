package src.shop 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import src.audio.Sfx;
	import src.system.GameStateItem;
	import src.system.Input;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class SlotDragArrow extends MovieClip 
	{
		public var body:MovieClip;
		public var head:MovieClip;
		public var from:MovieClip;
		public var ringFrom:MovieClip;
		public var ringTo:MovieClip;
		
		protected var _startSlot:Slot;
		protected var _targetSlot:Slot;
		
		protected var _tintMult:Number = 1;
		
		//protected var _baseX:Number;
		//protected var _baseY:Number;
		
		
		public function SlotDragArrow(startSlot:Slot, container:DisplayObjectContainer, baseX:Number, baseY:Number) 
		{
			_startSlot = startSlot;
			
			container.addChild(this);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			body.x = baseX;
			body.y = baseY;
			ringFrom.x = startBoxPosition.x;
			ringFrom.y = startBoxPosition.y;
			ringTo.visible = false;
			updateArrow(baseX, baseY, false);
			
			ShopMediator.slotOverSignal.add(overSlot);
			ShopMediator.slotOutSignal.add(outOfSlot);
			
			mouseEnabled = false;
			mouseChildren = false;
			
			removeTargetSlot();
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if (_targetSlot) {
				if (Input.instance.isKeyDown(16) && _startSlot.isEmpty == false && _targetSlot.isEmpty) {
					//Quickcopy
					//Do copy
					if (ShopEngine.duplicateItem(_startSlot, _targetSlot)) {
						Sfx.playCashLow();
					}
				}else {
					//Do swap
					var item1:GameStateItem = _startSlot.getItem();
					var item2:GameStateItem = _targetSlot.getItem();
					ProfileState.instance.currentGameState.swapItems(item1, item2);
				}
				ShopEngine.instance.loadFromState();
			}
			
			destroy();
		}
		
		private function outOfSlot(slot:Slot):void 
		{
			DisplayObjectUtil.setObjectTint(slot, 0, 0);
			removeTargetSlot();
			updateTints();
		}
		
		private function overSlot(slot:Slot):void 
		{
			if (slot == _startSlot) {
				removeTargetSlot();
			}else {
				setTargetSlot(slot);
			}
			updateTints();
		}
		
		protected function setTargetSlot(slot:Slot):void {
			_targetSlot = slot;
			ringTo.visible = true;
			ringTo.x = targetBoxPosition.x;
			ringTo.y = targetBoxPosition.y;
		}
		
		protected function removeTargetSlot():void {
			if (_targetSlot) {
				DisplayObjectUtil.setObjectTint(_targetSlot, 0, 0);
			}
			_targetSlot = null;
			ringTo.visible = false;
			updateTints();
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			updateArrow(e.stageX, e.stageY);
		}
		
		protected function get targetBoxPosition():Point {
			if (_targetSlot) {
				return DisplayObjectUtil.localToLocal2(_targetSlot.box, _targetSlot.box.parent, this);
			}else {
				return new Point();
			}
		}
		
		protected function get startBoxPosition():Point {
			if (_startSlot) {
				return DisplayObjectUtil.localToLocal2(_startSlot.box, _startSlot.box.parent, this);
			}else {
				return new Point();
			}
		}
		
		protected function updateTints():void {
			if (_targetSlot) {
				if (_startSlot.getItem().type == _targetSlot.getItem().type) {
					if (_targetSlot != _startSlot) {
						//Valid swap target
						DisplayObjectUtil.setObjectTint(this, 0, 0);
						DisplayObjectUtil.setObjectTint(_startSlot, 0x00FF00, 0.35 * _tintMult);
						DisplayObjectUtil.setObjectTint(_targetSlot, 0x00FF00, 0.35 * _tintMult);
					}else {
						//Targetting self
						DisplayObjectUtil.setObjectTint(this, 0xFFDD00, 0.85);
						DisplayObjectUtil.setObjectTint(_startSlot, 0xFFDD00, 0.35 * _tintMult);
					}
				}else {
					//Invalid swap target
					DisplayObjectUtil.setObjectTint(this, 0xFF0000, 0.75);
					DisplayObjectUtil.setObjectTint(_startSlot, 0xFF0000, 0.35 * _tintMult);
					DisplayObjectUtil.setObjectTint(_targetSlot, 0xFF0000, 0.35 * _tintMult);
				}
			}else {
				//No target
				DisplayObjectUtil.setObjectTint(this, 0xFFDD00, 0.85);
				DisplayObjectUtil.setObjectTint(_startSlot, 0xFFDD00, 0.35 * _tintMult);
			}
			
			ringFrom.alpha = ringTo.alpha = _tintMult * 0.3;
		}
		
		protected function updateArrow(X:Number, Y:Number, globalCoordinates:Boolean = true):void {
			var start:Point;
			var end:Point;
			var dis:Number;
			var angle:Number;
			var scale:Number;
			
			start = new Point(body.x, body.y);
			end = new Point(X, Y);
			if(globalCoordinates) end = parent.globalToLocal(end);
			dis = Point.distance(start, end);
			angle = Trig.angleTo(start.x, start.y, end.x, end.y);
			scale = NumberUtils.interpolate2(0, 1, 0, 47, dis, 1, true);
			_tintMult = (_targetSlot == null) ? scale:1;
			updateTints();
			
			body.rotation = angle;
			
			head.rotation = angle;
			head.x = end.x;
			head.y = end.y;
			
			from.rotation = angle - 180;
			from.x = start.x;
			from.y = start.y;
			
			
			body.alpha = head.alpha = from.alpha = scale;
			head.scaleX = head.scaleY = scale;
			from.scaleX = from.scaleY = scale;
			body.scaleY = scale;
			body.scaleX = (dis - (23 * scale)) / 203;//Stretches the body reach the arrow head
			_startSlot.highlight.alpha = 1;
		}
		
		public function destroy():void {
			removeTargetSlot();
			DisplayObjectUtil.setObjectTint(_startSlot, 0, 0);
			_startSlot.highlight.alpha = 0.2;
			
			_startSlot = null;
			_targetSlot = null;
			body = null;
			head = null;
			from = null;
			ringFrom = null;
			ringTo = null;
			ShopMediator.slotOverSignal.remove(overSlot);
			ShopMediator.slotOutSignal.remove(outOfSlot);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			if (stage) parent.removeChild(this);
		}
		
	}

}