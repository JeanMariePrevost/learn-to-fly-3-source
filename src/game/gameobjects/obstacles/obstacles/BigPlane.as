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
	public class BigPlane extends Obstacle 
	{
		protected var _targetBehind1:MovieClip;
		protected var _targetBehind2:MovieClip;
		protected var _trail1:LineTrail;
		protected var _trail2:LineTrail;
		
		public function BigPlane(visual:MovieClip=null, shapeCoords:Array=null) 
		{
			if(visual == null){
				var visual:MovieClip = new src.game.gameobjects.obstacles.obstacles.BigPlaneVisual();
				visual.scaleX = visual.scaleY = 1.4;
				var shapeCoords:Array = getShapeCoords("bigPlane", visual.scaleX);
			}
			
			super(visual, shapeCoords);
			
			_impulsePower = 13;
			
			//Base stats
			setMass(400);
			_life = 1500;
			
			_targetBehind1 = (_movieClip.tBehind1 as MovieClip);
			_targetBehind2 = (_movieClip.tBehind2 as MovieClip);
			
			_movieClip.addEventListener(Event.ADDED_TO_STAGE, added);
			
		}
		
		private function added(e:Event):void 
		{
			_movieClip.removeEventListener(Event.ADDED_TO_STAGE, added);
			
			_trail1 = LineTrail.newLineTrail();
			_trail1.color = 0xFFFFFF;
			_trail1.baseAlpha = 1;
			_trail1.fadeInLength = 20;
			_trail1.fadeInMinAlpha = 0.5;
			_trail1.fadeInPower = 0.5;
			_trail1.fadeFromLength = 1;
			_trail1.maxSegments = 60;
			_trail1.lineWidth = 23;
			GameCamera.instance.addChildToMovingLayerRelativeTo(_trail1.visual, _movieClip, -1);
			
			_trail2 = LineTrail.newLineTrail();
			_trail2.color = 0xFFFFFF;
			_trail2.baseAlpha = 1;
			_trail2.fadeInLength = 20;
			_trail2.fadeInMinAlpha = 0.5;
			_trail2.fadeInPower = 0.5;
			_trail2.fadeFromLength = 1;
			_trail2.maxSegments = 60;
			_trail2.lineWidth = 16;
			GameCamera.instance.addChildToMovingLayerRelativeTo(_trail2.visual, _movieClip, -1);
			
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (_targetBehind1 && _targetBehind2) {
				var pos:Point = GameCamera.getPositionOnCamera(_targetBehind1);
				_trail1.addSegment(pos.x, pos.y);
				_trail1.fadeLine(0.005);
				_trail1.update();
				
				pos = GameCamera.getPositionOnCamera(_targetBehind2);
				_trail2.addSegment(pos.x, pos.y);
				_trail2.fadeLine(0.005);
				_trail2.update();
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			if (_trail1) {
				_trail1.destroy();
			}
			
			if (_trail2) {
				_trail2.destroy();
			}
			
			_targetBehind1 = null;
			_targetBehind2 = null;
		}
		
		
	}

}