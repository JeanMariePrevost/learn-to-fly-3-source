package src.game.gameobjects.player.stage 
{
	import flash.display.MovieClip;
	import lbg.utils.DisplayObjectUtil;
	import lbg.utils.NumberUtils;
	import src.game.DeltaMovieClipWrapper;
	import src.game.gameobjects.player.Player;
	import src.system.GameStateItem;
	import src.system.Global;
	import src.game.particles.AbstractParticle;
	import src.game.particles.Particles;
	
	/**
	 * ...
	 * @author 
	 */
	public class MonsterTruck extends SimpleStage 
	{
		protected var _fires:Vector.<MovieClip> = new Vector.<MovieClip>();
		protected var _smokeCounter:Number = 0;
		
		public function MonsterTruck(player:Player, item:GameStateItem) 
		{
			super(player, item);
			
			//_thrustOffsetVec2.y = 0.05;
			
		}
		
		override public function startStage():void 
		{
			_hasStarted = true;
			_visual = new (_item.statVisualClass)();
			_wrapper = new DeltaMovieClipWrapper(_visual, "initStart");
			
			_player.getMovieClip().addChildAt(_visual, 0);//Add child BEHIND body
			_visual.x = _player.tBottom.x;
			_visual.y = _player.tBottom.y;
			
			if(_visual.fire1) _fires.push(_visual.fire1 as MovieClip);
			if(_visual.fire2) _fires.push(_visual.fire2 as MovieClip);
			if(_visual.fire3) _fires.push(_visual.fire3 as MovieClip);
			if(_visual.fire4) _fires.push(_visual.fire4 as MovieClip);
			if(_visual.fire5) _fires.push(_visual.fire5 as MovieClip);
			if (_visual.fire6) _fires.push(_visual.fire6 as MovieClip);
			
			for each(var f:MovieClip in _fires) f.visible  = false;
		}
		
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			
			if (_wrapper.currentState == "on" || _wrapper.currentState == "active") {
				if (_smokeCounter <= 0) {
					_smokeCounter = 3;
					var p:AbstractParticle = Particles.builder.smokeBlack(0, 60, 0.5, 0.75, 1 + Math.random() * 3, DisplayObjectUtil.globalRotationOf(_visual) + 90 + NumberUtils.randomBoth(4), _visual);
					p.vScale = 0.07;
					p.particleLife = 0
				}else {
					_smokeCounter -= 1;
				}
			}
			
			if (_wrapper.currentState == "on" || _wrapper.currentState == "active") {
				var scale:Number = NumberUtils.randomRange(0.9, 1.1);
				for each(var f:MovieClip in _fires) {
					f.visible = true;
					f.scaleX = f.scaleY = scale;
				}
			}else {
				for each(var f:MovieClip in _fires) f.visible  = false;
			}
		}
		
		override protected function playSound(fadeInDuration:Number = NaN):void 
		{
			super.playSound(150);
		}
		
		override protected function stopSound(fadeOutDuration:Number = NaN):void 
		{
			super.stopSound(600);
		}
	}

}