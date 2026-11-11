package src.shop.bonusshop 
{
	import flash.display.MovieClip;
	import lbg.utils.DisplayObjectUtil;
	import src.game.DeltaMovieClipWrapper;
	import lbg.components.labelmovieclip.LabelMovieClip;
	
	/**
	 * ...
	 * @author 
	 */
	public class BonusShopBaby extends MovieClip 
	{
		protected var _wrapper:DeltaMovieClipWrapper;
		
		public function BonusShopBaby() 
		{
			super();
			
			_wrapper = new DeltaMovieClipWrapper(this, "regInDelayed");
			_wrapper.setAction("regInDelayed", LabelMovieClip.ACTION_PLAY);
			_wrapper.setAction("regInStart", LabelMovieClip.ACTION_PLAY);
			_wrapper.setAction("regInEnd", LabelMovieClip.ACTION_STOP);
			_wrapper.setAction("regOutStart", LabelMovieClip.ACTION_PLAY);
			_wrapper.setAction("regOutEnd", "upInStart");
			_wrapper.setAction("upInStart", LabelMovieClip.ACTION_PLAY);
			_wrapper.setAction("upInEnd", LabelMovieClip.ACTION_STOP);
			_wrapper.setAction("upOutStart", LabelMovieClip.ACTION_PLAY);
			_wrapper.setAction("upOutEnd", "regInStart");
		}
		
		public function toUpgradeBar():void {
			if (_wrapper.currentState == "regOut" || _wrapper.currentState == "upIn") {
				//already going to upgrade bar
			}else {
				_wrapper.gotoLabel("regOutStart");
			}
		}
		
		public function toGlassBoard():void {
			if (_wrapper.currentState == "upOut" || _wrapper.currentState == "regIn") {
				//already going to glass board
			}else {
				_wrapper.gotoLabel("upOutStart");
			}
		}
		
		public function destroy():void {
			if (_wrapper)_wrapper.destroy();
			_wrapper = null;
			
			DisplayObjectUtil.removeAllChildFrom(this, true);
		}
		
	}

}