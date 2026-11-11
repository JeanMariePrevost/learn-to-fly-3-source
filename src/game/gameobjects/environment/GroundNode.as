package src.game.gameobjects.environment 
{
	import flash.display.MovieClip;
	import nape.dynamics.InteractionFilter;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import nape.shape.ShapeList;
	import src.game.gameobjects.GameObject;
	import src.game.gameobjects.KinematicGameObject;
	import src.game.PhysicsEngine;
	import src.system.Global;
	
	/**
	 * ...
	 * @author 
	 */
	public class GroundNode extends KinematicGameObject 
	{
		
		public function GroundNode(physicsEngine:PhysicsEngine) 
		{
			var shape:Shape =  new Polygon(Polygon.rect( -1000, -1000, 2000, 2000));
			shape.material.dynamicFriction = 0.2;
			shape.material.staticFriction = 5;
			shape.material.elasticity = 0.1;
			var shapeList:ShapeList = new ShapeList();
			shapeList.push(shape);
			var visual:MovieClip = new DebugGroundVisual();
			
			super(shapeList, visual);
			setPhysicsEngine(physicsEngine);
			
			_body.cbTypes.add(Global.CB_TYPE_GROUND);
			_body.setShapeFilters(new InteractionFilter(Global.COLLISION_GROUP_GROUND, Global.COLLISION_MASK_GROUND));
			
		}
		
		public static function  sortFunction(itemA:GroundNode, itemB:GroundNode):Number {
			if (itemA.getMovieClip().x < itemB.getMovieClip().x) return -1; //ITEM A is before ITEM B
			else if (itemA.getMovieClip().x > itemB.getMovieClip().x) return 1; //ITEM A is after ITEM B
			else return 0; //ITEM A and ITEM B have same date
		}		
	}

}