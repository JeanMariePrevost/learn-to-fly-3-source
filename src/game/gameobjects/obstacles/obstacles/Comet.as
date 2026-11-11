package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import lbg.utils.NumberUtils;
	import src.game.gameobjects.obstacles.Obstacle;
	import src.system.Global;
	
	/**
	 * ...
	 * @author 
	 */
	public class Comet extends Obstacle 
	{
		public var vxMult:Number = 1;
		public var vyMult:Number = 0.5;
		public var vr:Number;
		
		public function Comet(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.CometVisual();
				visual.scaleX = visual.scaleY = NumberUtils.randomRange(1, 6);
				var shapeCoords:Array = getShapeCoords("comet", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			
			_rotationCorrectionIncreasePerTick = 0;
			_rotationCorrection = 0;
			_drag = 1;
			
			//Base stats
			setMass(50 * Math.abs(_movieClip.scaleX));
			_life = 2000;
			
			applyCometMovement();
			
		}
		
		protected function applyCometMovement():void {
			_impulsePower = 400;
			vr = 10;
			
			_drag = 1;
			
			var power:Number = _impulsePower * Global.powerPerMassUnit * _body.mass;
			applyForce(NumberUtils.randomBoth(vxMult * power), NumberUtils.randomBoth(vyMult * power));
			applyRotation(NumberUtils.randomBoth(vr));
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
		}
		
		override protected function applyObstacleForce(delta:Number):void 
		{
			//No force
		}
		
		override protected function rectifyRotation(correctionMult:Number):void 
		{
			//No angle correction
		}
		
	}

}