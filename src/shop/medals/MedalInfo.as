package src.shop.medals 
{
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import src.Main;
	import src.reg.RegistryEntry;
	
	/**
	 * ...
	 * @author 
	 */
	public class MedalInfo extends MovieClip 
	{
		public var txtName:TextField;
		public var txtDesc:TextField;
		public var txtBonus:TextField;
		public var txtProgress:TextField;
		public var glow:MovieClip;
		
		protected const MIN_ROTATION:Number = -15;
		protected const MAX_ROTATION:Number = 2;
		protected const ROTATION_DURATION:Number = 60;
		
		protected var _medal:MovieClip;
		protected var _button:MedalButton;
		protected var _targetGlowAlpha:Number = 0;
		protected var _rotationTime:Number = 0;
		protected var _rotatingUp:Boolean = true;
		
		public function MedalInfo() 
		{
			super();
			
			txtName.text = " Select a medal";
			txtDesc.text = "";
			txtBonus.text = "";
			glow.alpha = 0;
			
			Main.unsafeTickSignal.add(tick);
		}
		
		protected function tick(delta:Number):void {
			glow.alpha -= (glow.alpha - _targetGlowAlpha) * 0.12;
			
			if (_medal) {
				if (_rotatingUp) {
					_rotationTime += delta;
					_rotationTime = Math.min(_rotationTime, ROTATION_DURATION);
					_medal.rotation = Easing.easeBothInOutQuad(_rotationTime, MIN_ROTATION, MAX_ROTATION - MIN_ROTATION, ROTATION_DURATION);
					if (_rotationTime >= ROTATION_DURATION) {
						_rotatingUp = false;
						_rotationTime = 0;
					}
				}else {
					_rotationTime += delta;
					_rotationTime = Math.min(_rotationTime, ROTATION_DURATION);
					_medal.rotation = Easing.easeBothInOutQuad(_rotationTime, MAX_ROTATION, MIN_ROTATION - MAX_ROTATION, ROTATION_DURATION);
					if (_rotationTime >= ROTATION_DURATION) {
						_rotatingUp = true;
						_rotationTime = 0;
					}
				}
			}
		}
		
		public function showMedal(button:MedalButton):void {
			reset();
			_button = button;
			_medal = getNewVisual();
			_targetGlowAlpha = 1;
			txtName.text = _button.entry.name;
			txtDesc.text = _button.entry.shopDescription.valueAt(_button.visual.currentFrame -1);
			
			checkForFontSize();
			
			updateLockedStatus();
			
		}
		
		protected function checkForFontSize():void {
			if (txtDesc.text.length >= 60) {
				var format:TextFormat = txtDesc.defaultTextFormat;
				format.size = 20;
				txtDesc.defaultTextFormat = format;
				txtDesc.setTextFormat(format);
			}else {
				var format:TextFormat = txtDesc.defaultTextFormat;
				format.size = 24;
				txtDesc.defaultTextFormat = format;
				txtDesc.setTextFormat(format);
			}
		}
		
		protected function updateLockedStatus():void {
			if (_button.isUnlocked) {
				txtBonus.text = _button.entry.bodyStageBeforeGameClass.valueAt(_button.visual.currentFrame -1);
				txtProgress.text = "";
			}else {
				var f:Array = _medal.filters;
				f.unshift(DisplayObjectUtil.getObjectSaturationFilter(0, 0.05));
				_medal.filters = f;
				txtBonus.text = "";
				txtProgress.text = MedalProgressDump.getProgressStringOf(_button.entry, _button.visual.currentFrame - 1);
				
				//Show medal progress
				
			}
			
			checkForFontSize();
		}
		
		protected function getNewVisual():MovieClip {
			var visual:MovieClip = new (_button.entry.gameClass.valueAt(0))();
			visual.gotoAndStop(_button.visual.currentFrame);
			visual.filters = [new GlowFilter(0xFFFFFF, 0.8, 15, 15, 1.1, 1)];
			addChild(visual);
			visual.x = glow.x;
			visual.y = glow.y;
			visual.scaleX = visual.scaleY = 1.35;
			visual.rotation = MIN_ROTATION;
			return visual;
		}
		
		public function hideMedal(button:MedalButton):void {
			if (button == _button) {
				reset();
				txtName.text = " Select a medal";
				txtDesc.text = "";
				txtBonus.text = "";
				_targetGlowAlpha = 0;
			}
		}
		
		public function reset():void {
			if (_medal) {
				if (_medal.destroy) _medal.destroy();
				DisplayObjectUtil.removeAllChildFrom(_medal, true);
			}
			_medal = null;
			_button = null;
		}
		
		public function destroy():void {
			Main.unsafeTickSignal.remove(tick);
			
			txtName = null;
			txtDesc = null;
			txtBonus = null;
			glow = null;
			
			if (_medal && _medal.destroy) _medal.destroy();
			_medal = null;
			if(_button) _button.destroy();
			_button = null;
			
			while (numChildren >= 1) removeChildAt(0);
			if (stage) parent.removeChild(this);
			
		}
		
	}

}