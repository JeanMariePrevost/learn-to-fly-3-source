package lbg.camera.cameratype 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.geom.Point;
	import lbg.debug.Log;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.Main;
	/**
	 * ...
	 * @author 
	 */
	public class AbstractCameraType implements ICameraType
	{
		/** Threshold to force an instant centering of the camera on the target, default 0.01 */
		protected const MOVEMENT_THRESHOLD:Number = 0.01;
		protected var _movableObjects:Vector.<MovableObject> = new Vector.<MovableObject>();
		protected var _elasticity:Point = new Point();
		protected var _neutralZone:Point = new Point();
		protected var _center:Point = new Point();
		protected var _easePower:Number = 1;
		protected var _minEasing:Number = 0.1;
		protected var _maxEasing:Number = 0.5;
		protected var _minMovement:Number = 0.09;//minimum camera move speed, can be used for stable movemnt speed
		protected var _stage:Stage;
		
		public function AbstractCameraType(stage:Stage) 
		{
			_stage = stage;
			
			setCenter(_stage.stageWidth / 2, _stage.stageHeight / 2);
			
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onStageResize);
		}
		
		private function onStageResize(e:FullScreenEvent):void 
		{
			if (e.fullScreen) {
				setCenter(_stage.fullScreenSourceRect.width / 2, _stage.fullScreenSourceRect.height / 2);
			}else {
				setCenter(720 / 2, 540 / 2);
				//setCenter(Main.visibleStageWidth / 2, Main.visibleStageHeight / 2);
			}
		}
		
		public function addObject(obj:DisplayObject, xParallax:Number, yParallax:Number):void 
		{
			if (_movableObjects.indexOf(obj) != -1) return;
			var newObject:MovableObject = new MovableObject(obj, xParallax, yParallax);
			_movableObjects.push(newObject);
		}
		
		public function setCenter(X:Number, Y:Number):void 
		{
			_center.x = X;
			_center.y = Y;
			
			//Log.log("setCenter", X.toFixed(1), Y.toFixed(1));
		}
		
		public function setElasticity(horizontal:Number, vertical:Number):void 
		{
			_elasticity.x = horizontal;
			_elasticity.y = vertical;
		}
		
		public function setEasing(power:Number, minEasing:Number = 0.1, maxEasing:Number = 0.5, minMovement:Number = 0.09):void {
			_easePower = power;
			_minEasing = minEasing;
			_maxEasing = maxEasing;
			_minMovement = minMovement;
		}
		
		public function setNeutralZone(horizontal:Number, vertical:Number):void 
		{
			horizontal = Math.max(horizontal, 0);
			vertical = Math.max(vertical, 0);
			_neutralZone.x = horizontal;
			_neutralZone.y = vertical;
		}
		
		public function tick(targetX:Number, targetY:Number, delta:Number = 1):void 
		{
			//this is where each camera type makes its own algorythm
		}
		
		public function centerCameraAt(targetX:Number, targetY:Number):void {
			if (isCentered(targetX, targetY)) return;
			//trace("Camera centered!");
			var X:Number = _center.x - targetX;
			var Y:Number = _center.y - targetY;
			moveObjectsBy(X,Y);
		}
		
		protected function moveObjectsBy(X:Number, Y:Number):void {
			if ((X == 0) && (Y == 0)) return;
			for each(var i:MovableObject in _movableObjects) {
				i.moveObject(X, Y);
			}
		}
		
		protected function isCentered(X:Number, Y:Number):Boolean {
			return ((X == _center.x) && (Y == _center.y));
		}
		
		public function copyConfigTo(camera:ICameraType):ICameraType 
		{
			camera.setCenter(_center.x, _center.y);
			camera.setElasticity(_elasticity.x, _elasticity.y);
			camera.setNeutralZone(_neutralZone.x, _neutralZone.y);
			return camera;
		}
		
		protected function interpolate(minValue:Number, maxValue:Number, lowPosition:Number = 0, highPosition:Number = 1, position:Number = 0.5, power:Number = 1):Number {
			return NumberUtils.interpolate2(minValue, maxValue, lowPosition, highPosition, position, power, true);
		}
		
	}

}