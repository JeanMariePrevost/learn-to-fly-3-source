package src.audio 
{
	import sound.*;
	/**
	 * ...
	 * @author 
	 */
	public class Sfx 
	{
		
		
		public static function playExplosion1():ISound { return Audio.playSound(Explode7) };	
		public static function playExplosion2():ISound { return Audio.playSound(Explode6) };	
		public static function playExplosion3():ISound { return Audio.playSound(FireworkExplosion) };	
		public static function playExplosion4():ISound { return Audio.playSound(Explode2) };	
		public static function playExplosion5():ISound { return Audio.playSound(Explode1) };	
		public static function playExplosion6():ISound { return Audio.playSound(ExplosionFar) };	
		
		public static function playOpenBooster():ISound {
			return Audio.playSound(OpenBooster);
		}
		
		public static function playPickBooster():ISound {
			return Audio.playSound(PickBooster);
		}
		
		public static function playClick1():ISound {
			return Audio.playSound(Click1);
		}
		
		public static function playClick3():ISound {
			return Audio.playSound(Click3);
		}
		
		public static function playPop2():ISound {
			return Audio.playSound(Pop2);
		}
		
		public static function playGetItem():ISound {
			return Audio.playSound(GotItem);
		}
		
		public static function playBuildUpHit():ISound {
			return Audio.playSound(BuildUpHit);
		}
		
		public static function playMedalSound():ISound {
			return Audio.playSound(Medal);
		}
		
		public static function playMedalSound2():ISound {
			var s:ISound = Audio.playSound(Medal2);
			s.volume = 0.8;
			return s;
		}
		
		public static function playMedalSound3():ISound {
			return Audio.playSound(Medal3);
		}
		
		public static function playButtonClick():ISound {
			return Audio.playSound(Bubble2);
		}
		
		public static function playShopClick():ISound {
			var s:ISound = Audio.playSound(Pop1);
			s.volume = 0.6;
			return s;
		}
		
		public static function playMediumClick():ISound {
			var s:ISound = Audio.playSound(Pop3);
			s.volume = 0.6;
			return s;
		}
		
		public static function playEquipSwap():ISound {
			var s:ISound = Audio.playSound(Equip2);
			s.volume = 0.8;
			return s;
		}
		
		public static function playCash():ISound {
			return Audio.playSound(Cash2);
		}
		
		public static function playCashLow():ISound {
			var s:ISound = Audio.playSound(Cash2);
			s.volume = 0.8;
			return s;
		}
		
		public static function playCashShort():ISound {
			var s:ISound = Audio.playSound(Cash1);
			s.volume = 0.8;
			return s;
		}
		
		public static function playCoin():ISound {
			var s:ISound = Audio.playSound(Coins3);
			s.volume = 0.8;
			return s;
		}
		
		public static function playInvaderStart():ISound {
			var s:ISound = Audio.playSound(InvaderStart);
			//s.volume = 0.9;
			return s;
		}
		
		public static function playInvaderGameOver():ISound {
			var s:ISound = Audio.playSound(InvaderGameOver);
			//s.volume = 0.9;
			return s;
		}
		
		public static function playInvaderTitleFlash():ISound {
			var s:ISound = Audio.playSound(InvaderTitleFlash);
			s.volume = 0.8;
			return s;
		}
		
		public static function playInvaderEnemyFire():ISound {
			var s:ISound = Audio.playSound(EnemyFire);
			s.volume = 0.45;
			return s;
		}
		
		public static function playInvaderPlayerHit():ISound {
			var s:ISound = Audio.playSound(InvaderPlayerHit);
			s.volume = 0.82;
			return s;
		}
		
		public static function playInvaderEnemyHit():ISound {
			var s:ISound = Audio.playSound(InvaderEnemyHit);
			s.volume = 0.6;
			return s;
		}
		
		public static function playInvaderWin():ISound {
			var s:ISound = Audio.playSound(InvaderWin);
			s.volume = 0.85;
			return s;
		}
		
		public static function playInvaderPlayerFire():ISound {
			var s:ISound = Audio.playSound(InvaderPlayerFire);
			s.volume = 0.8;
			return s;
		}
		
		
	}

}