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
	public class Tardis extends Comet 
	{
		
		public function Tardis(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.TardisVisual();
				visual.scaleX = visual.scaleY = 1.5;
				var shapeCoords:Array = getShapeCoords("tardis", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			//Base stats
			setMass(120);
			_life = 3000;
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