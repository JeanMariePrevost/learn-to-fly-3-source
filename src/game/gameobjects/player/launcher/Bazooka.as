package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import lbg.components.labelmovieclip.LabelMovieClip;
	import lbg.utils.Trig;
	import sound.Explode2;
	import sound.MissileLaunch;
	import src.audio.Audio;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameEngine;
	import src.game.gameobjects.player.Player;
	import src.game.GameToolTip;
	import src.game.particles.AbstractParticle;
	import src.game.particles.Particles;
	import src.game.StatHooks;
	import src.system.GameStateItem;
	import src.system.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class Bazooka extends AbstractLauncher 
	{
		public var puller:MovieClip;
		public var bazooka:MovieClip;
		
		protected var _pull:Number = 0;
		protected var _pullTotal:Number = 0;
		protected var _wrapper:DeltaMovieClipWrapper;
		protected var _pullerWrapper:DeltaMovieClipWrapper;
		
		protected var _tickFunction:Function;
		
		protected var _pullTime:Number = 0;
		protected const PULL_DURATION:Number = 50;
		protected var _dropTime:Number = 0;
		protected const DROP_DURATION:Number = 25;
		protected const MAX_PULL:Number = 500
		protected var _waitDownTime:Number = 0;
		protected const WAIT_DOWN_DURATION:Number = 60;
		
		public function Bazooka(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			GameToolTip.show("bazooka");
			_wrapper = new DeltaMovieClipWrapper(this, "specialStart");
			_wrapper.stop();
			_tickFunction = tickDrop;
			
			_pullerWrapper = new DeltaMovieClipWrapper(puller);
			//_pullerWrapper.stop();
			_pullerWrapper.setAction("activeEnd", "idleStart");
			_pullerWrapper.setAction("specialStart", LabelMovieClip.ACTION_PLAY);
			_pullerWrapper.setAction("specialEnd", "specialStart");
			
			Input.instance.basicCommands.anyKeyOrMouse.signalCommandDown.addOnce(fire);
		}
		
		protected function fire():void 
		{
			GameToolTip.hide();
			var bullet:BazookaBullet = new BazookaBullet(bazooka);
			bullet.explosionSignal.addOnce(onExplosion);
			addChild(bullet);
			
			Audio.playSound(MissileLaunch);
			
			var p:AbstractParticle;
			for (var i:int = 0; i <= 5; i++) {
				Particles.builder.smokeWhite(0, 0, 0.4, 0.9, 2 + Math.random() * 7, bazooka.rotation + (-20 + Math.random() * 40), bazooka.tBehind);
				var p:AbstractParticle = Particles.builder.smokeWhiteQuick(0, 0, 0.4, 0.6, Math.random() * 3, bazooka.rotation - 200 + Math.random() * 40, bazooka);
				p.vScale = 0.01;
				p.baseAlpha = 0.7;
				p.drag = 0.01;
			}
		}
		
		private function onExplosion(bullet:BazookaBullet):void 
		{
			var power:Number = launcherBasePower;
			var powerAtWeight:Number = _item.getPowerAtWeightMult(_player.getBody().mass);
			
			var bazookaAngle:Number;
			
			bazookaAngle = Trig.angleTo(bullet.x, bullet.y, 0, -130) + 90;
			
			applyLauncherThrust(power * powerAtWeight, bazookaAngle);
			_player.rotation = Trig.toRadians(bazookaAngle);
			
			finalizeTakeoff();
			finalizeLauncher();
			Audio.playSound(Explode2);
		}
		
		override public function tick(delta:Number):void 
		{
			_tickFunction(delta);
		}
		
		protected function tickPull(delta:Number):void {
			if (_pullTime <= PULL_DURATION) {
				//Pull
				_pullerWrapper.setToActive();
				_pull += 0.2;
				_pullTime+= 1;
			}else {
				if (_dropTime <= DROP_DURATION) {
					//Drop
					//_pullerWrapper.setToSpecial();
					_pull -= 0.2;
					_dropTime += 1;
				}else {
					//Loop
					_pullTime = 0;
					_dropTime = 0;
				}
			}
			
			_pull *= 0.95;
			
			_pullTotal += _pull;
			_pullTotal = Math.max(Math.min(_pullTotal, MAX_PULL), 1);
			
			_wrapper.interpolateLabel("specialStart", _pullTotal / MAX_PULL);
			
			if (_pullTotal >= MAX_PULL) {
				_tickFunction = tickDrop;
			}
		}
		
		protected function tickDrop(delta:Number):void {
			if (_pullTotal > 1) {
				_pullerWrapper.setToSpecial();
				_pull -= 0.2;
				_pull *= 0.94;
				
				_pullTotal += _pull;
				_pullTotal = Math.max(Math.min(_pullTotal, MAX_PULL), 1);
				
				_wrapper.interpolateLabel("specialStart", _pullTotal / MAX_PULL);
			}else {
				_pullerWrapper.setToIdle();
				if (_waitDownTime < WAIT_DOWN_DURATION) {
					_waitDownTime += 1;
				}else {
					_waitDownTime = 0;
					_pull = 0;
					_pullTime = 0;
					_dropTime = 0;
					_tickFunction = tickPull;
				}
			}
		}
		
	}

}