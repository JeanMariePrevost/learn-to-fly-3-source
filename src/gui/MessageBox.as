package src.gui 
{
	import fl.motion.Tweenables;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	import lbg.utils.DisplayObjectUtil;
	import src.UiScaler;
	import src.audio.Sfx;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	import src.gui.decorators.TweenPos;
	
	/**
	 * ...
	 * @author 
	 */
	public class MessageBox extends MovieClip 
	{
		public var box:DialogBox;
		public var txtTitle:TextField;
		public var txtMessage:TextField;
		public var btnYes:MovieClip;
		
		public var okFunction:Function;
		public var closingFunction:Function;
		
		public var decoYes:MouseBounce2;
		
		protected var _enable:Boolean;
		protected var _tweenDuration:Number = 20;
		
		protected var _disableTimer:Timer = new Timer(1000, 1);
		
		public function MessageBox(title:String, message:String, okFunction:Function = null, closingFunction:Function = null, tweenDuration:Number = 20) 
		{
			super();
			
			_tweenDuration = tweenDuration;
			
			txtTitle.text = title;
			txtMessage.text = message;
			
			//Resize box and adjust position if text if too long for normal-sized box			
			if (txtMessage.textHeight >= 61) {
				var h:Number = txtMessage.textHeight;
				var regPointOffset:Number = 0;
				
				while (h >= 61) {
					h -= 4;
					txtMessage.height += 4.1;
					box.height += 4.1;
					btnYes.y += 3.75;
					regPointOffset += 1.95;
				}
				
				var p:Point = DisplayObjectUtil.getRegistrationPoint(this);
				DisplayObjectUtil.setRegistrationPoint(this, p.x, p.y + regPointOffset);
			}
			
			this.okFunction = okFunction;
			this.closingFunction = closingFunction;
			
			decoYes = new MouseBounce2(btnYes);
			decoYes.colorWhenOver = DisplayObjectUtil.getColorMatrix(0, 50, 10, 0);
			decoYes.colorWhenDown = DisplayObjectUtil.getColorMatrix(0, 20, -10, 0);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			
			decoYes.signalClickTarget.add(clickYes);
		}
		
		protected function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			x = 360;
			y = UiScaler.stageHeightAtCurrentRatio * 0.5;
			
			UiScaler.addAbsolute(this);
			
			TweenPos.tweenToCurrentPosition(this, new Point(0, 540), _tweenDuration, 0, TweenPos.EASE_OUT_CUBIC);
		}
		
		protected function clickYes(target:DisplayObject):void 
		{
			Sfx.playMediumClick();
			if (okFunction != null) okFunction.call();
			closeMenu();
		}
		
		public function closeMenu():void {
			TweenPos.tweenFromCurrentPosition(this, new Point(0, 540), 20, 0, TweenPos.EASE_IN).finishedSignal.addOnce(destroy);
			
			if(decoYes) decoYes.signalClickTarget.remove(clickYes);
			
			if(btnYes) btnYes.mouseEnabled = false;
			
			if (closingFunction) {
				var f:Function = closingFunction;
				closingFunction = null;
				f.call();
			}
		}
		
		public function get enableButtons():Boolean 
		{
			return _enable;
		}
		
		public function set enableButtons(value:Boolean):void 
		{
			_enable = value;
			
			if (_enable) {
				btnYes.enabled = true;
				btnYes.mouseEnabled = true;
				DisplayObjectUtil.setObjectSaturation(btnYes, 1, 1);
			}else {
				btnYes.enabled = false;
				btnYes.mouseEnabled = false;
				DisplayObjectUtil.setObjectSaturation(btnYes, 0, 0.5);
				
			}
		}
		
		public function disableButtonsForTime(timeInMs:Number):void {
			if (_disableTimer) {
				//trace("MessageBox.disableButtonsForTime()", timeInMs.toFixed());
				_disableTimer.stop();
				_disableTimer.reset();
				_disableTimer.delay = timeInMs;
				_disableTimer.addEventListener(TimerEvent.TIMER, onDisableTimer);
				_disableTimer.start();
				enableButtons = false;
			}
		}
		
		private function onDisableTimer(e:TimerEvent):void 
		{
			if (_disableTimer) {
				//trace("MessageBox.onDisableTimer()");
				_disableTimer.stop();
				_disableTimer.reset();
				_disableTimer.removeEventListener(TimerEvent.TIMER, onDisableTimer);
			}
			enableButtons = true;
		}
		
		public function destroy():void {
			if(box) box.destroy();
			if(decoYes) decoYes.destroy();
			
			box = null;
			decoYes = null;
			
			if (_disableTimer) {
				_disableTimer.stop();
				_disableTimer.removeEventListener(TimerEvent.TIMER, onDisableTimer);
			}
			
			txtTitle = null;
			txtMessage = null;
			btnYes = null;
			
			okFunction = null
			closingFunction = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}