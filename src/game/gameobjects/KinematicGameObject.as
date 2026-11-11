package src.game.gameobjects 
{
	import flash.display.MovieClip;
	import nape.phys.BodyType;
	import nape.shape.Shape;
	import nape.shape.ShapeList;
	
	/**
	 * ...
	 * @author 
	 */
	public class KinematicGameObject extends GameObject 
	{
		
		public function KinematicGameObject(shapeList:ShapeList, visual:MovieClip) 
		{
			super(shapeList, visual, BodyType.KINEMATIC);
			
		}
		
	}

}