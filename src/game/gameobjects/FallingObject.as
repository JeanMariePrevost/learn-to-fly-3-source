package src.game.gameobjects 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Trig;
	import nape.dynamics.InteractionFilter;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.shape.Shape;
	import nape.shape.ShapeList;
	import src.game.GameCamera;
	import src.game.PhysicsEngine;
	import src.system.Global;
	import src.system.ProfileState;
	
	/**
	 * ...
	 * @author 
	 */
	public class FallingObject extends GameObject implements IFallingObject
	{
		
		public function FallingObject(instantiateThroughStaticFunction:Enforcer, visual:MovieClip, bodyType:BodyType=null) 
		{
			var r:Number = visual.rotation;
			
			var shapeList:ShapeList = GameObject.getDefaultRectShapeList(visual, 0.6);
			super(shapeList, visual, bodyType);
			
			_body.cbTypes.add(Global.CB_TYPE_PARTICLE);
			_body.setShapeFilters(new InteractionFilter(Global.COLLISION_GROUP_PARTICLE, Global.COLLISION_MASK_PARTICLE));
			
			setPosition(visual.x, visual.y);
			rotation = Trig.toRadians(r);
			
		}
		
		public static function getNewFallingObject(visual:MovieClip, bodyType:BodyType = null):IFallingObject {
			if (visual != null && visual.parent != null && ProfileState.instance.optionFallingObjects == "On") {
				return new FallingObject(new Enforcer(), visual, bodyType);
			}else {
				return new NullFallingObject(visual, bodyType);
			}
		}
		
		public static function createSimpleFallingObject(fromObject:MovieClip):IFallingObject {
			var fo:IFallingObject = FallingObject.getNewFallingObject(fromObject);
			
			//Change container solution
			DisplayObjectUtil.changeContainer(fromObject, GameCamera.instance.getMovingLayer(0));
			
			//GameCamera.instance.addChildToMovingLayer(fromObject);
			fo.setPhysicsEngine(PhysicsEngine.instance);
			
			var r:Number = fromObject.rotation;
			fo.setPosition(fromObject.x, fromObject.y);
			fo.rotation = Trig.toRadians(r);
			
			return fo;
		}
		
		public function useObjectPosition(obj:DisplayObject):void {
			setPosition(obj.x, obj.y);
			rotation = Trig.toRadians(obj.rotation);
		}
		
		public function mimicBodyMomentum(body:Body, mult:Number = 1, gravityMassMult:Number = 1):void {
			_body.angularVel = body.angularVel * mult;
			_body.velocity = body.velocity.mul(mult);
			_body.gravMass *= gravityMassMult;
		}
	}

}

class Enforcer{}