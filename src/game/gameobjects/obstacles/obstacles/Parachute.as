package src.game.gameobjects.obstacles.obstacles {
	import flash.display.MovieClip;
	import lbg.utils.Trig;
	import src.system.Global;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class Parachute extends Obstacle 
	{
		
		public function Parachute(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.ParachuteVisual();
				visual.scaleX = visual.scaleY = 1.3;
				var shapeCoords:Array = getShapeCoords("parachute", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			//Base stats
			setMass(5);
			_life = 70;
			
			_impulsePower = 6;
			
		}
		
		override protected function applyFlipChance(visual:MovieClip, shapeCoords:Array):void 
		{
			//Cannot be flipped
			//super.applyFlipChance(visual, shapeCoords);
		}
		
		override protected function applyObstacleForce(delta:Number):void 
		{
			var angle:Number = Trig.toDegrees(_body.rotation) + 90;
			if (_movieClip.scaleX < 0) {
				angle -= 180;
			}
			
			var power:Number = _impulsePower * Global.powerPerMassUnit * _body.mass;
			
			var vx:Number = Trig.vectorX(power, angle);
			var vy:Number = Trig.vectorY(power, angle);
			vy = Math.max(0, vy);//Cannot go up
			applyForce(vx, vy);
		}
		
	}

}