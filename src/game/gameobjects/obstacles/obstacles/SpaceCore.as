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
	public class SpaceCore extends Comet 
	{
		
		public function SpaceCore(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.SpaceCoreVisual();
				visual.scaleX = visual.scaleY = 0.4;
				var shapeCoords:Array = getShapeCoords("spaceCore", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			
			//Base stats
			setMass(20);
			_life = 4000;
			
			applyCometMovement();
		}
		
		override protected function applyCometMovement():void {
			_impulsePower = 150;
			vr = 5;
			
			_drag = 1;
			
			var power:Number = _impulsePower * Global.powerPerMassUnit * _body.mass;
			
			//Random here cannot go lower than 0.5 / -0.5 so that the core always moves at a certain pace, same for rotation
			applyForce(specialRandom() * vxMult * power, specialRandom() * vyMult * power);
			
			applyRotation(specialRandom() * vr);
		}
		
		protected function specialRandom():Number {
			var closestToZero:Number = 0.6;
			
			var n:Number = Math.random();
			n = Math.max(closestToZero, n);
			
			if (Math.random() >= 0.5) {
				//trace("specialRandom() =", n);
				return n;
			}else {
				//trace("specialRandom() =", -n);
				return -n;
			}
		}
		
	}

}