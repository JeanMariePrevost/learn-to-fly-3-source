package src.gui 
{
	import fl.motion.Tweenables;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import lbg.utils.DisplayObjectUtil;
	import src.UiScaler;
	import src.gui.decorators.MouseBounce;
	import src.gui.decorators.MouseBounce2;
	import src.gui.decorators.TweenPos;
	
	/**
	 * ...
	 * @author 
	 */
	public class InputBox extends MovieClip 
	{
		public var box:DialogBox;
		public var txtTitle:TextField;
		public var txtMessage:TextField;
		public var txtInput:TextField;
		public var btnYes:MovieClip;
		public var btnNo:MovieClip;
		
		public var yesFunction:Function;
		public var noFunction:Function;
		public var closingFunction:Function;
		public var closedFunction:Function;
		
		public var decoYes:MouseBounce2;
		public var decoNo:MouseBounce2;
		
		/**
		 * @param	yesFunction Need to take 1 string parameter, which will be the user input
		 */
		public function InputBox(title:String, message:String, yesFunction:Function = null, noFunction:Function = null, closingFunction:Function = null, closedFunction:Function = null) 
		{
			super();
			
			txtTitle.text = title;
			txtMessage.text = message;
			txtInput.text = "";
			txtInput.wordWrap = false;
			txtInput.multiline = false;
			
			
			//Resize box and adjust position if text if too long for normal-sized box			
			if (txtMessage.textHeight >= 61) {
				var h:Number = txtMessage.textHeight;
				var regPointOffset:Number = 0;
				
				while (h >= 61) {
					h -= 4;
					txtMessage.height += 4.1;
					box.height += 4.1;
					txtInput.y += 3.75;
					btnYes.y += 3.75;
					btnNo.y += 3.75;
					regPointOffset += 1.95;
				}
				
				var p:Point = DisplayObjectUtil.getRegistrationPoint(this);
				DisplayObjectUtil.setRegistrationPoint(this, p.x, p.y + regPointOffset);
			}
			
			
			this.yesFunction = yesFunction;
			this.noFunction = noFunction;
			this.closingFunction = closingFunction;
			this.closedFunction = closedFunction;
			
			decoYes = new MouseBounce2(btnYes, true, null, false);
			decoYes.colorWhenOver = DisplayObjectUtil.getColorMatrix(0, 50, 10, 0);
			decoYes.colorWhenDown = DisplayObjectUtil.getColorMatrix(0, 20, -10, 0);
			decoNo = new MouseBounce2(btnNo, true, null, false);
			decoNo.colorWhenOver = DisplayObjectUtil.getColorMatrix(0, 50, 10, 0);
			decoNo.colorWhenDown = DisplayObjectUtil.getColorMatrix(0, 20, -10, 0);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			
			decoYes.signalClickTarget.add(clickYes);
			decoNo.signalClickTarget.add(clickNo);
			
			txtInput.addEventListener(KeyboardEvent.KEY_DOWN, onTxtKeyDown);
		}
		
		protected function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			x = 360;
			y = stage.stageHeight * 0.5;
			
			UiScaler.addAbsolute(this);
			
			TweenPos.tweenToCurrentPosition(this, new Point(0, 540), 20, 0, TweenPos.EASE_OUT_CUBIC);
			
			stage.focus = txtInput;
		}
		
		private function onTxtKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == 13) {
				//Enter
				clickYes(null);
			}else if (e.keyCode == 27) {
				//Esc
				clickNo(null);
			}
		}
		
		protected function clickNo(target:DisplayObject):void 
		{
			if (noFunction != null) noFunction.call();
			closeMenu();
		}
		
		protected function clickYes(target:DisplayObject):void 
		{
			if (yesFunction != null) yesFunction.call(null, txtInput.text);
			closeMenu();
		}
		
		public function closeMenu():void {
			TweenPos.tweenFromCurrentPosition(this, new Point(0, 540), 20, 0, TweenPos.EASE_IN).finishedSignal.addOnce(destroy);
			
			if(decoYes) decoYes.signalClickTarget.remove(clickYes);
			if(decoNo) decoNo.signalClickTarget.remove(clickNo);
			
			if(txtInput) txtInput.removeEventListener(KeyboardEvent.KEY_DOWN, onTxtKeyDown);
			
			if (btnYes) {
				btnYes.mouseEnabled = false;
				btnYes.enabled = false;
			}
			
			if (btnNo) {
				btnNo.mouseEnabled = false;
				btnNo.enabled = false;
			}
			
			if (closingFunction) closingFunction.call();
		}
		
		public function destroy():void {
			if (closedFunction) closedFunction.call();
			
			if(txtInput) txtInput.removeEventListener(KeyboardEvent.KEY_DOWN, onTxtKeyDown);
			
			if(box) box.destroy();
			if(decoYes) decoYes.destroy();
			if(decoNo) decoNo.destroy();
			
			box = null;
			decoYes = null;
			decoNo = null;
			
			txtTitle = null;
			txtMessage = null;
			btnYes = null;
			btnNo = null;
			
			yesFunction = null
			noFunction = null;
			closingFunction = null;
		}
		
	}

}