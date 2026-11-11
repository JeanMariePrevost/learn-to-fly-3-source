package src 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import lbg.debug.Log;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import lbg.utils.VectorUtils;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author 
	 */
	public class UiScaler 
	{
		public static const MIN_ASPECT_RATIO:Number = 4 / 3;	
		public static const MAX_ASPECT_RATIO:Number = 16 / 9;	
		public static const ASPECT_RATIO_DIFF:Number = MAX_ASPECT_RATIO - MIN_ASPECT_RATIO;	
		public static const SCREEN_WIDTH_AT_MIN_RATIO:Number = 720;	
		public static const SCREEN_WIDTH_AT_MAX_RATIO:Number = 960;	
		public static const WIDTH_DIFF_BETWEEN_MIN_MAX_RATIOS:Number = SCREEN_WIDTH_AT_MAX_RATIO - SCREEN_WIDTH_AT_MIN_RATIO;//i.e. your x = 720 at 4:3, it would be 720 + 160 = 960 at 16:9
		
		public static const UNSCALED_STAGE_WIDTH:Number = 720;//For the UNSCALED game, as it was played in browsers	
		public static const UNSCALED_STAGE_HEIGHT:Number = 540;//For the UNSCALED game, as it was played in browsers	
		
		//protected static var listCenter:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
		protected static var listRelative:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
		protected static var listAbsolute:Vector.<UiScalerPair> = new Vector.<UiScalerPair>();
		
		public static var maxWidthAtCurrentRatio:Number = SCREEN_WIDTH_AT_MIN_RATIO;
		public static var stageHeightAtCurrentRatio:Number = UNSCALED_STAGE_HEIGHT;
		protected static var _previousAspectRatio:Number = 4 / 3;
		
		//public static function addCenter(obj:DisplayObjectContainer):void {
			//if (listCenter.indexOf(obj<0)) listCenter.push(obj);
		//}
		
		public static function moveIntoNewSprite(obj:DisplayObject):Sprite {
			if (obj.parent == null) {
				throw new Error("UiScaler.moveIntoNewSprite() ERROR - " + obj + " has no parent, cannot add container to the display list");
				return null;
			}
			
			var s:Sprite = new Sprite();
			obj.parent.addChildAt(s, obj.parent.getChildIndex(obj));
			DisplayObjectUtil.changeContainer(obj, s);
			return s;
		}
		
		/** Relative objects are move BY and not moved TO a certain point on resize, they do not need any anchors */
		public static function addRelative(obj:DisplayObjectContainer):void {
			if (listAbsolute.indexOf(obj) < 0) {
				listRelative.push(obj);
				
				//Now we assume it's been placed based on a 4:3 ratio and move it accordingly
				obj.x = (obj.x / MIN_ASPECT_RATIO) * _previousAspectRatio;
			}
		}
		
		/** Anchors the object's position to its distance to the right side of the screen
		 * @param	obj The object to add
		 * @param	anchorAtItsCenter Force the anchor to be set at the center of the object, disregarding its registration point
		 * @param	manualAnchorOffset Moves the anchor point of the object by hand, useful for objects that don't move quite as they should, doesn't affect the base position, only the anchor
		 * @param	manualObjectOffset Moves the object from its anchor
		 */
		public static function addAbsolute(obj:DisplayObjectContainer, anchorAtItsCenter:Boolean = false, manualAnchorOffset:Number = 0, manualObjectOffset:Number = 0):void {
			for (var i:int = 0; i < listAbsolute.length; i++) {
				if (listAbsolute[i].obj == obj) return;//Already in list
			}
			
			if (obj == null || obj.parent == null) {
				throw new Error("addAbsolute() ERROR - " + obj + " is null or doesn't have a parent");
				return;
			}
			
			if (obj.stage == null) {
				throw new Error("addAbsolute() ERROR - " + obj + " is not on stage, cannot get its global position");
				return;
			}
			
			
			var xToScreenWidthRatio:Number;
			var globalX:Number;
			var offsetFromCentering:Number;
			
			if (anchorAtItsCenter) {
				var rect:Rectangle = obj.getBounds(obj.parent);
				globalX = DisplayObjectUtil.localToLocal(new Point(rect.left + (rect.width / 2), rect.top + (rect.height / 2)), obj.parent, Main.parentLayer).x;
				//xToScreenWidthRatio = (globalCenteredPosition -manualAnchorOffset) / SCREEN_WIDTH_AT_MIN_RATIO;
				offsetFromCentering = DisplayObjectUtil.localToLocal2(obj, obj.parent, Main.parentLayer).x - globalX;
				//pair = new UiScalerPair(obj, xToScreenWidthRatio, -manualAnchorOffset + offsetFromCentering);
				//trace("Adding centered pair:", "obj.x=", obj.x, "xToScreenWidthRatio=", xToScreenWidthRatio, "globalCenteredPosition", globalCenteredPosition, "Global base x", DisplayObjectUtil.localToLocal2(obj, obj.parent, Main.parentLayer).x, "offsetFromCentering", offsetFromCentering, "screenWidthAtMinRatio=", SCREEN_WIDTH_AT_MIN_RATIO);
			}else {
				offsetFromCentering = 0;
				globalX = DisplayObjectUtil.localToLocal2(obj, obj.parent, Main.parentLayer).x + manualAnchorOffset;
				//xToScreenWidthRatio = (globalX + manualAnchorOffset) / SCREEN_WIDTH_AT_MIN_RATIO;
				//trace("Adding pair:", "obj.x=", obj.x, "globalX=", globalX, "xToScreenWidthRatio=", xToScreenWidthRatio, "screenWidthAtMinRatio=", SCREEN_WIDTH_AT_MIN_RATIO);
				//pair = new UiScalerPair(obj, xToScreenWidthRatio, -manualAnchorOffset);
				//trace("Would have been:", obj, xToScreenWidthRatio, -manualAnchorOffset);
				//trace("Now is:", obj, globalX, -manualAnchorOffset + offsetFromCentering);
			}
			
			addAbsoluteManually(obj, globalX, -manualAnchorOffset + offsetFromCentering + manualObjectOffset);
			
			//trace("Added pair:", obj, "anchorAtItsCenter=", anchorAtItsCenter, "xToScreenWidthRatio=", xToScreenWidthRatio);
			
			//trace("addAbsolute(), base x was", obj.x);
			//trace("addAbsolute(), global bas x was", DisplayObjectUtil.localToLocal2(obj, obj.parent, Main.parentLayer).x);
			//trace("addAbsolute(), maxWidthAtCurrentRatio", maxWidthAtCurrentRatio);
			//trace("addAbsolute(), pair.anchorPosition", pair.anchorPosition);
			//trace("addAbsolute(), pair.offset", pair.offset);
			
		}
		
		/** Anchors the object's position to its distance to the right side of the screen
		 * @param	obj The object to add
		 * @param	anchorX Forces a X coordinate to act as this object's anchor
		 * @param	anchorOffset Object's position relative to the set anchor */
		public static function addAbsoluteManually(obj:DisplayObjectContainer, anchorX:Number, anchorOffset:Number = 0):void {
			for (var i:int = 0; i < listAbsolute.length; i++) {
				if (listAbsolute[i].obj == obj) return;//Already in list
			}
			
			if (obj == null || obj.parent == null) {
				throw new Error("addAbsolute() ERROR - " + obj + " is null or doesn't have a parent");
				return;
			}
			
			if (obj.stage == null) {
				throw new Error("addAbsolute() ERROR - " + obj + " is not on stage, cannot get its global position");
				return;
			}
			
			var xToScreenWidthRatio:Number = anchorX / SCREEN_WIDTH_AT_MIN_RATIO;
			trace("addAbsoluteManually - Pair is:", obj, xToScreenWidthRatio, anchorOffset);
			var pair:UiScalerPair = new UiScalerPair(obj, xToScreenWidthRatio, anchorOffset);
			listAbsolute.push(pair);
			
			//Now we assume it's been placed based on a 4:3 and move it to its proportional position
			obj.x = maxWidthAtCurrentRatio * pair.anchorPosition + pair.offset;
		}
		
		public static function updateScale(aspectRatio):void {
			aspectRatio = NumberUtils.constrain(aspectRatio, MIN_ASPECT_RATIO, MAX_ASPECT_RATIO);
			if (_previousAspectRatio == aspectRatio) return;//Nothing changed
			
			var changeInRatio:Number = aspectRatio - _previousAspectRatio;
			var movementAtFullX:Number = WIDTH_DIFF_BETWEEN_MIN_MAX_RATIOS * (changeInRatio / ASPECT_RATIO_DIFF);
			
			maxWidthAtCurrentRatio = NumberUtils.interpolate2(SCREEN_WIDTH_AT_MIN_RATIO, SCREEN_WIDTH_AT_MAX_RATIO, MIN_ASPECT_RATIO, MAX_ASPECT_RATIO, aspectRatio);
			stageHeightAtCurrentRatio = maxWidthAtCurrentRatio / aspectRatio;
			
			cleanListsOfDestroyedObjects();
			
			var p:Point = new Point();
			var o:DisplayObjectContainer;
			
			for each(o in listRelative) {
				p.x = o.x;
				p.y = o.x;
				var moveRatio:Number = o.localToGlobal(p).x / maxWidthAtCurrentRatio;
				o.x += movementAtFullX * moveRatio;
			}
			
			for each(var pair:UiScalerPair in listAbsolute) {
				pair.obj.x = (maxWidthAtCurrentRatio * pair.anchorPosition) + pair.offset;
				//trace("pair.obj", pair.obj);
				//trace("pair.obj.x", pair.obj.x);
				//trace("pair.anchorPosition", pair.anchorPosition);
				//trace("pair.offset", pair.offset);
			}
			
			_previousAspectRatio = aspectRatio;
			
			//Log.log("UiScaler.updateScale() - ratio: " + aspectRatio + ", " + listRelative.length + " relatives, " + listAbsolute.length + " absolutes.");
		}
		
		protected static function cleanListsOfDestroyedObjects():void {
			for (var i:int = listRelative.length - 1; i >= 0; i--) {
				if (listRelative[i] == null || listRelative[i].stage == null) {
					//trace("UiScaler - removing", listRelative[i], "from listRelative");
					listRelative.splice(i, 1);
				}
			}
			
			for (i = listAbsolute.length - 1; i >= 0; i--) {
				if (listAbsolute[i] == null || listAbsolute[i].obj == null || listAbsolute[i].obj.stage == null) {
					//trace("UiScaler - removing", listAbsolute[i], "from listAbsolute");
					listAbsolute[i].destroy();
					listAbsolute.splice(i, 1);
				}else if (listAbsolute[i].obj.numChildren <= 0 && listAbsolute[i].obj.width == 0 && listAbsolute[i].obj.height == 0) {
					trace("UiScaler - removing", listAbsolute[i], listAbsolute[i].obj, "from listAbsolute, it seems to be an empty container");
					listAbsolute[i].destroy();
					listAbsolute.splice(i, 1);
				}
			}
		}
		
		static public function get previousAspectRatio():Number 
		{
			return _previousAspectRatio;
		}
		
	}

}