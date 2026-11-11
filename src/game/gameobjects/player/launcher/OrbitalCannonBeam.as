package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import lbg.utils.DisplayObjectUtil;
	import src.effects.LineTrail;
	import src.game.DeltaMovieClipWrapper;
	import src.game.particles.Particles;
	import src.Main;
	
	/**
	 * ...
	 * @author 
	 */
	public class OrbitalCannonBeam extends MovieClip 
	{
		public var beam1:MovieClip;
		public var beam2:MovieClip;
		
		protected var _smokeCounter:Number = 0;//Used to delay smoke particles
		protected var _trail1:LineTrail;
		protected var _trail2:LineTrail;
		
		protected var _wrapper:DeltaMovieClipWrapper;
		
		public function OrbitalCannonBeam() 
		{
			//DisplayObjectUtil.setObjectTint(this, 0xFF0000, 0.7);
			y = 15;
			_wrapper = new DeltaMovieClipWrapper(this);
			_trail1 = LineTrail.newLineTrail();
			_trail2 = LineTrail.newLineTrail();
			_trail1.minDistance = 2;
			_trail1.baseAlpha = 0.8;
			_trail1.fadeFromLength = 0;
			_trail1.lineWidth = 3;
			_trail1.minDistance = 2;
			_trail2.baseAlpha = 0.8;
			_trail2.fadeFromLength = 0;
			_trail2.lineWidth = 3;
			addChild(_trail1.visual);
			addChild(_trail2.visual);
			Main.unsafeTickSignal.add(tick);
		}
		
		protected function tick(delta:Number):void {
			if (beam1 != null) {
				if (_smokeCounter <= 0) {
					_trail1.addSegment(beam1.x, beam1.y);
					_trail2.addSegment(beam2.x, beam2.y);
					_trail1.fadeLine();
					_trail2.fadeLine();
					_trail1.update();
					_trail2.update();
					
					Particles.builder.smokeWhiteQuick(0, 0, 0.5, 0.8, Math.random() * 10, -70 - (Math.random() * 40), beam1);
					Particles.builder.smokeWhiteQuick(0, 0, 0.5, 0.8, Math.random() * 10, -70 - (Math.random() * 40), beam2);
					//Particles.builder.blackSpot(0, 0, 0.4, 0.4, 50, 50, beam1);
					//Particles.builder.blackSpot(0, 0, 0.4, 0.4, 50, 50, beam2);
					_smokeCounter = 2;
				}else {
					_smokeCounter --;
				}
			}
			
			
			_wrapper.tick(delta);
			if (currentLabel == "specialEnd") {
				//BOOM
				dispatchEvent(new Event(Event.COMPLETE));
				_wrapper.setToDeath();
			}else if (currentLabel == "deathEnd") {
				//Destroy
			}
		}
		
	}

}