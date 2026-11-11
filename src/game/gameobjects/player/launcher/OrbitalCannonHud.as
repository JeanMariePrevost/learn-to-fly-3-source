package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import lbg.utils.StringUtils;
	import src.Main;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class OrbitalCannonHud extends MovieClip 
	{
		public var txt1:TextField;
		public var txt2:TextField;
		public var txtBox1:TextField;
		public var txtBox2:TextField;
		public var txtBox3:TextField;
		public var txtTime:TextField;
		
		public var cursor:MovieClip;
		public var target:MovieClip;
		public var timeBar:MovieClip;
		
		
		protected var _vx:Number = 0;
		protected var _vy:Number = 0;
		protected var _controlMult:Number = 0.08;
		protected var _cursorDrag:Number = 0.96;
		
		protected var _targetDest:Point = new Point();
		protected var _targetCoolDown:Number = 50;
		protected var _targetTweenTime:Number = 0;
		protected var _targetTweenDuration:Number = 0;
		protected var _center:Point;
		protected var _startPoint:Point = new Point();
		
		protected var _minigameDurationMax:Number = 600;
		protected var _minigameDuration:Number = _minigameDurationMax;
		protected var _minigameScore:Number = 0;
		protected var _minigameBestScore:Number = 450;
		
		protected var _introTime:Number = 0;
		protected var _introDuration:Number = 60;
		
		protected var _outroTime:Number = 0;
		protected var _outroDuration:Number = 40;
		
		protected var _viusualScoreMult:Number;
		
		
		public function OrbitalCannonHud(visualScoreMult:Number = 1) 
		{
			super();
			
			visible = false;
			
			_viusualScoreMult = visualScoreMult;
			
			_center = new Point(cursor.x, cursor.y);
			
			DisplayObjectUtil.centerRegistrationPoint(timeBar);
			
			target.x = _center.x + NumberUtils.randomBoth(80);
			target.y = _center.y + NumberUtils.randomBoth(80);
			
			var f:Array = new Array();
			f.push(new GlowFilter(0x00ff00, 1, 5, 5, 1, 1));
			f.push(new GlowFilter(0x003300, 1, 5, 5, 1, 1));
			filters = f;
		}
		
		public function tickIntro(delta:Number):void {
			if (_introTime < _introDuration) {
				visible = true;
				scaleX = 1;
				scaleY = Easing.easeBothInOutCubic(_introTime, 0.02, 0.98, _introDuration);
				y = Easing.easeBothInOutCubic(_introTime, 200, -200, _introDuration);
				var brightness:Number = Easing.easeBothInOutCubic(_introTime, 1, -1, _introDuration);
				DisplayObjectUtil.setObjectTint(this, 0xFFFFFF, brightness);
				_introTime += delta;
			}
		}
		
		public function tick(delta:Number):void {
			if (stage == null) {
				destroy();
				return;
			}
			
			tickIntro(delta);
			
			_minigameDuration -= delta;
			timeBar.width = NumberUtils.interpolate2(500, 0, _minigameDurationMax, 0, _minigameDuration);
			
			if (_minigameDuration <= 0) {
				//Minigame over
				Main.unsafeTickSignal.remove(tick);
				Main.unsafeTickSignal.remove(tickIntro);
				Main.unsafeTickSignal.add(tickOutro);
				return;
			}
			
			txt1.text = "pn 10" + Number(1 + Math.random() * 7.9).toFixed(0);
			txt2.text = "1.0" + Number((target.x + target.y) / 100).toFixed(1);
			txtBox1.text = Easing.easeOutCubic(_minigameScore, 0, 1000 * _viusualScoreMult, _minigameBestScore).toFixed(0);
			txtBox2.text = target.y.toFixed(1);
			txtBox3.text = Number((Math.abs(_vx) + Math.abs(_vy)) * 17).toFixed(1);
			
			var timeLength:int = Math.max(0, Math.min(20,int(_minigameDuration / 30)));
			txtTime.text = (Math.random() * 17).toFixed(timeLength);
			
			tickTarget(delta);
			
			if (Input.metaBoost.isDown) {
				//up
				_vy -= _controlMult * delta;
			}
			if (Input.metaDown.isDown) {
				//down
				_vy += _controlMult * delta;
			}
			if (Input.metaLeft.isDown) {
				//left
				_vx -= _controlMult * delta;
			}
			if (Input.metaRight.isDown) {
				//right
				_vx += _controlMult * delta;
			}
			
			_vx *= _cursorDrag;
			_vy *= _cursorDrag;
			
			cursor.x += _vx;
			cursor.y += _vy;
			
			if (NumberUtils.distanceBetween(cursor.x,cursor.y,target.x, target.y) <= 5) {
				DisplayObjectUtil.setObjectTint(target, 0xFF0000, 0);
				_minigameScore += delta;
			}else if (NumberUtils.distanceBetween(cursor.x,cursor.y,target.x, target.y) <= 10) {
				DisplayObjectUtil.setObjectTint(target, 0xFFAA00, 0.7);
				_minigameScore += delta * 0.25;
			}else {
				DisplayObjectUtil.setObjectTint(target, 0xFF0000, 0.7);
				_minigameScore += delta * 0.03;
			}
			
			_minigameScore = NumberUtils.constrain(_minigameScore, 0, 450);
		}
		
		protected function tickTarget(delta:Number):void {
			if (_targetTweenTime < _targetTweenDuration) {
				//trace("Moving", _targetTweenTime);
				_targetTweenTime += delta;
				target.x = Easing.easeBothInOutQuad(_targetTweenTime, _startPoint.x, _targetDest.x - _startPoint.x, _targetTweenDuration);
				target.y = Easing.easeBothInOutQuad(_targetTweenTime, _startPoint.y, _targetDest.y - _startPoint.y, _targetTweenDuration);
			}else {
				if (_targetCoolDown <= 0) {
					//New destination!
					_targetDest.x = _center.x + NumberUtils.randomBoth(80);
					_targetDest.y = _center.y + NumberUtils.randomBoth(80);
					_targetCoolDown = NumberUtils.randomRange(0, 2, true);
					_targetTweenTime = 0;
					_targetTweenDuration = NumberUtils.randomRange(180, 400, true);
					_startPoint.x = target.x;
					_startPoint.y = target.y;
					//trace("New destination!", _targetDest);
				}else {
					//trace("CD", _targetCoolDown);
					_targetCoolDown -= delta;
				}
			}
		}
		
		protected function tickOutro(delta:Number):void {
			if (_outroTime < _outroDuration) {
				//Second phase
				scaleX = 1;
				scaleY = Easing.easeBothInOutCubic(_outroTime, 1, -0.99, _outroDuration);
				y = Easing.easeBothInOutCubic(_outroTime, 0, 100, _outroDuration);
				var brightness:Number = Easing.easeBothInOutCubic(_outroTime, 0, 1, _outroDuration);
				DisplayObjectUtil.setObjectTint(this, 0xFFFFFF, brightness);
				alpha = Easing.easeInQuart(_outroTime, 1, -1, _outroDuration);
				_outroTime += delta;
			}else {
				Main.unsafeTickSignal.remove(tickOutro);
				dispatchEvent(new Event(Event.COMPLETE));
				destroy();
			}
		}
		
		public function get minigameScoreNorm():Number 
		{
			return Easing.easeOutCubic(_minigameScore, 0, _minigameBestScore, _minigameBestScore) / _minigameBestScore;
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tickOutro);
			
			txt1 = null;
			txt2 = null;
			txtBox1 = null;
			txtBox2 = null;
			txtBox3 = null;
			txtTime = null;
			
			cursor = null;
			target = null;
			timeBar = null;
			
			_targetDest = null;
			_center = null;
			_startPoint = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}