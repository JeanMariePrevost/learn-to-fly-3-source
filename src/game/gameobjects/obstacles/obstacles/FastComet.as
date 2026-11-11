package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import lbg.utils.NumberUtils;
	import src.effects.LineTrail;
	import src.game.GameCamera;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class FastComet extends Obstacle 
	{
		//protected var _trail:LineTrail;
		
		public function FastComet(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.FastCometVisual();
				visual.scaleX = visual.scaleY = NumberUtils.randomRange(1, 3);
				var shapeCoords:Array = getShapeCoords("fastComet", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			_rotationCorrectionIncreasePerTick = 0.001;
			_targetRotation = -30 + Math.random() * 60;
			_impulsePower = 16 + Math.random() * 4;
			
			//Base stats
			setMass(700 * Math.abs(_movieClip.scaleX));
			_life = 750;
		}
		
		override protected function rectifyRotation(correctionMult:Number):void 
		{
			_body.angularVel *= 1 - _rotationCorrection;
		}
		
		
	}

}