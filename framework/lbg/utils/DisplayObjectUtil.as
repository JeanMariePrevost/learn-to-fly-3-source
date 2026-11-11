package lbg.utils 
{
	import com.gskinner.geom.ColorMatrix;
	import fl.motion.Color;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import lbg.debug.Log;
	/**
	 * ...
	 * @author 
	 */
	public class DisplayObjectUtil 
	{
		
		/** Iterate through parents to see if at any point an object is a child of another */
		public static function isChildOf(child:DisplayObject, parent:DisplayObjectContainer, depthLimit:int = 50):Boolean {
			if (child.parent) {
				var currentParent:DisplayObjectContainer = child.parent;
				if (currentParent == parent) return true;//Object is child of parent
				
				for (var i:int = 0; i < depthLimit; i++) {
					if (currentParent.parent) {
						currentParent = currentParent.parent;
					}else {
						//Parent is null
						break;
					}
				}
				//Ran out of depthLimit
			}
			
			return false;
			
		}
		
		/** Returns the stage rotation of an object, adding every container rotation */
		public static function globalRotationOf(obj:DisplayObjectContainer):Number {
			return recursiveRotation(obj);
		}
		
		/** Used in globalRotationOf */
		protected static function recursiveRotation(obj:DisplayObjectContainer):Number {
			if (obj.parent) {
				return obj.rotation + recursiveRotation(obj.parent);
			}else {
				return obj.rotation;
			}
		}
		
		
		/** Returns the registration point of a display object container */
		public static function getRegistrationPoint(obj:DisplayObjectContainer):Point {
			var rect:Rectangle = obj.getRect(obj.parent);
			//var rect:Rectangle = obj.getBounds(obj.parent);
			return new Point(obj.x - rect.x, obj.y - rect.y);
		}
		
		
		/**
		 * Change the registration point of a display object
		 * @param	regX New registration point, relative to rectangle of object
		 * @param	regY New registration point, relative to rectangle of object
		 * @return Returns the previous registration point
		 */
		public static function setRegistrationPoint(obj:DisplayObjectContainer, regX:Number, regY:Number):Point {
			var reg:Point = getRegistrationPoint(obj);
			
			var diffX:Number = regX - reg.x;
			var diffY:Number = regY - reg.y;
			
			if(diffX !=0 || diffY !=0){
				for ( var i:int = 0; i < obj.numChildren; i++) {
					obj.getChildAt(i).x -= diffX;
					obj.getChildAt(i).y -= diffY;
				}
			}
			
			return reg;//Returns the old reg point
		}
		
		/**
		 * Centers the registration point of an object at the center of it
		 * @param	maintainPosition Compensate the displacement of the registration point by moving the object itself, maintaining its position
		 * @param	withNullMatrix True to center the registration point on the object w/o any transformation (e.g. rotation, scaling)
		 * @return Returns the displacement of the registration point
		 */
		public static function centerRegistrationPoint(obj:DisplayObjectContainer, maintainPosition:Boolean = true, withNullMatrix:Boolean = false):Point {
			var oldReg:Point = getRegistrationPoint(obj);
			
			if (withNullMatrix) {
				var mat:Matrix = obj.transform.matrix;
				obj.transform.matrix = new Matrix();
			}
			
			var r:Rectangle = obj.getRect(obj);
			setRegistrationPoint(obj, r.width / 2, r.height / 2);
			
			if (withNullMatrix) {
				obj.transform.matrix = mat;
			}
			
			var newReg:Point = getRegistrationPoint(obj);
			var displacement:Point = new Point(newReg.x - oldReg.x, newReg.y - oldReg.y);
			
			if(maintainPosition){
				obj.x += displacement.x;
				obj.y += displacement.y;
			}
			
			return displacement;
		}
		
		/**
		 * Used to move an object from a container to another and retain its transformation
		 * @param	obj Object to move to a new container
		 * @param	newContainer New container for the object being moved
		 */
		public static function changeContainer(obj:DisplayObject, newContainer:DisplayObjectContainer):void {
			if (obj == null) {
				Log.log("changeContainer() Error -> obj is null");
				return;
			}
			if (obj.parent == null) {
				Log.log("changeContainer() Error - Cannot change the container on an object with no parent");
				return;
			}
			
			//Issue
			//Currently we substract the matrices, but the position sometimes gets offset
			//To counter this we also enforce correct stage position by localToGlobal and back, but this shouldn't be necessary...
			
			var mat:Matrix = obj.transform.concatenatedMatrix;
			var globalPos:Point = new Point(obj.x, obj.y);
			globalPos = obj.parent.localToGlobal(globalPos);
			globalPos = newContainer.globalToLocal(globalPos);
			obj.transform.matrix = Tools.subsctractMatrices(mat, newContainer.transform.concatenatedMatrix);
			newContainer.addChild(obj);
			obj.x = globalPos.x;
			obj.y = globalPos.y;
			
		}
		
		/**
		 * Moves a DisplayObject from a certain point inside it, from center by default, DISREGARDS REGISTRATION POINT
		 * @param	x
		 * @param	y
		 * @param	xAnchor 0-1, anchor from object width
		 * @param	yAnchor 0-1, anchor from object height
		 */
		public static function moveFromAnchor(obj:DisplayObjectContainer, x:Number, y:Number, xAnchor:Number = 0.5, yAnchor:Number = 0.5):void {
			var regPoint:Point = getRegistrationPoint(obj);
			obj.x = x - (obj.width * xAnchor) + regPoint.x;
			obj.y = y - (obj.height * yAnchor) + regPoint.y;
		}
		
		/**
		 * Remove a DisplayObject and place another one right in its place
		 * @param	obj The object to remove and replace
		 * @param	replaceWith The object to replace old one with
		 */
		public static function replaceDisplayObject(obj:DisplayObject, replaceWith:DisplayObject):void {
			if (!obj.stage) {
				trace("Error - replaceDisplayObject target is not on the display list");
				return;
			}
			
			if (replaceWith.stage) {
				replaceWith.parent.removeChild(replaceWith);
			}
			
			var parent:DisplayObjectContainer = obj.parent;
			var mat:Matrix = obj.transform.concatenatedMatrix;
			
			parent.addChildAt(replaceWith, parent.getChildIndex(obj));
			parent.removeChild(obj);
			replaceWith.transform.matrix = mat;
		}
		
		
		//TODO - DOES NOT WORK
		public static function duplicateMovieClip(obj:MovieClip):MovieClip {
		//registerClassAlias('mySprite', getDefinitionByName(getQualifiedClassName(obj)) as Class);
			var mcClass:Class = Tools.getClassOf(obj);
			var clone:MovieClip = new mcClass();
			
			clone.x = obj.x;
			clone.y = obj.y;
			clone.rotation = obj.rotation;
			clone.scaleX = obj.scaleX;
			clone.scaleY = obj.scaleY;
			
			if (obj.parent) {
				obj.parent.addChild(clone);
			}
			
			return clone;
		} 
		
		/**
		 * Returns the coordinates of a point inside a container to the corresponding point in another one
		 * @param	point Local coordinates of the object
		 * @param	fromObj Original container of an object
		 * @param	toObj Container to translate to
		 * @return Translated coordinates
		 */
		public static function localToLocal(point:Point, fromObj:DisplayObjectContainer, toObj:DisplayObjectContainer):Point {
			return toObj.globalToLocal(fromObj.localToGlobal(point));
		}
		
		/**
		 * Returns the coordinates of an object inside a container to the corresponding point in another one
		 * @param	obj Object to get base coordinates from
		 * @param	fromObj Original container of an object
		 * @param	toObj Container to translate to
		 * @return Translated coordinates
		 */
		public static function localToLocal2(obj:DisplayObjectContainer, fromObj:DisplayObjectContainer, toObj:DisplayObjectContainer):Point {
			if (obj == null) {
				throw new Error("localToLocal2 error -> param obj is null");
				return new Point();
			}
			
			if (fromObj == null) {
				throw new Error("localToLocal2 error -> param fromObj is null");
				return new Point();
			}
			
			if (toObj == null) {
				throw new Error("localToLocal2 error -> param toObj is null");
				return new Point();
			}
			
			
			return toObj.globalToLocal(fromObj.localToGlobal(new Point(obj.x, obj.y)));
		}
		
		
		/**
		 * Returns the first frame of a label inside a movieclip
		 * @param	label label to look for
		 * @param	movieClip movieclip to search in
		 * @return Frame # for label, -1 if label not found
		 */
		public static function getFrameOfLabel(label:String, movieClip:MovieClip):int {
			var labels:Array = movieClip.currentLabels;
			
			for each (var l:FrameLabel in labels) {
				if (l.name == label) {
					return l.frame;
				}
			}
			
			//label not found
			return -1;
			
			var index:int = labels.indexOf(label);
			
			if (index < 0) {
				//label not found in movieclip
				return -1;
			}else {
				//label found
				return (labels[index] as FrameLabel).frame;
			}
			
		}
		
		/**
		 * Returns the visible stage rectangle from the coordinates scope of a specified object
		 */
		public static function getStageRectOn(obj:DisplayObject):Rectangle {
			var p:Point = new Point(obj.stage.stageWidth, obj.stage.stageHeight);
			var p1:Point = obj.globalToLocal(new Point(0,0));
			var p2:Point = obj.globalToLocal(p);
			
			var rect:Rectangle = new Rectangle(p1.x, p1.y, p2.x, p2.y);
			
			return rect;
		}
		
		/** Moves a rectangle coordinates from a child to stage. LocalToGlobal for rects */
		public static function localToGlobalRect(rect:Rectangle, objectParent:DisplayObjectContainer):Rectangle {
			var p:Point = new Point(rect.width, rect.height);
			var p1:Point = objectParent.globalToLocal(new Point(0,0));
			var p2:Point = objectParent.globalToLocal(p);
			
			var resultRect:Rectangle = new Rectangle(p1.x, p1.y, p2.x, p2.y);
			
			return resultRect;
		}
		
		
		//Function does not appear to work
		//public static function getVisibleBounds(source:DisplayObject):Rectangle{
			// Updated 11-18-2010;
			// Thanks to Mark in the comments for this addition;
			//var matrix:Matrix = new Matrix()
			//matrix.tx = -source.getBounds(null).x;
			//matrix.ty = -source.getBounds(null).y;
			 //
			//var data:BitmapData = new BitmapData(source.width, source.height, true, 0x00000000);
			//data.draw(source, matrix);
			//var bounds:Rectangle = data.getColorBoundsRect(0xFFFFFFFF, 0x000000, false);
			//data.dispose();
			//
			//return bounds;
		//}	
		
		/**
		 * Get the pixel color at specified coordinates on a DisplayObject
		 * @param	object The object to get color from
		 * @param	x X coordinates inside object to get color from
		 * @param	y Y coordinates inside object to get color from
		 * @return uint color value from DisplayObject at specified coordinates
		 */
		public static function getPixelColor(object:DisplayObject, x:Number = 0, y:Number = 0):uint {
			var bitmap:BitmapData = new BitmapData(1, 1, false, 0);
			var matrix:Matrix = new Matrix();
			var clipRect:Rectangle = new Rectangle();
			
			clipRect.x = 0;
			clipRect.y = 0;
			clipRect.height = 1;
			clipRect.width = 1;
			matrix.tx = -x;
			matrix.ty = -y;
			bitmap.draw(object, matrix, null, null, clipRect);
			return bitmap.getPixel(0, 0);
		}
		
		/** Uses transform.colorTransform, does not affect filters */
		public static function setObjectTint(obj:DisplayObject, tint:uint = 0xFFFFFF, tintMultiplier:Number = 1):void {
			var _color:Color = new Color();
			_color.setTint(tint, tintMultiplier);
			obj.transform.colorTransform = _color;
		}
		
		/**
		 * Sets a ColorMatrixFilter, replaces previous filters on object
		 * @param	obj Target DisplayObject
		 * @param	hue Hue rotation (-180 to 180)
		 * @param	saturation (-100 to 100)
		 * @param	brightness (-100 to 100)
		 * @param	contrast (-100 to 100)
		 */
		public static function setColorMatrix(obj:DisplayObject, hue:Number = 0, saturation:Number = 0, brightness:Number = 0, contrast:Number = 0):void {
			obj.filters = [new ColorMatrixFilter(getColorMatrix(hue, saturation, brightness, contrast))];
		}
		
		/**
		 * Returns a ColorMatrix, useful to add to pre-existing filters array
		 * @param	hue Hue rotation (-180 to 180)
		 * @param	saturation (-100 to 100)
		 * @param	brightness (-100 to 100)
		 * @param	contrast (-100 to 100)
		 */
		public static function getColorMatrix(hue:Number = 0, saturation:Number = 0, brightness:Number = 0, contrast:Number = 0):ColorMatrix {
			var cm:ColorMatrix = new ColorMatrix();
			cm.adjustColor(brightness, contrast, saturation, hue);
			return cm;
		}
		
		/** Sets a ColorMatrixFilter, replaces previous filters on object */
		public static function setObjectSaturation(obj:DisplayObject, saturation:Number = 1, brightness:Number = 1):void {
			obj.filters = [getObjectSaturationFilter(saturation, brightness)];
		}
		
		/** Returns a ColorMatrixFilter, useful to add to pre-existing filters array */
		public static function getObjectSaturationFilter(saturation:Number = 1, brightness:Number = 1):ColorMatrixFilter {
			var r:Number= 0.212671;
			var g:Number= 0.715160;
			var b:Number = 0.072169;
			
			var rr:Number = NumberUtils.interpolate(r, 1, saturation) * brightness;
			var rg:Number = NumberUtils.interpolate(0, g, 1 - saturation) * brightness;
			var rb:Number = NumberUtils.interpolate(0, b, 1 - saturation) * brightness;
			
			var gr:Number = NumberUtils.interpolate(0, r, 1 - saturation) * brightness;
			var gg:Number = NumberUtils.interpolate(g, 1, saturation) * brightness;
			var gb:Number = NumberUtils.interpolate(0, b, 1 - saturation) * brightness;
			
			var br:Number = NumberUtils.interpolate(0, r, 1 - saturation) * brightness;
			var bg:Number = NumberUtils.interpolate(0, g, 1 - saturation) * brightness;
			var bb:Number = NumberUtils.interpolate(b, 1, saturation) * brightness;
			
			var matrix:Array = [rr, rg, rb, 0, 0,
								gr, gg, gb, 0, 0,
								br, bg, bb, 0, 0,
								0, 0, 0, 1, 0];
			return new ColorMatrixFilter(matrix);
		}
		
		/**
		 * Used to remove all children from a specified object
		 * @param	obj	Container to clear of children
		 * @param	removeSelfFromParent If the object itself should be removed from its parent (for cleaning up)
		 */
		public static function removeAllChildFrom(obj:DisplayObjectContainer, removeSelfFromParent:Boolean = false, loopLimit:Number = 2000):void {
			if (obj == null) return;
			
			if (isNaN(loopLimit)) loopLimit = Number.MAX_VALUE;
			
			for (var i:int = 0; i < loopLimit; i++) {
				if (obj.numChildren != 0) {
					obj.removeChildAt(0);
				}else {
					break;
				}
			}
			
			if (removeSelfFromParent && obj.parent != null) obj.parent.removeChild(obj);
		}
	}

}