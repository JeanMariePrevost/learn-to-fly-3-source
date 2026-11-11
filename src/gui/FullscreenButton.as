package src.gui 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import lbg.utils.DisplayObjectUtil;
	import src.Main;
	import src.gui.decorators.MouseBounce2;
	
	/**
	 * ...
	 * @author 
	 */
	public class FullscreenButton extends MovieClip 
	{
		protected var _wrapper:MouseBounce2;
		
		public function FullscreenButton() 
		{
			super();
			
			_wrapper = new MouseBounce2(this);
			_wrapper.signalClickTarget.add(onClick);
			_wrapper.signalOverTarget.add(onOver);
			_wrapper.signalOutTarget.add(onOut);
		}
		
		protected function onOver(obj:DisplayObject):void {
			if (currentFrame == 1) {
				Main.instance.setSysButtonLabel("Fullscreen", this);
			}else {
				Main.instance.setSysButtonLabel("Fullscreen", this);
			}
		}
		
		protected function onOut(obj:DisplayObject):void {
			Main.instance.setSysButtonLabel("", this);
		}
		
		protected function onClick(obj:DisplayObject):void {
			Main.instance.toggleFullScreen();
			
			onOver(null);
		}
		
		public function destroy():void {
			if (_wrapper) {
				_wrapper.signalClickTarget.remove(onClick);
				_wrapper.destroy();
			}
			_wrapper = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}