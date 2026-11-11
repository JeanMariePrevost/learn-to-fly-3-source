package src.game.gameobjects.player.launcher 
{
	import flash.display.MovieClip;
	import sound.CannonLight2;
	import sound.Explode6;
	import sound.Explode7;
	import sound.RussianRouletteSpin;
	import src.audio.Audio;
	import src.game.DeltaMovieClipWrapper;
	import src.game.GameEngine;
	import src.game.gameobjects.player.body.Bullet;
	import src.game.gameobjects.player.Player;
	import src.game.GameToolTip;
	import src.game.particles.AbstractParticle;
	import src.game.particles.Particles;
	import src.system.GameStateItem;
	
	/**
	 * ...
	 * @author 
	 */
	public class RussianRoulette extends AbstractLauncher 
	{
		public var target:MovieClip;
		
		protected const GREAT_BULLET_MULT:Number = 2;
		protected const GOOD_BULLET_MULT:Number = 01;
		protected const BAD_BULLET_MULT:Number = 0.15;
		
		protected var _barrel:RussianRouletteBarrel;
		protected var _wrapper:DeltaMovieClipWrapper;
		
		public function RussianRoulette(player:Player, item:GameStateItem, gameEngine:GameEngine) 
		{
			super(player, item, gameEngine);
			_wrapper = new DeltaMovieClipWrapper(this);
			
			_barrel = new RussianRouletteBarrel(_item);
			_barrel.fireSignal.addOnce(fire);
			_barrel.spinSignal.addOnce(spin);
			
			_player.getMovieClip().visible = false;
			
			movePlayerOnTarget(target);
			
			GameToolTip.show("russianRoulette");
		}
		
		override public function tick(delta:Number):void 
		{
			super.tick(delta);
			if(_takeoffFinalized == false) movePlayerOnTarget(target);
		}
		
		private function fire(bulletType:Number):void 
		{
			//2 = great
			//1 = good
			//0 = bad
			
			//trace("Bullet struck was type:", bulletType);
			
			switch(bulletType) {
				case 2:
					//Great bullet
					applyPower(GREAT_BULLET_MULT);
					spawnSmoke(1.8);
					Particles.builder.screenFlash(1, 5, 40);
					Audio.playSound(Explode7);
				break;
				case 1:
					//Good bullet
					applyPower(GOOD_BULLET_MULT);
					spawnSmoke(1.3);
					Particles.builder.screenFlash(1, 0, 30);
					Audio.playSound(Explode6);
					break;
				case 0:
					//Bad bullet
					applyPower(BAD_BULLET_MULT);
					spawnSmoke(0.5);
					Particles.builder.screenFlash(0.6, 0, 30);
					Audio.playSound(CannonLight2);
					break;
			}
			
			_player.getMovieClip().visible = true;
			
			finalizeTakeoff();
		}
		
		protected function spawnSmoke(speedMult:Number = 1):void {
			for (var i:int = 0; i <= 9; i++) {
				var p:AbstractParticle = Particles.builder.smokeGrey(0, 0, 0.8, 1.2, (20 + Math.random() * 30) * speedMult, -100 + Math.random() * 20, target);
				p.drag = 0.06;
			}
		}
		
		protected function spin():void {
			Audio.playSound(RussianRouletteSpin);
			_wrapper.setToDeath();
			GameToolTip.hide();
		}
		
		protected function applyPower(mult:Number):void {
			var power:Number = launcherBasePower;
			var powerAtWeight:Number = _item.getPowerAtWeightMult(_player.getBody().mass);
			
			applyLauncherThrust(power * powerAtWeight * mult);
		}
	}

}