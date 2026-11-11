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
	public class Dodolith extends Comet 
	{
		
		public function Dodolith(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.DodolithVisual();
				visual.scaleX = visual.scaleY = NumberUtils.randomRange(0.9, 2);
				var shapeCoords:Array = getShapeCoords("dodolith", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			
			//Base stats
			setMass(80 * Math.abs(_movieClip.scaleX));
			_life = 4000;
			
		}
		
		override protected function applyCometMovement():void 
		{
			_impulsePower = 300;
			vr = 4;
			
			_drag = 1;
			
			var power:Number = _impulsePower * Global.powerPerMassUnit * _body.mass;
			applyForce(NumberUtils.randomBoth(vxMult * power), NumberUtils.randomBoth(vyMult * power));
			applyRotation(NumberUtils.randomBoth(vr));
		}
		
	}

}