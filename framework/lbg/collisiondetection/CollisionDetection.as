/**
* GTween by Grant Skinner. Aug 1, 2005
* Visit www.gskinner.com/blog for documentation, updates and more free code.
*
*
* Copyright (c) 2005 Grant Skinner
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
**/

package lbg.collisiondetection{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class CollisionDetection {
		
		public function CollisionDetection() {
			throw new Error("Should not instantiate CollisionDetection");
		}
		
		/**
		 * 
		 * @param	p_alphaTolerance Offset objects alpha from -255 to 255
		 * @param	stageScaleMatrix Pass a matrix to account for scaled/stretched stage, typically the concatenatedMatrix of the main class object
		 * @return
		 */
		static public function checkForCollision(p_clip1:DisplayObjectContainer, p_clip2:DisplayObjectContainer, skipBroadPhase:Boolean = false, p_alphaTolerance:Number = 0, stageScaleMatrix:Matrix = null):Rectangle {
			
			if(!skipBroadPhase){
				if (!p_clip1.hitTestObject(p_clip2)) {
					return null;
				}
			}
					
			// get bounds:
			var bounds1:Rectangle = p_clip1.getBounds(p_clip1.stage);
			var bounds2:Rectangle = p_clip2.getBounds(p_clip2.stage);
			
			// rule out anything that we know can't collide:
			if (((bounds1.right < bounds2.left) || (bounds2.right < bounds1.left)) || ((bounds1.bottom < bounds2.top) || (bounds2.bottom < bounds1.top)) ) {
				return null;
			}
			
			// determine test area boundaries:
			var bounds:Rectangle = new Rectangle;
			bounds.left = Math.max(bounds1.left,bounds2.left);
			bounds.right = Math.min(bounds1.right,bounds2.right);
			bounds.top = Math.max(bounds1.top,bounds2.top);
			bounds.bottom = Math.min(bounds1.bottom, bounds2.bottom);
			
			// set up the image to use:
			var img:BitmapData = new BitmapData(Math.max(1,bounds.right - bounds.left), Math.max(1,bounds.bottom - bounds.top), false);
			
			// draw in the first image:
			var mat:Matrix = p_clip1.transform.concatenatedMatrix;
			if(stageScaleMatrix) mat.scale(1 / stageScaleMatrix.a,1 / stageScaleMatrix.d);
			mat.tx -= bounds.left;
			mat.ty -= bounds.top;
			img.draw(p_clip1,mat, new ColorTransform(1,1,1,1,255,-255,-255,p_alphaTolerance));
			
			// overlay the second image:
			mat = p_clip2.transform.concatenatedMatrix;
			if(stageScaleMatrix) mat.scale(1 / stageScaleMatrix.a,1 / stageScaleMatrix.d);
			mat.tx -= bounds.left;
			mat.ty -= bounds.top;
			img.draw(p_clip2, mat, new ColorTransform(1, 1, 1, 1, 255, 255, 255, p_alphaTolerance), "difference");
			
			// find the intersection:
			var intersection:Rectangle = img.getColorBoundsRect(0xFFFFFFFF, 0xFF00FFFF);
			
			// if there is no intersection, return null:
			if (intersection.width == 0) { return null; }
			
			// adjust the intersection to account for the bounds:
			intersection.x += bounds.left;
			intersection.y += bounds.top;
			
			return intersection;
		}
		
		
	}
}