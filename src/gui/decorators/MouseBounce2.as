package src.gui.decorators {
	import com.gskinner.geom.ColorMatrix;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import lbg.collisiondetection.CollisionDetection;
	import lbg.debug.Log;
	import lbg.utils.ArrayUtils;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import org.osflash.signals.Signal;
	import src.gui.GuiSettings;
	/**
	 * This version hitTests the target every mouse move to try to prevent roll over/out loops
	 * @author 
	 */
	public class MouseBounce2 
	{
		protected var _target:DisplayObject;
		protected var _targetHitBox:DisplayObject;
		/** Default = 0.1 */
		public var scaleMod:Number = 0.1;
		public var durationIn:Number = 10;
		public var durationOut:Number = 15;
		public var enableMouseDownAnim:Boolean = true;
		
		/** If a mask is specified, collision must be done for both the mask AND the target. Only rect areas for masks */
		public var mask:DisplayObject;
		
		/** Color effect when mouse if over */
		public var colorWhenOver:ColorMatrix = new ColorMatrix();
		/** Color effect when mouse if down */
		public var colorWhenDown:ColorMatrix = new ColorMatrix();
		protected var _colorOverFilter:ColorMatrixFilter;
		protected var _colorDownFilter:ColorMatrixFilter;
		
		/** Flase for square hit, true for actual shape. Best used with a filled hitbox on intricate shapes */
		public var useObjectShape:Boolean = false;
		
		protected var _enabled:Boolean = true;
		protected var _initialScaleX:Number;
		protected var _initialScaleY:Number;
		protected var _mouseIsOver:Boolean = false;
		protected var _mouseJustUp:Boolean = false;//Used to skip the extra onOver signal when mouse is up
		protected var _mouseIsDown:Boolean = false;
		protected var _animTime:Number = durationOut;
		protected var _scaleOutStartX:Number;
		protected var _scaleOutStartY:Number;
		protected var _useRollOverEvent:Boolean;
		protected var _useLocalMouseDown:Boolean;
		/** When mouse gets over the target. (target:DisplayObject) */
		protected var _signalOverTarget:Signal = new Signal(DisplayObject);
		/** When mouse gets out of the target. (target:DisplayObject) */
		protected var _signalOutTarget:Signal = new Signal(DisplayObject);
		/** When target is clicked, safer than click event. (target:DisplayObject) */
		protected var _signalClickTarget:Signal = new Signal(DisplayObject);
		
		/**
		 * @param	target The DisplayObject affected by the effect
		 * @param	useRollOverEvent Use "onRollOver" instead of hitbox detection, used to prevent onOver through other objects
		 * @param	useSeparateHitBox Use another DisplayObject as hitbox
		 * @param	useLocalMouseDown False to use stage-wide, enabling clicks through other objects
		 */
		public function MouseBounce2(target:DisplayObject, useRollOverEvent:Boolean = false, useSeparateHitBox:DisplayObject = null, useLocalMouseDown:Boolean = true) 
		{
			_target = target;
			_targetHitBox = target;
			if (useSeparateHitBox != null) {
				_targetHitBox = useSeparateHitBox;
			}
			
			_useRollOverEvent = useRollOverEvent;
			_useLocalMouseDown = useLocalMouseDown;
			_initialScaleX = _target.scaleX;
			_initialScaleY = _target.scaleY;
			_scaleOutStartX = _target.scaleX;
			_scaleOutStartY = _target.scaleY;
			
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
				if (_useRollOverEvent) _targetHitBox.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				
				_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				
				if (_useLocalMouseDown) {
					_targetHitBox.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				}else {
					_target.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				}
				
				//_target.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				_target.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			}
			GuiSettings.guiTickSignal.add(tick);
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			if (destroyIfNoTarget()) return;
			if (enabled == false) return;
			
			//trace("MouseBounce2.onRollOver", Math.random());
			
			_signalOverTarget.dispatch(_target);
			if (_mouseIsOver == false) {
				_mouseIsOver = true;
				_animTime = 0;
				_scaleOutStartX = _target.scaleX;
				_scaleOutStartY = _target.scaleY;
				checkColorEffect();
			}
			_mouseIsOver = true;
		}
		
		protected function tick(delta:Number):void 
		{
			if (destroyIfNoTarget()) return;
			if (enabled == false) return;
			
			if (_mouseIsDown == false) {
				if (_mouseIsOver && _animTime < durationIn) {
					_animTime += 1;
					_target.scaleX = Easing.easeOutBack(_animTime, _initialScaleX, scaleMod, durationIn);
					_target.scaleY = Easing.easeOutBack(_animTime, _initialScaleY, scaleMod, durationIn);
				}else if (!_mouseIsOver && _animTime < durationOut) {
					_animTime += 1;
					_target.scaleX = Easing.easeBothInOutQuad(_animTime, _scaleOutStartX, -(_scaleOutStartX - _initialScaleX), durationOut);
					_target.scaleY = Easing.easeBothInOutQuad(_animTime, _scaleOutStartY, -(_scaleOutStartY - _initialScaleY), durationOut);
				}
			}
			
			if (isNaN(_target.scaleX) || isNaN(_target.scaleY)) {
				_target.scaleX = _initialScaleX;
				_target.scaleY = _initialScaleY;
			}
			
			_mouseJustUp = false;
		}
		
		private function mouseUp(e:MouseEvent):void 
		{
			if (destroyIfNoTarget()) return;
			if (enabled == false) return;
			
			//trace("MouseBounce2.mouseUp()");
			
			//Safe click mechanics
			if (_mouseIsDown) {
				//HitTest at biggest scale
				var savedScaleX:Number = _target.scaleX;
				var savedScaleY:Number = _target.scaleY;
				_target.scaleX = _initialScaleX + scaleMod;
				_target.scaleY = _initialScaleY + scaleMod;
				
				if (mouseHitsTarget()) {
					//trace("MouseBounce2.mouseUp() -> target clicked");
					_signalClickTarget.dispatch(_target);
				}else {
					_target.scaleX = savedScaleX;
					_target.scaleY = savedScaleY;
				}
				
				
				checkMousePosition(true);
			}
			
			
			
			_mouseIsDown = false;
			_mouseIsOver = mouseHitsTarget();
			//_mouseIsOver = false;//Reset to force a re-check of mouse position
			_mouseJustUp = true;
			checkColorEffect();
		}
		
		private function mouseDown(e:MouseEvent):void 
		{
			if (destroyIfNoTarget()) return;
			if (enabled == false) return;
			
			//trace("MouseBounce2.mouseDown()");
			
			if (enableMouseDownAnim && _mouseIsOver) {
				_mouseIsDown = true;
				_target.scaleX = _initialScaleX - scaleMod * 0.5;
				_target.scaleY = _initialScaleY - scaleMod * 0.5;
				checkColorEffect();
			}
		}
		
		private function mouseMove(e:MouseEvent):void 
		{
			if (destroyIfNoTarget()) return;
			if (enabled == false) return;
			
			if (_useRollOverEvent) {
				if (_mouseIsOver == true) checkMousePosition();
			}else {
				checkMousePosition();
			}
		}
		
		public function mouseHitsTarget():Boolean {
			if (_target == null || _target.stage == null || _targetHitBox == null || _targetHitBox.stage == null) {
				return false;
			}
			
			var hit:Boolean = (_targetHitBox.hitTestPoint(_targetHitBox.stage.mouseX, _targetHitBox.stage.mouseY, useObjectShape));
			
			if (hit && mask) {
				if (!mask.hitTestPoint(_target.stage.mouseX, _target.stage.mouseY, false)) {
					hit = false;
				}
			}
			
			return hit;
			
		}
		
		public function checkMousePosition(forceAnimation:Boolean = false):void {
			if (destroyIfNoTarget()) return;
			if (enabled == false) return;
			
			if (mouseHitsTarget()) {
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
					_scaleOutStartX = _target.scaleX;
					_scaleOutStartY = _target.scaleY;
					checkColorEffect();
				}
			}else {
				if (_mouseIsOver == true) {
					//Last time, mouse WAS over, now it isn't. Mouse just went out.
					//This is only for the signal
					_signalOutTarget.dispatch(_target);
				}
				
				if (_mouseIsOver == true || forceAnimation) {
					//Mouse just out, this is for the anim stuff
					_mouseIsOver = false;
					_animTime = 0;
					_scaleOutStartX = _target.scaleX;
					_scaleOutStartY = _target.scaleY;
					checkColorEffect();
				}
			}
		}
		
		protected function checkColorEffect():void {
			if (destroyIfNoTarget()) return;
			
			if (colorWhenOver.isDefault && colorWhenDown.isDefault) return;
			
			var f:Array = _target.filters;
			
			if (_mouseIsDown && !colorWhenDown.isDefault) {
				if (!_colorDownFilter) {
					_colorDownFilter = new ColorMatrixFilter(colorWhenDown);
				}
				
				if (targetHasBrightnessFilter(_colorDownFilter) == false) {
					f.push(_colorDownFilter);
					_target.filters = f;
				}
			}else if (_colorDownFilter) {
				for each(var cmf:ColorMatrixFilter in f) {
					if (matricesAreEqual(cmf.matrix, _colorDownFilter.matrix)) {
						ArrayUtils.removeFromArray(f, cmf);
						_target.filters = f;
					}
				}
			}
			
			if (_mouseIsDown == false && _mouseIsOver && !colorWhenOver.isDefault) {
				if (!_colorOverFilter) {
					_colorOverFilter = new ColorMatrixFilter(colorWhenOver);
				}
				
				if (targetHasBrightnessFilter(_colorOverFilter) == false) {
					f.push(_colorOverFilter);
					_target.filters = f;
				}
			}else  if (_colorOverFilter) {
				for each(var cmf:ColorMatrixFilter in f) {
					if (matricesAreEqual(cmf.matrix, _colorOverFilter.matrix)) {
						ArrayUtils.removeFromArray(f, cmf);
						_target.filters = f;
					}
				}
			}
		}
		
		protected function targetHasBrightnessFilter(filter:ColorMatrixFilter):Boolean {
			var f:Array = _target.filters;
			
			for each(var cmf:ColorMatrixFilter in f) {
				if (matricesAreEqual(cmf.matrix, filter.matrix)) {
					return true;
				}
			}
			
			return false;
		}
		
		protected function matricesAreEqual(mat1:Array, mat2:Array):Boolean {
			return (mat1.join() == mat2.join());
		}
		
		public function destroyIfNoTarget():Boolean {
			if (_target == null || _targetHitBox == null) {
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
				if (_targetHitBox && _targetHitBox.stage) {
					_targetHitBox.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
					_targetHitBox.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
					_targetHitBox.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				}
			}else {
				if (_targetHitBox && _targetHitBox.stage) {
					_targetHitBox.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
					_targetHitBox.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
					_targetHitBox.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
				}
			}
		}
		
		public function get target():DisplayObject 
		{
			return _target;
		}
		
		public function destroy():void {
			GuiSettings.guiTickSignal.remove(tick);
			
			if(_signalOutTarget) _signalOutTarget.removeAll();
			_signalOutTarget = null;
			
			if(_signalOverTarget) _signalOverTarget.removeAll();
			_signalOverTarget = null;
			
			if(_signalClickTarget) _signalClickTarget.removeAll();
			_signalClickTarget = null;
			
			
			if(_target) _target.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			if (_targetHitBox) {
				_targetHitBox.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
				_targetHitBox.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				_targetHitBox.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				
				if (_targetHitBox.stage) {
					_targetHitBox.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
					_targetHitBox.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
					_targetHitBox.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				}
			}
			
			_target = null;
			_targetHitBox = null;
			mask = null;
			
			colorWhenOver = null;
			colorWhenDown = null;
			_colorOverFilter = null;
			_colorDownFilter = null;
			
		}
		
		
	}

}