package src.game 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Point;
	import lbg.components.NumberBuffer;
	import lbg.compositetick.ICompositeLeaf;
	import lbg.camera.Camera;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import src.Main;
	import src.game.gameobjects.player.Player;
	import src.system.ProfileState;
	/**
	 * ...
	 * @author 
	 */
	public class GameCamera implements ICompositeLeaf
	{
		protected const Y_OFFSET:Number = 80;//Moves the camera off-center, scales with zoom, diminishes with speed to leave only lead
		protected const ZERO_OFFSET_PLAYER_SPEED:Number = 30;//Speed at which offset = 0
		protected const LEAD:Number = -250;//How much the camera moves off-center depending on player speed and direction
		protected const LEAD_MAX_PLAYER_SPEED:Number = 60;//Speed at which camera leads = 100%
		protected const LEAD_SMOOTHING:Number = 0.05;//Changes speed of applying camera lead
		
		protected static var _instance:GameCamera;
		protected var _cameraObject:Camera;
		protected var _stage:Stage;
		protected var _player:Player;
		
		public static const LAYERS:uint = 11;//Number of layers used for depth, for each fixed and moving
		public static const MAIN_LAYER:uint = 5;//Most likely the middle layer (here 5 in [0,1,2,3,4,5,6,7,8,9])
		protected var _layersMoving:Vector.<GameLayer> = new Vector.<GameLayer>();
		protected var _layersFixed:Vector.<GameLayer> = new Vector.<GameLayer>();
		protected var _previousCameraLead:Number = 0;
		protected var _yOffsetSmoothing:NumberBuffer = new NumberBuffer(30, Y_OFFSET);
		
		public function GameCamera(stage:Stage, gameEngineContainer:DisplayObjectContainer, player:Player) 
		{
			_instance = this;
			_cameraObject = new Camera(stage);
			//_cameraObject.setCameraType(Camera.CIRCULAR_CAMERA);
			//_cameraObject.setElasticity(400, 300);
			//_cameraObject.setElasticity(0, 100);
			_stage = stage;
			_player = player;
			
			for (var i:int = 0; i < LAYERS; i++) {
				_layersFixed.push(new GameLayer(gameEngineContainer));
				var newMoveLayer:GameLayer = new GameLayer(gameEngineContainer);
				_layersMoving.push(newMoveLayer);
				addObjectToMovable(newMoveLayer);
			}
			
			updateZoomLevel();
			onPlayerSpeed(0, 0);
			
			if (ProfileState.instance.cheatUpsideDown) {
				for each(var layer:DisplayObjectContainer in _layersFixed) {
					//layer.scaleY =-1;
					//layer.y = 540;
				}
				for each(var layer:DisplayObjectContainer in _layersMoving) {
					layer.scaleY =-1;
					layer.y = 540;
				}
			}
			
			GameMediator.updatePlayerSpeed.add(onPlayerSpeed);
		}
		
		public static function getPositionOnCamera(object:DisplayObjectContainer):Point {
			var layer:GameLayer = getGameLayerOf(object);
			
			if (!(layer is GameLayer)) {
				throw new Error("getPositionOnCamera() Error - Recursion limit reached and GameLayer not found");
				return new Point();
			}else {
				return DisplayObjectUtil.localToLocal2(object, object.parent, layer);
			}
		}
		
		/** @param	depthOffset <0 to put behind, >0 to put up front */
		public function addChildToFixedLayer(child:DisplayObject, depthOffset:int = 0):void {
			var depth:uint = constrainDepth(MAIN_LAYER + depthOffset);
			_layersFixed[depth].addChild(child);
		}
		
		/** @param	depthOffset <0 to put behind, >0 to put up front */
		public function addChildToFixedLayerRelativeTo(child:DisplayObject, depthRelativeTo:DisplayObject, depthOffset:int = 0):void {
			var baseDepth:uint = getDepthOf(getGameLayerOf(depthRelativeTo));
			var depth:uint = constrainDepth(baseDepth + depthOffset);
			_layersFixed[depth].addChild(child);
		}
		
		/** @param	depthOffset <0 to put behind, >0 to put up front */
		public function addChildToMovingLayer(child:DisplayObject, depthOffset:int = 0):void {
			var depth:uint = constrainDepth(MAIN_LAYER + depthOffset);
			_layersMoving[depth].addChild(child);
		}
		
		/** @param	depthOffset <0 to put behind, >0 to put up front */
		public function addChildToMovingLayerRelativeTo(child:DisplayObject, depthRelativeTo:DisplayObject, depthOffset:int = 0):void {
			var baseDepth:uint = getDepthOf(getGameLayerOf(depthRelativeTo));
			var depth:uint = constrainDepth(baseDepth + depthOffset);
			_layersMoving[depth].addChild(child);
		}
		
		public function getMovingLayer(depthOffset:int = 0):GameLayer {
			var depth:uint = constrainDepth(MAIN_LAYER + depthOffset);
			return _layersMoving[depth];
		}
		
		protected function constrainDepth(depth:uint):uint {
			if (depth < 0) {
				throw new Error("constrainDepth() error - Layer depth < 0");
				return 0;
			}else if (depth > LAYERS) {
				throw new Error("constrainDepth() error - Layer depth [ " + depth + " ] is outside of range " + LAYERS);
				return LAYERS;
			}else {
				return depth;
			}
		}
		
		
		public static function getGameLayerOf(object:DisplayObject):GameLayer {
			var recursive:DisplayObjectContainer = object.parent;
			
			//Using a for loop to prevent endless loop
			for (var i:int = 0; i <= 100; i++) {
				if (recursive == null || recursive is Stage) {
					throw new Error("getGameLayerOf - Trying to get position on an object outside of the GameCamera");
					return p;
				}
				
				if (recursive is GameLayer) {
					//reached camera layer
					break;
				}
				
				recursive = recursive.parent;
			}
			
			if (!(recursive is GameLayer)) {
				throw new Error("getGameLayerOf() Error - Recursion limit reached and GameLayer not reached");
				return null;
			}else {
				return (recursive as GameLayer);
			}
		}
		
		protected function getDepthOf(layer:GameLayer):uint {
			var i:int;
			
			for (i = 0; i < _layersFixed.length; i++) {
				if (layer == _layersFixed[i]) {
					return i;
				}
			}
			
			for (i = 0; i < _layersMoving.length; i++) {
				if (layer == _layersMoving[i]) {
					return i;
				}
			}
			
			throw new Error("getDepthOf() error - specified GameLayer " + layer + " not found in GameCamera.");
			return MAIN_LAYER;
		}
		
		public static function get instance():GameCamera {
			return _instance;
		}
		
		
		
		protected function addObjectToMovable(obj:DisplayObject):void {
			_cameraObject.addObject(obj);
		}
		
		public function tick(delta:Number):void 
		{
			//Camera zoom
			var zoom:Number = targetZoom;
			var smoothedZoom:Number = _layersMoving[0].scaleX + ((targetZoom - _layersMoving[0].scaleX) * 0.01);
			//trace("Zoom:", _player.speed, _player.item.getZoomAtSpeed(_player.speed), smoothedZoom);
			if (ProfileState.instance.cheatUpsideDown) {
				//trace("Zoom goes from", smoothedZoom, "->", -smoothedZoom);
				for each(var l:GameLayer in _layersMoving) {
					l.scaleX = smoothedZoom;
					l.scaleY = -smoothedZoom;
				}
			}else {
				for each(var l:GameLayer in _layersMoving) {
					l.scaleX = l.scaleY = smoothedZoom;
				}
			}
			
			//Camera pan
			var playerPos:Point = new Point(_player.getMovieClip().x, _player.getMovieClip().y);//Use movieclip X/Y to align cam
			//Log.log("playerPos", playerPos.x.toFixed(4), playerPos.y.toFixed(4));
			playerPos = _player.getMovieClip().parent.localToGlobal(playerPos);
			
			_cameraObject.tick(playerPos.x, playerPos.y - StatHooks.cameraYOffset.value, delta);
		}
		
		/** The target zoom value from both the body (affect by speed) and forced by a launcher */
		protected function get targetZoom():Number {
			var targetZoom:Number = _player.item.getZoomAtSpeed(_player.speed);
			
			if (targetZoom >= 1) {
				targetZoom = NumberUtils.interpolate2(1, 4, 1, 3.5, targetZoom, 0.7, true);
			}
			
			targetZoom = Math.max(targetZoom, StatHooks.cameraZoomFloor);
			targetZoom = Math.min(targetZoom, StatHooks.cameraZoomCeil);
			return 1 / targetZoom;
		}
		
		/** Sets the camera zoom at the target zoom value */
		public function updateZoomLevel():void {
			var zoom:Number = targetZoom;
			for each(var l:GameLayer in _layersMoving) {
				l.scaleX = l.scaleY = zoom;
			}
			//trace("Camera zoom:", zoom);
		}
		
		public function centerCam():void {
			var playerPos:Point = new Point(_player.getMovieClip().x, _player.getMovieClip().y);//Use movieclip X/Y to align cam
			//var playerPos:Point = new Point(_player.getPositionX(), _player.getPositionY());//Use NAPE coordinates to align cam
			playerPos = _player.getMovieClip().parent.localToGlobal(playerPos);
			_cameraObject.centerCameraAt(playerPos.x, playerPos.y);
		}
		
		protected function onPlayerSpeed(speed:Number, angle:Number):void {
			var offsetX:Number = 0;
			var offsetY:Number = 0;
			
			//Camera leading the player to open FOV
			//trace("Speed:", speed);
			var preparedSpeed:Number = NumberUtils.constrain(speed, 0, LEAD_MAX_PLAYER_SPEED);
			var lead:Number = NumberUtils.interpolate2(0, LEAD, 0, LEAD_MAX_PLAYER_SPEED, Math.abs(preparedSpeed), 0.7, true);
			
			//disabled smoothing as it's causing the jittery feeling when changin direction 180 degrees
			//var smoothLead:Number = _previousCameraLead + ((lead - _previousCameraLead) * LEAD_SMOOTHING);
			var smoothLead:Number = lead;
			_previousCameraLead = smoothLead;
			
			var leadX:Number = Trig.vectorX(smoothLead, angle);
			var leadY:Number = Trig.vectorY(smoothLead, angle);
			
			//Reduce offset as speed increases since lead takes care of that
			var yOffset:Number = NumberUtils.interpolate2(Y_OFFSET, 0, 0, Y_OFFSET, Math.abs(_previousCameraLead), 0.6);
			_yOffsetSmoothing.add(yOffset);
			
			
			if (_stage.fullScreenSourceRect) {
				_cameraObject.setCenter(_stage.fullScreenSourceRect.width / 2  + leadX + offsetX, _stage.fullScreenSourceRect.height / 2 + leadY + offsetY + _yOffsetSmoothing.value);
			}else {
				_cameraObject.setCenter(Main.visibleStageWidth / 2  + leadX + offsetX, Main.visibleStageHeight / 2 + leadY + offsetY + _yOffsetSmoothing.value);
			}
			
		}
		
		public function destroy():void {
			_instance = null;
			_cameraObject.destroy();
			_cameraObject = null;
			_stage = null;
			_player = null;
			
			for each(var i:GameLayer in _layersMoving) {
				DisplayObjectUtil.removeAllChildFrom(i, true);
			}
			
			for each(i in _layersFixed) {
				DisplayObjectUtil.removeAllChildFrom(i, true);
			}
			
			_layersMoving = null;
			_layersFixed = null;
		}
		
	}

}