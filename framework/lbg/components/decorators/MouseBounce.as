package lbg.components.decorators {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import lbg.debug.Log;
	import lbg.utils.Easing;
	import org.osflash.signals.Signal;
	/**
	 * This version hitTests the target every mouse move to try to prevent roll over/out loops
	 * @author 
	 */
	public class MouseBounce 
	{
		protected var _target:DisplayObject;
		/** Default = 0.1 */
		public var scaleMod:Number = 0.1;
		public var durationIn:Number = 10;
		public var durationOut:Number = 15;
		
		protected var _enabled:Boolean = true;
		protected var _initialScale:Number;
		protected var _mouseIsOver:Boolean = false;
		protected var _mouseJustUp:Boolean = false;//Used to skip the extra onOver signal when mouse is up
		protected var _mouseIsDown:Boolean = false;
		protected var _animTime:Number = durationOut;
		protected var _scaleOutStart:Number;
		/** When mouse gets over the target. (target:DisplayObject) */
		protected var _signalOverTarget:Signal = new Signal(DisplayObject);
		/** When mouse gets out of the target. (target:DisplayObject) */
		protected var _signalOutTarget:Signal = new Signal(DisplayObject);
		/** When target is clicked, safer than click event. (target:DisplayObject) */
		protected var _signalClickTarget:Signal = new Signal(DisplayObject);
		
		protected var _tickFromEnterFrame:Boolean;
		
		public function MouseBounce(target:DisplayObject, tickFromEnterFrame:Boolean = true) 
		{
			_target = target;
			
			_initialScale = _target.scaleX;
			_tickFromEnterFrame = tickFromEnterFrame;
			
			if (_target && _target.stage) {
				addedToStage(null);
			}else {
				_target.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		
		private function addedToStage(e:Event):void 
		{
			_target.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			
			if (_enabled) {
				_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				_target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				_target.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			}
			
			if (_tickFromEnterFrame) _target.addEventListener(Event.ENTER_FRAME, onTargetEnterFrame);
		}
		
		private function onTargetEnterFrame(e:Event):void 
		{
			tick(1);
		}
		
		protected function tick(delta:Number):void 
		{
			if (destroyIfNoTarget()) return;
			
			if (_mouseIsDown == false) {
				if (_mouseIsOver && _animTime < durationIn) {
					_animTime += 1;
					_target.scaleX = _target.scaleY = Easing.easeOutBack(_animTime, _initialScale, scaleMod, durationIn);
				}else if (!_mouseIsOver && _animTime < durationOut) {
					_animTime += 1;
					_target.scaleX = _target.scaleY = Easing.easeBothInOutQuad(_animTime, _scaleOutStart, -(_scaleOutStart - _initialScale), durationOut);
				}
			}
			
			_mouseJustUp = false;
		}
		
		private function mouseUp(e:MouseEvent):void 
		{
			if (destroyIfNoTarget()) return;
			
			//Safe click mechanics
			if (_mouseIsDown) {
				//HitTest at biggest scale
				var savedScale:Number = _target.scaleX;
				_target.scaleX = _target.scaleY = _initialScale + scaleMod;
				
				if (mouseHitsTarget()) {
					//trace("target clicked");
					_signalClickTarget.dispatch(_target);
				}else {
					_target.scaleX = _target.scaleY = savedScale;
				}
			}
			
			
			
			_mouseIsDown = false;
			_mouseIsOver = mouseHitsTarget();
			//_mouseIsOver = false;//Reset to force a re-check of mouse position
			_mouseJustUp = true;
			checkMousePosition(true);
		}
		
		private function mouseDown(e:MouseEvent):void 
		{
			if (destroyIfNoTarget()) return;
			_mouseIsDown = true;
			_target.scaleX = _target.scaleY = _initialScale - scaleMod * 0.5;
		}
		
		private function mouseMove(e:MouseEvent):void 
		{
			if (destroyIfNoTarget()) return;
			checkMousePosition();
		}
		
		public function mouseHitsTarget():Boolean {
			if (_target == null || _target.stage == null) {
				return false;
			}
			
			return (_target.hitTestPoint(_target.stage.mouseX, _target.stage.mouseY, false));
			//return (_target.getBounds(_target.stage).contains(_target.stage.mouseX, _target.stage.mouseY));
			
			//if (_target.hitTestPoint(_target.stage.mouseX, _target.stage.mouseY, false)) {//Works, but only rect shape
			//if (_target.hitTestPoint(_target.stage.mouseX, _target.stage.mouseY, true)) {//Loops
			//if (_target.getBounds(_target.stage).contains(_target.stage.mouseX, _target.stage.mouseY)) {//Works, but only rect shape
		}
		
		public function checkMousePosition(forceAnimation:Boolean = false):void {
			if (_target == null || _target.stage == null) {
				//throw new Error("MouseBounce2 checkMousePosition() ERROR - Target or stage is null. Target = " + String(_target));
				destroy();
				return;
			}
			
			if (mouseHitsTarget()) {//Works, but only rect shape
				if (_mouseIsOver == false) {
					if (_mouseJustUp == false) {
						//trace("_signalOverTarget.dispatch");
						_signalOverTarget.dispatch(_target);
					}else {
						_mouseJustUp = false;
					}
				}
				if (_mouseIsOver == false || forceAnimation) {
					_mouseIsOver = true;
					_animTime = 0;
				}
			}else {
				if (_mouseIsOver == true) {
					_signalOutTarget.dispatch(_target);
				}
				if (_mouseIsOver == true || forceAnimation) {
					_mouseIsOver = false;
					_animTime = 0;
					_scaleOutStart = _target.scaleX;
				}
			}
		}
		
		public function destroyIfNoTarget():Boolean {
			if (_target == null) {
				//HACK - For some reason signals are received after being removed from list
				//This only happens ONCE after destroy and seems unlinked to the destroy process
				//This is probably because the signal list is not updated "mid-dispatch", hence the items cleared from list are still fired
				destroy();
				return true;
			}else {
				return false;
			}
		}
		
		/** When mouse gets over the target. (target:DisplayObject) */
		public function get signalOverTarget():Signal 
		{
			return _signalOverTarget;
		}
		
		/** When mouse gets out of the target. (target:DisplayObject) */
		public function get signalOutTarget():Signal 
		{
			return _signalOutTarget;
		}
		
		/** When target is clicked, safer than click event. (target:DisplayObject) */
		public function get signalClickTarget():Signal 
		{
			return _signalClickTarget;
		}
		
		public function get mouseIsOver():Boolean 
		{
			return _mouseIsOver;
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			
			if (_enabled) {
				if (_target && _target.stage) {
					_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
					_target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
					_target.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				}
			}else {
				if (_target && _target.stage) {
					_target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
					_target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
					_target.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
				}
			}
		}
		
		public function destroy():void {
			
			if (_target) {
				_target.addEventListener(Event.ENTER_FRAME, onTargetEnterFrame);
				_target.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				if (_target.stage) {
					_target.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
					_target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				}
				_target = null;
			}
			
			if(_signalOutTarget) _signalOutTarget.removeAll();
			_signalOutTarget = null;
			
			if(_signalOverTarget) _signalOverTarget.removeAll();
			_signalOverTarget = null;
			
			if(_signalClickTarget) _signalClickTarget.removeAll();
			_signalClickTarget = null;
			
			//trace("Destroyed", this);
		}
		
		
	}

}