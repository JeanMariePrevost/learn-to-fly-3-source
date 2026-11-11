package src.gui 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import lbg.utils.NumberUtils;
	import src.gui.decorators.MouseBounce2;
	
	/**
	 * ...
	 * @author 
	 */
	public class RewardSlot extends MovieClip 
	{
		
		public var txtLabel:TextField;
		public var wrapper:MouseBounce2;
		
		//Prevents turning off
		protected var _locked:Boolean = false;
		
		protected var _enabled:Boolean = false;
		
		public function RewardSlot() 
		{
			super();
			
			visible = false;
			
			txtLabel.text = "Enter text here";
			txtLabel.autoSize = TextFieldAutoSize.LEFT;
			
			gotoAndStop(1);
			
			wrapper = new MouseBounce2(this);
			wrapper.scaleMod = 0.04;
			
			wrapper.signalClickTarget.add(onRewardSlotClick)
			updateIcon();
		}
		
		public function updateXFromTextWidth():void {
			var w:Number = txtLabel.textWidth;
			
			//trace("txtLabel.textWidth", txtLabel.textWidth);
			
			x = 475 - NumberUtils.interpolate2(0, 300, 10, 720, w, 1);
			
			//trace("X:", x);
		}
		
		protected function onRewardSlotClick(obj:DisplayObject):void {
			if (_locked) {
				_enabled = true;
			}else {
				_enabled = !_enabled;
			}
			updateIcon();
		}
		
		protected function updateIcon():void {
			if (_locked) {
				if (_enabled) {
					gotoAndStop(1);
				}else {
					gotoAndStop(2);
				}
			}else {
				if (_enabled) {
					gotoAndStop(3);
				}else {
					gotoAndStop(4);
				}
			}
		}
		
		public function get locked():Boolean 
		{
			return _locked;
		}
		
		public function set locked(value:Boolean):void 
		{
			_locked = value;
			if (_locked) {
				_enabled = true;
				updateIcon();
			}
		}
		
		public function get bonusEnabled():Boolean {
			return _enabled;
		}
		
		public function set bonusEnabled(value:Boolean):void {
			_enabled = value;
			updateIcon();
		}
		
	}

}