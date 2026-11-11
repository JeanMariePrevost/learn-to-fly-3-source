package src.gui {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.Easing;
	import org.osflash.signals.Signal;
	import src.audio.Sfx;
	import src.reg.RegistryEntry;
	
	/**
	 * ...
	 * @author 
	 */
	public class MedalMessageBarMedal extends MovieClip 
	{
		public var medal:MovieClip;
		public var ring:MovieClip;
		public var shine:MovieClip;
		
		protected const SHINE_TIME:Number = 40;
		protected const RING_TIME:Number = 40;
		protected const MEDAL_TWEEN_START_TIME:Number = 20;
		protected const MEDAL_TWEEN_DURATION:Number = 25;
		protected const MEDAL_SCALE:Number = 0.9;
		
		protected var _time:Number = 0;
		
		public function MedalMessageBarMedal(entry:RegistryEntry, level:uint) 
		{
			super();
			
			ring = new src.gui.MedalMessageBarRing();
			addChild(ring);
			ring.gotoAndStop(1);
			ring.visible = false;
			
			medal = new (entry.gameClass.valueAt(level - 1))();
			medal.gotoAndStop(level);
			addChild(medal);
			
			shine = new src.gui.MedalMessageBarShine();
			addChild(shine);
			shine.gotoAndStop(1);
			shine.visible = false;
			
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		public function tick(delta:Number):void {
			_time += delta;
			
			//Medal animation
			if (_time <= MEDAL_TWEEN_START_TIME) {
				medal.visible = false;
				medal.scaleX = medal.scaleY = 0.001;
			}else if (_time <= MEDAL_TWEEN_START_TIME + MEDAL_TWEEN_DURATION) {
				medal.visible = true;
				medal.scaleX = medal.scaleY = Easing.easeOutBack(_time - MEDAL_TWEEN_START_TIME, 0, MEDAL_SCALE, MEDAL_TWEEN_DURATION);
			}else {
				medal.visible = true;
				medal.scaleX = medal.scaleY = MEDAL_SCALE;
			}
			
			//trace("Time:", _time, "Medal scale:", medal.scaleX);
			
			//Ring animation
			if (_time >= RING_TIME) {
				if (ring.visible == false) {
					Sfx.playMedalSound3();
					ring.visible = true;
					ring.gotoAndStop(1);
				}else if (ring.currentFrame < ring.totalFrames) {
					ring.nextFrame();
				}else {
					ring.alpha = 0;
				}
				//trace("Ring frame:", ring.currentFrame);
			}
			
			//Shine animation
			if (_time >= SHINE_TIME) {
				if (shine.visible == false) {
					shine.visible = true;
					shine.gotoAndStop(1);
					
					var rec:Rectangle = medal.getBounds(this);
					var mask:Bitmap = new Bitmap(new BitmapData(rec.width, rec.height, true, 0x00000000));
					var matrix:Matrix = medal.transform.matrix;
					matrix.tx = -rec.x;
					matrix.ty = -rec.y;
					mask.bitmapData.draw(medal, matrix);
					mask.x = rec.x;
					mask.y = rec.y;
					mask.cacheAsBitmap = true;
					shine.cacheAsBitmap = true;
					addChild(mask);
					shine.mask = mask;
				}else if (shine.currentFrame < shine.totalFrames) {
					shine.nextFrame();
				}else {
					shine.alpha = 0;
				}
			}
			
		}
		
		public function destroy():void {
			medal = null;
			
			if (stage) parent.removeChild(this);
			
			while (numChildren) removeChildAt(0);
		}
		
	}

}