package src.shop.bonusshop 
{
	import flash.events.MouseEvent;
	import src.Main;
	import lbg.utils.NumberUtils;
	import src.shop.ShopTooltip;
	import src.shop.UpgradeBarUI;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * Like UpgradeBarUI, but no minus button visible, and maybe different visual
	 * @author 
	 */
	public class BonusUpgradeBarUI extends UpgradeBarUI 
	{
		
		public function BonusUpgradeBarUI(scale:Number=1, length:Number=300) 
		{
			super(scale, length);
			
			barBonus.alpha = 0.3;
			barOverBonus.alpha = 0.3;
		}
		
		
		override protected function showTooltip(value:Number):void {
			var title:String = NumberUtils.numberDelimiter(value) + " BP";
			if (value == 0) title = "FREE!";
			
			if (value >= 0) {
				if (ProfileState.instance.bonusPoints.value >= value) {
					ShopTooltip.show(this, title);
				}else {
					ShopTooltip.showRed(this, title);
				}
			}else {
				//selling
				ShopTooltip.showGreen(this, "+" + title.replace("-", ""));
			}
		}
		
		
		override protected function checkButtons():void {
			var minus:Boolean = false;
			var plus:Boolean = false;
			
			
			if (_shopItem.isMaxed == false) {
				if (_shopItem.getCostAt(1) <= ProfileState.instance.bonusPoints.value) {
					//Can afford
					plus = true;
				}else {
					//Can't afford
					plus = true;
				}
				
				if (_shopItem.bonusUnlockedLevel > _shopItem.level) {
					//Already owned but downgraded
					plus = true;
				}
			}
			
			if (_shopItem.level >= 1) {
				minus = true;
				if (_shopItem.maxLevel <= 1) {
					//No over-upgrades for 1-level items
					plus = false;
				}
			}
			
			if (_shopItem.statSpecial == 0) {
				//Special == 0 means item cannot be downgraded
				minus = false;
			}
			
			setEnable(minus, plus);
		}
		
		override public function updateLevel():void 
		{
			divisions.gotoAndStop(Math.max(1, _shopItem.maxLevel));
			
			
			if (_shopItem.level >= _shopItem.bonusUnlockedLevel) {
				barBonus.visible = false;
				barOverBonus.visible = false;
				
				if (_shopItem.level == 0) {
					bar.gotoAndStop(1);
					barOver.visible = false;
				}else if (_shopItem.level > _shopItem.maxLevel) {
					//Overleveled
					bar.gotoAndStop(bar.totalFrames);
					barOver.visible = true;
					barOver.gotoAndStop(Math.ceil(barOver.totalFrames * ((_shopItem.level - _shopItem.maxLevel) / _shopItem.overLevelsAvailable)));
				}else{
					bar.gotoAndStop(Math.ceil(bar.totalFrames * (_shopItem.level / _shopItem.maxLevel)));
					barOver.visible = false;
				}
			}else {
				//Downgraded
				if (_shopItem.level > _shopItem.maxLevel) {
					//Overleveled
					barBonus.visible = false;
					barOverBonus.visible = true;
					barOverBonus.gotoAndStop(Math.ceil(barOver.totalFrames * ((_shopItem.bonusUnlockedLevel - _shopItem.maxLevel) / Global.OVER_LEVELS)));
					bar.gotoAndStop(bar.totalFrames);
					barOver.visible = true;
					barOver.gotoAndStop(Math.ceil(barOver.totalFrames * ((_shopItem.level - _shopItem.maxLevel) / Global.OVER_LEVELS)));
				}else{
					barBonus.visible = true;
					barOverBonus.visible = false;
					barBonus.gotoAndStop(NumberUtils.interpolate2(1, bar.totalFrames, 0, _shopItem.maxLevel, _shopItem.bonusUnlockedLevel));
					bar.gotoAndStop(Math.ceil(bar.totalFrames * (_shopItem.level / _shopItem.maxLevel)));
					barOver.visible = false;
				}
			}
			
			checkButtons();
		}
		
		override protected function plusClick(e:MouseEvent):void 
		{
			if (_shopItem.bonusUnlockedLevel > _shopItem.level || _shopItem.getCostAt(1) <= ProfileState.instance.bonusPoints.value) {
				super.plusClick(e);
			}else {
				Main.displayMessage("Not enough Bonus Points");
			}
		}
		
	}

}