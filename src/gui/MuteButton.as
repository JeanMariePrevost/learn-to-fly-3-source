package src.gui 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import src.audio.Audio;
	import src.gui.decorators.MouseBounce2;
	import src.Main;
	import src.shop.ShopTooltip;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class MuteButton extends MovieClip 
	{
		protected var _wrapper:MouseBounce2;
		
		public function MuteButton() 
		{
			super();
			
			if (ProfileState.instance.mute == 0) {
				gotoAndStop(2);
			}else {
				gotoAndStop(1);
			}
			
			_wrapper = new MouseBounce2(this);
			_wrapper.signalClickTarget.add(onMuteClick);
			_wrapper.signalOverTarget.add(onOver);
			_wrapper.signalOutTarget.add(onOut);
		}
		
		protected function onOver(obj:DisplayObject):void {
			if (currentFrame == 1) {
				Main.instance.setSysButtonLabel("Mute", this);
			}else {
				Main.instance.setSysButtonLabel("Unmute", this);
			}
		}
		
		protected function onOut(obj:DisplayObject):void {
			Main.instance.setSysButtonLabel("", this);
		}
		
		protected function onMuteClick(obj:DisplayObject):void {
			if (ProfileState.instance.mute == 0) {
				ProfileState.instance.mute = 1;
				Audio.mute = false;
				gotoAndStop(1);
			}else {
				ProfileState.instance.mute = 0;
				Audio.mute = true;
				gotoAndStop(2);
			}
			
			onOver(null);
		}
		
		public function destroy():void {
			if (_wrapper) {
				_wrapper.signalClickTarget.remove(onMuteClick);
				_wrapper.destroy();
			}
			_wrapper = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}