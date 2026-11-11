package lbg.camera.cameratype 
{
	import flash.display.Stage;
	import flash.geom.Point;
	import lbg.camera.cameratype.AbstractCameraType;
	import lbg.utils.NumberUtils;
	import lbg.utils.Trig;
	
	/**
	 * ...
	 * @author 
	 */
	public class CircleCamera extends AbstractCameraType 
	{
		
		public function CircleCamera(stage:Stage) 
		{
			super(stage);
		}
		
		override public function tick(targetX:Number, targetY:Number, delta:Number = 1):void 
		{
			
			var distance:Number = NumberUtils.distanceBetween(targetX, targetY, _center.x, _center.y);
			var angle:Number = Trig.angleTo(targetX, targetY, _center.x, _center.y);
			//var distance:Number = NumberUtils.distanceBetween(_center.x, _center.y, targetX, targetY);
			//var angle:Number = Trig.angleTo(_center.x, _center.y, targetX, targetY);
			
			//var neutralX:Number = Trig.vectorX(_neutralZone.x, angle);
			//var neutralY:Number = Trig.vectorY(_neutralZone.y, angle);
			//var neutralDistance:Number = NumberUtils.distanceBetween(0, 0, neutralX, neutralY);
			
			
			//trace(angle, distance, neutralDistance);
			//TestingClass.graph.clear();
			//TestingClass.graph.lineStyle(4, 0x0000FF, 0.7);
			//TestingClass.graph.moveTo(_center.x, _center.y);
			//TestingClass.graph.lineTo(_center.x + Trig.vectorX(distance,angle), _center.y+Trig.vectorY(distance,angle));
			//TestingClass.graph.lineStyle(4, 0x00FF00, 0.7);
			//TestingClass.graph.moveTo(_center.x, _center.y);
			//TestingClass.graph.lineTo(targetX, targetY);
			//TestingClass.graph.lineStyle(4, 0xFF0000, 0.7);
			//TestingClass.graph.moveTo(_center.x, _center.y);
			//TestingClass.graph.lineTo(_center.x + Trig.vectorX(neutralDistance,angle), _center.y+Trig.vectorY(neutralDistance,angle));
			
			if (distance <= MOVEMENT_THRESHOLD) {
				//Center camera if within minimum movement threshold, to avoid veeeery slow movement over 0.5 pixels
				centerCameraAt(targetX, targetY);
				return;
			}
			
			var neutralDistance:Number = Trig.getEllipseRadiusAt(angle, _neutralZone.x, _neutralZone.y);
			//trace(distance, neutralDistance, angle);
			
			distance = Math.max(0, distance - neutralDistance);
			
			if (distance == 0) {
				return;
			}
			
			//var elastX:Number = Trig.vectorX(_elasticity.x, angle);
			//var elastY:Number = Trig.vectorY(_elasticity.y, angle);
			//var elastDistance:Number = NumberUtils.distanceBetween(0, 0, elastX, elastY);
			var elastDistance:Number = Trig.getEllipseRadiusAt(angle, _elasticity.x, _elasticity.y);
			
			var distMult:Number = _maxEasing;
			var distWithinElasticity:Number = distance;
			var distOverElasticity:Number = 0;
			
			if (distance < elastDistance) {
				distMult = interpolate(_minEasing, _maxEasing, 0, elastDistance, distance, _easePower);
			}else {
				distOverElasticity = distance - elastDistance;
				distWithinElasticity -= distOverElasticity;
			}
			
			var moveDistance:Number = Math.max(_minMovement, (distWithinElasticity * distMult) + distOverElasticity);
			
			var moveX:Number = Trig.vectorX(moveDistance, angle);
			var moveY:Number = Trig.vectorY(moveDistance, angle);
			
			moveObjectsBy(moveX * delta, moveY * delta);
			
		}
		
	}

}