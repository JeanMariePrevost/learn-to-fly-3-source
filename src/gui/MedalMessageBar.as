package src.gui {
	import flash.display.MovieClip;
	import lbg.utils.Easing;
	import lbg.utils.NumberUtils;
	import org.osflash.signals.Signal;
	import src.audio.Sfx;
	import src.reg.RegistryEntry;
	import src.system.Global;
	/**
	 * ...
	 * @author 
	 */
	public class MedalMessageBar extends MessageBar 
	{
		public var medal:MedalMessageBarMedal;
		
		public var tickSignal:Signal = new Signal(Number);
		
		protected const MEDAL_Y:Number = 39;
		protected const MEDAL_X_OFFSET:Number = -60;
		protected const BP_TWEEN_START_DELAY:Number = 40;
		protected const BP_TWEEN_DURATION:Number = 30;
		
		protected var _bpTweenTime:Number = 0;
		protected var _bpReward:Number = 0;
		protected var _delay:Number = 0;//Delay before showing, used to queue medals popups
		protected var _started:Boolean = false;//When delay is over
		
		public function MedalMessageBar(entry:RegistryEntry, topMargin:Number, level:uint, delayInMs:Number = 0) 
		{
			super(getTitleText(entry, level), topMargin);
			
			medal = new MedalMessageBarMedal(entry, level); 
			bar.addChild(medal);
			medal.y = MEDAL_Y;
			
			
			//trace("Text width:", bar.txtMask.textWidth);
			var shortX:Number = 320;
			var longX:Number = 110;
			var shortestLength:Number = 30;
			var longestLength:Number = 600;
			var pos:Number = NumberUtils.interpolate2(shortX, longX, shortestLength, longestLength, bar.txtMask.textWidth);
			bar.txtMask.x = pos;
			bar.txtOutline.x = pos;
			bar.txtBP.x = pos;
			bar.txtBP.text = "";
			_bpReward = getBpReward(entry, level);
			medal.x = pos + MEDAL_X_OFFSET;
			
			mouseEnabled = false;
			mouseChildren = false;
			
			_delay = delayInMs / (1000 / Global.defaultFramerate);
			stop();
		}
		
		protected function getBpReward(entry:RegistryEntry, level:uint):Number {
			return entry.statSpecial.valueAt(level - 1);
		}
		
		protected function getTitleText(entry:RegistryEntry, level:uint):String {
			return entry.name;
		}
		
		override protected function tick(delta:Number):void 
		{
			if (parent == null) {
				return;
			}
			
			if (bar == null || bar.txtBP == null || medal == null) {
				destroy();
				return;
			}
			
			if (_started == false) {
				if (_delay >= 1) {
					//Wait
					trace(_delay, this);
					_delay -= delta;
					gotoAndStop(1);
					visible = false;
				}else {
					//Start
					trace("Starting", this);
					Sfx.playMedalSound2();
					_delay = 0;
					_started = true;
					gotoAndStop(1);
					visible = true;
				}
			}else {
				_bpTweenTime += delta;
				if (_bpTweenTime < BP_TWEEN_START_DELAY) {
					bar.txtBP.text = "";
				}else if (_bpTweenTime - BP_TWEEN_START_DELAY <= BP_TWEEN_DURATION) {
					var time:Number = Math.max(0, Math.min(BP_TWEEN_DURATION, _bpTweenTime - BP_TWEEN_START_DELAY));
					var bp:Number = Easing.easeOutQuad(time, 0, _bpReward, BP_TWEEN_DURATION);
					bar.txtBP.text = "+" + bp.toFixed(0) + " BP";
				}else {
					bar.txtBP.text = "+" + _bpReward + " BP";
				}
				
				medal.tick(delta);
				super.tick(delta);
			}
			
		}
		
		override public function destroy():void 
		{
			if(tickSignal) tickSignal.removeAll();
			tickSignal = null;
			if(medal) medal.destroy();
			super.destroy();
		}
		
	}

}