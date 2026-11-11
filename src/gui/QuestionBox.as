package src.gui 
{
	import fl.motion.Tweenables;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
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
	public class QuestionBox extends MovieClip 
	{
		public var box:DialogBox;
		public var txtTitle:TextField;
		public var txtMessage:TextField;
		public var btnYes:MovieClip;
		public var btnNo:MovieClip;
		
		public var yesFunction:Function;
		public var noFunction:Function;
		public var closingFunction:Function;
		
		public var decoYes:MouseBounce2;
		public var decoNo:MouseBounce2;
		
		public function QuestionBox(title:String, message:String, yesFunction:Function = null, noFunction:Function = null, closingFunction:Function = null) 
		{
			super();
			
			txtTitle.text = title;
			txtMessage.text = message;
			
			adjustSize();
			
			this.yesFunction = yesFunction;
			this.noFunction = noFunction;
			this.closingFunction = closingFunction;
			
			decoYes = new MouseBounce2(btnYes);
			decoYes.colorWhenOver = DisplayObjectUtil.getColorMatrix(0, 50, 10, 0);
			decoYes.colorWhenDown = DisplayObjectUtil.getColorMatrix(0, 20, -10, 0);
			decoNo = new MouseBounce2(btnNo);
			decoNo.colorWhenOver = DisplayObjectUtil.getColorMatrix(0, 50, 10, 0);
			decoNo.colorWhenDown = DisplayObjectUtil.getColorMatrix(0, 20, -10, 0);
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			
			decoYes.signalClickTarget.add(clickYes);
			decoNo.signalClickTarget.add(clickNo);
		}
		
		protected function adjustSize():void {
			if (txtMessage.numLines >= 3) {
				var step:Number = 32.5;
				var linesDiff:Number = txtMessage.numLines - 2;
				txtMessage.height = step * txtMessage.numLines;
				box.height +=  step * linesDiff * 1.1;
				box.y  -= step * linesDiff * 0.5;
				txtTitle.y -= step * linesDiff * 0.5;
				txtMessage.y -= step * linesDiff * 0.5;
				btnYes.y += step * linesDiff * 0.45;
				btnNo.y += step * linesDiff * 0.45;
			}
			
		}
		
		protected function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			x = UiScaler.maxWidthAtCurrentRatio * 0.5;
			y = UiScaler.stageHeightAtCurrentRatio * 0.5;
			
			TweenPos.tweenToCurrentPosition(this, new Point(0, 540), 20, 0, TweenPos.EASE_OUT_CUBIC);
		}
		
		protected function clickNo(target:DisplayObject):void 
		{
			Sfx.playMediumClick();
			if (noFunction != null) noFunction.call();
			closeMenu();
		}
		
		protected function clickYes(target:DisplayObject):void 
		{
			Sfx.playMediumClick();
			if (yesFunction != null) yesFunction.call();
			closeMenu();
		}
		
		protected function closeMenu():void {
			if (box == null) {
				if (closingFunction) closingFunction.call();
				destroy();
				return;
			}else {
				TweenPos.tweenFromCurrentPosition(this, new Point(0, 540), 20, 0, TweenPos.EASE_IN).finishedSignal.addOnce(destroy);
				
				decoYes.signalClickTarget.remove(clickYes);
				decoNo.signalClickTarget.remove(clickNo);
				
				if (closingFunction) closingFunction.call();
			}
		}
		
		public function destroy():void {
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
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}