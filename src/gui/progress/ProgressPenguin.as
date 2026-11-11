package src.gui.progress 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import src.Main;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class ProgressPenguin extends MovieClip 
	{
		public var progressBubble:ProgressBubble;
		public var txtLabel:TextField;
		public var penguin:MovieClip;
		
		public var triggered:Boolean = false;
		public var targetValue:Number;
		public var duration:Number = 70;
		public var time:Number = 0;
		
		
		public function ProgressPenguin() 
		{
			super();
			visible = false;
			progressBubble.visible = false;
			gotoAndStop(1);
			alpha = 0;
		}
		
		public function init(value:Number, label:String):void {
			if (triggered) return;
			
			alpha = 0;
			progressBubble.visible = true;
			visible = true;
			triggered = true;
			targetValue = Math.max(0, value);
			time = 0;
			txtLabel.text = label;
			progressBubble.selectFormat(value);
			progressBubble.setValue(0);
			
			Main.unsafeTickSignal.add(tick);
		}
		
		public function tick(delta:Number):void {
			time+= delta;
			time = NumberUtils.constrain(time, 0, duration);
			
			if (time >= duration) {
				updateState(targetValue);
				Main.unsafeTickSignal.remove(tick);
				alpha = 1;
			}else {
				var tweenVal:Number = Easing.easeOutCubic(time, 0, targetValue, duration);
				//var tweenVal:Number = Easing.easeBothInOutCubic(time, 0, targetValue, duration);
				alpha = NumberUtils.interpolate2(0, 1, 0, duration / 8, time, 1, true);
				updateState(tweenVal);
			}
		}
		
		protected function updateState(value:Number):void {
			progressBubble.setValue(value);
			
			var frame:Number = NumberUtils.interpolate2(1, totalFrames, 0, ProfileState.instance.currentGameState.storyModeSpaceLevel, value, 0.9, true);
			gotoAndStop(Math.floor(frame));
			
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			
			if (progressBubble) progressBubble.destroy();
			progressBubble = null;
			txtLabel = null;
			penguin = null;
		
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}