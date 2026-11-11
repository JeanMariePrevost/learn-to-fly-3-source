package src.game.gameobjects.environment 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import lbg.effects.MotionBlurWrapper;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	import org.osflash.signals.Signal;
	import src.game.GameCamera;
	import src.game.GameEngine;
	import src.game.GameMediator;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	internal class CloudsNode extends Sprite
	{
		public var signalReset:Signal = new Signal(CloudsNode);
		
		public var hideAfterReset:Boolean = false;//If set to true, cloud will not be visible after a reset, used to hide clouds in space
		
		protected const MIN_TINT:Number = 0;
		protected const MAX_TINT:Number = 0.7;
		protected const TINT_EASING:Number = 1.25;
		
		protected const LAST_CLOUD_FRAME:uint = 17;//Last frame in MC which is a cloud and not "space dust"
		
		protected var _visual:MovieClip = new DebugCloudsVisual();
		protected var _minScale:Number;
		protected var _maxScale:Number;
		protected var _ownSpeed:Number = 0;
		
		protected var _basicBlurFilter:BlurFilter;
		protected var _basicBlurMult:Number = 1.5;
		protected var _basicBlurSpeed:Number = 0.1;
		protected var _basicBlurSwitchThreshold:Number = 1.25;//How far into the other direction the ratio must go before switching to vert/hori blurring
		protected var _basicBlurX:Number = 0;//Not settings, runtime
		protected var _basicBlurY:Number = 0;//Not settings, runtime
		protected var _directionalBlur:MotionBlurWrapper;
		protected var _stageRect:Rectangle = new Rectangle(0, 0, 720, 540);
		
		protected var _tintAmount:Number = 0;
		
		public function CloudsNode(viewDiag:Number, spawnDiag:Number, center:Point, minScale:Number, maxScale:Number) 
		{
			addChild(_visual);
			_minScale = minScale;
			_maxScale = maxScale;
			resetCloudsNode(viewDiag, spawnDiag, center, false);
			
			initMotionBlur();
		}
		
		protected function initMotionBlur():void {
			if (ProfileState.instance.optionClouds == "High (blur)") {
				_basicBlurFilter = new BlurFilter(0, 0, 1);
				GameMediator.updatePlayerMove.add(basicBlurVertical);
			}else if (ProfileState.instance.optionClouds == "Best (blur)") {
				GameMediator.updatePlayerSpeed.add(directionalBlur);
				_directionalBlur = new MotionBlurWrapper(this);
				_directionalBlur.blurStartSpeed = 5;
				_directionalBlur.blurEndSpeed = 50;
				_directionalBlur.blurEasePower = 0.9;
				_directionalBlur.blurMaxStrength = 110;
				_directionalBlur.forceBlur();//Render without blur first
			}
		}
		
		public function tick(delta:Number, viewDiag:Number, spawnDiag:Number, center:Point):void {
			var distance:Number = NumberUtils.distanceBetween(x, y, center.x, center.y);
			if (distance <= (spawnDiag + nodeRadius)) {
				//Do cloud stuff
			}else {
				resetCloudsNode(viewDiag, spawnDiag, center, true);
			}
		}
		
		public function basicBlurVertical(speedX:Number, speedY:Number):void {
			if (visible) {
				if (_visual.currentFrame <= LAST_CLOUD_FRAME) {
					var blurX = 0;
					var blurY = Math.abs(speedY * _basicBlurMult);
					
					_basicBlurX += (blurX - _basicBlurX) * _basicBlurSpeed;
					_basicBlurY += (blurY - _basicBlurY) * _basicBlurSpeed;
					
					_basicBlurFilter.blurX = _basicBlurX;
					_basicBlurFilter.blurY = _basicBlurY;
					
					_visual.filters = [_basicBlurFilter];
					
					if (Math.abs(speedX / speedY) >= _basicBlurSwitchThreshold) {
						GameMediator.updatePlayerMove.remove(basicBlurVertical);
						GameMediator.updatePlayerMove.add(basicBlurHorizontal);
					}
				}else {
					_visual.filters = [];
				}
			}
		}
		
		public function basicBlurHorizontal(speedX:Number, speedY:Number):void {
			if(visible){
				if (_visual.currentFrame <= LAST_CLOUD_FRAME) {
					var blurX = Math.abs(speedX * _basicBlurMult);
					var blurY = 0;
					
					_basicBlurX += (blurX - _basicBlurX) * _basicBlurSpeed;
					_basicBlurY += (blurY - _basicBlurY) * _basicBlurSpeed;
					
					_basicBlurFilter.blurX = _basicBlurX;
					_basicBlurFilter.blurY = _basicBlurY;
					
					_visual.filters = [_basicBlurFilter];
					
					if (Math.abs(speedY / speedX) >= _basicBlurSwitchThreshold) {
						GameMediator.updatePlayerMove.remove(basicBlurHorizontal);
						GameMediator.updatePlayerMove.add(basicBlurVertical);
					}
				}else {
					_visual.filters = [];
				}
			}
		}
		
		
		public function directionalBlur(speed:Number, angle):void {
			if (alpha < 1 || !visible) return;//Clouds in front of player are really big and costly to blur, skip them
			
			var r:Rectangle = getRect(stage);
			if (r.intersects(_stageRect)) {
				//trace(speed);
				_directionalBlur.blurFromDisplacement(speed, Trig.toRadians(angle));
			}
			
		}
		
		public function resetCloudsNode(viewDiag:Number, spawnDiag:Number, center:Point, outsideFOV:Boolean = true):void {
			if (hideAfterReset) {
				_visual.gotoAndStop(NumberUtils.randomRange(LAST_CLOUD_FRAME + 1, _visual.totalFrames, true));
			}else {
				_visual.gotoAndStop(NumberUtils.randomRange(1, LAST_CLOUD_FRAME, true));
			}
			
			//if (_directionalBlur) {
				//_directionalBlur.putBackCachedVisual(this);
			//}
			
			//reset scale
			var scale:Number = NumberUtils.randomRange(_minScale, _maxScale);
			_visual.scaleX = _visual.scaleY = scale;
			
			//Mirror chance
			if (Math.random() <= 0.5) {
				if (_visual.currentFrame == 17) {
					//"Senpai" cloud, don't flip because text
					_visual.scaleX = Math.abs(_visual.scaleX);
				}else {
					_visual.scaleX = -_visual.scaleX;
				}
			}
			
			//Tint
			_tintAmount = NumberUtils.interpolate2(MIN_TINT, MAX_TINT, _maxScale, _minScale, scale, TINT_EASING);
			DisplayObjectUtil.setObjectTint(this, GameMediator.skyColor, _tintAmount);
			DisplayObjectUtil.setObjectSaturation(this, NumberUtils.interpolate2(1, 0.6, _maxScale, _minScale, scale, TINT_EASING), NumberUtils.interpolate2(1, 1.25, _maxScale, _minScale, scale, TINT_EASING));
			
			//reset position (position is dependent on scale if outsideFOV)
			moveToRandomPosition(spawnDiag, viewDiag, center, outsideFOV);
			
			//Rebuild directional blur bitmapdata since size changed to prevent cropping
			//if (_directionalBlur) {
				//_directionalBlur.rebuildVisual(this);
			//}
			
			signalReset.dispatch(this);
		}
		
		protected function moveToRandomPosition(viewDiag:Number, spawnDiag:Number, center:Point, outsideFOV:Boolean):void {
			var distance:Number;
			if (outsideFOV) {
				distance = viewDiag + nodeRadius + (Math.random() * (spawnDiag - viewDiag));
			}else {
				distance = Math.random() * (spawnDiag + nodeRadius) + 300;//Magic number spreads clouds apart because they're all crammed up at the beginning, no idea why
			}
			
			//trace("On", viewDiag + nodeRadius + (1 *  (spawnDiag - viewDiag)));
			//trace("off", spawnDiag + nodeRadius);
			var angle:Number = Math.random() * 360;
			x = center.x + Trig.vectorX(distance, angle);
			y = center.y + Trig.vectorY(distance, angle);
			
			var groundLevel:Number = GameEngine.instance.ground.groundLevel;
			if (y + height *0.5 >= groundLevel) {
				y = groundLevel - NumberUtils.randomRange(1500, 4500);
				//moveOutside(viewDiag);
			}
			
		}
		
		protected function moveOutside(zoneRect:Rectangle):void {
			//move node outside rect not from x/y but from it's real bounds
			var bounds:Rectangle = getBounds(this.parent);
			var intersection:Rectangle = bounds.intersection(zoneRect);
			if (intersection.isEmpty()) {
				//already outside
				return;
			}
			if (x <= (zoneRect.x + (zoneRect.width / 2))) {
				//left of center
				x -= intersection.width;
			}else {
				//right of center
				x += intersection.width;
			}
			if (y <= (zoneRect.y + (zoneRect.height / 2))) {
				//above center
				y -= intersection.height;
			}else {
				//below center
			}
				y += intersection.height;
		}
		
		public function get nodeRadius():Number {
			return Math.sqrt((height * height) + (width * width)) / 2;
		}
		
		public function get tintAmount():Number 
		{
			return _tintAmount;
		}
		
		public function destroy():void {
			if (_visual.stage) _visual.parent.removeChild(_visual);
			_visual = null;
		}
		
	}

}