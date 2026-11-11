package src.game.gameobjects.obstacles.obstacles 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import src.effects.LineTrail;
	import src.game.GameCamera;
	import src.game.gameobjects.obstacles.Obstacle;
	
	/**
	 * ...
	 * @author 
	 */
	public class Jet extends Obstacle 
	{
		protected var _targetBehind:MovieClip;
		protected var _trail:LineTrail;
		
		public function Jet(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.JetVisual();
				visual.scaleX = visual.scaleY = 1.8;
				var shapeCoords:Array = getShapeCoords("jetObstacle", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			_targetRotation = -10 + Math.random() * 20;
			_impulsePower = 20;
			
			//Base stats
			setMass(100);
			_life = 750;
			
			_targetBehind = (_movieClip.tBehind as MovieClip);
			
			_movieClip.addEventListener(Event.ADDED_TO_STAGE, added);
			
		}
		
		private function added(e:Event):void 
		{
			_movieClip.removeEventListener(Event.ADDED_TO_STAGE, added);
			
			_trail = LineTrail.newLineTrail();
			_trail.color = 0xFFFFFF;
			_trail.baseAlpha = 1;
			_trail.fadeInLength = 15;
			_trail.fadeInMinAlpha = 0.5;
			_trail.fadeInPower = 0.5;
			_trail.fadeFromLength = 1;
			_trail.maxSegments = 60;
			_trail.lineWidth = 18;
			GameCamera.instance.addChildToMovingLayerRelativeTo(_trail.visual, _movieClip, -1);
			
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (_targetBehind) {
				var pos:Point = GameCamera.getPositionOnCamera(_targetBehind);
				_trail.addSegment(pos.x, pos.y);
				_trail.fadeLine();
				_trail.update();
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			if (_trail) {
				_trail.destroy();
			}
			
			_targetBehind = null;
		}
		
	}

}