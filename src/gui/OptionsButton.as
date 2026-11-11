package src.gui 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import src.audio.Audio;
	import src.game.GameMediator;
	import src.gui.decorators.MouseBounce2;
	import src.Main;
	import src.shop.ShopTooltip;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class OptionsButton extends MovieClip 
	{
		protected var _wrapper:MouseBounce2;
		
		public function OptionsButton() 
		{
			super();
			
			_wrapper = new MouseBounce2(this, true);
			_wrapper.signalClickTarget.add(onOptionsClick);
			_wrapper.signalOverTarget.add(onOver);
			_wrapper.signalOutTarget.add(onOut);
		}
		
		protected function onOver(obj:DisplayObject):void {
			Main.instance.setSysButtonLabel("Options", this);
		}
		
		protected function onOut(obj:DisplayObject):void {
			Main.instance.setSysButtonLabel("", this);
		}
		
		protected function onOptionsClick(obj:DisplayObject):void {
			Main.showOptionsMenu();
			GameMediator.gamePaused.dispatch();
		}
		
		public function destroy():void {
			if (_wrapper) {
				_wrapper.signalClickTarget.remove(onOptionsClick);
				_wrapper.destroy();
			}
			_wrapper = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (parent) parent.removeChild(this);
		}
		
	}

}