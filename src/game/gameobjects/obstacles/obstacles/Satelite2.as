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
	public class Satelite2 extends Satelite 
	{
		
		public function Satelite2(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.Satelite2Visual();
				visual.scaleX = visual.scaleY = NumberUtils.randomRange(1, 1.4);
				var shapeCoords:Array = getShapeCoords("satelite2", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			
			_rotationCorrectionIncreasePerTick = 0;
			_rotationCorrection = 0;
			_drag = 1;
			
			//Base stats
			setMass(30 * Math.abs(_movieClip.scaleX));
			_life = 600;
			
		}
		
		override protected function applyCometMovement():void 
		{
			_impulsePower = 300;
			vr = 2;
			
			_drag = 1;
			
			var power:Number = _impulsePower * Global.powerPerMassUnit * _body.mass;
			applyForce(NumberUtils.randomBoth(vxMult * power), NumberUtils.randomBoth(vyMult * power));
			applyRotation(NumberUtils.randomBoth(vr));
		}
		
	}

}