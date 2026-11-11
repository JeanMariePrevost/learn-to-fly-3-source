package src.game.gameobjects.environment 
{
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.game.GameMediator;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class CloudsOverNode extends CloudsNode 
	{
		
		public function CloudsOverNode(viewDiag:Number, spawnDiag:Number, center:Point, minScale:Number, maxScale:Number) 
		{
			super(viewDiag, spawnDiag, center, minScale, maxScale);
			
		}
		
		override protected function initMotionBlur():void 
		{
			if (ProfileState.instance.optionClouds == "High (blur)") {
				_basicBlurFilter = new BlurFilter(0, 0, 1);
				GameMediator.updatePlayerMove.add(basicBlurVertical);
			}else if (ProfileState.instance.optionClouds == "Best (blur)") {
				_basicBlurFilter = new BlurFilter(0, 0, 1);
				GameMediator.updatePlayerMove.add(basicBlurVertical);
				
				//GameMediator.updatePlayerSpeed.add(directionalBlur);
				//_directionalBlur = new MotionBlurWrapper(this);
				//_directionalBlur.blurStartSpeed = 2;
				//_directionalBlur.blurEndSpeed = 30;
				//_directionalBlur.blurEasePower = 1;
				//_directionalBlur.blurMaxStrength = 60;
				//_directionalBlur.forceBlur();//Render without blur first
			}

		}
		
		
		override public function resetCloudsNode(viewDiag:Number, spawnDiag:Number, center:Point, outsideFOV:Boolean = true):void 
		{
			super.resetCloudsNode(viewDiag, spawnDiag, center, outsideFOV);
			
			alpha = 0.2 + Math.random() * 0.4;
		}
	}

}