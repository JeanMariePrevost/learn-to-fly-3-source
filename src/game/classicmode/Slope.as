package src.game.classicmode 
{
	import flash.display.MovieClip;
	import nape.phys.BodyType;
	import nape.shape.ShapeList;
	import src.game.GameEngine;
	import src.game.GameEngineClassic;
	import src.game.GameMediator;
	import src.game.gameobjects.GameObject;
	import src.game.gameobjects.ShapesData;
	
	/**
	 * ...
	 * @author 
	 */
	public class Slope extends GameObject 
	{
		public var target:MovieClip;
		
		public function Slope() 
		{
			var shapeList:ShapeList = ShapesData.getShapeListOf("classicSlope");
			var visual:MovieClip = new SlopeVisual();
			super(shapeList, visual, BodyType.KINEMATIC);
			
			GameMediator.playerLaunched.addOnce(onTakeoff);
			
		}
		
		private function onTakeoff():void 
		{
			trace("Takeoff!");
			GameEngine.instance.addToPhysicsEngine(this);
		}
		
	}

}