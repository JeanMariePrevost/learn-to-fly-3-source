package src.cards 
{
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import lbg.utils.DisplayObjectUtil;
	import src.shop.medals.MedalButton;
	import src.shop.medals.MedalInfo;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CardInfo extends MedalInfo 
	{
		protected var _progressString:String = "";
		
		public function CardInfo() 
		{
			super();
			
			txtName.text = "Your cards collection";
			txtDesc.text = "";
			txtBonus.text = "";
			txtDesc.text = "";
			txtProgress.text = "";
			glow.alpha = 0;
		}
		
		override public function showMedal(button:MedalButton):void 
		{
			if ((button as CardButton).amountIfBpCard >= 1) {
				_progressString = "Total earned: " + (button as CardButton).amountIfBpCard.toFixed(0);
			}else if ((button as CardButton).progressIfOmega >= 1 && (button as CardButton).progressIfOmega <= 3) {
				_progressString = "Fragments found: " + (button as CardButton).progressIfOmega.toFixed(0) + " / 3";
			}else {
				_progressString	= "";
			}
			
			super.showMedal(button);
			
			checkForFontSize();
		}
		
		override public function hideMedal(button:MedalButton):void 
		{
			if (button == _button) {
				reset();
				txtName.text = "Your cards collection";
				txtDesc.text = "";
				txtBonus.text = "";
				_targetGlowAlpha = 0;
			}
		}
		
		override protected function getNewVisual():MovieClip 
		{
			var visual:CardVisual = new CardVisual();
			visual.gotoAndStop(_button.entry.id);
			//visual.newItem.visible = false;
			//visual.omegaComplete.visible = false;
			//visual.newFragment.visible = false;
			visual.hitzone.visible = false;
			visual.filters = [new GlowFilter(0xFFFFFF, 0.8, 15, 15, 1.1, 1)];
			addChild(visual);
			visual.x = glow.x + 30;
			visual.y = glow.y;
			//DisplayObjectUtil.centerRegistrationPoint(visual);
			visual.scaleX = visual.scaleY = 0.7;
			visual.rotation = MIN_ROTATION;
			return visual;
		}
		
		override protected function updateLockedStatus():void 
		{
			if (_button.isUnlocked) {
				if ((_button as CardButton).progressIfOmega >= 1 && (_button as CardButton).progressIfOmega <= 2) {
					(_medal as CardVisual).setOmegaProgress((_button as CardButton).progressIfOmega);
					txtName.text = "???";
					txtDesc.text = "You have not unlocked this card yet";
				}
				txtBonus.text = "";
				txtProgress.text = _progressString;
			}else {
				if (_button.entry.id.indexOf("omega") >= 0) {
					_medal.gotoAndStop("notEarnedOmega");
				}else {
					_medal.gotoAndStop("notEarned");
				}
				
				(_medal as CardVisual).hidePopups();
				txtName.text = "???";
				txtDesc.text = "You have not unlocked this card yet";
				txtBonus.text = "";
				txtProgress.text = "";
			}
		}
		
	}

}