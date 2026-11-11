package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import lbg.utils.NumberUtils;
	import sound.Electronics;
	import sound.LockAndFire;
	import src.UiScaler;
	import src.audio.Audio;
	import src.game.GameCamera;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.game.GameToolTip;
	import src.game.particles.Particles;
	import src.game.StatHooks;
	import src.Main;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class OrbitalCannon extends AbstractLauncher 
	{
		public var sat1:MovieClip;
		public var sat2:MovieClip;
		public var sat3:MovieClip;
		
		protected var _hud:OrbitalCannonHud;
		protected var _beam:OrbitalCannonBeam;
		
		protected var _animFrame:Number = 1;
		
		public function OrbitalCannon(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			
			StatHooks.cameraZoomFloor = 2.2;
			
			sat1.stop();
			if (sat2) sat2.stop();
			if (sat3) sat3.stop();
			
			_hud = new OrbitalCannonHud(_item.statSpecial);
			_hud.addEventListener(Event.COMPLETE, onMinigameOver);
			GameCamera.instance.addChildToFixedLayer(_hud, 3);
			UiScaler.addAbsolute(_hud, false, 360);
			
			GameToolTip.show("orbital");
			
			Audio.playSound(Electronics).volume = 0.5;
		}
		
		private function onMinigameOver(e:Event):void 
		{
			_hud.removeEventListener(Event.COMPLETE, onMinigameOver);
			GameToolTip.hide();
			_beam = new OrbitalCannonBeam();
			_beam.addEventListener(Event.COMPLETE, onBeamComplete);
			addChild(_beam);
			Audio.playSound(LockAndFire);
		}
		
		private function onBeamComplete(e:Event):void 
		{
			StatHooks.cameraZoomFloor = 0;
			doExplosion();
			applyPower();
			finalizeTakeoff();
			finalizeLauncher();
		}
		
		
		override public function tick(delta:Number):void 
		{
			_hud.tick(delta);
			
			_animFrame += delta;
			sat1.gotoAndStop(int(Math.min(sat1.totalFrames, _animFrame)));
			if (sat2) sat2.gotoAndStop(int(Math.max(1, Math.min(sat2.totalFrames, _animFrame - 60))));
			if (sat3) sat3.gotoAndStop(int(Math.max(1, Math.min(sat3.totalFrames, _animFrame - 120))));
		}
		
		protected function applyPower():void {
			var power:Number = launcherBasePower;
			var powerAtWeight:Number = _item.getPowerAtWeightMult(_player.getBody().mass);
			
			var minigamePower:Number = Math.max(0.1, _hud.minigameScoreNorm);
			
			trace("Applying launcher power:", power, "x", powerAtWeight, "x", minigamePower);
			
			applyLauncherThrust(power * powerAtWeight * minigamePower);
		}
		
		protected function doExplosion():void {
			var i:int;
			
			for (i = 0; i <= 7; i++) {
				Particles.builder.smokeWhite(0, 0, 1, 2, Math.random() * 20, -30 + NumberUtils.randomBoth(40), this);
			}
			for (i = 0; i <= 7; i++) {
				Particles.builder.smokeWhite(0, 0, 1, 2, Math.random() * 20, -150 - NumberUtils.randomBoth(40), this);
			}
			for (i = 0; i <= 15; i++) {
				Particles.builder.snowDebris(NumberUtils.randomBoth(300), NumberUtils.randomBoth(200), 2 + Math.random(), 500 + Math.random() * 2000, -45 - Math.random() * 90, this);
			}
			for (i = 0; i <= 15; i++) {
				Particles.builder.snowDebris(NumberUtils.randomBoth(20), NumberUtils.randomBoth(20), 1 + Math.random(), Math.random() * 500, -Math.random() * 180, this);
			}
			
			Particles.builder.explosiveSmoke(0, 0, 1, 1, 1 + Math.random() * 2, -90, this);
		}
	}

}